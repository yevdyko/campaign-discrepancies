# frozen_string_literal: true

require_relative 'external_apis/ad_service'

module CampaignDiscrepancies
  class ExternalApiFetcher
    def self.call
      new.call
    end

    def call
      response = CampaignDiscrepancies::ExternalApis::AdService.new.campaigns
      JSON.parse(response.body).fetch('ads')
    rescue StandardError
      false
    end
  end
end
