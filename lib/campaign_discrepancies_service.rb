# frozen_string_literal: true

require_relative 'campaign_discrepancies/discrepancies_finder'

class CampaignDiscrepanciesService
  def self.call(local_campaigns:, remote_campaigns:)
    new(
      local_campaigns: local_campaigns,
      remote_campaigns: remote_campaigns
    ).call
  end

  def initialize(local_campaigns:, remote_campaigns:)
    @local_campaigns = local_campaigns
    @remote_campaigns = remote_campaigns
  end

  def call
    return find_discrepancies if @remote_campaigns

    show_error
  end

  private

  def find_discrepancies
    @local_campaigns.each_with_object([]) do |local_campaign, discrepancies_list|
      remote_campaign = find_remote_campaign(local_campaign)

      if remote_campaign
        discrepancies = CampaignDiscrepancies::DiscrepanciesFinder.call(
          local_state: convert_local_campaign(local_campaign),
          remote_state: convert_remote_campaign(remote_campaign)
        )
      end

      discrepancies_list << format_output(remote_campaign['reference'], discrepancies) if discrepancies&.any?
    end
  end

  def find_remote_campaign(local_campaign)
    @remote_campaigns.find do |remote_campaign|
      Integer(remote_campaign['reference']) == Integer(local_campaign['external_reference'])
    end
  end

  def convert_local_campaign(local_campaign)
    {
      'status' => local_campaign['status'],
      'description' => local_campaign['ad_description']
    }
  end

  def convert_remote_campaign(remote_campaign)
    remote_campaign.slice('status', 'description')
  end

  def format_output(reference, discrepancies)
    {
      'remote_reference' => reference,
      'discrepancies' => discrepancies
    }
  end

  def show_error
    { error: 'External API does not work' }
  end
end
