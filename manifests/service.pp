# This class maintains the required ipsec service. There are no user
# servicable parts here. Everything is in the 'ipsec' class.
class ipsec::service {
  service { 'ipsec':
    ensure => running,
    enable => true,
  }
}
