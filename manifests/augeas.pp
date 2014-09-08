# = Define: piwik::augeas
#
# Manage config.ini through augeas
#
# Here's an example how to find the augeas path to a variable:
#
#     # augtool --noload
#     augtool> rm /augeas/load
#     rm : /augeas/load 781
#     augtool> set /augeas/load/myfile/lens @PHP
#     augtool> set /augeas/load/myfile/incl /opt/piwik/config/global.ini.php
#     augtool> load
#     augtool> print
#     ...
#     /files/opt/piwik/config/global.ini.php/Database/host = ""
#     /files/opt/piwik/config/global.ini.php/Development/enabled = "0"
#     /files/opt/piwik/config/global.ini.php/General/enable_processing_unique_visitors_day = "1"
#     ...
#     augtool> exit
#     #
#
# The part after 'global.ini.php/' is what you need to use as 'entry'.
#
# == Parameters
#
# [*entry*]
#   Augeas path to entry to be modified.
#
# [*ensure*]
#   Standard puppet ensure variable
#
# [*target*]
#   Which config.ini.php to manipulate, defaults to ${install_dir}/config/config.ini.php
#
# [*value*]
#   Value to set
#
# == Examples
#
# piwik::augeas {
#   'database-host':
#     entry  => 'database/host',
#     value  => 'localhost';
#   'general-maintenance_mode':
#     entry  => 'General/maintenance_mode',
#     ensure => absent;
# }
#
define piwik::augeas (
  $entry,
  $ensure = present,
  $target = "${piwik::install_dir}/config/config.ini.php",
  $value  = '',
  ) {
  include piwik

  $changes = $ensure ? {
    present => [ "set '${entry}' '${value}'" ],
    absent  => [ "rm '${entry}'" ],
  }

  augeas { "piwik_config_ini-${name}":
    incl    => $target,
    lens    => 'Php.lns',
    changes => $changes,
  }
}