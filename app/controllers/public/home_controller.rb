# Copyright (c) 2019 Danil Pismenny <danil@brandymint.ru>

# frozen_string_literal: true

module Public
  class HomeController < ApplicationController
    helper Gera::ApplicationHelper

    helper_method :income_payment_system, :outcome_payment_system, :income_payment_systems, :outcome_payment_systems, :income_amount, :direction

    def index
      render locals: { order: build_order }
    end

    private

    def direction
      direction = Gera::Direction.new(ps_from: income_payment_system, ps_to: outcome_payment_system).freeze
    end

    def build_order
      Order.new(
        income_amount: income_amount,
        outcome_amount: direction.direction_rate.exchange(income_amount),
        income_payment_system: income_payment_system,
        outcome_payment_system: outcome_payment_system
      )
    end

    def income_amount
      @income_amount ||= [params[:income_amount].to_f.to_money(income_payment_system.currency), income_payment_system.minimal_income_amount].max
    end

    def income_payment_systems
      PaymentSystem.alive.available.enabled.where(income_enabled: true).ordered
    end

    def outcome_payment_systems
      PaymentSystem.alive.available.enabled.where(outcome_enabled: true).ordered
    end

    def income_payment_system
      ps = income_payment_systems.find_by(bestchange_key: params[:cur_from]) if params[:cur_from]
      ps || income_payment_systems.first
    end

    def outcome_payment_system
      ps = outcome_payment_systems.find_by(bestchange_key: params[:cur_to]) if params[:cur_to]
      ps || outcome_payment_systems.where.not(id: income_payment_system).first
    end
  end
end
