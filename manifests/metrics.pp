class mapr4::metrics ($metrics_mysql_server, $metrics_mysql_user, $metrics_mysql_pass, $metrics_mysql_db) inherits mapr4 {
  package { "mapr-metrics": 
    ensure => $mapr_version,
    notify => Exec["configure.sh"]
  }
  file { "/opt/mapr/conf/db.conf":
    content => template('mapr4/metrics-db.conf.erb'),
    require => Package["mapr-metrics"],
    notify => Exec["init_metrics_schema"], 
  }
  exec { "init_metrics_schema":
    command => "mysql -u $metrics_mysql_user -h $metrics_mysql_server $metrics_mysql_db -p$metrics_mysql_pass -e 'select * from JOB;' || mysql -u $metrics_mysql_user -h $metrics_mysql_server $metrics_mysql_db -p$metrics_mysql_pass  < /opt/mapr/bin/setup.sql",
    refreshonly => true,
    require => File["/opt/mapr/conf/db.conf"]
  }
}  

