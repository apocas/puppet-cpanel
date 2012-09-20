class cpanel::maldet {

        exec { "install_maldet":
                cwd => "/tmp",
                    command => "/usr/bin/wget -N http://www.rfxn.com/downloads/maldetect-current.tar.gz && tar -xzf maldetect-current.tar.gz && cd maldetect* && /bin/bash install.sh",
                    creates => "/usr/local/maldetect"
        }
}
