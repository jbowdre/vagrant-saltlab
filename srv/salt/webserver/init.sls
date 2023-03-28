install_apache:
  pkg.installed:
    - name: {{ pillar['pkgs']['apache'] }}
  service.running:
    - name: {{ pillar['pkgs']['apache'] }}
    - require:
      - pkg: {{ pillar['pkgs']['apache'] }}

install_html_file:
  file.managed:
    - name: /var/www/html/index.html
    - source: salt://webserver/index.html
    - require:
      - pkg: {{ pillar['pkgs']['apache'] }}

configure_firewall_service:
  pkg.installed:
    - name: firewalld
  firewalld.service:
    - require:
      - pkg: firewalld
    - name: webserver
    - ports:
      - 80/tcp
      - 443/tcp

configure_firewall_zone:
  firewalld.present:
    - require:
      - pkg: firewalld
      - firewalld: webserver
    - name: public
    - services:
      - webserver
