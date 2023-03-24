base:
  '*':
    - vim
  'roles:saltlab':
    - match: grain
    - cowsay
  'roles:web':
    - match: grain
    - nginx
