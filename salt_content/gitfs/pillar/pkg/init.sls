# -*- coding: utf-8 -*-
# vim: ft=yaml
---
pkgs:
  {% if grains['os_family'] == 'RedHat' %}
  apache: httpd
  vim: vim-enhanced
  {% elif grains['os_family'] == 'Debian' %}
  apache: apache2
  vim: vim
  {% else %}
  apache: apache
  vim: vim
  {% endif %}
