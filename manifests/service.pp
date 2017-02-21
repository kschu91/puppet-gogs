class gogs::service
  (

    $service_ensure         = $gogs::params::service_ensure,
    $service_name           = $gogs::service_name,
    $installation_directory = $gogs::installation_directory,
    $sysconfig              = $gogs::sysconfig,

  ) inherits gogs::params {

  $os = downcase($::osfamily)

  file { "/etc/init.d/${service_name}":
    ensure => file,
    source => "${installation_directory}/scripts/init/${os}/gogs",
    owner  => 'root',
    group  => 'root',
    mode   => '0755',
  }

  file { $gogs::params::sysconfig_script:
    ensure => file,
  }

  create_resources('gogs::sysconfig', $sysconfig)

  service { $service_name:
    ensure     => $service_ensure,
    hasrestart => true, # let puppet start and stop (restart seems to be not working)
    hasstatus  => true, # let puppet check for the process in process list (status command seems to be not working )
    enable     => true,
  }
}
