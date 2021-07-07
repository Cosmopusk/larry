# frozen_string_literal: true

# Copyright (c) 2019 Danil Pismenny <danil@brandymint.ru>

class UserOrderDecorator < OrderDecorator
  def user_email
    secure object.user_email
  end

  def user_full_name
    secure object.user_full_name
  end

  def user_income_address
    secure object.user_income_address
  end

  def self.decorated_class
    Order
  end

  private

  def secure(string)
    return if string.blank?
    return '***' if string.length < 5

    string.slice(0, 2) + ' *** ' + string.slice(-2, 2)
  end
end