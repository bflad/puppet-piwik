# == Class: piwik::permissions
#
# Configure Piwik permissions
#
# === Parameters
#
# [*install_dir*]
#   Base installation directory for Piwik, defaults to /opt
#
# [*log_dir*]
#   Log directory for Piwik, defaults to /var/log/piwik
#
# [*tmp_dirs*]
#   Temporary directories for Piwik, see defaults in params
#
# [*user*]
#   Web user for Piwik, defaults to apache
#
# === Examples
#
#  class { piwik::permissions: }
#
# === Authors
#
# Brian Flad <bflad417@gmail.com>
#
# === Copyright
#
# Copyright (c) 2014 Brian Flad Licensed under the Apache 2.0 License
#
class piwik::permissions(
  $install_dir = $piwik::params::install_dir,
  $log_dir     = $piwik::params::log_dir,
  $tmp_dirs    = $piwik::params::tmp_dirs,
  $user        = $piwik::params::web_user,
  ) inherits piwik::params {
  file { "${install_dir}/piwik/config":
    ensure => directory,
    owner  => $web_user,
    group  => $web_user,
    mode   => '0755',
  }

  file { "${install_dir}/piwik/plugins":
    ensure => directory,
    owner  => $web_user,
    group  => $web_user,
    mode   => '0755',
  }

  file { $tmp_dirs:
    ensure => directory,
    owner  => $web_user,
    group  => $web_user,
    mode   => '0755',
  }

  file { $log_dir:
    ensure => directory,
    owner  => $web_user,
    group  => $web_user,
    mode   => '0755',
  }
}
