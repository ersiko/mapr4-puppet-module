class mapr4::core ($disks) inherits mapr4 {

  package { "mapr-core":
    ensure => $mapr_version,
    require => User[mapr],    
  }

  package { "mapr-tasktracker":
    ensure => $mapr_version,
    require => Package["mapr-core"],
  }

  package { "mapr-fileserver":
    ensure => $mapr_version,
    require => Package["mapr-core"],             
    notify  => Exec["disksetup"]
  }

  exec { "disksetup":
    command => "/opt/mapr/server/disksetup -F /opt/mapr/conf/disks.txt ",
    refreshonly => true,
    require => [ File["/opt/mapr/conf/disks.txt"], Exec["configure.sh"] ],
  }

  file { "/opt/mapr/conf/disks.txt":
    owner     => mapr,
    group     => mapr,
    source    => "puppet:///modules/mapr4/$disks",
    require   => User["mapr"]
  }

  service { "mapr-warden":
    enable => true,
    ensure => "running",
    require => Package["mapr-core"],
    subscribe => Exec["configure.sh"]
  }
  
}
