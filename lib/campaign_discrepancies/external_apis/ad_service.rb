# frozen_string_literal: true

require 'httparty'

module CampaignDiscrepancies
  module ExternalApis
    class AdService
      include HTTParty
      base_uri 'https://mockbin.org'

      def campaigns
        self.class.get('/bin/fcb30500-7b98-476f-810d-463a0b8fc3df')
      end
    end
  end
end
