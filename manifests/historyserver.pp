class mapr4::historyserver inherits mapr4::core {
  package { "mapr-historyserver":
    require => Package["mapr-core"],
    ensure => $mapr_version,
    notify => Exec["configure.sh"],
  }
 }
