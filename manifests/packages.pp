class gogs::packages () {

  case $::operatingsystem {
    'RedHat': {
      ensure_packages(['git', 'curl', 'wget', 'tar', 'initscripts'])
    }
    'CentOS': {
      ensure_packages(['git', 'curl', 'wget', 'tar', 'initscripts'])
    }
    'Debian': {
      ensure_packages(['git-core', 'curl', 'wget', 'tar', 'software-properties-common'])
    }
    'Ubuntu': {
      ensure_packages(['git-core', 'curl', 'wget', 'tar', 'software-properties-common'])
    }
    default: {
      fail("${::operatingsystem} not supported")
    }
  }
}
