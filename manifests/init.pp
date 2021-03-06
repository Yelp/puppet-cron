# == Class cron
#
# Main class to get the cron infrastructure in place for the other
# types. Enablings the cron job purging mechanism.
#
# === Parameters
#
# [*check_file_age_path*]
#
# path to a nagios-compatible check_file_age script
#
# [*service_ensure*]
#
# How Puppet should manage the service. Defaults to 'running'.
#
class cron (
  $check_file_age_path = '/usr/lib/nagios/plugins/check_file_age',
  $conf_dir = '/nail/etc',
  $scripts_dir = '/nail/sys/bin',
  $purge_upstart_jobs = true,
  $package_ensure = 'latest',
  $service_ensure = 'running',
) {

  include nail

  $purged_directories = [
    "${conf_dir}/init",
    "${conf_dir}/cron.d",
    "${conf_dir}/upstart_crons",
  ]

  $supported_upstart_oses = [
    '10.04',
    '12.04',
    '14.04',
  ]

  file { $purged_directories:
    ensure  => 'directory',
    mode    => '0755',
    owner   => 'root',
    group   => 'root',
    recurse => true,
    purge   => true,
    force   => true,
  }

  # The cron::d wrapper uses symlinks to purge cron jobs
  # This purges the actual symlinks, puppet purges the targets.
  cron::d { 'delete_broken_cron_symlinks':
    user => 'root',
    minute => '0',
    hour   => '*',
    command => '/usr/bin/find -L /etc/cron.d/ -type l -delete',
  }

  file_line { 'disable_cron_hourly_emails':
    line  => 'MAILTO=""',
    path  => '/etc/crontab',
    after => 'SHELL=/bin/sh',
  }

  if $purge_upstart_jobs and $::operatingsystemrelease in $supported_upstart_oses {
    cron::job { 'purge_cruft_upstart_jobs':
      user    => 'root',
      command => "test -e '${conf_dir}/init' && comm -2 -3 <(grep -rl '^# FLAG: MANAGED BY PUPPET$' '/etc/init' | sort) <(find '/nail/etc/init' -mindepth 1 | sed -e 's#/nail##' | sort) | xargs -r rm",
    }
  }

  file { "${scripts_dir}/cron_staleness_check":
    mode    => '0555',
    owner   => 'root',
    group   => 'root',
    content => template('cron/cron_staleness_check.erb'),
  }

  file { "${scripts_dir}/initial_cron_run":
    mode   => '0555',
    owner  => 'root',
    group  => 'root',
    source => 'puppet:///modules/cron/initial_cron_run',
  }

  case $::osfamily {
    'Debian': { $service_name = 'cron' }
    'RedHat': { $service_name = 'crond' }
  }
  package { 'cron':
    ensure => $package_ensure,
  } ->
  service { 'cron':
    name   => $service_name,
    ensure => $service_ensure,
    enable => true,
  }

}
