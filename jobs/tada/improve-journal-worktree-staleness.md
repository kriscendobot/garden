Inbox empty. Work complete.

## Completion report

**Job:** `improve-journal-worktree-staleness` — make `scripts/jobs/journal-worktree-keeper.sh` persist the last successful reconciliation and enforce a bounded freshness threshold, so a persistently-stale shared `journal/` worktree emits one deduplicated actionable alert instead of silently lagging ~14h.

**What was wrong:** Every keeper tick that could not reconcile — a failed `journal_fetch` (offline), a refused `merge --ff-only`, a self-heal that aborted on an active writer — just logged and `return 0`, indistinguishable from success. There was no cross-tick memory, so unbounded lag accumulated with no escalation; agents landing in `journal/` had to detect and route around the stale board by hand.

**What I changed** (`scripts/jobs/journal-worktree-keeper.sh`, +98 lines):
- Added two config knobs: `GARDEN_JW_STATE_DIR` (default `$GARDEN_STATE/journal-worktree-keeper`) and `GARDEN_JW_FRESH_MAX_SECS` (default `7200`s ≈ 4 ticks, well under the 14h pathology).
- `jw_mark_fresh` — persists an epoch to a `last-fresh` marker at every **confirmed reconciliation to origin tip** (already-fresh, fast-forward, and successful self-heal reset), and clears any open staleness episode (logging `FRESHNESS-RESTORED`).
- `jw_check_staleness` — called on every **not-fresh** exit path (failed fetch, gitdir/origin unresolved, unresolvable HEAD/remote, ff-refused, diverged-but-heal-didn't-complete, self-heal-disabled). It measures age against the threshold; **first-ever observation seeds the clock** (never a spurious page); within threshold it only logs `STALE-WATCH`; past threshold it emits **exactly one** `alert_maintainer` page keyed `journal-worktree-stale-<host>` and sets a `stale-alerted` episode marker so subsequent stale ticks log `STALE-PERSISTS` without re-paging. Deliberately not the retired hourly page-storm.
- A `JW_RECONCILED` tick flag lets the diverged branch tell a completed heal from an aborted one.

**Tests** (`journal-worktree-keeper-test.sh`, +77 lines, 23 new cases): last-fresh persistence on the fresh and fast-forward paths; first-observation seeding with no page; within-threshold silence; one-page-past-threshold with the correct dedup key and episode marker; second-tick dedup (`STALE-PERSISTS`); and episode clearing on recovery.

**Verification:** `bash -n` clean; full suite **117/117 pass** (94 pre-existing unchanged + 23 new), run and observed.

**Committed & pushed:** `032e4ab8af` on `origin/main2` (rebase-CAS, first attempt). Inbox drained (empty). Deploys to every instance on the next deliberate deploy via the root checkout.

**Follow-ups:** none required. Minor note: the per-episode dedup is my own `stale-alerted` marker; `alert_maintainer`'s own 1h throttle is a secondary belt-and-suspenders, so a lag that recovers and re-fails inside the same hour could have its second episode's page folded into the throttle window — acceptable given episodes are threshold-gated at hours.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/improve-journal-worktree-staleness.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 46 tokens (1937977 cached reads)
- Output: 24507 tokens
- Cost: $2.5267245
- Wall-clock: 329s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
