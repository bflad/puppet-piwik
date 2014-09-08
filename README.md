# puppet-piwik

## Description

Installs/Configures [Piwik](http://piwik.org/)

## Requirements

### Platforms

* CentOS 6
* RHEL 6

### Modules

* [apache](https://forge.puppetlabs.com/puppetlabs/apache/)
* [epel](https://forge.puppetlabs.com/stahnma/epel/)
* [logrotate](https://forge.puppetlabs.com/rodjek/logrotate/)
* [mysql](https://forge.puppetlabs.com/puppetlabs/mysql/)
* [php](https://forge.puppetlabs.com/example42/php/)
* [wget](https://forge.puppetlabs.com/maestrodev/wget/)

## Heira Data and Defaults

These facts are in the `piwik::` hiera data namespace.

Fact | Description | Type | Default
-----|-------------|------|--------
install_dir | Base installation directory for Piwik | String | /opt
log_dir | Log directory for Piwik | String | /var/log/piwik
php_binary | Location of php binary | String | /usr/bin/php
tmp_dirs | Temporary directories for Piwik | String or Array of Strings | See params.pp
url | URL to download Piwik | String | http://builds.piwik.org
version | Version of Piwik to install | String | 2.6.1
web_user | Web user for Piwik | String | apache

These facts are in the `piwik::apache::` hiera data namespace.

Fact | Description | Type | Default
-----|-------------|------|--------
access_log_file | Filename for Piwik access log | String | piwik_access.log
admin_allowed_domains | Simple Allow from configuration | String | `(example\.com|localhost)$`
admin_allowed_ips | Simple Allow from configuration | String | `^(10\.|127\.0\.0\.1|172\.|192\.168\.)`
custom_fragment | Custom configuration block for each VirtualHost | String | See params.pp
manage | Manage Apache | Boolean | true
port | HTTP port | Fixnum | 80
priority | Site ordering | String | 10
serveradmin | Server administrator email | String | noreply@example.com
ssl_port | HTTPS port | Fixnum | 443

These facts are in the `piwik::archive::` hiera data namespace.

Fact | Description | Type | Default
-----|-------------|------|--------
cron | Enables archive crontab | Boolean | true
cron_minute | Minute setting for archive crontab | String | */10
logrotate | Enables archive log logrotate | Boolean | true
url | Piwik URL to archive | String | http://localhost

These facts are in the `piwik::config::` hiera data namespace.

Fact | Description | Type | Default
-----|-------------|------|--------
manage | Manage configuration | Boolean | false (in development)

These facts are in the `piwik::mysql::` hiera data namespace.

Fact | Description | Type | Default
-----|-------------|------|--------
database | MySQL database name | String | piwik
manage | Manage MySQL | Boolean | true
password_hash | MySQL user password hash, generated via `SELECT PASSWORD('password');` | String | *56E87D7B48023AB211CCB9A23F75A3CB7A8A64F3
user | MySQL user | String | piwik

These facts are in the `piwik::php::` hiera data namespace.

Fact | Description | Type | Default
-----|-------------|------|--------
manage | Manage PHP | Boolean | true
memory_limit | PHP memory limit | String | 256M
modules | PHP modules to install | String or Array of Strings | See params.pp
pecl_modules | PECL modules to install | String or Array of Strings | See params.pp
timezone | PHP timezone | String | America/New_York

## Manifests

* `init` Installs/Configures Piwik
* `augeas` Defined resource to configure Piwik properties (in development)
* `apache` Installs/Configures Apache for Piwik
* `archive` Configures Piwik auto archive
* `config` Configure Piwik properties (in development)
* `install` Installs Piwik
* `mysql` Installs/Configures MySQL for Piwik
* `permissions` Configures permissions for Piwik
* `php` Installs/Configures PHP for Piwik

## Usage

### Default Installation

Add the below to your profile.

    class { 'piwik': }

## Testing and Development

* Quickly testing with Vagrant: [VAGRANT.md](VAGRANT.md)
* Full development and testing workflow with rspec-puppet, puppet-lint, and friends: [TESTING.md](TESTING.md)

## Contributing

Please use standard Github issues/pull requests and if possible, in combination with testing on the Vagrant boxes.

## Maintainers

* Brian Flad (<bflad417@gmail.com>)
