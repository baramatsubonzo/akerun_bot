class AkerunUnlockRequestsController < ApplicationController
  before_action :reject_no_authorized_clients

  def create
    render plain: AkerunUnlockRequest.new.adjust_value_from_akerun_api
  end

  private
    def reject_no_authorized_clients
      # RFC: 今回Slack推奨のsigning secretの利用で動作確認できず、非推奨であるがverification tokenを利用。
      render status: 401 if confirm_not_slack_token
    end

    def confirm_not_slack_token
      # TODO: Env.fetch('SLACK_TOKEN')へ変更する。
      request.params['token'] != ENV.fetch('SLACK_TOKEN')
    end
end
