class mapr4::webserver inherits mapr4::core {
  package { "mapr-webserver":
    require => [ Package["mapr-core"], Exec["apt-update"] ],
    ensure => $mapr_version,
    notify => Exec["configure.sh"],
  }
 }
