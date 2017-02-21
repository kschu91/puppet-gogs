# kschu91/gogs

[![Build Status](https://travis-ci.org/kschu91/puppet-gogs.svg?branch=master)](https://travis-ci.org/kschu91/puppet-gogs)

#### Table of Contents

1. [Description](#description)
1. [Setup - The basics of getting started with gogs](#setup)
    * [What gogs affects](#what-gogs-affects)
    * [Setup requirements](#setup-requirements)
    * [Beginning with gogs](#beginning-with-gogs)
1. [Usage - Configuration options and additional functionality](#usage)
1. [Reference - An under-the-hood peek at what the module is doing and how](#reference)
1. [Limitations - OS compatibility, etc.](#limitations)
1. [Development - Guide for contributing to the module](#development)

## Description

This module will install and configure [Gogs (A painless self-hosted Git service.)](http://gogs.io)
by using the preferred way of [installing Gogs from binary](https://gogs.io/docs/installation/install_from_binary)
instead of using any Thirdparty PPA´s.
You are completely free to configure Gogs for your needs since this module allows dynamic configuration for the `custom/conf/app.in` file.

## Setup

### What gogs affects

Gogs will be installed in the given installation directory (`/opt/gogs` by default) and a
service will be installed with an init.d script (by default the service is called `gogs`).

Beside from that nothing else will be affected on your system.

### Setup Requirements

`MySQL` or `PostgreSQL` and `git` are not being installed by this module. Make sure those services are
installed before using this module. 
Have a look at the [prerequisites documentation of Gogs](https://gogs.io/docs/installation) for quick step into it.

### Beginning with gogs

You can simply include the `gogs` module to get started with the defaults. Check out the [reference](#reference) to see what the defaults are.
After that you can visit your installation via [http://youhost.tld:3000](http://youhost.tld:3000) and you can follow the installation instructions.

    include ::gogs
    

## Usage

The most common way of using the `gogs` module with a minimal set of custom configuration is the following.
> **Note**: You are able to provide any available Gogs configuration in `app_ini` and `app_ini_sections`. For a 
complete list of available configuration have a look at the [Gogs configuration cheat sheet](https://gogs.io/docs/advanced/configuration_cheat_sheet).

    class { '::gogs':
        app_ini => {
            'APP_NAME' => 'My Fancy GIT Service'
        },
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
            'security'   => {
                'INSTALL_LOCK' => true,
            },
        },
    }

> **Note**: Currently the module will not create an admin user for you. You can do this by using the gogs cli:
`gogs admin create-user --name="john.doe" --password="supersecret" --email="john@doe.com" --admin`

## Reference

### Parameters

#### version
  You can specify a specific version. Just tell the module which version you want to install. For example `0.9.113`.
  The default version is `latest` and the module will then fetch the latest version from [Github](https://github.com/gogits/gogs/releases) automatically.
  
    class { '::gogs':
        version => '0.9.113'
    }


#### installation_directory
  If you need to change the installation directory you can do this by specifieng this parameter. By default gogs will be installed in `/opt/gogs`
  
    class { '::gogs':
        installation_directory => '/home/git/gogs'
    }


#### repository_root
  By default git repositories are stored in `/var/git`. Use this parameter to change the default path.
  
    class { '::gogs':
        repository_root => '/home/git/gogs-repositories'
    }

#### app_ini
  A hash of available Gogs configuration.
  For a full list please have a look at the [configuration cheat sheet](https://gogs.io/docs/advanced/configuration_cheat_sheet).
  
    class { '::gogs':
        app_ini => {
            'APP_NAME' => 'My Fancy GIT Service'
        },
    }

#### app_ini_sections
  Hash of available Gogs configurations that belong to a specific section.
  For a full list please have a look at the [configuration cheat sheet](https://gogs.io/docs/advanced/configuration_cheat_sheet).
  
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


#### manage_user
  Set this to `false` if you want to manage the user under which Gogs is running to handle by yourself.
  By default this is set to `true` and the module will create the user and the corresponding group.
  
    class { '::gogs':
        manage_user => false
    }


#### manage_home
  Set this to `false` if you want to manage/create the users home directory by yourself.
  By default this is set to `true` and the module will create the users home directory for you.
  This parameter have no effect if `manage_user` is set to `false`. No home directory will then
  be created/managed by this module.
  
    class { '::gogs':
        manage_home => false
    }


#### owner
  Use this parameter to change the user under which Gogs is running. By default the users name is `git`.
  
    class { '::gogs':
        owner => 'johndoe'
    }


#### group
  Use this parameter to change the group under which Gogs is running. By default the group name is `git`.
  
    class { '::gogs':
        group => 'company'
    }


#### service_ensure
  By default this parameter is set to `running`. Set it to `stopped` if you don´t want to start gogs by puppet.
  
    class { '::gogs':
        service_ensure => 'stopped'
    }


#### service_name
  By default the service is named `gogs`. If you ever need to change that you can do this by setting this parameter.
  
    class { '::gogs':
        service_name => 'gogitsgogs'
    }


#### sysconfig
  This module installs Gogs as a daemons/service on your system. This is done by the [provided init scripts of Gogs](https://github.com/gogits/gogs/tree/master/scripts/init)
  and depends on your distribution. If you need to change variables for the daemon script use this parameter.
  The provided variables are stored in a sysconfig file depending on your distribution and service name (e.g `/etc/default/gogs`)
  and are then automatically interpreted by the daemon scripts.
  
    class { '::gogs':
        sysconfig => {
            'NAME' => { value => 'gogitsgogs' },
            'USER' => { value => 'johndoe' },
        }
    }


## Limitations

This module is developed and tested on Ubuntu but should also work on CentOS, Suse or Debian.
Dont hesitate to [create an issue on Github](https://github.com/kschu91/puppet-gogs/issues/new)
if you are having any trouble.

## Development

You are very welcome to contribute on this module. The [source code is available on GitHub](https://github.com/kschu91/puppet-gogs).
Please follow the [contributing instructions](https://docs.puppet.com/forge/contributing.html) from puppet.
