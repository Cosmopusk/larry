# frozen_string_literal: true

# Copyright (c) 2019 Danil Pismenny <danil@brandymint.ru>

# Public order creator:
#
# 1. Validate data
# 2. Create order
# 3. Notify managers
#
class OrderCreator
  Error = Class.new StandardError
  InvalidRateCalculation = Error.new

  self.class.delegate :call, to: :new

  def call(rate_calculation)
    raise InvalidRateCalculation, rate_calculation unless rate_calculation.valid?

    rate_calculation.build_order.tap { |o| o.save! }
  end

  private

  def create_order(order_params)
    order = Order.new order_params
    order.save!
    order
  end
end
