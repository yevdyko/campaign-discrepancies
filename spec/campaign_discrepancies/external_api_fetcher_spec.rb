# frozen_string_literal: true

require 'campaign_discrepancies/external_api_fetcher'

describe CampaignDiscrepancies::ExternalApiFetcher do
  subject(:campaigns) { described_class.call }
  let(:external_api_url) { 'https://mockbin.org/bin/fcb30500-7b98-476f-810d-463a0b8fc3df' }
  let(:response_body) do
    {
      'ads': [
        {
          'reference': '1',
          'status': 'enabled',
          'description': 'Description for campaign 11'
        },
        {
          'reference': '2',
          'status': 'disabled',
          'description': 'Description for campaign 12'
        },
        {
          'reference': '3',
          'status': 'enabled',
          'description': 'Description for campaign 13'
        }
      ]
    }
  end

  describe '#call' do
    it 'returns campaigns from the external ad service api' do
      stub_request(:get, external_api_url)
        .to_return(
          status: 200,
          body: response_body.to_json,
          headers: { 'Content-Type': 'application/json' }
        )

      expect(campaigns.count).to eq(3)
      expect(campaigns[0]['reference']).to eq('1')
      expect(campaigns[0]['status']).to eq('enabled')
      expect(campaigns[0]['description']).to eq('Description for campaign 11')
    end

    it 'returns false if the api fails to respond' do
      stub_request(:get, external_api_url)
        .to_return(
          status: 404,
          body: '',
          headers: { 'Content-Type': 'application/json' }
        )

      expect(campaigns).to eq(false)
    end
  end
end
