define cron::staleness_check(
  $threshold,
  $params,
  $user,
  $annotation = annotate(),
) {
  validate_hash($params)

  $threshold_s = human_time_to_seconds($threshold)

  # Check whether we are fresh five times per threshold.
  $check_every = $threshold_s / 5

  $check_title = "${name}_staleness"

  $overrides = {
    'command' => "/usr/lib/nagios/plugins/check_file_age /nail/run/success_wrapper/${name} -w ${threshold_s} -c ${threshold_s}",
    'check_every' => $check_every,
    'annotation' => $annotation,
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
