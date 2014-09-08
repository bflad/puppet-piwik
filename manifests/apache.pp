# == Class: piwik::apache
#
# Configure Apache for Piwik
#
# === Parameters
#
# [*access_log_file*]
#   Filename for Piwik access log, defaults to piwik_access.log
#
# [*admin_allowed_domains*]
#   Simple Allow from configuration, defaults to (example\.com|localhost)$
#
# [*admin_allowed_ips*]
#   Simple Allow from configuration, defaults to ^(10\.|127\.0\.0\.1|172\.|192\.168\.)
#
# [*custom_fragment*]
#   Custom configuration block for each VirtualHost, see params.pp
#
# [*install_dir*]
#   Base installation directory for Piwik, defaults to /opt
#
# [*manage*]
#   Manage Apache, defaults to true
#
# [*port*]
#   HTTP port, defaults to 80
#
# [*priority*]
#   Site ordering, defaults to 10
#
# [*serveradmin*]
#   Server administrator email, defaults to noreply@example.com
#
# [*ssl_port*]
#   HTTPS port, defaults to 443
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
class piwik::apache(
  $access_log_file       = $piwik::params::apache_access_log_file,
  $admin_allowed_domains = $piwik::params::apache_admin_allowed_domains,
  $admin_allowed_ips     = $piwik::params::apache_admin_allowed_ips,
  $custom_fragment       = $piwik::params::apache_custom_fragment,
  $install_dir           = $piwik::params::install_dir,
  $manage                = $piwik::params::apache_manage,
  $port                  = $piwik::params::apache_port,
  $priority              = $piwik::params::apache_priority,
  $serveradmin           = $piwik::params::apache_serveradmin,
  $ssl_port              = $piwik::params::apache_ssl_port,
  ) inherits piwik::params {
  if $apache_manage == true {
    class { '::apache': }
    class { '::apache::mod::fcgid': }
    class { '::apache::mod::php': }

    if $admin_allowed_domains != '' {
      $_custom_fragment_domains = "RewriteCond %{REMOTE_HOST} ${admin_allowed_domains} [OR]"
    } else {
      $_custom_fragment_domains = ''
    }

    if $admin_allowed_ips != '' {
      $_custom_fragment_ips = "RewriteCond %{REMOTE_ADDR} ${admin_allowed_ips} [OR]"
    } else {
      $_custom_fragment_ips = ''
    }

    if $custom_fragment {
      $_custom_fragment = $custom_fragment
    } else {
      $_custom_fragment = "
      IndexIgnore *
      Options All -Indexes
      DirectoryIndex index.php index.html
      ServerSignature Off
      RewriteEngine On

      # Disable all methods except GET and POST, as only those are needed
      # (Note: TRACE does not seem to be possible to disable in .htaccess, only in server config by the host)
      RewriteCond %{REQUEST_METHOD} !^(GET|POST) [NC]
      # Return 405 Method Not Allowed
      RewriteRule .* - [R=405,L]

      RewriteCond %{THE_REQUEST} (\\\\r|\\\\n|%0A|%0D) [NC,OR]
      RewriteCond %{HTTP_REFERER} (<|>|’|%0A|%0D|%27|%3C|%3E|%00) [NC,OR]
      RewriteCond %{HTTP_COOKIE} (<|>|’|%0A|%0D|%27|%3C|%3E|%00) [NC,OR]
      RewriteCond %{REQUEST_URI} ^/(,|;|:|<|>|”>|”<|/|\\\\\\.\\.\\\\).{0,9999} [NC,OR]

      #Block mySQL injects
      RewriteCond %{QUERY_STRING} (;|<|>|’|”|\\)|%0A|%0D|%22|%27|%3C|%3E|%00).*(/\\*|union|select|insert|cast|set|declare|drop|update|md5|benchmark) [NC,OR]
      RewriteCond %{QUERY_STRING} \\.\\./\\.\\. [OR]
      RewriteCond %{QUERY_STRING} (localhost|loopback|127\\.0\\.0\\.1) [NC,OR]
      # Comment by jawsmith: commented following out, as otherwise error by the world map widget (flash)
      #RewriteCond %{QUERY_STRING} \\.[a-z0-9] [NC,OR]
      RewriteCond %{QUERY_STRING} (<|>|’|%0A|%0D|%27|%3C|%3E|%00) [NC]
      # Return 403 Forbidden
      RewriteRule .* - [F]

      #Block out some common exploits
      # If the request query string contains /proc/self/environ (by SigSiu.net)
      RewriteCond %{QUERY_STRING} proc/self/environ [OR]
      # Block out any script trying to set a mosConfig value through the URL
      # (these attacks wouldn't work w/out Joomla! 1.5's Legacy Mode plugin)
      RewriteCond %{QUERY_STRING} mosConfig_[a-zA-Z_]{1,21}(=|\\%3D) [OR]
      # Block out any script trying to base64_encode or base64_decode data within the URL
      RewriteCond %{QUERY_STRING} base64_(en|de)code[^(]*\\([^)]*\\) [OR]
      ## IMPORTANT: If the above line throws an HTTP 500 error, replace it with these 2 lines:
      # RewriteCond %{QUERY_STRING} base64_encode\\(.*\\) [OR]
      # RewriteCond %{QUERY_STRING} base64_decode\\(.*\\) [OR]
      # Block out any script that includes a <script> tag in URL
      RewriteCond %{QUERY_STRING} (<|%3C)([^s]*s)+cript.*(>|%3E) [NC,OR]
      # Block out any script trying to set a PHP GLOBALS variable via URL
      RewriteCond %{QUERY_STRING} GLOBALS(=|\\[|\\%[0-9A-Z]{0,2}) [OR]
      # Block out any script trying to modify a _REQUEST variable via URL
      RewriteCond %{QUERY_STRING} _REQUEST(=|\\[|\\%[0-9A-Z]{0,2})
      # Return 403 Forbidden
      RewriteRule .* - [F]

      #File injection protection, by SigSiu.net
      RewriteCond %{REQUEST_METHOD} GET
      RewriteCond %{QUERY_STRING} [a-zA-Z0-9_]=http:// [OR]
      RewriteCond %{QUERY_STRING} [a-zA-Z0-9_]=(\\.\\.//?)+ [OR]
      RewriteCond %{QUERY_STRING} [a-zA-Z0-9_]=/([a-z0-9_.]//?)+ [NC]
      RewriteRule .* - [F]

      ## Disallow PHP Easter Eggs (can be used in fingerprinting attacks to determine
      ## your PHP version). See http://www.0php.com/php_easter_egg.php and
      ## http://osvdb.org/12184 for more information
      RewriteCond %{QUERY_STRING} \\\\=PHP[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12} [NC]
      RewriteRule .* - [F]

      ## SQLi first line of defense, thanks to Radek Suski (SigSiu.net) @
      ## http://www.sigsiu.net/presentations/fortifying_your_joomla_website.html
      ## May cause problems on legitimate requests
      RewriteCond %{QUERY_STRING} concat[^\\(]*\\( [NC,OR]
      RewriteCond %{QUERY_STRING} union([^s]*s)+elect [NC,OR]
      RewriteCond %{QUERY_STRING} union([^a]*a)+ll([^s]*s)+elect [NC]
      RewriteRule .* - [F]

      ## Allow robots exclusion file
      RewriteRule ^/robots\\.txt$ - [L]

      ## Allow Piwik API files or plain directories
      RewriteRule ^/((piwik\\.(php|js))?)?$ - [L]
      RewriteRule ^/js(/(index\\.php|piwik\\.js)?)?$ - [L]
      ${_custom_fragment_domains}
      ${_custom_fragment_ips}
      RewriteCond %{QUERY_STRING} action=optOut
      RewriteRule ^/index\\.php - [L]

      ## Allow limited access for certain Piwik system directories with client-accessible content
      RewriteRule ^/(libs|plugins|themes)/([^/]+/)*([^/.]+\\.)+(jp(e?g|2)?|png|gif|bmp|css|js|swf|html?|pdf|svg|ico)$ - [L]

      ## Disallow access to all other (works, as only resources explicitly allowed above are accessed, no SEO pseudo directories)
      RewriteRule .* - [F]
      "
    }

    ::apache::vhost { 'piwik':
      access_log_file => $access_log_file,
      custom_fragment => $_custom_fragment,
      docroot         => "${install_dir}/piwik",
      port            => $port,
      priority        => $priority,
      serveradmin     => $serveradmin,
    }
    ::apache::vhost { 'piwik-ssl':
      access_log_file => "ssl_${access_log_file}",
      custom_fragment => $_custom_fragment,
      docroot         => "${install_dir}/piwik",
      port            => $ssl_port,
      priority        => $priority,
      serveradmin     => $serveradmin,
      ssl             => true,
    }
  }
}
