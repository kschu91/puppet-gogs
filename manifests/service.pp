class gogs::service
  (

    $service_ensure         = $gogs::service_ensure,
    $service_name           = $gogs::service_name,
    $installation_directory = $gogs::installation_directory,
    $sysconfig              = $gogs::sysconfig,
    $owner                  = $gogs::owner,

  ) {

  case $::operatingsystem {
    'RedHat': {
      ::gogs::sysconfig::centos { 'RedHat': }
    }
    'OracleLinux': {
      ::gogs::sysconfig::centos { 'OracleLinux': }
    }
    'CentOS': {
      ::gogs::sysconfig::centos { 'CentOS': }
    }
    'Debian': {
      ::gogs::sysconfig::debian { 'Debian': }
    }
    'Ubuntu': {
      ::gogs::sysconfig::debian { 'Ubuntu': }
    }
  }

  service { $service_name:
    ensure     => $service_ensure,
    enable     => true,
    hasstatus  => false,
    hasrestart => false,
  }
}
