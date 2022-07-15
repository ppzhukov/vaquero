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
    - require:
        - sls: registration

mysql:
  service.running:
    - enable: True
    - require:
      - pkg: rmt-server

#rmt_conf:
#  file.managed:
#    - user: root
#    - group: root
#    - mode: 644
#    - names:
#       - /etc/rmt/ssl/rmt-server.cnf:
#         - source: salt://files/rmt-server.cnf
#       - /etc/rmt.conf
#         - source: salt://files/rmt.conf
#    - require:
#      - pkg: rmt
