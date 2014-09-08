# == Class: piwik::params
#
# Default parameters for Piwik
#
# === Authors
#
# Brian Flad <bflad417@gmail.com>
#
# === Copyright
#
# Copyright (c) 2014 Brian Flad Licensed under the Apache 2.0 License
#
class piwik::params {
  $apache_access_log_file       = 'piwik_access.log'
  $apache_admin_allowed_ips     = '^(10\.|127\.0\.0\.1|172\.|192\.168\.)'
  $apache_admin_allowed_domains = '(example\.com|localhost)$'
  $apache_custom_fragment       = undef
  $apache_manage                = true
  $apache_port                  = 80
  $apache_priority              = '10'
  $apache_serveradmin           = 'noreply@example.com'
  $apache_ssl_port              = 443

  $archive_cron        = true
  $archive_cron_minute = '*/10'
  $archive_logrotate   = true
  $archive_url         = 'http://localhost'

  $config_manage = false # in development

  $install_dir = '/opt'
  $log_dir     = '/var/log/piwik'

  $mysql_database      = 'piwik'
  $mysql_manage        = true
  $mysql_password_hash = '*56E87D7B48023AB211CCB9A23F75A3CB7A8A64F3'
  $mysql_user          = 'piwik'

  $php_binary       = '/usr/bin/php'
  $php_manage       = true
  $php_memory_limit = '256M'
  $php_modules      = ['gd', 'mbstring', 'mcrypt', 'mysql', 'pdo', 'recode', 'xml']
  $php_pecl_modules = ['apc', 'geoip']
  $php_timezone     = 'America/New_York'

  $tmp_dirs = [
    "${install_dir}/piwik/tmp",
    "${install_dir}/piwik/tmp/assets",
    "${install_dir}/piwik/tmp/cache",
    "${install_dir}/piwik/tmp/logs",
    "${install_dir}/piwik/tmp/tcpdf",
    "${install_dir}/piwik/tmp/templates_c"
  ]
  $url      = 'http://builds.piwik.org'
  $version  = '2.6.1'
  $web_user = 'apache'
}
