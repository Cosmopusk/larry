# frozen_string_literal: true

# Copyright (c) 2019 Danil Pismenny <danil@brandymint.ru>

class UserDecorator < ApplicationDecorator
  delegate_all

  def self.table_columns
    %i[created_at public_name email orders partner_ref_token partner_orders partner_balances partner_accruals]
  end

  def partner_ref_token
    return h.middot if partner.nil?

    h.link_to partner.ref_token, partner.referal_url, target: :_blank
  end

  def partner_orders
    return h.middot if partner.nil?

    h.link_to partner.orders.count, h.operator_orders_path(q: { referrer_id_eq: user.partner.id })
  end

  def orders
    h.link_to user.orders.count, h.operator_orders_path(q: { user_id_eq: user.id })
  end

  def partner_balances
    # partner balances
  end

  def partner_accruals
    h.render 'partner_accruals', partner: object.partner if object.partner.present?
  end
end
