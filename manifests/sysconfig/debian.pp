define gogs::sysconfig::debian (

  $service_name           = $gogs::service_name,
  $installation_directory = $gogs::installation_directory,
  $owner                  = $gogs::owner,
  $group                  = $gogs::group,
  $home                   = $gogs::home,

) {

  file { "/etc/systemd/system/${service_name}.service":
    ensure => file,
    source => "${installation_directory}/scripts/systemd/gogs.service",
    owner  => 'root',
    group  => 'root',
    mode   => '0644',
    replace => false,
    notify => Service[$service_name],
  }  ~>
  exec { '/bin/systemctl daemon-reload':
    refreshonly => true,
    notify => Service[$service_name],
  }

  file_line { '${service_name}.service User':
    ensure => present,
    path   => "/etc/systemd/system/${service_name}.service",
    line   => "User=${owner}",
    match  => "^User=",
    notify => Exec['/bin/systemctl daemon-reload'],
  }
  file_line { '${service_name}.service Group':
    ensure => present,
    path   => "/etc/systemd/system/${service_name}.service",
    line   => "Group=${group}",
    match  => "^Group=",
    notify => Exec['/bin/systemctl daemon-reload'],
  }
  file_line { '${service_name}.service WorkingDirectory':
    ensure => present,
    path   => "/etc/systemd/system/${service_name}.service",
    line   => "WorkingDirectory=${installation_directory}",
    match  => "^WorkingDirectory=",
    notify => Exec['/bin/systemctl daemon-reload'],
  }
  file_line { '${service_name}.service ExecStart':
    ensure => present,
    path   => "/etc/systemd/system/${service_name}.service",
    line   => "ExecStart=${installation_directory}/gogs web",
    match  => "^ExecStart=",
    notify => Exec['/bin/systemctl daemon-reload'],
  }
  file_line { '${service_name}.service Environment':
    ensure => present,
    path   => "/etc/systemd/system/${service_name}.service",
    line   => "Environment=USER=${owner} HOME=${home}",
    match  => "^Environment=",
    notify => Exec['/bin/systemctl daemon-reload'],
  }
}
