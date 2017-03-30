# This class maintains the required ipsec configuration. There are no
# user servicable parts here. Everything is in the 'ipsec' class.
#
# This class performs the following steps to configure IPSec for our
# needs
#
# 1: Set up Opportunistic Encryption, with null authentication if the
# policies data structure exists.
#
# 2: Import the Puppet CA certificate, host certificate and key.
#
# 3: Make peer configuration files if the peers data structure
# contains this node and at least one one other.
#
class ipsec::config {

  include ipsec
  $policies = $::ipsec::policies
  $peers    = $::ipsec::peers

  $bundle='/var/lib/puppet/ssl/private/puppet.pkcs12'
  $key="/var/lib/puppet/ssl/private_keys/${trusted['certname']}.pem"
  $cert="/var/lib/puppet/ssl/certs/${trusted['certname']}.pem"
  $cert_nickname=$trusted['certname']
  $ca_cert='/var/lib/puppet/ssl/certs/ca.pem'
  $ca_nickname='PuppetCA'

  File {
    owner => 'root',
    group => 'root',
    mode  => '0644',
  }

  Exec {
    path => [ '/usr/sbin', '/usr/bin' ]
  }

  file { '/etc/ipsec.d/opportunistic-encryption.conf':
    ensure  => file,
    content => epp('ipsec/opportunistic-encryption.conf')
  }

  file { '/etc/ipsec.d/ipsec.secrets':
    ensure  => file,
    content => epp('ipsec/ipsec.secrets')
  }

  exec { "${module_name} import puppet ca cert":
    command => "certutil -A -a -i ${ca_cert} -d sql:/etc/ipsec.d -n '${ca_nickname}' -t 'CT,,'",
    unless  => "certutil -L -d sql:/etc/ipsec.d -n '${ca_nickname}'",
  }

  exec { "${module_name} export puppet key/cert to pkcs12 bundle":
    command => "openssl pkcs12 -export -out ${bundle} -inkey ${key} -in ${cert} -certfile ${ca_cert} -passout pass:",
    creates => $bundle,
  }
  -> exec { "${module_name} import puppet key/cert from pkcs12 bundle":
    command => "pk12util -d sql:/etc/ipsec.d -i ${bundle} -W ''",
    unless  => "certutil -d sql:/etc/ipsec.d -L -n ${trusted['certname']}"
  }


  file { '/etc/ipsec.d/policies':
    ensure  => directory,
    purge   => true,
    recurse => true,
  }

  $policies.each |$policy, $prefixes| {
    $epp_data = {prefixes => $prefixes}
    file { "/etc/ipsec.d/policies/${policy}":
      ensure  => file,
      content => epp('ipsec/policy', $epp_data)
    }
  }

  # This is done twice, once for 'inet' and once for 'inet6', just
  # because nested lambdas is hard with puppet.
  $others_inet  = $peers.filter |$peer| { $peer['name'] != $::fqdn and $peer['family'] == 'inet' }
  $others_inet6 = $peers.filter |$peer| { $peer['name'] != $::fqdn and $peer['family'] == 'inet6' }
  $self_inet    = $peers.filter |$peer| { $peer['name'] == $::fqdn and $peer['family'] == 'inet' }
  $self_inet6   = $peers.filter |$peer| { $peer['name'] == $::fqdn and $peer['family'] == 'inet6' }

  # IPv4 peers
  if $self_inet =~ Array[Hash, 1] and $others_inet =~ Array[Hash, 1] {
    $others_inet.each |$peer| {
      $epp_data = { self => $self_inet[0], peer => $peer }
      file { "/etc/ipsec.d/${peer['family']}-${peer['name']}.conf":
        ensure  => file,
        content => epp('ipsec/peer', $epp_data)
      }
    }
  }

  # IPv6 peers
  if $self_inet6 =~ Array[Hash, 1] and $others_inet6 =~ Array[Hash, 1] {
    $others_inet6.each |$peer| {
      $epp_data = { self => $self_inet6[0], peer => $peer }
      file { "/etc/ipsec.d/${peer['family']}-${peer['name']}.conf":
        ensure  => file,
        content => epp('ipsec/peer', $epp_data)
      }
    }
  }
}
