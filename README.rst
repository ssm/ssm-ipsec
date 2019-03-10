ipsec
=====

.. contents:: Table of Contents

Description
-----------

This is a class to install and configure IPSec for peer-to-peer
transport encryption. This can be done implicitly using opportunistic
encryption, if the IPSec implementation supports it, or with explicit
peer-to-peer configuration blocks.

This modules defaults to 'strongswan' on the Debian OS family, and
'libreswan' on the 'RedHat' OS family.

This is a work in progress. Not everything is implemented or tested
yet.

Usage
-----

Under development. For now, see the "puppet strings" documentation.

Reference
---------

Under development. For now, see the "puppet strings" documentation.

Limitations
-----------

Opportunistic IPSec has some limitations.

- strongSwan does not support `Opportunistic IPSec
  <https://wiki.strongswan.org/issues/2160>`_ .

- The "policies" parameter sets up opportunistic IPSec, using NULL
  authentication. Support for opportunistic IPSec with Puppet CA
  authentication is not implemented in this puppet module yet.

- Libreswan supports Opportunistic IPSec on IPv6 from the 3.20
  release.

Development
-----------

Feedback, pull requests, bug reports and patches are welcome.
