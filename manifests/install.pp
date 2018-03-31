class gogs::install (

  $version                = $gogs::version,

  $owner                  = $gogs::owner,
  $group                  = $gogs::group,

  $service_name           = $gogs::service_name,

  $installation_directory = $gogs::installation_directory,
  $repository_root        = $gogs::repository_root,
  $log_path_internal      = $gogs::variables::log_path_internal,

) {

  file { $repository_root:
    ensure => 'directory',
    owner  => $owner,
    group  => $group,
    notify => Exec["permissions:${repository_root}"],
  }

  file { $installation_directory:
    ensure => 'directory',
    owner  => $owner,
    group  => $group,
    notify => Exec["permissions:${installation_directory}"],
  }

  file { $log_path_internal:
    ensure  => 'directory',
    owner   => $owner,
    group   => $group,
    require => File[$installation_directory],
  }

  file { "${installation_directory}/scripts":
    ensure  => 'directory',
    owner   => $owner,
    group   => $group,
    require => File[$installation_directory],
  }

  exec { 'download_gogs_from_github':
    command     => "${installation_directory}/scripts/kschu91-gogs.download.sh",
    user        => $owner,
    group       => $group,
    environment => [
      "PUPPET_GOGS_INSTALLATION_DIRECTORY=${installation_directory}",
      'PUPPET_GOGS_OS=linux',
      "PUPPET_GOGS_ARCH=${::architecture}",
      "PUPPET_GOGS_VERSION=${version}",
    ],
    logoutput   => true,
    onlyif      => "bash ${installation_directory}/scripts/kschu91-gogs.version.sh ${installation_directory} ${version}"
    ,
    path        => [ '/bin/', '/sbin/', '/usr/bin/', '/usr/sbin/' ],
    notify      => Service[$service_name],
    require     => [
      File[$repository_root],
      File[$installation_directory],
      File['kschu91-gogs.download.sh'],
      File['kschu91-gogs.version.sh'],
    ],
  }

  file { 'kschu91-gogs.download.sh':
    ensure  => 'file',
    path    => "${installation_directory}/scripts/kschu91-gogs.download.sh",
    source  => 'puppet:///modules/gogs/download.sh',
    user    => $owner,
    group   => $group,
    mode    => '0755',
    require => File["${installation_directory}/scripts"],
  }

  file { 'kschu91-gogs.version.sh':
    ensure  => 'file',
    path    => "${installation_directory}/scripts/kschu91-gogs.version.sh",
    source  => 'puppet:///modules/gogs/version.sh',
    user    => $owner,
    group   => $group,
    mode    => '0755',
    require => File["${installation_directory}/scripts"],
  }

  # just to make sure permissions are fine if owner or group is changed afterwards
  exec { "permissions:${installation_directory}":
    command     => "/bin/chown -Rf ${owner}:${group} ${installation_directory}",
    refreshonly => true,
  }

  # just to make sure permissions are fine if owner or group is changed afterwards
  exec { "permissions:${repository_root}":
    command     => "/bin/chown -Rf ${owner}:${group} ${repository_root}",
    refreshonly => true,
  }
}