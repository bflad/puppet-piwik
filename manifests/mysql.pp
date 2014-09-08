# == Class: piwik::mysql
#
# Install and configure MySQL for Piwik
#
# === Parameters
#
# [*database*]
#   MySQL database name, defaults to piwik
#
# [*manage*]
#   Manage MySQL, defaults to true
#
# [*password_hash*]
#   MySQL user password hash, generated via SELECT PASSWORD('password');,
#   defaults to *56E87D7B48023AB211CCB9A23F75A3CB7A8A64F3 from PASSWORD('piwik123')
#
# [*user*]
#   MySQL user, defaults to piwik
#
# === Examples
#
#  class { piwik::mysql: }
#
# === Authors
#
# Brian Flad <bflad417@gmail.com>
#
# === Copyright
#
# Copyright (c) 2014 Brian Flad Licensed under the Apache 2.0 License
#
class piwik::mysql(
  $database      = $piwik::params::mysql_database,
  $manage        = $piwik::params::mysql_manage,
  $password_hash = $piwik::params::mysql_password_hash,
  $user          = $piwik::params::mysql_user,
  ) inherits piwik::params {
  if $manage == true {
    class { '::mysql::client': }
    class { '::mysql::server':
      databases => {
        "${database}" => {
          charset => 'utf8'
        }
      },
      grants => {
        "${user}@localhost/${database}.*" => {
          privileges => ['ALL'],
          table      => "${database}.*",
          user       => "${user}@localhost",
        }
      },
      users => {
        "${user}@localhost" => {
          password_hash => $password_hash
        }
      },
    }
  }
}
