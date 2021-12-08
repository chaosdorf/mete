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
      @caffeine = caffeine(audits)
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
    drink, count = audits.reorder(nil).group(:drink).count.max_by { |_, v| v }
    user_more = audits_for(User.where(audit: true), year)
                .where(drink: drink).reorder(nil).group(:user).count
                .select { |_, v| v > count }
                .size
    { drink: drink, count: count, user_more: user_more }
  end
  
  def caffeine(audits)
    total = audits.joins(:drink).sum(:caffeine)
    if total.positive?
      # for humans: overdose: 1000 mg, intoxication: 5000 mg
      would_kill_kg = total / 192.0  # lethal dosage (mg) per kg
      puts would_kill_kg
      would_kill = case would_kill_kg
                   when 0..0.025 then nil
                   when 0.025..0.3 then 'hamster'
                   when 0.3..0.4 then 'squirrel'
                   when 0.4..0.9 then 'rat'
                   when 0.9..2.5 then 'guinea pig'
                   when 2.5..5 then 'lemur'
                   when 5..9 then 'cat'
                   when 9..13 then 'koala'
                   when 13..23 then 'coyote'
                   when 23..55 then 'lynx'
                   when 55..81 then 'capybara'
                   when 81..101 then 'jaguar'
                   when 101..140 then 'reindeer'
                   when 140..175 then 'gorilla'
                   when 175..278 then 'lion'
                   when 278..368 then 'bear'
                   when 368..540 then 'moose'
                   when 540..Float::INFINITY then 'bison'
                   end
    end
    { total: total, would_kill: would_kill }
  end
end
