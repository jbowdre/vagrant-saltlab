uninstall_apache:
  pkg.removed:
    - name: {{ pillar['pkgs']['apache'] }}

remove_html_file:
  file.absent:
    - name: /var/www/html/index.html
