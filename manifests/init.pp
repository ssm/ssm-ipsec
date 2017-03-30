# ipsec puppet class
#
# This is a class to install and configure IPSec for peer-to-peer
# transport encryption. This can be done implicitly using
# opportunistic encryption, if the IPSec implementation supports it,
# or with explicit peer-to-peer configuration blocks.
#
# This modules uses 'strongswan' on the Debian OS family, and
# 'libreswan' on the 'RedHat' OS family.
#
# For authentication between nodes, the Puppet TLS certificates are
# used.
#
# @summary Configure IPSec for p2p transport encryption
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
#     { 'name' => 'host1', 'address' => '2001:db8::1', 'family' => 'inet6' },
#     { 'name' => 'host2', 'address' => '2001:db8::2', 'family' => 'inet6' },
#   ]
#
#   class { 'ipsec':
#     peers => $peers,
#   }
#
# @param peers A list of IPSec peers.
#
# @param policies A list of IPSec policies for opportunistic encryption.
#
class ipsec (
  Array[
    Hash[Enum['address','family','name'], String]
  ] $peers = [],
  Hash[
    Enum[ 'block', 'clear', 'clear-or-private', 'private', 'private-or-clear' ],
    Array[String]
  ] $policies = {},
) {

  contain ::ipsec::install
  contain ::ipsec::config
  contain ::ipsec::service

  Class['::ipsec::install'] -> Class['::ipsec::config'] ~> Class['::ipsec::service']
}
