# == Define: cron::d
#
# Generates an /etc/cron.d file for you.
#
# == Reasoning
#
# Including a files makes it too easy to forget the MAILTO
# or only put 4 *s, or any other stupid mistake.
# Also, putting the cron command inline with the puppet code to generate
# it generally involves less tail chasing when you're looking for a job
#
# == Examples
#
# This makes a job which runs every min, and emails systems+cron@yelp.com
# if anything is sent to stdout
#
# ```
# cron::d { 'minimum_example':
#     minute  => '*',
#     user    => 'push',
#     command     => '/nail/sys/bin/example_job | logger'
#  }
#  ```
#
# Full example with all optional params:
# ```
# cron::d { 'name_of_cronjob':
#     second  => '*/20',
#     minute  => '*',
#     hour    => '*',
#     dom     => '*',
#     month   => '*',
#     dow     => '*',
#     user    => 'bob',
#     mailto  => 'example@yelp.com',
#     command     => '/some/example/job';
# }
# ```
#
# == Parameters
#
# [*lock*]
# Boolean that defaults to false. If true, the command will be wrapped in a
# a `flock` invocation to prevent the cron job from stacking.
#
# [*timeout*]
# String giving the amount of time to wait before killing the supplied
# command. All strings accepted by the gnu timeout utility are valid.
#
# [*timeout_custom_args*]
# By default, when you only specify $timeout, this module will SIGKILL
# the cron process. However, if you want to specify more complex timeout
# behavior, apart from the actual timeout, like `-k 21300 -s 15`, you can do so
# using this argument.
#
# [*second*]
# String describing which seconds of the minute you want your job to execute
# on. This is implemented by dropping multiple lines into the cron.d file,
# prefixed with sleep commands. This supports lists (separated by commas),
# ranges (e.g. 0-10), and ranges with steps (e.g. 0-10/2). An asterisk (*)
# is equivalent to 0-59, and also supports steps (e.g. */20).
#
# [*env*]
# Hash of VARIABLE=VALUE to export to the cronjob subshell
#
# [*staleness_threshold*]: A human-readable time unit ('24h', '5m', '3s') representing
# how long it is acceptable for the cron job to be failing before sending an alert.
#
# [*staleness_check_params*]: A hash of any parameter to
# [monitoring_check](https://github.com/Yelp/puppet-monitoring_check).
#
# [*show_diff*]: Whether to display differences when the file changes, defaulting to true.
# 
define cron::d (
  $minute,
  $command,
  $user,
  $second='0',
  $hour='*',
  $dom='*',
  $month='*',
  $dow='*',
  $mailto='""',
  $log_to_syslog=true,
  $staleness_threshold=undef,
  $staleness_check_params=undef,
  $lock=false,
  $timeout=undef,
  $timeout_custom_args=undef,
  $normalize_path=hiera('cron::d::normalize_path', false),
  $comment='',
  $env={},
  $show_diff=true,
) {
  validate_cron_numeric($second)
  validate_cron_numeric($minute)
  validate_cron_numeric($hour)
  validate_cron_numeric($dom)
  validate_cron_numeric($month)
  validate_cron_numeric($dow)

  validate_bool($log_to_syslog,$lock,$show_diff)

  if $mailto == '' {
    fail('You must provide a value for MAILTO. Did you mean mailto=\'""\'?')
  }

  $safe_name = regsubst($name, ':', '_', 'G')
  $reporting_name = "cron_${safe_name}"

  if $staleness_threshold {
    $actual_command = "/nail/sys/bin/success_wrapper '${reporting_name}' ${command}"

    cron::staleness_check { $reporting_name:
      threshold  => $staleness_threshold,
      params     => $staleness_check_params,
      user       => $user,
    }
  } else {
    $actual_command = $command
  }

  # If both syslogging and mailing are requested, choose mailing over syslogging
  $actually_log_to_syslog = $log_to_syslog and $mailto=='""'

  if $timeout_custom_args != undef {
    $timeout_signal_arg = $timeout_custom_args
  } else {
    # Ancient versions of `timeout` have a slightly different argument syntax
    # for what signal should be sent.
    $timeout_signal_arg = "${::lsbdistid}_${::lsbdistrelease}" ? {
      /(Ubuntu_10.04|CentOS_5.*)/ => '-9',
      default => '-s 9'
    }
  }

  cron::file { $safe_name:
    file_params => {
      content   => template('cron/d.erb'),
      show_diff => $show_diff,
    },
  }
}
