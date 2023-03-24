vim:
  pkg.removed:
    {% if grains['os_family'] == 'RedHat'%}
    - name: vim-enhanced
    {% else %}
    - name: vim
    {% endif %}

/etc/vimrc:
  file.absent
