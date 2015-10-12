class mapr4::oozie inherits mapr4 {
  $listpackage = [ "mapr-oozie", "mapr-oozie-internal" ]
  package { $listpackage:
    ensure => $mapr_version,
    notify => Exec["configure.sh"],
  }
  file { '/opt/mapr/oozie/ext-2.2.zip':
    ensure => 'file',
    owner => 'mapr',
    group => 'mapr',
    source  => "puppet:///modules/oozie/ext-2.2.zip",
    notify => Exec['ooziesetup'],
  }
  exec { 'ooziesetup':
    command => "/opt/mapr/oozie/oozie-4.1.0/bin/oozie-setup.sh prepare-war -extjs /opt/mapr/oozie/ext-2.2.zip",
    refreshonly => true,
    require => File["/opt/mapr/oozie/ext-2.2.zip"]
  }
}
