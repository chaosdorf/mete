module ApplicationHelper

  def m(price)
    return 'n/a' if price.blank?
    humanized_money_with_symbol price
  end

end
