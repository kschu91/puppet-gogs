class { '::gogs':
  app_ini_sections => {
    'server'   => {
      'HTTP_PORT' => 3210,
    },
  },
}