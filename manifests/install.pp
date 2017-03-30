# This class maintains the required ipsec packages. There are no user
# servicable parts here. Everything is in the 'ipsec' class.
class ipsec::install {
  package { 'libreswan':
    ensure => installed,
  }
}
