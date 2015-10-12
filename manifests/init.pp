class mapr4($mapr_subnets, $mapr_cldb, $mapr_zookeeper, $mapr_gid, $mapr_uid, $mapr_pass) {
  exec { "apt-update":
    command => "/usr/bin/apt-get update;wget -O - http://package.mapr.com/releases/pub/gnugpg.key | sudo apt-key add -"
  }

  exec { "configure.sh":
    command => "/opt/mapr/server/configure.sh -C $mapr_cldb -Z $mapr_zookeeper",
    refreshonly => true,
    require => User["mapr"],
  }

  file { "/etc/apt/sources.list.d/mapr.list":
    ensure => present,
    mode => 0440,
    owner => root,
    group => root,
    source => "puppet:///modules/mapr4/apt-mapr.list",
    notify => Exec["apt-update"]
  }

  file { "/etc/apt/apt.conf.d/99auth":       
    owner     => root,
    group     => root,
    content   => "APT::Get::AllowUnauthenticated yes;",
    mode      => 644;
  }

  file { "/opt/mapr/conf/env.sh":
    owner     => mapr,
    group     => mapr,
    content   => template('mapr4/env-jdk8.sh.erb'),
    require => File["/opt/mapr/conf"]
  }
  file { ["/opt/mapr", "/opt/mapr/conf"]:
    ensure   => directory,
    require => User["mapr"]
  }

  puppi::netinstall { 'jdk8':
    url                 => 'http://www.java.net/download/jdk8u40/archive/b23/binaries/jdk-8u40-ea-bin-b23-linux-x64-27_jan_2015.tar.gz',
    destination_dir     => '/opt/', # Must Exist ...
    extracted_dir       => 'jdk1.8.0_40',
    owner               => 'root',
    group               => 'root'
  }
  
  group { 'mapr':
    name                 => 'mapr',   
    gid                  => $mapr_gid,   
    ensure               => 'present',
  }
  user { 'mapr':
    name                 => 'mapr',
    uid                  => $mapr_uid,
    gid                  => $mapr_gid,
    home                 => '/var/mapr',
    password             => generate('/bin/sh', '-c', "mkpasswd -m sha-512 -S M14.FQmovKJs ${mapr_pass} | tr -d '\n'"),
    ensure               => 'present',
    require              => [ Group["mapr"], Package["whois"] ],
  }
    package { "whois":   
    ensure => installed,    
  }

  file { '/var/mapr':
    ensure               => directory,
    owner => mapr,
    group => mapr,
    require              => [ Group["mapr"], User["mapr"] ],
  }

}    

