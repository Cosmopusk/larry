# Copyright (c) 2019 Danil Pismenny <danil@brandymint.ru>

# frozen_string_literal: true

module RateHelper
  MINIMAL_EPSILON = 0.001

  def rate_humanized_description(rate_value, cur_from, cur_to)
    if rate_value < 1
      t '.sell_for', cur_to: cur_to, value: (1.0 / rate_value).round(3), cur_from: cur_from
    else
      t '.buy_for', cur_to: cur_to, value: rate_value.round(3), cur_from: cur_from
    end
  end

  def humanized_currency_rate(rate_value, currency)
    rate = if rate_value < 1
             format('%.9f', rate_value.to_f)
           else
             format('%.3f', rate_value.to_f)
           end

    "#{rate} #{currency}" # покупка
  end

  def muted(content)
    content_tag :span, content, class: 'text-muted'
  end

  def rate_source(currency_rate, level = 0)
    if currency_rate.mode_cross?
      buffer = currency_rate_mode_detailed currency_rate, level
      "⟮ <span class='text-muted'>#{buffer}</span> ⟯".html_safe
    else
      buffer = currency_rate.rate_source.presence || currency_rate.mode
      "(#{buffer})".html_safe
    end
  end

  def currency_rate_cell_data_attr(rate)
    {
      toggle: :popover,
      container: :body,
      content: "Метод расчета: #{currency_rate_mode_detailed rate}",
      trigger: :hover,
      html: 'true',
      placement: :bottom,
      animation: false,
      delay: 0,
      href: currency_rate_path(rate, subdomain: :gera)
    }
  end

  def rate_diff(rv1, rv2, _reverse = false)
    return rate_diff(1.0 / rv1, 1.0 / rv2, true) if rv1 < 1

    diff = rv2 - rv1
    return 0 if diff.abs.round(3).zero?

    p = 100 * diff / rv2

    buffer = "#{format('%.2f', p.round(3))}%"
    content_tag :span, buffer, data: { toggle: :tooltip, title: "#{rv2} - #{rv1}" }
  end

  def rate_with_currency(rate, currency)
    rate = format('%.12f', rate) if rate.is_a?(Float) && rate < MINIMAL_EPSILON
    "#{rate} <span class=text-muted>#{currency}</span>".html_safe
  end

  def rate_cell_with_currency(rate, currency)
    buffer = [rate_with_currency(rate, currency)]
    buffer << rate_with_currency(rate_inversed(rate), currency) if rate < 1
    [buffer].join('<br/>').html_safe
  end

  # = '%.12f' % humanized_money rate.buy_money
  def humanized_rate(rate, _currency = nil)
    rate = rate.to_f if rate.is_a? Gera::Rate
    if rate.is_a? Money
      raise 'Валюту отдавать запрещено, она округляет не удачно'
    elsif rate < 1
      rate1 = format('%.3f', (1.0 / rate))
      "<span class=text-muted>1/</span>#{rate1}".html_safe
    else
      format('%.3f', rate)
      # = '%.12f' % humanized_money rate.buy_money
      # humanized_money Money.from_amount(rate, currency)
    end
  end

  def humanized_rate_text(rate, _currency = nil)
    if rate < 1
      rate1 = format('%.3f', (1.0 / rate))
      "1/#{rate1}".html_safe
    else
      format('%.3f', rate)
    end
  end

  def rate_inversed(rate)
    "<span class='text-muted'>(1/#{1.0 / rate.to_f})</span>".html_safe
  end

  def humanized_rate_detailed(rate, separator = ' ')
    buffer = if rate < 1
               "#{rate}#{separator}#{rate_inversed(rate)}".html_safe
             else
               rate
             end
    content_tag :span, buffer.to_s, class: 'text-nowrap'
  end
end
