class mapr4::hbase ($hbase_version) inherits mapr4 {
  package { "mapr-hbase": 
    ensure => $hbase_version
  }
}  

class mapr4::hbase::master inherits mapr4::hbase {
  package { "mapr-hbase-master": 
    ensure => $hbase_version,
    notify => Exec["configure.sh"]
  }   
}

class mapr4::hbase::regionserver inherits mapr4::hbase {
  package { "mapr-hbase-regionserver": 
    ensure => $hbase_version,
    notify => Exec["configure.sh"]
  }   
}
