uninstall_apache:
  pkg.removed:
    - name: {{ pillar['pkgs']['apache'] }}

remove_html_file:
  file.absent:
    - name: /var/www/html/index.html

unconfigure_firewall_http:
  module.run:
    - firewalld.remove_service:
      - service: http
      - zone: public

unconfigure_firewall_https:
  module.run:
    - firewalld.remove_service:
      - service: https
      - zone: public

