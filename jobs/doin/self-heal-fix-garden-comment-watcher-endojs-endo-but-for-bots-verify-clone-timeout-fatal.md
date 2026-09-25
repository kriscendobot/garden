---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
scripts/jobs/comment-watcher.sh

`verify_fetch()` (comment-watcher.sh:472) calls the raw `ensure_clone "$VERIFY"` to (re)clone the journal VERIFY checkout. When that clone is missing/corrupt and the network stalls past `GARDEN_FETCH_TIMEOUT` (45s), `bounded_clone` is killed by `timeout` before any stderr is written, so `GARDEN_CLONE_STDERR` is empty; `_fetch_stderr_is_offline("")` doesn't match, so `reclone_clone` (common.sh:4302) falls through to a loud `die` instead of the quiet `EX_TEMPFAIL` (75) offline skip. That `die` propagates straight out of `verify_fetch`'s caller with no rescue, killing the whole tick with exit 1 — a plain network timeout escalates into a FATAL service crash and a self-heal escalation.

Failure signature (from the captured tail):
```
clone of git@github.com:kriscendobot/garden.git into .../comment-watcher/verify timed out (>45s) on attempt 1
clone of git@github.com:kriscendobot/garden.git into .../comment-watcher/verify failed after 1 attempt(s) (last rc=124)
FATAL: clone of git@github.com:kriscendobot/garden.git (journal2) into .../comment-watcher/verify failed
```

Fix: change `verify_fetch()`'s `ensure_clone "$VERIFY"` to `ensure_clone_or_latch_outage "$VERIFY" comment-watcher-verify` — the same wrapper already used by `cursor-get.sh`/`cursor-set.sh` (common.sh:4661) to classify exactly this ambiguous rc=1/timeout clone shape as a transient outage (`journal_bounded_fetch_is_ambiguous_outage`) and latch a quiet cooldown/`exit 75` instead of dying loud. `ensure_clone_or_latch_outage` still re-raises loud (unchanged behavior) for a positively-identified auth/corruption/missing-upstream failure, so no real fault gets masked.

While fixing comment-watcher.sh, audit and apply the same swap to the other watcher scripts with the identical raw `ensure_clone "$VERIFY"` call shape, all exposed to the same crash: `ci-watcher.sh:198`, `mention-watcher.sh:130`, `dependabot-watcher.sh:168`, `issue-inbox-watcher.sh:224`, `pages-watcher.sh:76`, `approval-reconciler.sh:216`, `backfill-dropped-review-comments.sh:82`.

---
claim:
  host: endolin-garden2-5bcdff64
  gardener: 1
  worker_kind: monk
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-09-25T21:54:51Z
