## 2017-03-04 Release 1.0.1
- Bugfix for older Ubuntu versions which does not start/stop the daemon correctly because of wrong init scripts error codes

## 2017-02-28 Release 1.0.0
- Fixed [issue #4](https://github.com/kschu91/puppet-gogs/issues/4) that does not allow overwriting of default values which have an impact either on sysconfig or `app.ini` values.
- Dependent system packages (eg. `git`, `curl`, etc.) are now getting installed automatically if not already there.
- The parameter `sysconfig` has changed! [Check the README](README.md#sysconfig) for further details.
- Changing ownership after the first run is now possible.

## 2017-02-22 Release 0.2.0
- Added support for CentOS and Debian.
- Added acceptance tests for CentOS, Debian and Ubuntu.
- Clarify requirements in README.md

## 2017-02-19 Release 0.1.0
First version of gogs puppet module.