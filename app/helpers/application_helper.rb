module ApplicationHelper

  def m(price)
    return 'n/a' if price.blank?
    raw sprintf('%.2f&thinsp;EUR', price)
  end

end
