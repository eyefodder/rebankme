puppet-rack
===========

Install and run rack.

Synopsis
--------

    include rack

    rack::app { 'jsonp':
      ensure   => present,
      doc_root => '/var/www',
      app_root => '/opt/freddy',
    }

Requirements
------------

  * Debian Linux
