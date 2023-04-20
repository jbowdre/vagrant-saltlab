{% from "users/map.jinja" import users  with context %}

create_user_jbyers:
  user.present:
    - name: jbyers
    - fullname: John Byers
    - shell: /bin/bash
    - home: /home/jbyers
    - groups:
      - {{ users.sudo_group }}
      - qa
    - require:
      - group: qa
