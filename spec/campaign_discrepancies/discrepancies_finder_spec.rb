# frozen_string_literal: true

require 'campaign_discrepancies/discrepancies_finder'

describe CampaignDiscrepancies::DiscrepanciesFinder do
  subject(:discrepancies) { described_class.call(local_state: local_state, remote_state: remote_state) }
  let(:local_state) do
    {
      'status' => 'paused',
      'description' => 'Description for campaign 1'
    }
  end

  let(:remote_state) do
    {
      'status' => 'enabled',
      'description' => 'Description for campaign 11'
    }
  end

  let(:expected_discrepancies) do
    [
      {
        'description' => {
          'remote' => 'Description for campaign 11',
          'local' => 'Description for campaign 1'
        }
      },
      {
        'status' => {
          'remote' => 'enabled',
          'local' => 'paused'
        }
      }
    ]
  end

  describe '#call' do
    context 'when the local state differs from the remote' do
      it 'returns discrepancies between local and remote state' do
        expect(discrepancies).to eq(expected_discrepancies)
      end
    end

    context 'when no discrepancies' do
      let(:remote_state) do
        {
          'status' => 'paused',
          'description' => 'Description for campaign 1'
        }
      end

      it 'returns an empty array' do
        expect(discrepancies).to be_empty
      end
    end
  end
end
