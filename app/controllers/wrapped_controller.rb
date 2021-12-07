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
    # wrapped.html.haml
  end
  
  private
  
  def audits_for(user, year)
    Audit
      .where(user: user)
      .where(created_at: Date.new(year, 01, 01)..Date.new(year, 12, 31))
  end
end
