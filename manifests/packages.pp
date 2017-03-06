class gogs::packages () {

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
      fail("${::operatingsystem} not supported")
    }
  }
}
