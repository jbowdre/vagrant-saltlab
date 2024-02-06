# -*- coding: utf-8 -*-
# vim: ft=yaml
---
sync_grains:
  local.saltutil.sync_grains:
    - tgt: {{ data['id'] }}