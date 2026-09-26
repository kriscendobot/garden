My commit `74e27d32dc` is confirmed an ancestor of `origin/main2` (genuinely merged; the fleet has since advanced to `dd3eec1c2c`). Both suites remain green (sysop 56/56, guard 42/42). The job is complete — the requeue was spurious (my prior session landed the work before the reaper carried it forward).

## Completion report

**Landed on main2:** `74e27d32dc86556962d6fa3c9dcf7da1ac54310b` — verified an ancestor of the current `origin/main2` (`dd3eec1c2c`), all three new files present on the remote. No further work was needed on resume; the worktree is clean and nothing was uncommitted.

### What shipped

Added **`maintain`** to the sysop's closed vocabulary — a host-directed op that authorizes `root-repo-guard` to break a **confirmed-stale** `git gc.pid` lock and run one bounded gc on `$GARDEN_ROOT/.git`, closing the trigger case (endolin-garden-ece02cb4's UNMAINTAINABLE store: 51 packs, 0 missing objects — a stale lock, not corruption). The guard's correct unattended refusal is preserved; `maintain` is the maintainer-authorized escalation for one named host.

Design decisions (in `designs/sysop-repo-maintenance.md`):
- **Delegation, not reimplementation:** `root-maintenance.sh` invokes `root-repo-guard.sh` with one new flag `GARDEN_ROOT_GUARD_UNLOCK_STALE_GC=1`, checked inside `guard_object_store`; no new gc logic.
- **Liveness before force:** shared `gc_lock_holder_alive` (common.sh) distinguishes a stale lock (holder dead/recycled) from a live gc; **never passes `git gc --force`**; a live gc is refused synchronously, never clobbered.
- **Destructive tier:** issuer gate + maintainer `authorized_by` attestation, argued from consequence (repacks the shared root repo backing journal sync).
- **Async/bounded:** reuses the `local-model` shape — fixed non-enabled `garden-root-maintenance.service` started `--no-block`, polled on later ticks; a fast `drain off` is not starved.
- **Scope:** IN = stale-lock unlock + bounded gc; permanently OUT = dropping any ref/history (a store with missing objects still alerts a human), any repo but `$GARDEN_ROOT`, ferry/identity switch.

All sysop invariants preserved (deterministic, no `claude`, host-scoped, ticks under drain, idempotent, `sysop-log`-recorded, acked).

**Files:** `designs/sysop-repo-maintenance.md`, `scripts/jobs/root-maintenance.sh` (+x), `scripts/systemd/garden-root-maintenance.service` (no `[Install]`) — new; edits to `sysop.sh`, `root-repo-guard.sh`, `common.sh`, `send-host-op.sh`, `designs/sysop.md`, `CLAUDE.md`, and both test suites.

**Tests (hermetic, no real `gc --force`):** sysop-test 56/56 (+8 maintain cases), root-repo-guard-test 42/42 (+3 escalation cases). Re-verified green on resume.

### Overlapping parked orchestration

**Nothing to retire.** `sysop-local-model-provisioning` and both children are already **complete** (`jobs/tada/`, `orchestration-status: complete`) — `local-model` shipped. I did not subsume it; `maintain` is a distinct sibling op that reuses `local-model`'s async substrate shape. No two competing designs remain on the board.

### Operator repair for the trigger host

```
scripts/jobs/send-host-op.sh endolin-garden-ece02cb4 op=maintain authorized_by=<maintainer-login>
```
(`<maintainer-login>` on `maintainers/allowlist`; issued from a host on `config/sysop-issuers`.)

### Still needs a human
- **A deliberate deploy** to the target host before the op is available there (the deployed root advances only via drained `deploy-garden.sh`, not fast-forward).
- **Issuing the repair** with attestation (an agent cannot originate `authorized_by`).
- **If it returns `refused` (live gc):** confirm pid 3728245 is wedged, kill by hand, re-issue.
- **Genuinely-corrupt stores** remain human-only — `maintain` alerts with the back-up-refs-first recipe and never drops history.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/garden-widen-sysop-host-maintenance.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 2 on 1 host(s) (1 unmetered)
- Input: 7 tokens (684517 cached reads)
- Output: 3012 tokens
- Cost: $2.5083335 (1 engagement(s) unpriced)
- Wall-clock: 1242s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
