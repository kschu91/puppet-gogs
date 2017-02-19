class gogs::user
  (

    $manage_user = $gogs::manage_user,
    $manage_home = $gogs::manage_home,
    $owner       = $gogs::owner,
    $group       = $gogs::group,
    $home        = $gogs::home,

  ) inherits gogs::params {

  if $manage_user {

    group { $group:
      ensure => present,
      system => true,
    }

      ->

      user { $owner:
        ensure     => present,
        gid        => $group,
        home       => $home,
        managehome => $manage_home,
        system     => true,
      }

  }
}
