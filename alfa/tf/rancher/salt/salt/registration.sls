registration_sles:
    cmd.run:
        - name: |
            if [ "$(echo $(SUSEConnect --status-text | grep -A 2 '(SLES/15.4/x86_64)' | tail -1))" = "Not Registered" ]
            then
                ping updates.suse.com -c 10
                SUSEConnect --url 192.168.14.11 > /var/log/registration.log 2>&1
                zypper ref
            fi