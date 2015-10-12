class mapr4::cldb inherits mapr4::core {
  package { "mapr-cldb":
    require => Package["mapr-fileserver"],
    ensure => $mapr_version,
    notify => Exec["configure.sh"]
  }
}
