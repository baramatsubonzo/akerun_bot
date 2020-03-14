# frozen_string_literal: true

require 'rails_helper'

RSpec.describe AkerunUnlockRequest do
  AKERUN_BASE_URI = "https://api.akerun.com/v3/organizations/#{ENV.fetch('ORGANIZATION_ID')}"

  describe 'adjust_value_from_akerun_api' do
    let(:res) { AkerunUnlockRequest.new }

    context '解錠リクエストが成功する時' do
      before do
        stub_request(:post, "#{AKERUN_BASE_URI}/akeruns/#{ENV.fetch('AKERUN_ID')}/jobs/unlock")
          .to_return(body: {}.to_json, status: 201)
      end
      it 'return 解錠中です' do
        res = AkerunUnlockRequest.new.adjust_value_from_akerun_api
        expect(res).to eq '成功'
      end
    end

    context '処理中の解錠リクエストが存在する時' do
      before do
        stub_request(:post, "#{AKERUN_BASE_URI}/akeruns/#{ENV.fetch('AKERUN_ID')}/jobs/unlock")
          .to_return(body: { 'code' => 'duplicate_job', 'message' => 'The access token expired.' }.to_json, status: 403)
      end
      it 'return 前の解錠リクエストが処理中です' do
        res = AkerunUnlockRequest.new.adjust_value_from_akerun_api
        expect(res).to eq '前の解錠リクエストが処理中です。しばらくお待ちください'
      end
    end

    context '解錠リクエストが失敗する時' do
      before do
        stub_request(:post, "#{AKERUN_BASE_URI}/akeruns/#{ENV.fetch('AKERUN_ID')}/jobs/unlock")
          .to_return(body: { 'code' => 'invalid_token', 'message' => 'The access token expired.' }.to_json, status: 401)
      end
      it 'return エラーが発生しました。' do
        res = AkerunUnlockRequest.new.adjust_value_from_akerun_api
        expect(res).to include 'エラーが発生しました。管理者に確認してください。'
      end
    end
  end
end
