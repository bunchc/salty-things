install-iptables:
  pkg.installed:
    - pkgs:
      - iptables

{% for key,rule in salt['pillar.get']('user-ports',{}).items() %}

user-ports-{{key}}:

  iptables.append:
    - table: filter
    - chain: {{rule.get('chain', 'INPUT')}}
    - jump: ACCEPT
    - match: state
    - connstate: NEW
    - dport: {{rule.get('dport')}}
    - proto: {{rule.get('proto', 'tcp')}}
    - sport: 1025:65535
    - save: True
{% endfor %}

allow established:
  iptables.append:
    - table: filter
    - chain: INPUT
    - match: state
    - connstate: ESTABLISHED
    - jump: ACCEPT
    - save: True

default to drop:
  iptables.set_policy:
    - table: filter
    - chain: INPUT
    - policy: DROP