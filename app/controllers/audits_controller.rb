class AuditsController < ApplicationController
  def index
    @audits = Audit.all
  end
end
