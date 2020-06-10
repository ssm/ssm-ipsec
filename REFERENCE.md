# Reference
<!-- DO NOT EDIT: This document was generated by Puppet Strings -->

## Table of Contents

**Classes**

_Public Classes_

* [`ipsec`](#ipsec): IPSec for host-to-host or opportunistic encryption.

_Private Classes_

* `ipsec::config`: Configure IPSec daemon
* `ipsec::install`: Install IPSec daemon
* `ipsec::service`: Manage IPSec service

## Classes

### ipsec

Install and configure IPSec transport encryption for IPv6 or IPv4.

This modules uses 'strongswan' on the Debian OS family, and
'libreswan' on the 'RedHat' OS family.

For authentication between peers, the Puppet TLS keys and
certificates are used.

When given a set of peers (including this node), this module will
configure IPSec rules between all peers.

Opportunistic encryption can be configured for "libreswan". For a
given CIDR, assign a Libreswan policy ('block', 'clear',
'clear-or-private', 'private' or 'private-or-clear'). For more
information about these policies, consult the Libreswan
documentation.

#### Examples

##### Declaring the class

```puppet
include ipsec
```

##### Using policies

```puppet
$policies = {
  'private' => ['192.0.2.0/24'],
  'private-or-clear' => ['0.0.0.0/0'] },
}

class { 'ipsec':
  policies => $policies,
}
```

##### Using peers

```puppet
$peers = [
  { 'name' => 'thishost.example.com',   'address' => '2001:db8::1', 'family' => 'inet6' },
  { 'name' => 'otherhost1.example.com', 'address' => '2001:db8::2', 'family' => 'inet6' },
  { 'name' => 'otherhost2.example.com', 'address' => '2001:db8::3', 'family' => 'inet6' },
]

class { 'ipsec':
  peers => $peers,
}
```

#### Parameters

The following parameters are available in the `ipsec` class.

##### `peers`

Data type: `Array[
    Hash[Enum['address','family','name'], String]
  ]`

A list of IPSec peers.  The peer list must include the local host.

Default value: []

##### `policies`

Data type: `Hash[
    Enum[ 'block', 'clear', 'clear-or-private', 'private', 'private-or-clear' ],
    Array[
      Variant[
        Stdlib::IP::Address,
        Stdlib::IP::Address::V4::CIDR,
        Stdlib::IP::Address::V6::CIDR,
      ]
    ]
  ]`

A list of IPSec policies for opportunistic encryption.

Default value: {}

##### `hostname`

Data type: `Stdlib::Fqdn`

The local hostname.

Default value: $trusted['certname']

##### `package`

Data type: `Enum['libreswan','strongswan']`

(see module hieradata for default) The package containing the
IPSec software.

##### `tls_cert_file`

Data type: `Stdlib::Absolutepath`

Path to the local host certificate.

Default value: $facts['ipsec']['puppet_setting']['hostcert']

##### `tls_cacert_file`

Data type: `Stdlib::Absolutepath`

Path to the local CA certificate or bundle

Default value: $facts['ipsec']['puppet_setting']['cacert']

##### `tls_key_file`

Data type: `Stdlib::Absolutepath`

Path to the local host key.

Default value: $facts['ipsec']['puppet_setting']['hostprivkey']
