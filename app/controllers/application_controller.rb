class ApplicationController < ActionController::Base
  def no_resp_redir(dest)
    respond_to do |format|
      format.html { redirect_to dest }
      format.json { render json: '', status: 200 }
    end
  end

  def info
    respond_to do |format|
      format.json { render json: '', status: 200 }
    end
  end

  before_action :set_raven_context

  private

  def set_raven_context
    Raven.extra_context(params: params.to_unsafe_h, url: request.url)
  end
end
