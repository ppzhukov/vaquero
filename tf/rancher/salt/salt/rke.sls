include:
  - registration

rke-pre-configure:
      cmd.run:
        - name: |
            swapoff -a
            systemctl disable kdump --now
            systemctl disable firewalld --now

configure-docker:
      cmd.run:
        - name: |
            usermod -aG docker sles
            usermod -aG docker root
            chown root:docker /var/run/docker.sock
            modprobe br_netfilter
            sysctl net.bridge.bridge-nf-call-iptables=1
            sysctl net.ipv6.conf.all.disable_ipv6=1
            sysctl net.ipv6.conf.default.disable_ipv6=1
            sysctl net.ipv6.conf.lo.disable_ipv6=1      
        - require:
            - docker-install

pre-configure-docker:
      file.managed:
          - names:
              - /etc/sysctl.d/90-rancher.conf:
                  - user: root
                  - group: root
                  - mode: 644
                  - contents: |
                        net.bridge.bridge-nf-call-iptables=1
                        net.ipv6.conf.all.disable_ipv6=1
                        net.ipv6.conf.default.disable_ipv6=1
                        net.ipv6.conf.lo.disable_ipv6=1
              - /etc/modules-load.d/modules-rancher.conf:
                  - user: root
                  - group: root
                  - mode: 644
                  - contents: 'br_netfilter'

set-AllowTcpForwarding-sshd:
      file.replace:
          - name: /etc/ssh/sshd_config
          - pattern: '#AllowTcpForwarding\s*yes'
          - repl: 'AllowTcpForwarding yes'
          - append_if_not_found: true

set-PubkeyAuthentication-sshd:
      file.replace:
          - name: /etc/ssh/sshd_config
          - pattern: 'PubkeyAuthentication\s*no'
          - repl: 'PubkeyAuthentication yes'
          - append_if_not_found: true

ssh-server-restart:
      cmd.run:
        - name:  'systemctl restart sshd'
        - require:
            - set-AllowTcpForwarding-sshd
            - set-PubkeyAuthentication-sshd
        - order: last

add-product-containers:
     cmd.run:
        - name: 'SUSEConnect -p sle-module-containers/15.3/x86_64'
        - require:
            - sls: registration

docker-install:
  pkg.installed:
    - name: docker
    - require:
      - add-product-containers

docker:
  service.running:
    - enable: True
    - watch:
      - pkg: docker
      - configure-docker
    - require:
      - pkg: docker
      - configure-docker

/etc/chrony.d/ntp.conf:
  file.managed:
    - user: root
    - group: root
    - mode: 644
    - source: salt://main/ntp.conf
    - require:
      - chronyd-install

chrony-pool-suse-remove:
  pkg.purged:
    - name: chrony-pool-suse
    - require:
        - sls: registration

chronyd-install:
  pkg.installed:
    - names:
      - chrony-pool-empty
      - chrony
    - require:
        - chrony-pool-suse-remove

chronyd:
  service.running:
    - enable: True
    - watch:
      - pkg: chrony
      - file: /etc/chrony.d/ntp.conf
    - require:
      - pkg: chrony
      - file: /etc/chrony.d/ntp.conf

longhorn-install:
  pkg.installed:
    - names:
      - open-iscsi
      - nfs-kernel-server
    - require:
        - sls: registration

nfs-server:
  service.running:
    - enable: True
    - require:
      - longhorn-install
