class gogs::install(

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
    '/tmp/install_gogs.sh':
      ensure    => 'file',
      path      => '/tmp/install_gogs.sh',
      source    => 'puppet:///modules/gogs/install.sh',
      mode      => '0755',
      notify    => Exec['install_gogs'],
  }
  exec { 'install_gogs':
    command      => "/tmp/install_gogs.sh ${installation_directory} linux ${::architecture} ${version}",
    user         => $owner,
    group        => $group,
    environment  => ["HOME=${$home}"],
    refreshonly  => true
  }

}
