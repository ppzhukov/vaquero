include:
  - registration

chronyd-install:
  pkg.installed:
    - names:
        - chrony
    - require:
        - sls: registration
chronyd:
  service.running:
    - enable: True
    - require:
      - pkg: chrony

rmt-install:
  pkg.installed:
    - names:
        - rmt-server
        - mariadb
    - require:
        - sls: registration

mariadb:
  service.running:
    - enable: True
    - require:
      - pkg: rmt-server

rmt_conf:
  file.managed:
    - user: root
    - group: root
    - mode: 644
    - names:
       - /etc/rmt/ssl/rmt-ca.cnf:
         - source: salt://files/rmt-ca.cnf
       - /etc/rmt/ssl/rmt-server.cnf:
         - source: salt://files/rmt-server.cnf
       - /etc/rmt.conf:
         - source: salt://files/rmt.conf
    - require:
      - pkg: rmt-server

rmt_init:
      cmd.run:
        - name: |
             echo "SET PASSWORD FOR root@localhost=PASSWORD(\"${password}\");" | mysql -u root
             echo 'create database if not exists rmt character set = "utf8"' | mysql -u root
             echo "GRANT ALL PRIVILEGES ON rmt.* TO rmt@localhost IDENTIFIED BY \"${password}\"; FLUSH PRIVILEGES;" | mysql -u root
             CA_PWD=${password} openssl genrsa -aes256 -passout env:CA_PWD -out /etc/rmt/ssl/rmt-ca.key 2048
             CA_PWD=${password} openssl req -x509 -new -nodes -key /etc/rmt/ssl/rmt-ca.key -sha256 -days 1825 -out /etc/rmt/ssl/rmt-ca.crt -passin env:CA_PWD -config /etc/rmt/ssl/rmt-ca.cnf
             CA_PWD=${password} openssl genrsa -out /etc/rmt/ssl/rmt-server.key 2048
             CA_PWD=${password} openssl req -new -key /etc/rmt/ssl/rmt-server.key -out /etc/rmt/ssl/rmt-server.csr -config /etc/rmt/ssl/rmt-server.cnf
             CA_PWD=${password} openssl x509 -req -in /etc/rmt/ssl/rmt-server.csr -out /etc/rmt/ssl/rmt-server.crt -CA /etc/rmt/ssl/rmt-ca.crt -CAkey /etc/rmt/ssl/rmt-ca.key -passin env:CA_PWD -days 1825 -sha256 -CAcreateserial -extensions v3_server_sign -extfile /etc/rmt/ssl/rmt-server.cnf
             CA_PWD=${password} chmod 0600 /etc/rmt/ssl/*
        - require:
            - rmt_conf

rmt-server:
  service.running:
    - enable: True
    - require:
      - rmt_init