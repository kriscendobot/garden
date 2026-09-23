---
kind: error
role: gardener-scaler
host: endolinbot
at: 2026-07-06T11:11:50Z
---
# Host-identity DRIFT detected (deterministic guard)

**GARDEN=`endolinbot`** diverges from **hostname -s=`endolin-garden-ece02cb4`** on this host,
with NO recorded parallel-pool override (checked GARDEN_IDENTITY_OVERRIDE and
`/home/kris/garden/.garden-state/identity-override`).

GARDEN is the single key every per-host structure hangs off — claim metadata, the
`hosts/<host>` worker count, the journal index, and the leader/follower
predicate. An unrecorded divergence silently mislabels all of it (here: up to this
host's full gardener pool) and disables the leader gate.

**Leader impact:** is-main-host reports FOLLOWER (leader marker='endolin-garden2-5bcdff64', GARDEN=endolinbot)

**Likely source:** the gitignored per-instance identity file `/home/kris/garden/.garden`
(common.sh precedence step 2) or an inherited-env `GARDEN`. This is the
endolinbot2 regression class.

**Fix:** if this host is the leader, correct `/home/kris/garden/.garden` (and any
inherited `GARDEN`) to `endolin-garden-ece02cb4` and restart the pool; if this is a
deliberate parallel pool, record the override in `/home/kris/garden/.garden-state/identity-override`
(or export GARDEN_IDENTITY_OVERRIDE=`endolinbot`) so this guard stays quiet.

Posted once per distinct drift state by `scripts/jobs/identity-drift-guard.sh`
(gardener-scaler preflight). It will not repeat until the drift changes or clears.
