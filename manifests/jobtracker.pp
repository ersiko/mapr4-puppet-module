class mapr4::jobtracker inherits mapr4::core {
  package { "mapr-jobtracker":
    require => Package["mapr-fileserver"],
    ensure => $mapr_version,
    notify => Exec["configure.sh"],
  }
 }
