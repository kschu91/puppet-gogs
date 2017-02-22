class gogs::params {

  $service_ensure = 'running'
  $service_name = 'gogs'

  $manage_user = true
  $manage_home = true

  $version = 'latest'
  $installation_directory = '/opt/gogs'
  $repository_root = '/var/git'

  $owner = 'git'
  $group = 'git'
  $home = "/home/${owner}"

  $app_ini = {
    'APP_NAME' => 'Go Git Service (managed by puppet)',
    'RUN_USER' => $owner,
    'RUN_MODE' => 'prod',
  }

  $app_ini_sections = {
    'server'     => {
      'DOMAIN'    => 'localhost',
      'ROOT_URL'  => 'http://localhost:3000',
      'HTTP_ADDR' => '0.0.0.0',
      'HTTP_PORT' => 3000,
    },
    'repository' => {
      'ROOT' => $repository_root,
    },
    'security'   => {
      'INSTALL_LOCK' => false,
    },
  }

  case $::operatingsystem {
    'RedHat': {
      $init_script = "/etc/rc.d/init.d/${service_name}"
      $sysconfig_dir = "/etc/sysconfig"
      $sysconfig_script = "${sysconfig_dir}/${service_name}"
      $gogs_init_script = "${installation_directory}/scripts/init/centos/gogs"
      $sysconfig = {
        'NAME'      => { value => $service_name },
        'GOGS_USER' => { value => $owner },
        'GOGS_HOME' => { value => $installation_directory },
        'GOGS_PATH' => { value => "${installation_directory}/${service_name}" },
        'LOGPATH'   => { value => "${installation_directory}/log" },
        'LOGFILE'   => { value => "${installation_directory}/log/gogs.log" },
      }
    }
    'CentOS': {
      $init_script = "/etc/rc.d/init.d/${service_name}"
      $sysconfig_dir = "/etc/sysconfig"
      $sysconfig_script = "${sysconfig_dir}/${service_name}"
      $gogs_init_script = "${installation_directory}/scripts/init/centos/gogs"
      $sysconfig = {
        'NAME'      => { value => $service_name },
        'GOGS_USER' => { value => $owner },
        'GOGS_HOME' => { value => $installation_directory },
        'GOGS_PATH' => { value => "${installation_directory}/${service_name}" },
        'LOGPATH'   => { value => "${installation_directory}/log" },
        'LOGFILE'   => { value => "${installation_directory}/log/gogs.log" },
      }
    }
    'Debian': {
      $init_script = "/etc/init.d/${service_name}"
      $sysconfig_dir = "/etc/default"
      $sysconfig_script = "${sysconfig_dir}/${service_name}"
      $gogs_init_script = "${installation_directory}/scripts/init/debian/gogs"
      $sysconfig = {
        'NAME'       => { value => $service_name },
        'USER'       => { value => $owner },
        'WORKINGDIR' => { value => $installation_directory },
        'DAEMON'     => { value => "${installation_directory}/${service_name}" },
      }
    }
    'Ubuntu': {
      $init_script = "/etc/init.d/${service_name}"
      $sysconfig_dir = "/etc/default"
      $sysconfig_script = "${sysconfig_dir}/${service_name}"
      $gogs_init_script = "${installation_directory}/scripts/init/debian/gogs"
      $sysconfig = {
        'NAME'       => { value => $service_name },
        'USER'       => { value => $owner },
        'WORKINGDIR' => { value => $installation_directory },
        'DAEMON'     => { value => "${installation_directory}/${service_name}" },
      }
    }
    default: {
      fail("${::operatingsystem} not supported")
    }
  }

}
