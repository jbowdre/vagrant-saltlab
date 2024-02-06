# -*- coding: utf-8 -*-
# vim: ft=yaml
---
{% for user, uid in pillar.get('users', {}).items() %}
{{user}}:
  user.present:
    - uid: {{uid}}
{% endfor %}
