module ApplicationHelper

  def show_amount(price)
    return 'n/a' if price.blank?
    res = ""
    if APP_CONFIG["currency"]["before_value"]
      res += "#{APP_CONFIG["currency"]["symbol"]} "
    end
    
    res += sprintf('%.2f', price)
    
    unless APP_CONFIG["currency"]["before_value"]
      res += " #{APP_CONFIG["currency"]["symbol"]}"
    end
    return res
  end

  def link_to_drink_if_exists(drink)
    drink = Drink.find_by(:id => drink)
    if drink.nil?
      return "n/a"
    else
      return link_to drink do
        drink.name
      end
    end
  end
end
