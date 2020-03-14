# frozen_string_literal: true

# AkerunUnlockRequestを実行するためのエンドポイントを作成する責務
class AkerunUnlockRequestsController < ApplicationController
  before_action :reject_no_authorized_clients

  def create
    render plain: AkerunUnlockRequest.new.adjust_value_from_akerun_api
  end

  private

  def reject_no_authorized_clients
    render status: 401 if confirm_not_slack_token
  end

  def confirm_not_slack_token
    # TODO: Env.fetch('SLACK_TOKEN')へ変更する。
    request.params['token'] != ENV.fetch('SLACK_TOKEN')
  end
end
