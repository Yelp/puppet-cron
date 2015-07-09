# == Class cron
#
# Main class to get the cron infrastructure in place for the other
# types. Enablings the cron job purging mechanism.
#
class cron (
  $conf_dir = '/nail/etc',
  $scripts_dir = '/nail/sys/bin',
  $purge_upstart_jobs = true,
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
    mode   => '0555',
    owner  => 'root',
    group  => 'root',
    source => 'puppet:///modules/cron/cron_staleness_check',
  }

  file { "${scripts_dir}/initial_cron_run":
    mode   => '0555',
    owner  => 'root',
    group  => 'root',
    source => 'puppet:///modules/cron/initial_cron_run',
  }

}
