class mapr4::nfs inherits mapr4::core {
  package { "mapr-nfs":
    require => Package["mapr-core"],
    ensure => $mapr_version,
    notify => Exec["configure.sh"],
  }
 }
