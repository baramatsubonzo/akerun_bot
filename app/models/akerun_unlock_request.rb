class AkerunUnlockRequest
  def adjust_value_from_akerun_api
    @res = AkerunApiClient.new.post_unlock_request
    @content = JSON.parse(@res.body)

    if @res.status == 201
      # memo: テスト動作確認のため、一時的に文字列を返却値とする
      # { "response_type": "in_channel", "text": "解錠中です。しばらくお待ちください" }
      "成功"
    elsif processed_previous_request?
      "前の解錠リクエストが処理中です。しばらくお待ちください"
    else
      # 本来はappから`status 500`を返したいが、
      # Slack公式ドキュメント#Sending error responsesで正しくない方法と明示されているので実装しない
      # https://api.slack.com/interactivity/slash-commands#responding_to_commands
      "エラーが発生しました。管理者に確認してください。\n code: #{@content["code"]}\n message: #{@content["message"]}"
    end
  end

  private
  def processed_previous_request?
    # Akerunの仕様では、403のhttp statusに含まれるものが多い。
    # https://developers.akerun.com/#remote-control-unlock-request
    @res.status == 403 && @content["code"] == "duplicate_job"
  end
end