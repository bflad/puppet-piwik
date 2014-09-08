# == Class: piwik::config
#
# Configure Piwik
#
# === Parameters
#
# [*manage*]
#   Manage configuration, defaults to true
#
# [*database*]
#   Database configuration, defaults to {
#     host         => "localhost",
#     username     => "piwik",
#     password     => "piwik123",
#     table_prefix       => "piwik",
#     table_prefix => "piwik_"
#   }
#
# === Examples
#
#  class { piwik::config: }
#
# === Authors
#
# Brian Flad <bflad417@gmail.com>
#
# === Copyright
#
# Copyright (c) 2014 Brian Flad Licensed under the Apache 2.0 License
#
class piwik::config(
  $manage   = $piwik::params::config_manage,
  $database = {
    host         => $piwik::params::mysql_host,
    username     => $piwik::params::mysql_username,
    password     => $piwik::params::mysql_password,
    dbname       => $piwik::params::mysql_database,
    table_prefix => $piwik::params::mysql_table_prefix,
    charset      => 'utf8',
  },
  ) inherits piwik::params {
  if $manage == true {
    piwik::augeas {
      'database-host':
        entry  => 'database/host',
        value  => $memory_limit;
      'php-date_timezone':
        entry  => 'Date/date.timezone',
        value  => $timezone;
    }
  }
}
