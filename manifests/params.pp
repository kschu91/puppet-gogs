class gogs::params {

  $service_ensure         = 'running'
  $service_name           = 'gogs'

  $manage_user            = true
  $manage_home            = true

  $version                = 'latest'
  $installation_directory = '/opt/gogs'
  $repository_root        = '/var/git'

  $owner                  = 'git'
  $group                  = 'git'
  $home                   = "/home/$owner"

  $app_ini                = {
    'APP_NAME' => 'Go Git Service (managed by puppet)',
    'RUN_USER' => $owner,
    'RUN_MODE' => 'prod',
  }

  $app_ini_sections       = {
    'server' => {
      'DOMAIN' => 'localhost',
      'ROOT_URL' => 'http://localhost:3000',
      'HTTP_ADDR' => 'localhost',
      'HTTP_PORT' => 3000,
    },
    'repository' => {
      'ROOT' => $repository_root,
    },
    'security' => {
      'INSTALL_LOCK' => true,
    },
  }

  $sysconfig              = {
    'NAME'       => { value => $service_name },
    'USER'       => { value => $owner },
    'WORKINGDIR' => { value => $installation_directory },
    'DAEMON'     => { value => "${installation_directory}/${service_name}" },
  }

  case $::osfamily {
    'RedHat': {
      $sysconfig_script = "/etc/sysconfig/$service_name"
    }
    'Suse': {
      $sysconfig_script = "/etc/sysconfig/$service_name"
    }
    'Debian': {
      $sysconfig_script = "/etc/default/$service_name"
    }
    default: {
      fail("${::operatingsystem} not supported")
    }
  }

}
