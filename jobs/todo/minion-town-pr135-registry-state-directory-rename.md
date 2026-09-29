---
role: fixer
pr: https://github.com/kriscendobot/minion.town/pull/135
tier: mentor
fallback-tier: minion
dispatch: automatic
---

# Rename REGISTRY_STATE_DIR → REGISTRY_STATE_DIRECTORY in minion.town#135

The Endo package this deployment runs (endojs/endo-but-for-bots#1362,
`@endo/npm-registry-server`) renamed its state-directory environment variable
from `REGISTRY_STATE_DIR` to `REGISTRY_STATE_DIRECTORY`; `src/config.js` refuses
to start without the new name. kriscendobot/minion.town#135 (dark provisioning
for npm.minion.town) still sets `REGISTRY_STATE_DIR` in the systemd unit, the
admin/verify scripts, and its tests. Rename every occurrence to
`REGISTRY_STATE_DIRECTORY`, push a follow-up commit to the #135 head, and watch CI.
Surfaced by panel round 6 (integrator) on endojs/endo-but-for-bots#1362.
