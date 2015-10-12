class mapr4::client inherits mapr4 {
  package { "mapr-client":
    ensure => $mapr_version,
    notify => Exec["configure.sh"]
  }
  file { "/mapr":
    ensure => "directory",
  }
}
