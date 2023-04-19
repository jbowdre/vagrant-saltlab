create_user_jbyers:
  user.present:
    - name: jbyers
    - fullname: John Byers
    - shell: /bin/bash
    - home: /home/jbyers
    - groups:
      - sudo
      - qa
    - require:
      - group: qa
