define cron::staleness_check(
  $threshold,
  $params,
  $user,
  $annotation = annotate(),
) {
  validate_hash($params)

  $threshold_s = human_time_to_seconds($threshold)

  # Check whether we are fresh five times per threshold, not to exceed 1 hour
  if $threshold_s / 5 > 3600 {
    $check_every = 3600
  } else {
    $check_every = $threshold_s / 5
  }

  $check_title = "${name}_staleness"

  $overrides = {
    'command'     => "/nail/sys/bin/cron_staleness_check ${name} ${threshold_s}",
    'check_every' => $check_every,
    'annotation'  => $annotation,
    'needs_sudo'  => true,
    'alert_after' => '2m',
  }

  $check_data = { "$check_title" =>
    merge(
      $params,
      $overrides
    )
  }
  create_resources('monitoring_check', $check_data)

  file { "/nail/run/success_wrapper/${name}":
    ensure => 'file',
    owner  => $user,
    group  => $user,
    mode   => '640',
  } ->
  Monitoring_check[$check_title]
}
