# -*- coding: utf-8 -*-
# vim: ft=yaml
---
base:
  '*':
    - vim
  'roles:saltlab':
    - match: grain
    - users
  'roles:web':
    - match: grain
    - webserver
