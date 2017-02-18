# == Class gogs::sysconfig
#
# This class is called from gogs
#
define gogs::sysconfig(
  $value,
) {
  validate_string($value)

  file_line { "Gogs sysconfig setting ${name}":
    path   => $gogs::params::sysconfig_script,
    line   => "${name}=\"${value}\"",
    match  => "^${name}=",
    notify => Service[$gogs::params::service_name]
  }
}
