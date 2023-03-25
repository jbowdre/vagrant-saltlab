install_vim:
  pkg.installed:
    - name: {{ pillar['pkgs']['vim'] }}

/etc/vimrc:
  file.managed:
    - source: salt://vim/vimrc
    - mode: 644
    - user: root
    - group: root

