vim:
  pkg.installed:
    {% if grains['os_family'] == 'RedHat'%}
    - name: vim-enhanced
    {% else %}
    - name: vim
    {% endif %}

/etc/vimrc:
  file.managed:
    - source: salt://edit/vimrc
    - mode: 644
    - user: root
    - group: root

