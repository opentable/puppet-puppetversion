# Author::    Liam Bennett (mailto:lbennett@opentable.com)
# Copyright:: Copyright (c) 2013 OpenTable Inc
# License::   MIT

# == Class puppetversion::params
#
# This private class is meant to be called from `puppetversion`
# It sets variables according to platform
#
class puppetversion::params {

  $version = '3.4.2'
  $proxy_address = ''
  $download_source = 'https://downloads.puppetlabs.com/windows'

  $time_delay =  3

  $ruby_augeas_version = '0.5.0'
  $manage_repo = true
}
