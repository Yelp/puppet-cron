# puts a purge-safe cronjob in /etc/cron.d.
# $file_params is a transparent wrapper around the File resource

# if using $staleness_threshold, it is required that your cronjob
# touch /nail/run/success_wrapper/cron_${name} whenever it succeeds


define cron::file (
  $file_params,
) {
  validate_hash($file_params)
  $overrides = {
    owner  => 'root',
    group  => 'root',
    mode   => '0444',
    ensure => 'file',
  }

  $nail_file = "/nail/etc/cron.d/${name}"
  $file_data = { "$nail_file" => merge($file_params, $overrides) }

  create_resources('file', $file_data)

  File[$nail_file] ->
  file { "/etc/cron.d/${name}":
    ensure => 'link',
    target => $nail_file,
    owner  => 'root',
    group  => 'root',
  }

}
