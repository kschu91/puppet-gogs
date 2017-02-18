class gogs::app_ini(

  $installation_directory = $gogs::installation_directory,
  $owner          = $gogs::owner,
  $group          = $gogs::group,

  $app_ini = $gogs::app_ini,
  $app_ini_sections = $gogs::app_ini_sections,

) inherits gogs::params {

  $template_app_ini =   deep_merge($gogs::params::app_ini, $app_ini)
  $template_app_ini_sections =   deep_merge($gogs::params::app_ini_sections, $app_ini_sections)

  file { "${installation_directory}/custom":
    ensure => 'directory',
    owner  => $owner,
    group  => $group,
  } ->

  file { "${installation_directory}/custom/conf":
    ensure => 'directory',
    owner  => $owner,
    group  => $group,
  } ->

  file { "${installation_directory}/custom/conf/app.ini":
    ensure  => 'file',
    content => template('gogs/app.ini.erb'),
    owner   => $owner,
    group   => $group,
  }
}
