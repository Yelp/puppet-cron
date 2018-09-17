## puppet-cron

[![Build Status](https://travis-ci.org/Yelp/puppet-cron.svg?branch=master)](https://travis-ci.org/Yelp/puppet-cron)

A super great cron Puppet module with timeouts, locking, monitoring, and more!

**WARNING**: This module still has some "Yelpisms". Watch out!

Please open an [issue](https://github.com/Yelp/puppet-cron/issues) if you encounter
one. Bonus points for a PR!! :)

## Description

Cron is the foundation of any great architecture. Don't let anyone else tell you differently :)

If you are going to deploy cron jobs, do it right.

There is, however, a fine line between using cron to do scheduled tasks,
and abusing cron where a better system should be used.

## Examples

Minimal job config:
```puppet
cron::d { 'minimum_example':
  minute  => '*',
  user    => 'root',
  command => '/bin/true',
}
 ```

Full example high-frequency job with all optional params:
```puppet
cron::d { 'name_of_cronjob':
  second  => '*/20',
  minute  => '*',
  hour    => '*',
  dom     => '*',
  month   => '*',
  dow     => '*',
  user    => 'bob',
  mailto  => 'example@example.com',
  command => '/some/example/job',
}
```

## Monitoring Params

This cron module optionally integrates with Yelp's [monitoring_check](https://github.com/Yelp/puppet-monitoring_check)
module to add monitoring to your cron job. You can use the following params
to tune this monitoring:

* `staleness_threshold`: A human-readable time unit ('24h', '5m', '3s') representing
   how long it is acceptable for the cron job to be failing before sending an alert.
* `staleness_check_params`: A hash of any parameter to [monitoring_check](https://github.com/Yelp/puppet-monitoring_check).

This makes it very easy to get alerts for cron jobs when they start failing,
while re-using any existing notification options that your Sensu infrastructure
has.

Example: An important cron job that makes tickets after failing for 24h hours:
```puppet
cron::d { 'name_of_cronjob':
  minute                 => '0',
  hour                   => '4',
  user                   => 'root',
  command                => 'fortune';
  staleness_threshold    => '24h',
  staleness_check_params => {
    'team'    => 'operations',
    'ticket   => true,
    'project' => 'FORTUNE',
  },
}
```

## License

Apache 2.

## Contributing

Open an [issue](https://github.com/Yelp/puppet-cron/issues) or 
[fork](https://github.com/Yelp/puppet-cron/fork) and open a 
[Pull Request](https://github.com/Yelp/puppet-cron/pulls)
