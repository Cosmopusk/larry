# Copyright (c) 2019 Danil Pismenny <danil@brandymint.ru>

# frozen_string_literal: true

module Operator
  class UsersController < ApplicationController
    def index
      render locals: { users: paginate(User.includes(:partner).order('created_at desc')) }
    end
  end
end