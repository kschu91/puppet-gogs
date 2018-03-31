class gogs::packages (

  $manage_packages = $gogs::manage_packages,

) {
  if $manage_packages {
    case $::operatingsystem {
      'RedHat': {
        ensure_packages(['git', 'curl', 'wget', 'tar', 'initscripts'])
      }
      'OracleLinux': {
        ensure_packages(['git', 'curl', 'wget', 'tar', 'initscripts'])
      }
      'CentOS': {
        ensure_packages(['git', 'curl', 'wget', 'tar', 'initscripts'])
      }
      'Debian': {
        ensure_packages(['git-core', 'curl', 'wget', 'tar'])
      }
      'Ubuntu': {
        ensure_packages(['git-core', 'curl', 'wget', 'tar'])
      }
      default: {
        warning("${::operatingsystem}
           not supported yet: Make sure dependend packages git, curl, wget and tar are installed!")
      }
    }
  }
}