Exec {
  path => "/usr/bin:/usr/local/bin:/bin:/usr/local/sbin:/usr/sbin:/sbin"
}

# # include apache2
 include apt
 include bundler
 include rack
 # include ruby
 # apt::ppa{'ppa:brightbox/ruby-ng-experimental':}

 # adding this to the package list should enable apt0get to install ruby2.1
 # so you need to
 # run apt:ppa -->
 # apt-get update
 # ruby stuff

 # include ruby

class { 'ruby':
  version         => '2.1.1'
}

unicorn::app { 'my-rails-app':
  approot     => '/app',
  pidfile     => '/app/unicorn.pid',
  socket      => '/app/unicorn.sock',
  user        => 'puppet',
  group       => 'puppet',
  preload_app => true,
  rack_env    => 'development',
  source      => 'bundler',
  require     => [
    Class['ruby'],
    Bundler::Install[$app_root],
  ],
}



