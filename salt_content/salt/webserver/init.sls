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

configure_firewall:
  pkg.installed:
    - name: firewalld
  firewalld.present:
    - require:
      - pkg: firewalld
    - name: public
    - services:
      - http
      - https
