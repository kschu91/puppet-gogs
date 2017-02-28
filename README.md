# kschu91/gogs

[![Build Status](https://travis-ci.org/kschu91/puppet-gogs.svg?branch=master)](https://travis-ci.org/kschu91/puppet-gogs)
[![Puppet Forge](https://img.shields.io/puppetforge/v/kschu91/gogs.svg)](https://forge.puppetlabs.com/kschu91/gogs)
[![Puppet Forge - downloads](https://img.shields.io/puppetforge/dt/kschu91/gogs.svg)](https://forge.puppetlabs.com/kschu91/gogs)
[![Puppet Forge - scores](https://img.shields.io/puppetforge/f/kschu91/gogs.svg)](https://forge.puppetlabs.com/kschu91/gogs)

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

This module install and configure [Gogs (A painless self-hosted Git service.)](http://gogs.io)
by [installing Gogs from binary](https://gogs.io/docs/installation/install_from_binary)
instead of using any thirdparty PPA´s.
You are completely free to configure Gogs for your needs since this module allows dynamic configuration for the `custom/conf/app.in` file.

## Setup

### What gogs affects

* Gogs will be installed in `/opt/gogs` (can be changed).
* A service will be installed with an init script.
* By default a user and the correspendig group will be created (can be turned off). 
* `curl`, `wget`, `tar`, `git` will be installed if not already installed on your system.
* On `RedHat` and `CentOS` the `initscripts` package will be installed if not already done.

### Setup Requirements

`MySQL` or `PostgreSQL` are not being installed by this module. Make sure those services are
installed before using Gogs. 
Have a look at the [prerequisites documentation of Gogs](https://gogs.io/docs/installation) for a quick step into it.

> **Note**: Currently puppet 3 and 4 is supported. But the support of puppet 3.x will be dropped in future versions of this module. 


### Beginning with gogs

You can simply include the `gogs` module to get started with the defaults. Check out the [reference](#reference) to see what the defaults are.
After that you can visit Gogs via [http://youhost.tld:3000](http://youhost.tld:3000) and you can follow the installation instructions from the gogs install tool.

    include ::gogs
    
But be aware, if you change anything within gogs installation tool puppet will overwrite the `app.ini` on its next run. You rather should
define all your configurations within puppet. A minimal setup with a `mysql` database should look like this:

    class { '::gogs':
        app_ini_sections => {
            'database' => {
                'DB_TYPE' => 'mysql',
                'HOST'    => 'localhost:3306',
                'NAME'    => 'gogs',
                'USER'    => 'gogs',
                'PASSWD'  => 'mysecretpasswd',
            },
            'security' => {
                'SECRET_KEY' => 'mysecretkey',
                'INSTALL_LOCK' => true,
            },
        },
    }
> **Note**: You should always set `INSTALL_LOCK` configuration to `true`. Otherwise the installer is open for everyone.

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
                'HTTP_PORT' => 8080,
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
  You should **NOT** change the service name after your first puppet run. Otherwise you may run into issues with two services and already blocked ports.
  
    class { '::gogs':
        service_name => 'gogitsgogs'
    }


#### sysconfig
  Normally there is no need to change this. But if you need to change variables for the daemon script anyways use this parameter.
  The provided variables are stored in a sysconfig file depending on your distribution and service name (e.g `/etc/default/gogs`)
  and are then automatically interpreted by the daemon scripts.
  
  The configuration key to pass depends on your OS. For example on Debian the user variable is named `USER` and on CentOS it´s named `GOGS_USER`.
  Take a look into the [provided init scripts of Gogs](https://github.com/gogits/gogs/tree/master/scripts/init) to make sure you pass the correct variables.
  Otherwise your service may fail silently.
  
    class { '::gogs':
        sysconfig => {
            'NAME' => 'gogitsgogs',
            'USER' => 'johndoe',
        }
    }
> **Note**: This parameter has changed from version [0.2.0](https://forge.puppet.com/kschu91/gogs/0.2.0) to [1.0.0](https://forge.puppet.com/kschu91/gogs/1.0.0)

## Limitations

This module is developed and tested on Ubuntu, Debian and CentOS (RedHat should also work). But other distributions are currently not supported.
Do not hesitate to [create an issue on Github](https://github.com/kschu91/puppet-gogs/issues/new) if you are facing any trouble.

## Development

You are very welcome to contribute on this module. The [source code is available on GitHub](https://github.com/kschu91/puppet-gogs).
Please follow the [contributing instructions](https://docs.puppet.com/forge/contributing.html) from puppet.
