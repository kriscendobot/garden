scripts/jobs/ci-watcher.sh
Add a deterministic **stale-shepherd re-validation sweep** to ci-watcher.sh that runs each tick alongside the existing red→post pass, closing the false-positive-wedge loop that produced the `endojs-endo-but-for-bots-pr693-shepherd` exit-0-unsatisfying escalation (journal 2026-07-11T18:34Z).

Root cause: the watcher mints a shepherd from a *point-in-time* rollup read (`GARDEN_CI_ROLLUP` == RED) and hands the freshness re-check to the agent via the job body ("Re-fetch the live check state before acting"). When that red self-heals before the job is claimed/run — a flaky check that later passes, or a check still IN_PROGRESS that later goes green (PR #693 was DRAFT/MERGEABLE with every check SUCCESS, its last check still running at wedge time) — the shepherd agent re-fetches, finds CI no-longer-red, has nothing to do, and exits 0 **without emitting the completion marker**. gardener.sh then classifies that as exit-0-unsatisfying, requeues doin→todo, and the elapsed-constancy detector (37s,37s) escalates a `kind:error` "WEDGED child" — a phantom wedge for a job whose work simply evaporated.

What to change: for every shepherd base this watcher owns (`$slug-pr<N>-shepherd`) that is currently **unclaimed in `todo/`**, re-read the rollup; if the verdict is no longer RED (green rc=10 / none rc=11 / pending rc=12), the shepherd is stale — deterministically retire it (move `todo/`→`tada/` with an auto completion report like "CI recovered/settled before claim — nothing to shepherd; ci-watcher retired this stale auto-shepherd", carrying the completion sentinel so it records as genuinely done, CAS-pushed like the existing posts). Reuse the existing `GARDEN_CI_ROLLUP` handler, the `$VERIFY` clone, and the `posted_anywhere`/`shepherd_live` helpers already in the file; gate on leader-only exactly as the post path is.

Restrict retirement to **`todo/` (unclaimed) only** — never touch a `doin/` claim, to avoid racing an in-flight gardener. This is sufficient to break the observed loop: exit-0-unsatisfying requeues the wedging job doin→todo, so on the next ci-watcher tick the now-in-`todo/` stale shepherd is retired instead of re-claimed, ending the requeue/escalation cycle rather than burning toward the poison threshold.

Residual (prose, not this job's single script): the durable complement is for the shepherd itself to emit a clean completion marker when it re-fetches and finds CI green/settled, so an in-flight (`doin/`) no-op records as done rather than exit-0-unsatisfying — that lives in `roles/shepherd/AGENT.md` and is an agent-instruction change, out of scope for this script-level hardening.

---
claim:
  host: endolin-garden2-5bcdff64
  gardener: 14
  claimed_at: 2026-07-11T18:54:45Z
