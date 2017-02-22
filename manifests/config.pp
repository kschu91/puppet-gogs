class gogs::config (

  $owner           = $gogs::owner,
  $group           = $gogs::group,
  $repository_root = $gogs::repository_root,

) inherits gogs::params {

  file { $repository_root:
    ensure => 'directory',
    owner  => $owner,
    group  => $group,
  }

    ->

    # @todo make log path configurable (app.ini: [log] ROOT_PATH && $::gogs::params::sysconfig[LOGPATH])
    file { "$repository_root/log":
      ensure => 'directory',
      owner  => $owner,
      group  => $group,
    }
}
