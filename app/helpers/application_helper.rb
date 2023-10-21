require 'git_rev'

module ApplicationHelper
  
  def get_revision
    GitRev::Sha.new.short
  end

  def show_amount(price)
    return 'n/a' if price.blank?
    sprintf('%.2f €', price)
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
