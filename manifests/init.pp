class mapr4($mapr_subnets, $mapr_cldb, $mapr_zookeeper, $mapr_gid, $mapr_uid, $mapr_pass) {
  exec { "apt-update":
    command => "/usr/bin/wget -O - http://package.mapr.com/releases/pub/gnugpg.key | sudo apt-key add -;/usr/bin/apt-get update",
    refreshonly => true
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

  group { 'mapr':
    name                 => 'mapr',   
    gid                  => $mapr_gid,   
    ensure               => 'present',
  }

  package { "whois":   
    ensure => installed,    
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

  file { '/var/mapr':
    ensure               => directory,
    owner => mapr,
    group => mapr,
    require              => [ Group["mapr"], User["mapr"] ],
  }

}    

