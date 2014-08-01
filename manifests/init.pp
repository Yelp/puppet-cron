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

}
