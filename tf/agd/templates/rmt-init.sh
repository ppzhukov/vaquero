echo "SET PASSWORD FOR root@${hostname}=PASSWORD(\"${password}\");" | mysql -u root < #{command_file} 2>/dev/null

CA_PWD=${password}

openssl genrsa -aes256 -passout env:CA_PWD -out ./a/rmt-ca.key 2048

openssl req -x509 -new -nodes -key /etc/rmt/ssl/rmt-ca.key -sha256 -days 1825 -out /etc/rmt/ssl/rmt-ca.crt \
 -passin env:CA_PWD -config /etc/rmt/ssl/rmt-ca.cnf

openssl genrsa -out /etc/rmt/ssl/rmt-server.key 2048
openssl req -new -key /etc/rmt/ssl/rmt-server.key -out /etc/rmt/ssl/rmt-server.csr -config /etc/rmt/ssl/rmt-server.cnf
openssl x509 -req -in /etc/rmt/ssl/rmt-server.csr -out /etc/rmt/ssl/rmt-server.crt -CA /etc/rmt/ssl/rmt-ca.crt \
 -CAkey /etc/rmt/ssl/rmt-ca.key -passin env:CA_PWD -days 1825 -sha256 -CAcreateserial \
 -extensions v3_server_sign -extfile /etc/rmt/ssl/rmt-server.cnf

chmod 0600 /etc/rmt/ssl/*