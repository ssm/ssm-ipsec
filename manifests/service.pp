class ipsec::service {
  service { 'ipsec':
    ensure => running,
    enable => true,
  }
}
