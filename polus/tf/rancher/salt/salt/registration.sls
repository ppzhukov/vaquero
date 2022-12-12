registration_sles:
    cmd.run:
        - name: |
            if [ "$(echo $(SUSEConnect --status-text | grep -A 2 '(SLES/15.4/x86_64)' | tail -1))" = "Not Registered" ]
            then
                ping 172.17.13.52 -c 10
                curl -k https://172.17.13.52/rmt.crt -o /etc/pki/trust/anchors/rmt-ca.crt
                update-ca-certificates
                SUSEConnect --url https://172.17.13.52 > /var/log/registration.log 2>&1
                zypper ref
            fi