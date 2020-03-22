class gogs (

  $service_ensure         = $gogs::params::service_ensure,
  $service_name           = $gogs::params::service_name,

  $manage_packages        = $gogs::params::manage_packages,

  $enable_puppetstats     = $gogs::params::enable_puppetstats,

  $version                = $gogs::params::version,
  $installation_directory = $gogs::params::installation_directory,
  $repository_root        = $gogs::params::repository_root,

  $manage_user            = $gogs::params::manage_user,
  $manage_home            = $gogs::params::manage_home,
  $owner                  = $gogs::params::owner,
  $group                  = $gogs::params::group,
  $home                   = undef,

  $app_ini                = {},
  $app_ini_sections       = {},

  $sysconfig              = {},

  $log_path               = undef,

) inherits gogs::params {

  puppetstats { 'kschu91-gogs': enabled => $enable_puppetstats }

  if !($::operatingsystem in [ 'RedHat', 'OracleLinux', 'CentOS', 'Debian', 'Ubuntu' ]) {
    warning("${::operatingsystem} not supported yet: Gogs might not running as expected!")
  }

  anchor { 'gogs::begin': }
  -> class { 'gogs::variables': }
  -> class { 'gogs::packages': }
  -> class { 'gogs::user': }
  -> class { 'gogs::install': }
  -> class { 'gogs::app_ini': }
  -> class { 'gogs::service': }
  -> anchor { 'gogs::end': }

}
