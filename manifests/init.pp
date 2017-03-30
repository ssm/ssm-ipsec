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
