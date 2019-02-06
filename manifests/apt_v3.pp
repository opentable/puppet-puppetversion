class puppetversion::apt_v3(
  $version = $puppetversion::version,
  $ruby_augeas_version = $puppetversion::ruby_augeas_version,
  $manage_repo = $puppetversion::params::manage_repo,
  $apt_location = $puppetversion::params::apt_location,
) {
  validate_absolute_path($::agent_rundir)

  $puppet_packages = ['puppet','puppet-common']

  if $manage_repo {
    apt::source { 'puppetlabs':
      location => $apt_location,
      repos    => 'main dependencies',
      key      => {
        'id'      => '6F6B15509CF8E59E6E469F327F438280EF8D349F',
        'content' => template('puppetversion/puppetlabs.gpg'),
      },
    }
  }

  $package_require = $manage_repo ? {
    true    => Apt::Source['puppetlabs'],
    default => undef,
  }

  if $::lsbdistrelease == '16.04' {
    $full_version = $version
  } else {
    $full_version = "${version}-1puppetlabs1"
  }

  package { $puppet_packages:
    ensure  => $full_version,
    require => $package_require,
  }

  package { 'facter':
    ensure => 'latest',
    notify => Service['puppet']
  }

  ini_setting { 'update init.d script PIDFILE to use agent_rundir':
    ensure  => present,
    section => '',
    setting => 'PIDFILE',
    value   => "\"${::agent_rundir}/\${NAME}.pid\"",
    path    => '/etc/init.d/puppet',
    require => Package['puppet'],
  }

  if versioncmp($::rubyversion, '2.0.0') >= 0 {
    if ($::operatingsystem == 'Ubuntu') and ($::lsbdistrelease == '12.04') {
      package { ['libaugeas0', 'augeas-lenses' ]:
        ensure  => '1.2.0-0ubuntu1.1~ubuntu12.04.1',
      }
      package { 'libaugeas-dev':
        ensure  => '1.2.0-0ubuntu1.1~ubuntu12.04.1',
        require => Package['libaugeas0'],
      }
    } else {
      package { ['libaugeas0', 'augeas-lenses' ]:
        ensure => installed,
      }
      package { 'libaugeas-dev':
        ensure  => installed,
        require => Package['libaugeas0'],
      }
    }

    package { ['pkg-config', 'build-essential']:
      ensure => present,
      before => Package['ruby-augeas'],
    }

    package { 'ruby-augeas':
      ensure          => present,
      provider        => 'gem',
      install_options => { '-v' => $ruby_augeas_version },
    }
  }

  $puppet_service_sub = defined(Package['puppet']) ? {
    true    => Package['puppet'],
    default => undef,
  }

  service { 'puppet':
    ensure    => 'running',
    enable    => true,
    subscribe => $puppet_service_sub,
  }
}
