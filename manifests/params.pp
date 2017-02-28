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
}
