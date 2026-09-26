The fix is committed and pushed to `main2` (`845b1895e2`).

## Completion report

**Job:** Fix the self-sustaining deadlock in the rolling deploy where a failed canary drained itself into permanent exclusion.

**Root cause (confirmed):** `halt_roll` remediated a failed canary with a benign `drain on`, but that drain was indistinguishable from an operator pause — `self-deploy` declined under it and published `operator-drained`, which `rolling-deploy` skips forever. The remediation manufactured exactly the state that made autonomous recovery impossible.

**Fix — drain provenance + bounded retry:**
- `drain-fleet.sh`: `on [--source SRC]` now writes a `source:` marker line (default `operator`). `common.sh` adds `drain_source`/`drain_is_roll_induced`, **failing safe toward operator** for any absent/unknown source (the operator guarantee is never weakened by a missing field).
- `send-host-op.sh → sysop.sh` drain handler: plumbs `source=` through to `drain-fleet.sh --source`.
- `self-deploy.sh`: under a roll-induced drain, publishes `roll-drained` (not `operator-drained`) and still declines to deploy; a *leaderless* follower self-clears a stale roll-drain (no conductor to retry it) but **never** an operator drain.
- `rolling-deploy.sh`: a `roll-drained`/failed canary is retried on its own, bounded by `GARDEN_CANARY_MAX_RETRIES` (default 3) with `GARDEN_CANARY_RETRY_BACKOFF` (default 15m) — the conductor lifts its own roll-drain, posts a fresh attempt-suffixed probe, and re-validates; on exhaustion it halts and pages **louder**. `operator-drained` is still skipped, never lifted.

**Tests (`scripts/jobs/test/rolling-deploy-test.sh`, 42/0):** new DRAIN PROVENANCE unit checks; the RETRY→RECOVER path (drained with roll provenance → no page → backoff hold → self-lift → fresh `-r1` probe → pass → leader advances **on its own**); retries-exhausted HALT (page + drained); and `self-deploy`'s `roll-drained`-vs-`operator-drained` decline. Also re-ran sysop (56/0), deploy-garden (131/0), deploy-tree-swap (18/0), release-boundary (18/0), scheduler-preflight (14/0).

**Watchdog severity aging (the 1545-fire):** judged a **follow-up, largely mitigated here** — a `roll-drained` follower no longer counts toward the all-followers-*operator*-drained hold (so that watchdog now fires only on a genuine all-operator pause), and `alert_maintainer` already coalesces with a rising `--count` and `--first-seen`, so age is already surfaced in the single inbox entry.

**Design:** `designs/follower-self-deploy.md` § Failure handling + § Interaction with drain updated to document the provenance/retry model.

**Process note:** my editor initially wrote to the deployed root `/home/kris/garden` instead of the job worktree; no git ran in the root, so no corruption. I copied the edits into the worktree and restored the root files to pristine from the worktree's HEAD blobs (verified byte-identical), then committed and pushed from the worktree only.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/fix-canary-drain-self-exclusion-20260916.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 138 tokens (8635125 cached reads)
- Output: 73920 tokens
- Cost: $7.8377895
- Wall-clock: 1086s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
