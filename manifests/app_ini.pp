class gogs::app_ini (

  $installation_directory = $gogs::installation_directory,
  $repository_root        = $gogs::repository_root,
  $service_name           = $gogs::service_name,

  $owner                  = $gogs::owner,
  $group                  = $gogs::group,

  $app_ini                = $gogs::app_ini,
  $app_ini_sections       = $gogs::app_ini_sections,

  $log_path               = $gogs::log_path,

) {

  $default_app_in = {
    'RUN_USER' => $owner,
  }

  $default_ini_sections = {
    'repository' => {
      'ROOT' => $repository_root,
    },
    'log'        => {
      'ROOT_PATH' => $log_path,
    },
  }

  $template_app_ini = deep_merge($gogs::params::app_ini, $default_app_in, $app_ini)
  $template_app_ini_sections = deep_merge($gogs::params::app_ini_sections, $default_ini_sections, $app_ini_sections)

  file { "${installation_directory}/custom":
    ensure => 'directory',
    owner  => $owner,
    group  => $group,
  }

  file { "${installation_directory}/custom/conf":
    ensure  => 'directory',
    owner   => $owner,
    group   => $group,
    require => File["${installation_directory}/custom"],
  }

  file { "${installation_directory}/custom/conf/app.ini":
    ensure  => 'file',
    content => template('gogs/app.ini.erb'),
    owner   => $owner,
    group   => $group,
    notify  => Service[$service_name],
    require => File["${installation_directory}/custom/conf"],
  }
}
