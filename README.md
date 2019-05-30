# Campaign Discrepancies

[![Build Status](https://travis-ci.org/yevdyko/campaign-discrepancies.svg?branch=master)](https://travis-ci.org/yevdyko/campaign-discrepancies)

A service, which get campaigns from external JSON API and detect discrepancies between local and remote state.

## Assumptions

1. Local and remote campaigns are passed as arguments in the `CampaignDiscrepanciesService`.
2. We receive data with remote campaigns using the `AdService` fetcher and the `ExternalApiParser` parser (can be used for different external apis). For instance, this is how we use these services:

```ruby
response = CampaignDiscrepancies::ExternalApis::Adservice.new.campaigns
remote_campaigns = CampaignDiscrepancies::ExternalApiParser.call(response: response).fetch('ads')
```

3. `CampaignDiscrepanciesService` should be regularly executed with a cron job.

## How to use

```ruby
CampaignDiscrepanciesService.call(local_campaigns: local_campaigns, remote_campaigns: remote_campaigns)
```

Expected results:

1. When the local state differs from the remote:

```
[
  {
    'remote_reference': '1',
    'discrepancies': [
      'status': {
        'remote': 'disabled',
        'local': 'active'
      },
      'description': {
        'remote': 'Rails Engineer',
        'local': 'Ruby on Rails Developer'
      }
    ]
  }
]
```

2. When no discrepancies:

```
[]
```

3. When external api does not work:

```
{
  error: 'External API does not work'
}
```

## Technologies Used

- Ruby 2.6.3
- Tested with RSpec, using Webmock for stubing external services in tests.
- Hashdiff for getting difference between two hashes.

## Setup

Clone the repository:

    $ git clone git@github.com:yevdyko/campaign-discrepancies.git

Change into the directory:

    $ cd campaign-discrepancies

Install the required dependencies:

    $ bundle

## Testing

To run the tests:

    $ rspec
