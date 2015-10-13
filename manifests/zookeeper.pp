class mapr4::zookeeper inherits mapr4 {

  package { "mapr-zookeeper":
    ensure => $mapr_version,
    require => [ User[mapr], Exec["apt-update"] ]
  }

  service { "mapr-zookeeper":
    enable => true,
    ensure => "running",
    require => File["/opt/mapr/zookeeper/zookeeper-3.4.5/conf/zoo.cfg"],
  }

  file { "/opt/mapr/zookeeper/zookeeper-3.4.5/conf/zoo.cfg":
    source => 'puppet:///modules/mapr4/zoo.cfg',
    owner => mapr,
    group => mapr,
    require => Package["mapr-zookeeper"],
    notify => [ Service["mapr-zookeeper"], Exec["configure.sh"] ]
  }

}
