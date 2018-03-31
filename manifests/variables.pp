class gogs::variables (

  $home                   = $gogs::home,
  $installation_directory = $gogs::installation_directory,
  $log_path               = $gogs::log_path,
  $owner                  = $gogs::owner,

) {

  # make sure log_path is used with the installation_directory provided in gogs::init
  if $log_path == undef {
    $log_path_internal = "${installation_directory}/log"
  }else {
    $log_path_internal = $log_path
  }

  # make sure home is used with the owner provided in gogs::init
  if $home == undef {
    $home_internal = "/home/${owner}"
  }else {
    $home_internal = $home
  }
}