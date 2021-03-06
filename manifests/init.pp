# === Class: quagga
#
# === Description
#
# === Parameters
#
# === Examples
#
# === Authors
#
# Thomas Vassilian <thomas@kernel23.org>
# URL : https://github.com/kernel23/puppet-quagga/
#
# Initial work ...
#
# Leslie Carr <leslie@cumulusnetworks.com>
# URL : https://github.com/LeslieCarr/puppet-quagga
#
# === License
# Apache v2
#

class quagga (
  $asn = $::quagga::params::asn,
  $hostname = $::quagga::params::hostname,
  $password = $::quagga::params::password,
  $enable = $::quagga::params::enable,
  $network = $::quagga::params::network,
  $router_id = $::quagga::params::router_id,
  $bgp_logfile = $::quagga::params::bgp_logfile,
  $bgpd = $::quagga::params::bgpd,
  $zebra = $::quagga::params::zebra,
  $isisd = $::quagga::params::isisd,
  $ospfd = $::quagga::params::ospfd,
  $ospf6d = $::quagga::params::ospf6d,
  $ripd = $::quagga::params::rip,
  $ripngd = $::quagga::params::ripngd,
  $bgp_neighbors = $::quagga::params::bgp_neighbors,
  $ip_prefix_list = $::quagga::params::ip_prefix_list,
  $route_map = $::quagga::params::route_map,
)
{
  include quagga::params

  package { 'quagga':
    ensure   => present,
    before   => Service['quagga']
  }

  service { 'quagga':
    ensure      => running,
    hasrestart  => true,
    hasstatus   => false,
    enable      => true,
  }

  file { '/etc/quagga/daemons':
    mode    => '0644',
    owner   => 'quagga',
    group   => 'quagga',
    content => template('quagga/daemons.erb'),
    notify  => Service['quagga'],
  }

  file { '/etc/quagga/vtysh.conf':
    mode    => '0644',
    owner   => 'quagga',
    group   => 'quagga',
    content => template('quagga/vtysh.conf.erb'),
    notify  => Service['quagga'],
  }

  file { '/etc/quagga/debian.conf':
    mode    => '0644',
    owner   => 'root',
    group   => 'root',
    content => template('quagga/debian.conf.erb'),
    notify  => Service['quagga'],
  }

  if $zebra == true {
    include quagga::zebra
  }

  if $bgpd == true {
    include quagga::bgpd
  }

  if $ospfd == true {
    include quagga::ospfd
  }

  if $ospf6d == true {
    include quagga::ospf6d
  }

  if $ripd == true {
    include quagga::ripd
  }

  if $ripngd == true {
    include quagga::ripngd
  }

  if $isisd == true {
    include quagga::isisd
  }

  if $babeld == true {
    include quagga::babeld
  }

}
