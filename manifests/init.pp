# == Class: piwik
#
# Installs Piwik
#
# === Parameters
#
# [*install_dir*]
#   Base installation directory for Piwik, defaults to /opt
#
# [*log_dir*]
#   Log directory for Piwik, defaults to /var/log/piwik
#
# [*php_binary*]
#   Location of php binary, see defaults in params
#
# [*tmp_dirs*]
#   Temporary directories for Piwik, see defaults in params
#
# [*url*]
#   URL to download Piwik, defaults to http://builds.piwik.org
#
# [*version*]
#   Version of Piwik to install, defaults to 2.6.1
#
# [*web_user*]
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
class piwik(
  $install_dir = $piwik::params::install_dir,
  $log_dir     = $piwik::params::log_dir,
  $php_binary  = $piwik::params::php_binary,
  $tmp_dirs    = $piwik::params::tmp_dirs,
  $url         = $piwik::params::url,
  $version     = $piwik::params::version,
  $web_user    = $piwik::params::web_user,
  ) inherits piwik::params {
  class { 'piwik::install':
    install_dir => $install_dir,
    url         => $url,
    version     => $version,
  } ->

  # TODO: In development
  # class { 'piwik::config':
  #   install_dir => $install_dir,
  # } ->

  class { 'piwik::mysql': } ->

  class { 'piwik::apache':
    install_dir => $install_dir,
  } ->

  class { 'piwik::php': } ->

  class { 'piwik::permissions':
    install_dir => $install_dir,
    log_dir     => $log_dir,
    tmp_dirs    => $tmp_dirs,
    user        => $web_user,
  } ->

  class { 'piwik::archive':
    install_dir => $install_dir,
    log_dir     => $log_dir,
    php_binary  => $php_binary,
    user        => $web_user,
  }
}
