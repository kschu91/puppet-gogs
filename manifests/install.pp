class gogs::install (

  $owner                  = $gogs::owner,
  $group                  = $gogs::group,
  $home                   = $gogs::home,
  $installation_directory = $gogs::installation_directory,
  $version                = $gogs::version,

) {

  file { $installation_directory:
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
        mode   => '0755',
        notify => Exec['download_gogs_from_github'],
    }

  exec { 'download_gogs_from_github':
    command     => '/tmp/download_gogs_from_github.sh',
    user        => $owner,
    group       => $group,
    environment => [
      "HOME=${$home}",
      "PUPPET_GOGS_INSTALLATION_DIRECTORY=${installation_directory}",
      'PUPPET_GOGS_OS=linux',
      "PUPPET_GOGS_ARCH=${::architecture}",
      "PUPPET_GOGS_VERSION=${version}"
    ],
    logoutput   => true,
    refreshonly => true,
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
