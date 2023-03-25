base:
  '*':
    - vim
  'roles:saltlab':
    - match: grain
    - users
  'roles:web':
    - match: grain
    - apache
