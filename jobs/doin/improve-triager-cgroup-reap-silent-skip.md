---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
scripts/jobs/triager.sh
triager_reap_cgroup_stragglers (scripts/jobs/triager.sh:534-587) silently `return 0` with no log when it can't identify the unit's cgroup (line 542-543: no `^0::` line; line 547-550: leaf name doesn't match `garden-triager@*.service`; line 552: `cgroup.procs` unreadable) — a real recurrence today: journalctl shows systemd itself finding 3 leftover git PIDs at 03:00:00 for `garden-triager@kriscendobot-oros-ckm-data-readiness.service` with none of the function's own "cgroup still holds N straggler(s)" WARNs (line 582) in the same window, consistent with the sweep quietly no-opping rather than timing out. Add a one-line WARN on each of those three early-return branches (cgroup line absent, leaf mismatch, procs unreadable) so a future silent no-op is distinguishable in the journal from a normal zero-straggler pass, instead of manifesting only as systemd's generic "Found left-over process" message on the next start.

---
claim:
  host: endolin-garden2-5bcdff64
  gardener: 2
  worker_kind: monk
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-09-25T03:21:50Z
