class ApplicationController < ActionController::Base
  def no_resp_redir(dest)
    respond_to do |format|
      format.html { redirect_to dest }
      format.json { head :no_content }
    end
  end
end
