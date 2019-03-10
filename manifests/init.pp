# @summary IPSec for host-to-host or opportunistic encryption.
#
# Install and configure IPSec transport encryption for IPv6 or IPv4.
#
# This modules uses 'strongswan' on the Debian OS family, and
# 'libreswan' on the 'RedHat' OS family.
#
# For authentication between peers, the Puppet TLS keys and
# certificates are used.
#
# When given a set of peers (including this node), this module will
# configure IPSec rules between all peers.
#
# Opportunistic encryption can be configure for "libreswan".  For a
# given CIDR, assign a policy ('block', 'clear', 'clear-or-private',
# 'private' or 'private-or-clear').
#
# @example Declaring the class
#   include ipsec
#
# @example Using policies
#   $policies = {
#     'private' => ['192.0.2.0/24'],
#     'private-or-clear' => ['0.0.0.0/0'] },
#   }
#
#   class { 'ipsec':
#     policies => $policies,
#   }
#
# @example Using peers
#   $peers = [
#     { 'name' => 'thishost.example.com',   'address' => '2001:db8::1', 'family' => 'inet6' },
#     { 'name' => 'otherhost1.example.com', 'address' => '2001:db8::2', 'family' => 'inet6' },
#     { 'name' => 'otherhost2.example.com', 'address' => '2001:db8::3', 'family' => 'inet6' },
#   ]
#
#   class { 'ipsec':
#     peers => $peers,
#   }
#
# @param peers
#   A list of IPSec peers.  The peer list must include the local host.
#
# @param policies
#   A list of IPSec policies for opportunistic encryption.
#
# @param hostname
#   The local hostname.
#
# @param package
#   (see module hieradata for default) The package containing the
#   IPSec software.
#
# @param tls_cert_file
#   Path to the local host certificate.
#
# @param tls_cacert_file
#   Path to the local CA certificate or bundle
#
# @param tls_key_file
#   Path to the local host key.
class ipsec (
  Enum['libreswan','strongswan'] $package,
  Array[
    Hash[Enum['address','family','name'], String]
  ] $peers = [],
  Hash[
    Enum[ 'block', 'clear', 'clear-or-private', 'private', 'private-or-clear' ],
    Array[
      Variant[
        Stdlib::IP::Address,
        Stdlib::IP::Address::V4::CIDR,
        Stdlib::IP::Address::V6::CIDR,
      ]
    ]
  ] $policies = {},
  Stdlib::Fqdn $hostname = $trusted['certname'],
  Stdlib::Absolutepath $tls_cert_file   = $facts['ipsec']['puppet_setting']['hostcert'],
  Stdlib::Absolutepath $tls_cacert_file = $facts['ipsec']['puppet_setting']['cacert'],
  Stdlib::Absolutepath $tls_key_file    = $facts['ipsec']['puppet_setting']['hostprivkey'],
) {

  # Sanity checks
  $features = lookup('ipsec::features',  Hash[String, Hash[String, Boolean]])

  if (!empty($policies) and !$features[$package]['opportunistic'] ){
    fail("Package ${package} does not support opportunistic encryption with policies")
  }

  class {'ipsec::install':
    package => $package,
  }
  class { 'ipsec::config':
    hostname => $hostname,
    peers    => $peers,
    policies => $policies,
  }
  contain ::ipsec::service

  Class['::ipsec::install'] -> Class['::ipsec::config'] ~> Class['::ipsec::service']
}
