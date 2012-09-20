class cpanel {

        package { "screen":    ensure => "installed"}
        package { "git":    ensure => "installed"}
        package { "iotop":    ensure => "installed"}
        package { "wget":    ensure => "installed"}
        package { "nano":    ensure => "installed"}
        package { "mlocate":    ensure => "installed"}
        package { "which":    ensure => "installed"}
        package { "man":    ensure => "installed"}
        package { "libpng-devel":    ensure => "installed"}
        package { "libjpeg-devel":    ensure => "installed"}
        package { "zlib-devel":    ensure => "installed"}
        package { "jwhois":    ensure => "installed"}

        exec { "install_cpanel":
                cwd => "/home",
                    command => "/usr/bin/wget -N http://httpupdate.cpanel.net/latest && /bin/sh latest",
                    timeout => 0,
                    creates => "/scripts"
        }

        exec { "install_csf":
                cwd => "/tmp",
                    command => "/usr/bin/wget -N http://www.configserver.com/free/csf.tgz && tar -xzf csf.tgz && cd csf && sh install.sh",
                    creates => "/etc/csf",
                    require => Exec['install_cpanel']
        }

        exec { "install_seo":
                cwd => "/tmp",
                    command => "/usr/local/cpanel/bin/manage_features enable attracta --yes",
                    require => Exec['install_cpanel'],
                    subscribe => Exec['install_cpanel'],
                    refreshonly => true
        }

	    exec { "install_softaculous":
                cwd => "/tmp",
                    command => "/usr/bin/wget -N http://files.softaculous.com/install.sh && sh install.sh",
                    creates => "/var/softaculous/zikula/",
                    require => Exec['install_cpanel'],
                    timeout => 3600
        }

        exec { "install_csf_queues":
                cwd => "/tmp",
                    command => "/usr/bin/wget -N http://www.configserver.com/free/cmq.tgz && tar -xzf cmq.tgz && cd cmq && sh install.sh",
                    creates => "/usr/local/cpanel/whostmgr/docroot/cgi/cmq",
                    require => Exec['install_csf']
        }

        exec { "install_csf_modsec":
                cwd => "/tmp",
                    command => "/usr/bin/wget -N http://www.configserver.com/free/cmc.tgz && tar -xzf cmc.tgz && cd cmc && sh install.sh",
                    creates => "/usr/local/cpanel/whostmgr/docroot/cgi/cmc",
                    require => Exec['install_csf']
        }

        exec { "install_imagemagick":
                cwd => "/tmp",
                    command => "/scripts/installimagemagick",
                    creates => "/usr/include/ImageMagick",
                    timeout => 3600,
                    require => Exec['install_cpanel']
        }
        
}
