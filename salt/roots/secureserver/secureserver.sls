include:
  - secureserver.sysctl
  - secureserver.firewall-base
  - fail2ban.config

software-requirements:
  pkg.installed:
    - pkgs:
      - denyhosts
      - psad
      - aide
      - logwatch

/etc/cron.daily/00logwatch:
  file:
    - managed
    - source: salt://secureserver/cron.daily/00logwatch
    - require:
      - pkg: software-requirements