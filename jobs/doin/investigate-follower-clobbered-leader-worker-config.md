---
role: fixer
---

# fixer (garden main2) — a FOLLOWER host rewrote the LEADER's per-host worker config (zeroed gardeners)

## Incident (2026-07-22, during the leader's deploy)
After the leader host **`endolin-garden2-5bcdff64`** deployed (drain → restart) at
~15:05Z, its gardener pool came back at **0** despite 0 failed units — the exact
"0 gardeners, nothing failed" silent trap. Root cause: the journal file
`hosts/endolin-garden2-5bcdff64` read:
```
gardeners: 0
clerics: 20
hermits: 2
updated_at: 2026-07-22T15:02:01Z
updated_by: endolin-garden-ece02cb4     <-- the FOLLOWER host, not the leader
```
So the **follower `endolin-garden-ece02cb4` wrote the LEADER's per-host worker
counts** (zeroing `gardeners`, bumping `clerics` 10→20) at 15:02Z — mid-deploy.
The scaler then faithfully "scaled gardener pool to 0." A human restored
`gardeners: 10`.

## Why this is a bug
A host's `hosts/<GARDEN>` worker counts are **that host's own** config
(`set-gardeners.sh <N> [host]`, `set-clerics.sh`, `set-hermits.sh`, the scaler,
`common.sh`). A follower must **not** silently rewrite another host's counts, and
**never** to `gardeners: 0` (gardeners run on every host). Doing so during that
host's deploy window is especially damaging — it survives the restart as a
"correctly reconciled" 0.

## Investigate & fix (garden main2, direct)
1. **Find the code path** by which `endolin-garden-ece02cb4` came to write
   `hosts/endolin-garden2-5bcdff64`. Candidates: a cross-host rebalancer/scaler, a
   `set-*-workers` call passing the wrong/other host id, a deploy-adjacent scaling
   step, or a default that stamps `hosts/<leader>` from a follower. Name the exact
   script + call site.
2. **Determine intent:** is cross-host worker rebalancing a real feature, or is this
   purely a misfire? If a legitimate rebalancer exists, it must (a) never zero a
   host's `gardeners`, (b) never clobber a host during that host's deploy/drain, and
   (c) be attributable. If there is NO legitimate cross-host writer, forbid it: a
   host writes only its OWN `hosts/<its-own-GARDEN>`.
3. **Fix + guard:** enforce the invariant (a host only sets its own counts, or a
   rebalancer respects the floors above), with a regression test. Consider a
   scaler-side sanity floor: refuse to scale gardeners to 0 on a host that should
   run them (esp. the leader) without an explicit drain/stand-down marker.
4. Report the root-cause call site, the fix commit sha, and the test evidence.

Reference: `scripts/jobs/{set-gardeners.sh,set-clerics.sh,set-hermits.sh,install-units.sh,common.sh}`,
the gardener-scaler unit, and `context/operations/{scaling.md,leader-follower.md}`.

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 16
  worker_kind: cleric
  claimed_at: 2026-07-22T15:13:28Z
