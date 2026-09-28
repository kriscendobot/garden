---
role: fixer
priority: urgent
posted_by: liaison
tier: minion
model-burned: mentor
fallback-tier: 
dispatch: automatic
---
# Fix: a fresh journal clone can't finish inside the 45s fetch cap, so new workers can never start

Repo: the garden itself (`kriscendobot/garden`, `main2`, push direct, no PR).

## Observed (2026-09-28, endolin-garden2-5bcdff64)
`journal2` is back to ~322 MiB packed / 29,121 commits since the 2026-09-23 truncation. `ensure_clone` →
`reclone_clone` → `bounded_clone "$remote" "$dir" --single-branch --branch journal2` runs under the 45s fetch cap. A
**fresh** clone over SSH can't finish in 45s (rc=124), so a worker whose clone dir is missing (a newly scaled-up
worker, or a clone the journal-contention watch rebuilt) logs `offline; skipping tick (rc=75)` forever and never
claims. On this host `monk-2` and three monitor clones were stuck this way while 32 jobs sat in `todo`. The liaison
worked around it by seeding each clone with
`git clone --single-branch --branch journal2 --reference $GARDEN_ROOT/.git --dissociate <remote> <tmp>` and then
renaming it into place: **~7s each**, and `monk-2` claimed immediately. The leader and oros-studio very likely have
the same stuck workers (fleet-wide only 3 jobs were running with 8 monks declared).

## Ask
1. Make fresh clones bootstrap from local objects: in `reclone_clone`/`bounded_clone` for the journal, use
   `--reference-if-able "$GARDEN_ROOT/.git" --dissociate` (the root repo already holds `journal2` objects via the
   `journal/` worktree), keeping the atomic sibling-temp-then-rename landing.
2. Give a **cold** clone its own, larger timeout than an incremental fetch (the 45s cap exists so a *stale* fetch fails
   fast and doesn't serve stale refs; a first clone has no stale ref to serve), bounded, with a clear log.
3. Make sure the journal-contention watch's automatic clone rebuild uses the same local-reference path, so a rebuild
   never produces an un-cloneable worker.
4. Tests: a missing clone dir is created via the reference path within budget; a cold clone that exceeds the old cap
   but fits the new one succeeds; an incremental fetch still fails fast at 45s. Run the fetch/clone and
   journal-contention suites and push. Complete via the normal completion path.

<!-- garden-reaped: 1 -->
<!-- garden-plain-retry-not-before: 2026-09-28T09:56:13Z -->

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 1
  worker_kind: monk
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-09-28T09:56:28Z
