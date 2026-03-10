system {
    host-name vyos-router
    login {
        user vyos {
            authentication {
                encrypted-password "*"
                plaintext-password ""
            }
            level admin
        }
    }
    console {
        device ttyS0 {
            speed 115200
        }
    }
    config-management {
        commit-revisions 100
    }
}

interfaces {
    ethernet eth0 {
        address dhcp
    }
    loopback lo {
    }
}

service {
    ssh {
    }
}
