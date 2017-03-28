class nail {}
define monitoring_check (
    $command,
    $runbook               = 'y/rb-generic-alerts',
    $check_every           = '1m',
    $alert_after           = '0s',
    $realert_every         = '-1',
    $irc_channels          = undef,
    $notification_email    = 'undef',
    $ticket                = false,
    $project               = false,
    $tip                   = false,
    $sla                   = 'No SLA defined.',
    $page                  = false,
    $needs_sudo            = false,
    $sudo_user             = 'root',
    $team                  = 'operations',
    $ensure                = 'present',
    $dependencies          = [],
    $use_sensu             = pick($profile_sensu::enable, true),
    $use_consul            = pick($profile_consul::enable, false),
    $use_nagios            = false,
    $nagios_custom         = {},
    $low_flap_threshold    = undef,
    $high_flap_threshold   = undef,
    $aggregate             = false,
    $sensu_custom          = {},
) {}
class profile_sensu(
    $enable = true,
) {}
class profile_consul(
    $enable = true,
) {}
include profile_sensu
include profile_consul
