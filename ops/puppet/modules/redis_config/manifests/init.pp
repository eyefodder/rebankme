class redis_config{

  # include redis
  class { 'redis':
    version => '2.8.9',
    redis_port         => '6900',
  }

}