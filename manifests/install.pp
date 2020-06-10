# @summary Install IPSec daemon
#
# This class maintains the required ipsec packages. There are no user
# servicable parts here. Everything is in the 'ipsec' class.
# @api private
#
# @param package
#   The package to install
#
class ipsec::install (
  String $package,
) {
  package { $package:
    ensure => installed,
  }
}
