# -*- coding: utf-8 -*-
# vim: ft=yaml
---
uninstall_vim:
  pkg.removed:
    - name: {{ pillar['pkgs']['vim'] }}

/etc/vimrc:
  file.absent
