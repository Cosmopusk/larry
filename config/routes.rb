# Copyright (c) 2019 Danil Pismenny <danil@brandymint.ru>

# frozen_string_literal: true

require 'sidekiq/web'
require 'sidekiq/cron/web'
require 'route_contraints'

Rails.application.routes.draw do
  default_url_options Settings.default_url_options.symbolize_keys

  scope module: :authentication do
    resources :sessions, only: [:new, :create, :destroy]
  end

  scope subdomain: 'operator', constraints: { subdomain: 'operator' } do
    scope constraints: RouteConstraints::AdminRequiredConstraint.new do
      mount Gera::Engine => 'gera'
      mount Sidekiq::Web => 'sidekiq'
      scope as: :operator do
        scope module: :operator do
          root to: 'dashboard#index'
          resources :wallets
          resources :wallet_activities
        end
      end
      match '*anything', to: 'application#not_found', via: %i[get post]
    end
  end

  scope subdomain: '', as: :public, constraints: RouteConstraints::PublicConstraint.new do
    scope module: :public do
      root to: 'home#index'
      resources :pages, only: %i[index show]
    end
  end

  match '*anything', to: 'application#not_found', via: %i[get post]
end
