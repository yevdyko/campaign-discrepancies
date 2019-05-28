# frozen_string_literal: true

require 'campaign_discrepancies/external_apis/ad_service'

describe CampaignDiscrepancies::ExternalApis::AdService do
  subject(:ad_service) { described_class.new }
  let(:external_api_url) { 'https://mockbin.org/bin/fcb30500-7b98-476f-810d-463a0b8fc3df' }

  describe '#campaigns' do
    it 'calls the external ad service api endpoint' do
      stub_request(:get, external_api_url)
        .to_return(
          status: 200,
          body: '',
          headers: { 'Content-Type': 'application/json' }
        )

      ad_service.campaigns

      expect(WebMock).to have_requested(:get, external_api_url).once
      expect(WebMock).not_to have_requested(:get, 'https://google.com')
    end
  end
end
