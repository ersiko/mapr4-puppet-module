class mapr4::hive($hive_mysql_server, $hive_mysql_table, $hive_mysql_user, $hive_mysql_pass, $hive_log_location, $hive_version) inherits mapr4::client {
  package { "mapr-hive":
    ensure => $hive_version,
    require => Package["mapr-client"],
    notify => Exec["configure.sh"],
  }
  package { "mapr-hivemetastore":   
    ensure => $hive_version,
    require => Package["mapr-client"],
    notify => Exec["configure.sh", "initschema"],
  }
  file { "/opt/mapr/hive/hive-1.0/conf/hive-site.xml":
    content => template('mapr4/hive-site.xml.erb'),
  }
  file { "/opt/mapr/hive/hive-1.0/lib/mysql-connector-java-5.1.35-bin.jar":
    source => "puppet:///modules/mapr4/mysql-connector-java-5.1.35-bin.jar"
  }
  file { "/opt/mapr/hive/hive-1.0/conf/hive-log4j.properties":
    content => template('mapr4/hive-log4j.properties.erb'),
  }
  file { "/opt/mapr/hive/hive-1.0/conf/hive-env.sh":
    source => "puppet:///modules/mapr4/hive-env.sh"
  }
  file { "/etc/init.d/mapr-hivemetastore":
    mode    => 0755,
    source => "puppet:///modules/mapr4/mapr-hivemetastore.initd"
  }
  file { "/etc/init.d/mapr-hiveserver2":
    mode    => 0755,
    source => "puppet:///modules/mapr4/mapr-hiveserver2.initd"
  }

  exec { "initschema":
    command => "mysql -u $hive_mysql_user -h $hive_mysql_server $hive_mysql_table -p$hive_mysql_pass -e 'select * from DATABASE_PARAMS;' || /opt/mapr/hive/hive-1.0/bin/schematool -initSchema -dbType mysql",
    refreshonly => true,
    require => Package["mapr-hivemetastore"],
  }
}

