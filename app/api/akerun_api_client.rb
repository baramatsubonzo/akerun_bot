# frozen_string_literal: true

# AkerunApiとHTTPプロトコルでの通信を行う責務
class AkerunApiClient < HTTPClient
  AKERUN_BASE_URI = "https://api.akerun.com/v3/organizations/#{ENV.fetch('ORGANIZATION_ID')}"

  def initialize
    super(default_header: { 'Authorization' => ENV.fetch('AKERUN_ACCESS_TOKEN') })
  end

  def post_unlock_request
    post("#{AKERUN_BASE_URI}/akeruns/#{ENV.fetch('AKERUN_ID')}/jobs/unlock")
  end
end
