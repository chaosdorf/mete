class WrappedController < ApplicationController
  # GET /user/1/wrapped
  def index
    @user = User.find(params[:user_id])
    @years = Date.today.year.downto(2010)
      .select { |y| audits_for(@user, y).any? }
    # index.html.haml
  end
  
  # GET /users/1/wrapped/1970
  def show
    @user = User.find(params[:user_id])
    @year = Integer(params[:id])
    audits = audits_for(@user, @year)
    @empty = audits.none?
    unless @empty
      @most_bought_drink = most_bought_drink(audits, @year)
    end
    
    # wrapped.html.haml
  end
  
  private
  
  def audits_for(user, year)
    Audit
      .where(user: user)
      .where(created_at: Date.new(year, 01, 01)..Date.new(year, 12, 31))
  end
  
  def most_bought_drink(audits, year)
    drink_id, count = audits.reorder(nil).group(:drink).count.max_by { |_, v| v }
    drink = Drink.find(drink_id)
    user_more = audits_for(User.where(audit: true), year)
                .where(drink: drink).reorder(nil).group(:user).count
                .select { |_, v| v > count }
                .size
    { drink: drink, count: count, user_more: user_more }
  end
end
