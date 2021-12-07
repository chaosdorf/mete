class WrappedController < ApplicationController
  # GET /user/1/wrapped
  def index
    # index.html.haml
  end
  
  # GET /users/1/wrapped/1970
  def show
    puts params
    @user = User.find(params[:user_id])
    @year = params[:id]
    # wrapped.html.haml
  end
end
