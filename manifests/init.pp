# Author::    Liam Bennett (mailto:lbennett@opentable.com)
# Copyright:: Copyright (c) 2013 OpenTable Inc
# License::   MIT

# == Class: puppetversion
#
# The puppetversion module for managing the upgrade/downgrade of puppet to a specified version
#
# === Requirements/Dependencies
#
# Currently reequires the puppetlabs/stdlib module on the Puppet Forge in
# order to validate much of the the provided configuration.
#
# === Parameters
#
# [*version*]
# The version of puppet to be installed
#
# [*proxy_address*]
# (Windows only) - The proxy address to use when downloading the msi
#
# [*download_source]
# (Windows only) - The source location where the msi can be found
#
# [*time_delay*]
# (Windows only) - How many minutes in the future should we schedule the upgrade task for
#
# [*ruby_augeas_version*]
# (Debian only) - The version of ruby-augeas to install from RubyGems.
#
# [*manage_repo*]
# (Debian only) - Manage the apt repo for puppetlabs
#
# [*apt_location*]
# (Debian only) - URL for apt repo for puppetlabs
#
# === Examples
#
# Installing puppet to a specified version
#
# class { 'puppetversion':
#   version => '3.4.3'
# }
#
class puppetversion(
  $version = $puppetversion::params::version,
  $proxy_address = $puppetversion::params::proxy_address,
  $download_source = $puppetversion::params::download_source,
  $time_delay = $puppetversion::params::time_delay,
  $ruby_augeas_version = $puppetversion::params::ruby_augeas_version,
  $manage_repo = $puppetversion::params::manage_repo,
  $apt_location = $puppetversion::params::apt_location,
) inherits puppetversion::params {

  case downcase($::osfamily) {
    'debian': {
      if versioncmp($version, '5') < 0 {
        class {'puppetversion::apt_v3':
          apt_location => $apt_location,
        }
      } else {
        class {'::puppet_agent':
          source          => $apt_location,
          package_version => $version,
          collection      => 'puppet5',
        }
      }
    }
    'redhat': {

      class { '::puppetlabs_yum': }

      package{ 'puppet' :
        ensure  => "${version}-1.el${::operatingsystemmajrelease}",
        require => Class['puppetlabs_yum'],
      }

    }
    'windows': {

      if $::puppetversion != $version {

        # Using powershell to uninstall and reinstall puppet because there is not workflow
        # support for inplace upgrades
        file { 'UpgradePuppet script':
          path    => 'C:/Windows/Temp/UpgradePuppet.ps1',
          content => template('puppetversion/UpgradePuppet.ps1.erb'),
        }

        # Using another powershell script to create a scheduled task to run the upgrade script.
        #
        # The scheduled_task resource is not being used here because there is no way to pass
        # local time to the start_time parameter. Using the strftime from stdlib will use the
        # time at catalog compilation (the time of the master) which will cause problems if you
        # clients run in a differne timezone to the master

        file { 'ScheduleTask script':
          path    => 'C:/Windows/Temp/ScheduledTask.ps1',
          content => template('puppetversion/ScheduledTask.ps1.erb'),
          require => File['UpgradePuppet script'],
          notify  => Exec['create scheduled task'],
        }

        exec { 'create scheduled task':
          command     => 'C:\Windows\Temp\ScheduledTask.ps1 -ensure present',
          provider    => powershell,
          require     => File['ScheduleTask script'],
          refreshonly => true,
        }

      } else {

        file { 'UpgradePuppet script':
          ensure => absent,
          path   => 'C:/Windows/Temp/UpgradePuppet.ps1',
        }

        # Yes we still have to exec to remove because scheduled_task { ensure => absent } doesn't work!
        exec { 'remove scheduled task':
          command  => 'C:\Windows\Temp\ScheduledTask.ps1 -ensure absent',
          provider => powershell,
          before   => File['ScheduleTask script'],
          onlyif   => 'C:\Windows\Temp\ScheduledTask.ps1 -exists True',
        }

        file { 'ScheduleTask script':
          ensure => absent,
          path   => 'C:/Windows/Temp/ScheduledTask.ps1',
        }
      }
    }
    default: {
      fail("This module does not support ${::osfamily}")
    }
  }
}
