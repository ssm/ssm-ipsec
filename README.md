# ipsec

#### Table of Contents

1. [Description](#description)
2. [Setup - The basics of getting started with ipsec](#setup)
    * [What ipsec affects](#what-ipsec-affects)
    * [Setup requirements](#setup-requirements)
    * [Beginning with ipsec](#beginning-with-ipsec)
3. [Usage - Configuration options and additional functionality](#usage)
4. [Limitations - OS compatibility, etc.](#limitations)
5. [Development - Guide for contributing to the module](#development)

## Description

This is a class to install and configure IPSec for peer-to-peer
transport encryption. This can be done implicitly using opportunistic
encryption, if the IPSec implementation supports it, or with explicit
peer-to-peer configuration blocks.

This modules defaults to 'strongswan' on the Debian OS family, and
'libreswan' on the 'RedHat' OS family.

## Setup

### What ipsec affects

The `ipsec` module installs `libreswan` or `strongswan` depending on
the OS family and version. When given a set of peers or policies, this
module will configure IPSec rules.

By default, this module will use the Puppet host certificates for
authentication between hosts.

### Beginning with ipsec

#. Figure out your network topology
#. Create a data structure of peers or policies reflecting that topology
#. Include the ipsec module with the peers or policies as

When initially configuring IPSec, pleasee ensure you have
administrative access through other means. There is a non-zero risk of
making your systems unreachable.

## Usage

IPSec with network policies for opportunistic encryption:

```puppet
class { 'ipsec':
  $policies = {
    'private'          => ['192.0.2.0/24'],
    'private-or-clear' => ['0.0.0.0/0'] },
  }
}
```

IPSec with configured peers:

```puppet
class { 'ipsec':
  $peers = [
    { 'name'    => 'thishost.example.com',
      'address' => '2001:db8::1',
      'family'  => 'inet6' },
    { 'name'    => 'otherhost1.example.com',
      'address' => '2001:db8::2',
      'family'  => 'inet6' },
    { 'name'    => 'otherhost2.example.com',
      'address' => '2001:db8::3',
      'family'  => 'inet6' },
  ],
}
```

IPSec with TLS certificates not provided by Puppet:

```puppet
class { 'ipsec':
  tls_cert_file   => '/etc/pki/tls/certs/ipsec.crt',
  tls_key_file    => '/etc/pki/tls/private/ipsec.key',
  tls_cacert_file => '/etc/pki/tls/tls/certs/ca-bundle.trust.crt',
}
```

See the REFERENCE.md document for more information.

## Limitations

Opportunistic IPSec has some limitations.

- strongSwan does not support `Opportunistic IPSec
  <https://wiki.strongswan.org/issues/2160>`_ .

- The "policies" parameter sets up opportunistic IPSec, using NULL
  authentication. Support for opportunistic IPSec with Puppet CA
  authentication is not implemented in this puppet module yet.

- Libreswan supports Opportunistic IPSec on IPv6 from the 3.20
  release.

## Development

Feedback in the form of bug reports and pull requests are welcome.
