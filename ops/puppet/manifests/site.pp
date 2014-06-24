Exec {
  path => "/usr/bin:/usr/local/bin:/bin:/usr/local/sbin:/usr/sbin:/sbin"
}

package {
	'apache2':
		ensure => present
}
service {
	"apache2":
	    enable => true,
		ensure => true
}
file {
	'/etc/apache2/apache2.conf':
		source 	=> 'puppet:///modules/apache2/apache2.conf',
		mode 	=>	644,
		owner	=>	root,
		group  	=>	root
}