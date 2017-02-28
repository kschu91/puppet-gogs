define gogs::sysconfig::centos (

  $service_name           = $gogs::service_name,
  $installation_directory = $gogs::installation_directory,
  $owner                  = $gogs::owner,

) {

  # @see https://github.com/gogits/gogs/blob/master/scripts/init/centos/gogs
  $sysconfig = {
    'NAME'      => $service_name,
    'GOGS_USER' => $owner,
    'GOGS_HOME' => $installation_directory,
    'GOGS_PATH' => "${installation_directory}/${service_name}",
    'LOGPATH'   => "${installation_directory}/log",
    'LOGFILE'   => "${installation_directory}/log/gogs.log",
  }

  file { "/etc/sysconfig/${service_name}":
    ensure  => 'file',
    content => template('gogs/sysconfig.erb'),
    owner   => 'root',
    group   => 'root',
    mode    => '0755',
    notify  => Service[$service_name],
    before  => File["/etc/rc.d/init.d/${service_name}"],
  }

  file { "/etc/rc.d/init.d/${service_name}":
    ensure => file,
    source => "${installation_directory}/scripts/init/centos/gogs",
    owner  => 'root',
    group  => 'root',
    mode   => '0755',
    notify => Service[$service_name],
  }

  # puppet does not automatically check changes in systemctl
  # this sucks hard!
  # @see https://tickets.puppetlabs.com/browse/PUP-3483
  # @see https://github.com/puppetlabs/puppetlabs-firewall/blob/master/manifests/linux/redhat.pp#L46
  exec { 'systemctl daemon-reload':
    before => Service[$service_name],
    unless => "systemctl is-active ${service_name}",
    path   => [ '/bin/', '/sbin/', '/usr/bin/', '/usr/sbin/' ],
  }

  File["/etc/rc.d/init.d/${service_name}"] -> Exec['systemctl daemon-reload']
  File["/etc/sysconfig/${service_name}"] -> Exec['systemctl daemon-reload']
}