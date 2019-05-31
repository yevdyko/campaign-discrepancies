# frozen_string_literal: true

require 'hashdiff'

module CampaignDiscrepancies
  class DiscrepanciesFinder
    def self.call(local_state:, remote_state:)
      new(
        local_state: local_state,
        remote_state: remote_state
      ).call
    end

    def initialize(local_state:, remote_state:)
      @local_state = local_state
      @remote_state = remote_state
    end

    def call
      diff = HashDiff.diff(@local_state, @remote_state)
      find_discrepancies(diff)
    end

    private

    def find_discrepancies(diff)
      diff.map do |array_diff|
        {
          array_diff[1] => {
            'remote' => array_diff[3],
            'local' => array_diff[2]
          }
        }
      end
    end
  end
end
