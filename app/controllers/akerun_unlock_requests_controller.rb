class AkerunUnlockRequestsController < ApplicationController
  def create
    render plain: AkerunUnlockRequest.new.adjust_value_from_akerun_api
  end
end
