# == Class: piwik::install
#
# Install Piwik
#
# === Parameters
#
# [*install_dir*]
#   Base installation directory for Piwik, defaults to /opt
#
# [*url*]
#   URL to download Piwik, defaults to http://builds.piwik.org
#
# [*version*]
#   Version of Piwik to install, defaults to 2.6.1
#
# === Examples
#
#  class { piwik::install:
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
class piwik::install(
  $install_dir = $piwik::params::install_dir,
  $url         = $piwik::params::url,
  $version     = $piwik::params::version,
  ) inherits piwik::params {
  require wget

  wget::fetch { 'download-piwik':
    source      => "${url}/piwik-${version}.tar.gz",
    destination => "${install_dir}/piwik-${version}.tar.gz",
  } ->

  exec { 'untar-piwik':
    command => "/bin/tar xf ${install_dir}/piwik-${version}.tar.gz",
    cwd     => $install_dir,
    creates => "${install_dir}/piwik/piwik.php",
  }
}
