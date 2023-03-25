install_apache:
  pkg.installed:
    - name: {{ pillar['pkgs']['apache'] }}
  service.running:
    - require:
      - pkg: {{ pillar['pkgs']['apache'] }}
    - name: {{ pillar['pkgs']['apache'] }}
