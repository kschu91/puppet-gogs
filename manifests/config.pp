class gogs::config(

  $owner          = $gogs::owner,
  $group          = $gogs::group,
  $repository_root = $gogs::repository_root,

) inherits gogs::params {

  file { $repository_root:
    ensure => 'directory',
    owner  => $owner,
    group  => $group,
  }
}
