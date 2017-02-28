define gogs::sysconfig::debian (

  $service_name           = $gogs::service_name,
  $installation_directory = $gogs::installation_directory,
  $owner                  = $gogs::owner,

) {

  # @see https://github.com/gogits/gogs/blob/master/scripts/init/centos/gogs
  $sysconfig = {
    'NAME'       => $service_name,
    'USER'       => $owner,
    'WORKINGDIR' => $installation_directory,
    'DAEMON'     => "${installation_directory}/${service_name}",
  }

  file { "/etc/default/${service_name}":
    ensure  => 'file',
    content => template('gogs/sysconfig.erb'),
    owner   => 'root',
    group   => 'root',
    mode    => '0755',
    notify  => Service[$service_name],
    before  => File["/etc/init.d/${service_name}"],
  }

  file { "/etc/init.d/${service_name}":
    ensure => file,
    source => "${installation_directory}/scripts/init/debian/gogs",
    owner  => 'root',
    group  => 'root',
    mode   => '0755',
    notify  => Service[$service_name],
  }

}
