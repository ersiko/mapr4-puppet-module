class mapr4::resourcemanager inherits mapr4::core {
  package { "mapr-resourcemanager":
    require => Package["mapr-core"],
    ensure => $mapr_version,
    notify => Exec["configure.sh"],
  }
 }
