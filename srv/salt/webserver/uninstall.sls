uninstall_apache:
  pkg.removed:
    - name: {{ pillar['pkgs']['apache'] }}

remove_html_file:
  file.absent:
    - name: /var/www/html/index.html

unconfigure_firewall:
  module.run:
    - firewalld.remove_service:
      - service: webserver
      - zone: public
    - firewalld.delete_service:
      - name: webserver

