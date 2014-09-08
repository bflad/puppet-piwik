# == Class: piwik::php
#
# Install PHP for Piwik
#
# === Parameters
#
# [*manage*]
#   Manage PHP, defaults to true
#
# [*memory_limit*]
#   PHP memory limit, defaults to 256M
#
# [*modules*]
#   PHP modules to install, see defaults in params
#
# [*pecl_modules*]
#   PECL modules to install, see defaults in params
#
# [*timezone*]
#   PHP timezone, defaults to America/New_York
#
# === Examples
#
#  class { piwik::php: }
#
# === Authors
#
# Brian Flad <bflad417@gmail.com>
#
# === Copyright
#
# Copyright (c) 2014 Brian Flad Licensed under the Apache 2.0 License
#
class piwik::php(
  $manage       = $piwik::params::php_manage,
  $memory_limit = $piwik::params::php_memory_limit,
  $modules      = $piwik::params::php_modules,
  $pecl_modules = $piwik::params::php_pecl_modules,
  $timezone     = $piwik::params::php_timezone,
  ) inherits piwik::params {
  if $manage == true {
    require '::epel'
    require '::php'

    package { 'uuid-php': }
    php::module { $modules: }
    php::module { $pecl_modules:
      module_prefix => 'php-pecl-',
    }
    php::augeas {
      'php-memorylimit':
        entry  => 'PHP/memory_limit',
        value  => $memory_limit;
      'php-date_timezone':
        entry  => 'Date/date.timezone',
        value  => $timezone;
    }
  }
}
