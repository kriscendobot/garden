---
role: fixer
tier: mentor
---
<!-- garden-promoted-from-plan: gate=deferred priority=urgent at=2026-09-16T10:04:07Z cleared=none -->

---
role: fixer
tier: mentor
dispatch: automatic
fallback-tier: minion
---
# Verify the foreman target-2 rollout and first real promotion

Successor to `foreman-partial-unquiesce-target-2`. Commit `78772d0c3e` is already
on `main2` and changes `scripts/systemd/garden-foreman.service` from active target
0 to 2. The predecessor could not observe the post-deploy tick because the
deliberate deploy waits for all active gardeners, including the predecessor, to
quiesce.

Wait for the normal rolling deploy to put `78772d0c3e` (or a descendant) on the
leader `endolin-garden-ece02cb4`; do not run a deploy manually unless needed and
then use only the maintainer-authorized sysop operation
`send-host-op.sh endolin-garden-ece02cb4 op=deploy authorized_by=kriskowal`.
Confirm the rendered unit has `GARDEN_FOREMAN_ACTIVE_TARGET=2`. Then observe
`/home/kris/garden/.garden-state/foreman/decisions.log` until a real tick records
`target=2` with `guard=promoted` or `guard=pumped` (not merely `subscribed`). There
are deferred plan jobs available. Report the exact post-change line and cite the
pre-change line captured by the predecessor:
`2026-09-16T05:30:13Z inflight=4 target=0 guard=subscribed`.

Do not change the target or deploy unrelated code. If the board remains at or
above two active jobs, wait for it to fall below two so the actual promotion can
be observed.

---
claim:
  host: endolin-garden2-5bcdff64
  gardener: 1
  worker_kind: cleric
  tier: 
  provider: openai
  model: 
  claimed_at: 2026-09-16T10:04:12Z
