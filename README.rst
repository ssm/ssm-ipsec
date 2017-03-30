ipsec
=====

.. contents:: Table of Contents

Description
-----------

This is a class to install and configure IPSec for peer-to-peer
transport encryption. This can be done implicitly using opportunistic
encryption, if the IPSec implementation supports it, or with explicit
peer-to-peer configuration blocks.

This modules uses 'strongswan' on the Debian OS family, and
'libreswan' on the 'RedHat' OS family.

Usage
-----

Under development. For now, see the "puppet strings" documentation.

Reference
---------

Under development. For now, see the "puppet strings" documentation.

Limitations
-----------

Not everything is implemented yet.

Opportunistic IPSec has some limitations.

- strongSwan `does not support Opportunistic IPSec
  <https://wiki.strongswan.org/issues/2160>`_ , making this a RedHat
  OS family feature only.

- The "policies" parameter sets up opportunistic IPSec, using NULL
  authentication. Support for opportunistic IPSec with Puppet CA
  authentication is not implemented in this puppet module yet.

- Libreswan does not yet support Opportunistic IPSec on IPv6 (as of
  2017-03-30).

Development
-----------

Feedback, pull requests, bug reports and patches are welcome.
