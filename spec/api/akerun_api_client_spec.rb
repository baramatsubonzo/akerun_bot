# frozen_string_literal: true

require 'rails_helper'
WebMock.enable!

RSpec.describe AkerunApiClient do
  AKERUN_BASE_URI = "https://api.akerun.com/v3/organizations/#{ENV.fetch('ORGANIZATION_ID')}"
  let(:client) { AkerunApiClient.new }

  describe 'post_unlock_request' do
    before do
      stub_request(:post, "#{AKERUN_BASE_URI}/akeruns/#{ENV.fetch('AKERUN_ID')}/jobs/unlock")
        .to_return(status: 201)
    end
    it 'return status 201' do
      res = client.post_unlock_request
      expect(res.status).to eq 201
    end
  end
end
