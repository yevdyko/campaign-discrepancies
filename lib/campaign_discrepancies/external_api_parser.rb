# frozen_string_literal: true

require_relative 'external_apis/ad_service'

module CampaignDiscrepancies
  class ExternalApiParser
    def self.call(response: CampaignDiscrepancies::ExternalApis::AdService.new.campaigns)
      new(response: response).call
    end

    def initialize(response:)
      @response = response
    end

    def call
      response_body
    rescue StandardError
      false
    end

    private

    def response_body
      JSON.parse(@response.body)
    end
  end
end
