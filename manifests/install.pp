class ipsec::install {
  package { 'libreswan':
    ensure => installed,
  }
}
