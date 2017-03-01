# puppet-puppetversion

####Table of Contents

1. [Overview](#overview)
2. [Module Description - What is the puppetversion module?](#module-description)
3. [Setup - The basics of getting started with puppetversion](#setup)
    * [What puppetversion affects](#what-puppetversion-affects)
    * [Setup requirements](#setup-requirements)
    * [Beginning with puppetversion](#beginning-with-puppetversion)
4. [Usage - Configuration options and additional functionality](#usage)
5. [Reference - An under-the-hood peek at what the module is doing and how](#reference)
5. [Limitations - OS compatibility, etc.](#limitations)
6. [Development - Guide for contributing to the module](#development)

##Overview

The puppetversion module for managing the upgrade/downgrade of puppet to a specified version

[![Build Status](https://secure.travis-ci.org/opentable/puppet-puppetversion.png)](https://secure.travis-ci.org/opentable/puppet-puppetversion.png)

##Module Description

The purpose of this module is to manage puppet upgrades. This was created because performing upgrades on on some platforms and some older
versions of puppet requires a little more effort than simply ```package { 'puppet': ensure => '3.4.3' }```. This module intends to deal
with all of those edge cases, making upgrades as simple as they should be.

##Setup

###What puppetversion affects

* The installation of puppet itself.
* Create a scheduled task (on Windows)

###Beginning with puppetversion

To upgrade to a new puppetversion

```puppet
   class { 'puppetversion':
     version => '3.4.3'
   }
```

##Usage

###Classes and Defined Types

####Class: `puppetversion`
The puppetversion module guides the upgrade of puppet.

**Parameters within `puppetversion`:**
#####`version`
The version that you want to upgrade to

#####`proxy_address`
(Windows only) - The proxy address to use when downloading the msi

#####`download_source`
(Windows only) - The source location where the msi can be found

#####`time_delay`
(Windows only) - How many minutes in the future should we schedule the upgrade task for

#####`ruby_augeas_version`
(Debian only) - The version of ruby-augeas to install from RubyGems.

##Reference

###Classes
####Public Classes
* [`puppetversion`](#class-puppetversion): Guides the upgrade of puppet from the current version to the specified new version

##Limitations

This module is tested on the following platforms:

* CentOS 5
* CentOS 6
* CentOS 7
* Ubuntu 12.04
* Ubuntu 14.04
* Ubuntu 16.04 (puppet3.8.5-2 only)
* Windows 2008 R2
* Windows 2012 R2

It is tested with the OSS version of Puppet only.

##Development

###Contributing

Please read CONTRIBUTING.md for full details on contributing to this project.
