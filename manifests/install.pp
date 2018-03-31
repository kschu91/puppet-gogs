class gogs::install (

  $version                = $gogs::version,

  $owner                  = $gogs::owner,
  $group                  = $gogs::group,

  $service_name           = $gogs::service_name,

  $installation_directory = $gogs::installation_directory,
  $repository_root        = $gogs::repository_root,

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

  # @todo make log path configurable (app.ini: [log] ROOT_PATH && $::gogs::params::sysconfig[LOGPATH])
  file { "${installation_directory}/log":
    ensure => 'directory',
    owner  => $owner,
    group  => $group,
  }

  exec { 'download_gogs_from_github':
    command     => '/tmp/download_gogs_from_github.sh',
    user        => $owner,
    group       => $group,
    environment => [
      "PUPPET_GOGS_INSTALLATION_DIRECTORY=${installation_directory}",
      'PUPPET_GOGS_OS=linux',
      "PUPPET_GOGS_ARCH=${::architecture}",
      "PUPPET_GOGS_VERSION=${version}",
    ],
    logoutput   => true,
    notify      => Service[$service_name],
    require     => [
      File[$repository_root],
      File[$installation_directory],
      File["${installation_directory}/log"],
      File['/tmp/download_gogs_from_github.sh'],
      File['/tmp/gogs_check_version.sh'],
    ],
    # only run if version has changed and needs to be updated
    onlyif      => "/bin/bash /tmp/gogs_check_version.sh ${installation_directory} ${version}",
    path        => ['/usr/bin', '/usr/sbin', '/bin'],
  }

  file { '/tmp/download_gogs_from_github.sh':
    ensure => 'file',
    path   => '/tmp/download_gogs_from_github.sh',
    source => 'puppet:///modules/gogs/download.sh',
    owner  => 'root',
    group  => 'root',
    mode   => '0755',
  }

  file { '/tmp/gogs_check_version.sh':
    ensure => 'file',
    path   => '/tmp/gogs_check_version.sh',
    source => 'puppet:///modules/gogs/version.sh',
    owner  => 'root',
    group  => 'root',
    mode   => '0755',
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