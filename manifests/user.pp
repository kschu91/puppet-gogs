class gogs::user (

  $manage_user = $gogs::manage_user,
  $manage_home = $gogs::manage_home,
  $owner       = $gogs::owner,
  $group       = $gogs::group,
  $home        = $gogs::home,

) {

  if $home == undef {
    $homedir = "/home/${owner}"
  }else {
    $homedir = $home
  }

  if $manage_user {

    validate_absolute_path($homedir)

    group { $group:
      ensure => present,
      system => true,
    }

    user { $owner:
      ensure     => present,
      gid        => $group,
      home       => $homedir,
      managehome => $manage_home,
      system     => true,
      require    => Group[$group]
    }

  }
}
