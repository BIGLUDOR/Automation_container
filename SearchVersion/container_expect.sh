#!/usr/bin/expect -f
#With this script create the container without person.

set versiondae "ess3000_6.0.1.2_1204-18_dae.sh"
set versiondme "ess3000_6.0.1.2_1204-18_dme.sh"
set versiontype [lindex $argv 0]
set timeout 1200
#------------------------------------------------------

if { $versiontype == 1 } {
        send "cd /home/fab3/prod/dae_env_cems_ess3K\r"
        spawn sh ess3000_6.0.1.2_1204-18_dae.sh --silent --text-only --install-image
        expect "Are you sure you want to continue?" {
            send -- "y\r"
        }
} else {
    send "cd /home/fab3/prod/DME_env_cems_ess3K\r"
    spawn sh ess3000_6.0.1.2_1204-18_dme.sh --silent --text-only --install-image
    expect "Are you sure you want to continue?" {
        send -- "y\r"
    }
}