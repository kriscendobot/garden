<!-- POISON POSTMORTEM (investigate-poisoned-garden-infra-jobs, 2026-07-02) -->
<!--
This job was dropped from the board as POISON after 5 reaper requeue cycles. Root
cause of the poisoning was NOT this job body and NOT the infra it targets: a
sustained Claude quota/usage outage (2026-07-01T00:26-00:50Z, recurring in the
2026-07-02T01:20-01:45Z window) made EVERY gardener claude -p handler exit rc=1
with a transient "claude quota/usage cut" signature. The reaper counts requeue
cycles regardless of transient-vs-deterministic classification, so 5 cycles inside
one sustained outage poisoned this job and dozens of unrelated peers
(pr96-shepherd, pr394-fixer, pr216-weave, pr587/588/591-shepherd, ...) identically.
Compounding factor: the endolinbot2 host-identity drift was (and at re-post time
still is) live -- /home/kris/.garden holds "endolinbot2" though hostname -s and the
leader marker are "endolinbot", so is-main-host reports FOLLOWER and the leader-only
singletons were down. The target defect below was re-verified present at re-post
time against origin/main2. Do the work as specified; if claude -p is CURRENTLY
failing with a quota/usage signature, that is an environmental outage -- let the
tick requeue, do not treat it as a job defect.
-->

Every new gardener entry in this window reports `host: endolinbot2`, but per the maintainer record this host is canonically `endolinbot` (the leader marker names `endolinbot`; the `GARDEN=endolinbot2` override was removed as drift on 2026-07-01 precisely because it breaks every leader-only singleton's `is-main-host` ExecCondition). A silent `GARDEN` divergence corrupts per-host state (worker counts, claim metadata, journal index) and disables the leader gate for hours before anyone notices. `scripts/jobs/common.sh` defaults `GARDEN` to `hostname -s` but never checks for divergence. Add a deterministic drift guard (in `common.sh` or a preflight run each `gardener-scaler.sh` tick): when `$GARDEN` != `hostname -s` AND the host is not explicitly configured as a parallel pool, emit ONE loud `kind:error` journal entry (and, on the leader path, surface that `is-main-host` will fail) so a regression of the endolinbot2 override surfaces on the first tick instead of silently mislabeling 100 gardeners.

## Re-verification & sharpening (investigator, 2026-07-02)

Re-verified LIVE at re-post time on host endolinbot. The drift source is NOT an
inherited-env `GARDEN` (environment.d / manager env) — it is the gitignored
per-instance identity FILE `/home/kris/.garden`, which contains `endolinbot2`.
`common.sh` (precedence step 2, ~line 62) reads `.garden` and sets
`GARDEN=endolinbot2`, so `is-main-host.sh` compares `endolinbot2` against the
`leader` marker `endolinbot` and returns FOLLOWER — every leader-only singleton
(foreman, scheduler, reaper, bulletin, triager, issue-inbox, ci-watcher,
orchestrate, maintainer-inbox Monitor) is skipped on the true leader host.

Why the EXISTING guards miss it (build on them, do not duplicate):
- `gardener.sh` ~line 98 already logs a per-spawn WARN on `GARDEN != hostname -s`
  with no recorded override — but it is a plain `log` line, NOT a `kind:error`
  journal entry, so it does not surface loudly/greppably as this job asks.
- `gardener-scaler.sh` runs `install-units.sh reconcile-identity` every tick, but
  that catches only an INCONSISTENCY between a worker's frozen `/proc` environ and
  the current resolved `$GARDEN`. A `.garden`-FILE override makes ALL workers
  resolve `endolinbot2` consistently, so the reconcile sees no drift and restarts
  nothing.

So the ask stands and is unmet: add a deterministic guard that, when `$GARDEN` !=
`hostname -s` AND no recorded parallel-pool override
(`GARDEN_IDENTITY_OVERRIDE`/`$GARDEN_STATE/identity-override`) matches, emits ONE
loud `kind:error` JOURNAL entry (not just a log line) and, on the leader path,
surfaces that `is-main-host` will report follower. Run it as a `gardener-scaler.sh`
preflight (once per tick, host-level) so it fires even when the size signal is
missing, rather than only per-gardener-spawn. NOTE: the live `.garden=endolinbot2`
regression itself is being surfaced to the maintainer separately (operational fix
on the deployed root, out of a gardener's autonomous scope); this job is the
DETECTOR so the next regression is loud on tick 1.

---
claim:
  host: endolinbot2
  gardener: 88
  claimed_at: 2026-07-02T10:04:40Z
