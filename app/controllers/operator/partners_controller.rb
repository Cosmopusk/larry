# Copyright (c) 2019 Danil Pismenny <danil@brandymint.ru>

# frozen_string_literal: true

module Operator
  class PartnersController < ApplicationController
    def show
      render locals: { user: Partner.find(params[:id]) }
    end

    def update
      partner = Partner.find params[:id]
      partner.update! params.require(:partner).permit!
      redirect_to operator_user_path(partner.user), notice: 'Изменения приняты'
    rescue ActiveRecord::RecordInvalid
      render 'operator/users/show', locals: { user: partner.user }
    end
  end
end