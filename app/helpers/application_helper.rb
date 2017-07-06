module ApplicationHelper
  def show_amount(price)
    return 'n/a' if price.blank?
    sprintf('%.2f EUR', price / 100.0)
  end

end
