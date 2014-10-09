# == Class cron
#
# Main class to get the cron infrastructure in place for the other
# types. Enablings the cron job purging mechanism.
#
class cron {

  include nail
  file { '/nail/etc/cron.d':
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
    line  => 'MAILTO="" #No cron spam',
    path  => '/etc/crontab',
    after => 'SHELL=/bin/sh',
  }

  # Temporary, I put the at the end of the file where it has no effect
  file_line { 'disable_cron_hourly_emails_fix':
    ensure => absent,
    line  => 'MAILTO=""',
    path  => '/etc/crontab',
  }

}
