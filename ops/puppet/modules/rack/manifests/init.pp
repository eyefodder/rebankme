# Class: rack
#
# Installs the rack gem.
#
class rack(
  $ensure = 'present',
  $provider = 'gem',
) {

  require ruby

  package { 'rack':
    ensure   => $ensure,
    provider => $provider,
  }
}
