class mapr4::nodemanager inherits mapr4::core {
  package { "mapr-nodemanager":
    require => Package["mapr-core"],
    ensure => $mapr_version,
    notify => Exec["configure.sh"],
  }
 }
