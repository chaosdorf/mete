class ApplicationController < ActionController::Base
  def no_resp_redir(dest)
    respond_to do |format|
      format.html { redirect_to dest }
      format.json { head :no_content }
    end
  end

  before_action :set_raven_context

  private

  def set_raven_context
    Raven.extra_context(params: params.to_hash, url: request.url)
  end
end
