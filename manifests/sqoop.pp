class mapr4::sqoop ($sqoop_version) inherits mapr4 {
  package { "mapr-sqoop":
  ensure => $sqoop_version
  }
  file { "/opt/mapr/sqoop/sqoop-1.4.5/conf/sqoop-site.xml":
    source  => "puppet:///modules/mapr/sqoop-site.xml",
    require => Package["mapr-sqoop"]
  }
  file { "/opt/mapr/sqoop/sqoop-1.4.5/conf/sqoop-env.sh":
    source  => "puppet:///modules/mapr/sqoop-env.sh",
    require => Package["mapr-sqoop"]
  }
}
