# == Define: cron::job
#
# Creates an upstart task and uses cron to periodically schedule it.
# See also cron::d.
#
# Mutual exclusion is enforced by Upstart, and also using flock(1)
#
# The defaults result in a cronjob that runs hourly, splayed using
# fqdn_rand.
#
# == Parameters
#
# [*sync*]
#
# Whether to force an initial run of the job when it is installed on the
# system.
#
define cron::job (
  $command,
  $user,
  $sync = false,
  $minute = fqdn_rand(60, $title),
  $second='0',
  $hour='*',
  $dom='*',
  $month='*',
  $dow='*',
  $d_params=undef,
  $staleness_threshold=undef,
  $staleness_check_params=undef,
) {
  # Deliberate copy here so we can add extra fancy options (like pipe stdout
  # to scribe) in additional parameters later
  validate_cron_numeric($second)
  validate_cron_numeric($minute)
  validate_cron_numeric($hour)
  validate_cron_numeric($dom)
  validate_cron_numeric($month)
  validate_cron_numeric($dow)

  include ::cron

  if ! ($::operatingsystemrelease in $::cron::supported_upstart_oses) {
    fail('I cannot install Upstart backed crons on machines without Upstart')
  }

  $reporting_name = "cron_${title}"

  if $staleness_threshold {
    $success_wrapper_command = "${::cron::scripts_dir}/success_wrapper '${reporting_name}' "

    cron::staleness_check { $reporting_name:
      threshold  => $staleness_threshold,
      params     => $staleness_check_params,
      user       => $user,
    }
  } else {
    $success_wrapper_comand = ""
  }

  $job_ticket = "${::cron::conf_dir}/init/${reporting_name}.conf"
  $job_file = "/etc/init/${reporting_name}.conf"

  file { "${::cron::conf_dir}/upstart_crons/${title}":
    ensure  => 'file',
    mode    => '0555',
    content => template("${module_name}/job_script.erb"),
    before  => File[$job_file],
  }

  # A mechanism for making these jobs purge-safe
  # Upstart's inotify based reload system basically ignores anything
  # that happens to a symlink (e.g. create, delete, change ctime).
  # Our options are to either:
  # 1) Use symlinks anyway, and do 'initctl reload-configuration' a
  # bunch.
  # 2) Create the jobs as regular files, and find some other way to purge
  # them.
  # We've opted for #2, so each job is associated with a marker file
  # that is its "ticket" to exist.  If a job is present without a ticket,
  # a cleanup job is programmed to remove it.
  file { $job_ticket:
    ensure  => 'file',
  } ->
  file { $job_file:
    ensure  => 'file',
    content => template("${module_name}/job_upstart.erb"),
    before  => Cron::File[$title],
  }

  if $sync {
    $sync_exec = "${::cron::scripts_dir}/initial_cron_run cron_${title}"
    exec { $sync_exec:
      subscribe   => File[$job_file],
      refreshonly => true,
    }
  }

  if $sync and $staleness_threshold {
      Cron::Staleness_check[$reporting_name] ->
      Exec[$sync_exec]
  }

  cron::file { $title:
    file_params => {
      content => template("${module_name}/job_cron.erb"),
    },
  }
}
