class gogs::install (

  $version                = $gogs::version,

  $owner                  = $gogs::owner,
  $group                  = $gogs::group,

  $installation_directory = $gogs::installation_directory,
  $repository_root        = $gogs::repository_root,

) {

  file { $repository_root:
    ensure => 'directory',
    owner  => $owner,
    group  => $group,
  }

    ->

    file { $installation_directory:
      ensure => 'directory',
      owner  => $owner,
      group  => $group,
    }

    ->

    # @todo make log path configurable (app.ini: [log] ROOT_PATH && $::gogs::params::sysconfig[LOGPATH])
    file { "${installation_directory}/log":
      ensure => 'directory',
      owner  => $owner,
      group  => $group,
    }

    ->

    file {
      'create:/tmp/download_gogs_from_github.sh':
        ensure => 'file',
        path   => '/tmp/download_gogs_from_github.sh',
        source => 'puppet:///modules/gogs/download.sh',
        owner  => 'root',
        group  => 'root',
        mode   => '0755',
    }

    ->

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
      notify      => [
        Exec['remove:/tmp/download_gogs_from_github.sh'],
        Service[$gogs::params::service_name]
      ],
    }

  exec { 'remove:/tmp/download_gogs_from_github.sh':
    command     => '/bin/rm -f /tmp/download_gogs_from_github.sh',
    refreshonly => true,
  }

}
