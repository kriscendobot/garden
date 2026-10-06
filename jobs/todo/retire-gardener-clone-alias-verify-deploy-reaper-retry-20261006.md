---
arc: garden-upkeep
role: fixer
tier: mentor
fallback-tier: minion
dispatch: automatic
---
Fixer on kriscendobot/garden (main2): do the last unfinished regression check for 70b6d1e3d42, the commit that retired the GARDEN_GARDENER_CLONE alias. It is the only sibling not yet in tada; the parked `retire-gardener-clone-alias-verify-deploy-reaper` was doomed after two transient timeouts. Run the deploy-garden, reaper-requeue-cap, reaper-live-handler-guard, reaper-doom-park, deadline-nudge and fetch-timeout suites with a scrubbed env (`env -i HOME=$HOME PATH=$PATH TMPDIR=$TMPDIR GARDEN_TEST=1`), diff their FAIL lines against an extract of 70b6d1e3d42^, fix and land only failures that the commit caused, and withdraw the doomed plan entry. fetch-timeout takes over 15 minutes, so run it detached with a long timeout.
