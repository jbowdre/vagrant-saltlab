# -*- coding: utf-8 -*-
# vim: ft=yaml
---
{% if grains['os_family'] == 'RedHat' %}
install_epel_repo:
  pkg.installed:
    - name: epel-release
{% endif %}

install_neofetch:
  pkg.installed:
    - name: neofetch
    {% if grains['os_family'] == 'RedHat' %}
    - require:
      - pkg: install_epel_repo
    {% endif %}
