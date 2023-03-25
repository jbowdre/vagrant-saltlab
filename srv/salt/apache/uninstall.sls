uninstall_apache:
  pkg.removed:
    - name: {{ pillar['pkgs']['apache'] }}
