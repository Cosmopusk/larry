# frozen_string_literal: true

# Base controller for operator namespace
#
module Operator
  class ApplicationController < ApplicationController
    layout 'operator'
    include RansackSupport
    helper_method :model_class
    private

    def model_class
      self.class.name.split('::').last.remove('Controller').singularize.constantize
    end
  end
end
