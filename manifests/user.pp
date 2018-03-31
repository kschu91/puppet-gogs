class gogs::user (

  $manage_user   = $gogs::manage_user,
  $manage_home   = $gogs::manage_home,
  $owner         = $gogs::owner,
  $group         = $gogs::group,
  $home_internal = $gogs::variables::home_internal,

) {

  if $manage_user {

    group { $group:
      ensure => present,
      system => true,
    }

    user { $owner:
      ensure     => present,
      gid        => $group,
      home       => $home_internal,
      managehome => $manage_home,
      system     => true,
      require    => Group[$group],
    }
  }
}
