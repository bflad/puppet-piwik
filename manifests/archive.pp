# == Class: piwik::archive
#
# Configure Piwik auto archive
#
# === Parameters
#
# [*cron*]
#   Enables archive crontab, defaults to true, set
#   any other value to disable
#
# [*cron_minute*]
#   Minute setting for archive crontab, defaults to */10
#
# [*install_dir*]
#   Base installation directory for Piwik, defaults to /opt
#
# [*log_dir*]
#   Log directory for Piwik, defaults to /var/log/piwik
#
# [*logrotate*]
#   Enables archive log logrotate, defaults to true,
#   set any other value to disable
#
# [*php_binary*]
#   Location of php binary, see defaults in params
#
# [*url*]
#   Piwik URL to archive, defaults to http://localhost
#
# [*user*]
#   Web user for Piwik, defaults to apache
#
# === Examples
#
#  class { piwik:
#    version => '2.6.1',
#  }
#
# === Authors
#
# Brian Flad <bflad417@gmail.com>
#
# === Copyright
#
# Copyright (c) 2014 Brian Flad Licensed under the Apache 2.0 License
#
class piwik::archive(
  $cron        = $piwik::params::archive_cron,
  $cron_minute = $piwik::params::archive_cron_minute,
  $install_dir = $piwik::params::install_dir,
  $log_dir     = $piwik::params::log_dir,
  $logrotate   = $piwik::params::archive_logrotate,
  $php_binary  = $piwik::params::php_binary,
  $url         = $piwik::params::archive_url,
  $user        = $piwik::params::web_user,
  ) inherits piwik::params {
  if $cron == true {
    cron { 'piwik-archive':
      command  => "${php_binary} ${install_dir}/piwik/console core:archive --url=${url} >> ${log_dir}/piwik-archive.log",
      user     => $user,
      minute   => $cron_minute,
    }
  }

  if $logrotate == true {
    logrotate::rule { 'piwik-archive':
     path          => "${log_dir}/piwik-archive.log",
     compress      => true,
     rotate_every  => 'day',
     rotate        => 5,
     missingok     => true,
    }
  }
}
