# frozen_string_literal: true

require 'campaign_discrepancies_service'

describe CampaignDiscrepanciesService do
  subject(:discrepancies) do
    described_class.call(local_campaigns: local_campaigns, remote_campaigns: remote_campaigns)
  end
  let(:external_api_url) { 'https://mockbin.org/bin/fcb30500-7b98-476f-810d-463a0b8fc3df' }
  let(:local_campaigns) do
    [
      {
        'id' => '1',
        'job_id' => '1',
        'status' => 'paused',
        'external_reference' => '1',
        'ad_description' => 'Description for campaign 2'
      },
      {
        'id' => '2',
        'job_id' => '2',
        'status' => 'deleted',
        'external_reference' => '2',
        'ad_description' => 'Description for campaign 12'
      },
      {
        'id' => '3',
        'job_id' => '3',
        'status' => 'enabled',
        'external_reference' => '3',
        'ad_description' => 'Description for campaign 13'
      }
    ]
  end

  let(:remote_campaigns) do
    [
      {
        'reference' => '1',
        'status' => 'enabled',
        'description' => 'Description for campaign 11'
      },
      {
        'reference' => '2',
        'status' => 'disabled',
        'description' => 'Description for campaign 12'
      },
      {
        'reference' => '3',
        'status' => 'enabled',
        'description' => 'Description for campaign 13'
      }
    ]
  end

  let(:expected_discrepancies) do
    [
      {
        'remote_reference' => '1',
        'discrepancies' => [
          {
            'description' => {
              'remote' => 'Description for campaign 11',
              'local' => 'Description for campaign 2'
            }
          },
          {
            'status' => {
              'remote' => 'enabled',
              'local' => 'paused'
            }
          }
        ]
      },
      {
        'remote_reference' => '2',
        'discrepancies' => [
          {
            'status' => {
              'remote' => 'disabled',
              'local' => 'deleted'
            }
          }
        ]
      }
    ]
  end

  describe '#call' do
    context 'when the local state differs from the remote' do
      it 'returns array of discrepancies' do
        expect(discrepancies).to eq(expected_discrepancies)
      end
    end

    context 'when no discrepancies' do
      let(:local_campaigns) do
        [
          {
            'id' => '1',
            'job_id' => '1',
            'status' => 'enabled',
            'external_reference' => '1',
            'ad_description' => 'Description for campaign 11'
          },
          {
            'id' => '2',
            'job_id' => '2',
            'status' => 'disabled',
            'external_reference' => '2',
            'ad_description' => 'Description for campaign 12'
          },
          {
            'id' => '3',
            'job_id' => '3',
            'status' => 'enabled',
            'external_reference' => '3',
            'ad_description' => 'Description for campaign 13'
          }
        ]
      end

      it 'returns an empty array' do
        stub_request(:get, external_api_url)
          .to_return(
            status: 200,
            body: remote_campaigns.to_json,
            headers: { 'Content-Type': 'application/json' }
          )
  
        expect(discrepancies).to be_empty
      end
    end

    context 'when external api does not work' do
      let(:remote_campaigns) { false }

      it 'shows an error messsage' do
        stub_request(:get, external_api_url)
          .to_return(
            status: 500,
            body: '',
            headers: { 'Content-Type': 'application/json' }
          )

        expect(discrepancies[:error]).to eq('External API does not work')
      end
    end
  end
end
