README
============

Sumologic is a cloud management log solution.

This module is to install the sumologic client via puppet configured to use a proxy.

Usage
============

These are some usage examples:

Installing the latest version with a basic template
```
class { 'sumologic::client':
   template => 'sumo.conf.erb',
   version  => latest,
}
```

Using a custom file with a specific version
```
class { 'sumologic::client':
   source  => 'sumo.conf.server01',
   version => '20.1-5',
}

```

Tested
============

This module has been tested againt 64-bit CentOS 5.x/6.x servers.
I would suspect it should work again RHEl and compatible systems with minimal changes.
