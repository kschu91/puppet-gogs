class gogs (

  $package_ensure = $gogs::params::package_ensure,
  $service_ensure = $gogs::params::service_ensure,
  $service_name   = $gogs::params::service_name,

  $version                = $gogs::params::version,
  $installation_directory = $gogs::params::installation_directory,
  $repository_root        = $gogs::params::repository_root,

  $manage_user = $gogs::params::manage_user,
  $manage_home = $gogs::params::manage_home,
  $owner       = $gogs::params::owner,
  $group       = $gogs::params::group,
  $home        = $gogs::params::home,

  $app_ini          = { },
  $app_ini_sections = { },

  $sysconfig = $gogs::params::sysconfig,

) inherits gogs::params {

  anchor { 'gogs::begin': } ->
  class  { '::gogs::user': } ->
  class  { '::gogs::install': } ->
  class  { '::gogs::config': } ~>
  class  { '::gogs::app_ini': } ~>
  class  { '::gogs::service': } ->
  anchor { 'gogs::end': }

}
