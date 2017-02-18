kschu91/gogs
============

Overview
--------

Puppet module to install Gogs easily (Go Git Service, see: <http://gogs.io>).

Module Description
-------------------

Gogs(Go Git Service) is a painless self-hosted Git Service written in Go. The goal of the Gogs
project is to make the easiest, fastest and most painless way to set up a self-hosted Git service.
With Go, this can be done in independent binary distribution across ALL platforms that Go supports,
including Linux, Mac OS X, and Windows.

Usage
-----

In order to use this Gogs module you should be able to simply include it:

    include ::gogs


### Parameters

#### app_ini
  Hash of available configurations for gogs.
  For a full list please have a look at the [configuration cheat sheet](https://gogs.io/docs/advanced/configuration_cheat_sheet)
  
    class { '::gogs':
        app_ini => {
            'APP_NAME' => 'My Fancy GIT Service'
        },
    }

#### app_ini_sections
  Hash of available configurations for gogs that contains to a specific section.
  For a full list please have a look at the [configuration cheat sheet](https://gogs.io/docs/advanced/configuration_cheat_sheet)
  
    class { '::gogs':
        app_ini_sections => {
            'server'   => {
                'DOMAIN'    => 'git.example.com',
                'HTTP_PORT' => 3000,
            },
            'database' => {
                'DB_TYPE' => 'mysql',
                'HOST'    => 'localhost:3306',
                'NAME'    => 'gogs',
                'USER'    => 'gogs',
                'PASSWD'  => 'mysecretpasswd',
            },
            'security' => {
                'SECRET_KEY' => 'mysecretkey',
            },
            'service'  => {
                'REQUIRE_SIGNIN_VIEW'  => true,
                'DISABLE_REGISTRATION' => true,
            },
        },
    }