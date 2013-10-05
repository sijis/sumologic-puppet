# == Class: sumologic::client
#
# This class configures sumologic client on a system.
#
# === Parameters
#
# [*source*]
#   Filename of a sumo.conf file. This option will override
#   the template parameter.
#
# [*template*]
#   Filename of a sumo.conf template
#
# [*version*]
#   The version of the client package to install.
#   It can be an rpm version number or 'latest'
#
# === Variables
#
# None
#
# === Usage
#
#   class { 'sumologic::client': }
#
#   class { 'sumologic::client':
#       template => 'sumo.conf.erb',
#       version  => latest,
#   }
#
#   class { 'sumologic::client':
#       source  => 'sumo.conf.server01',
#       version => '20.1-5',
#   }
#
#
class sumologic::client (
    $source   = hiera('sumologic_client_source'),
    $template = hiera('sumologic_client_template'),
    $version  = hiera('sumologic_client_version')
){

    if $source {
        $sumo_source  = "puppet:///modules/sumologic/${source}"
        $sumo_content = undef
    } else {
        $sumo_source  = undef
        $sumo_content = template("sumologic/${template}")
    }

    File {
        owner => '0',
        group => '0',
    }

    package { 'SumoCollector':
	ensure  => $version,
        require => File['/etc/sumo.conf'],
    }

    file { '/etc/sumo.conf':
        ensure  => present,
        mode    => '0400',
        content => $sumo_content,
        source  => $sumo_source,
    }

    file { '/opt/SumoCollector/config/wrapper.conf':
        audit  => ['content'],
        notify => Service['collector'],
    }

    service { 'collector':
        ensure => running,
        enable     => true,
        hasstatus  => true,
        hasrestart => true,
        require    => Package['SumoCollector'],
    }

}
