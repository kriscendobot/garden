---
event: dispatch
role: fixer
dispatcher: endolinbot-steward
dispatch_root: /home/kris/dispatches/fixer--a5b969
repo: endojs/endo-but-for-bots
pr: 345
branch: mirror/3032-cancel
trigger: kriskowal directive 2026-05-23T07:07:53Z on #345 — "Dispatch fixer."
---

# Fixer dispatch: address #345 real CI failures escalated by shepherd-f4b8bd

Per shepherd-f4b8bd's escalation (endo-but-for-bots#345 issuecomment-4524192233), 5 real failures remain on head 77e2dc050:
- lint
- cover (20.x, ubuntu-latest)
- cover (24.x, ubuntu-latest)
- viable-release (20.x, ubuntu-latest)
- viable-release (24.x, ubuntu-latest)
