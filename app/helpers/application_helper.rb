module ApplicationHelper
  def money(amount, currency: 'KSh')
    return '' if amount.nil?

    if amount.is_a?(Numeric)
      "#{currency} #{number_with_delimiter(amount)}"
    else
      "#{currency} #{amount}"
    end
  end
end
