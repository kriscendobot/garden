Done. Completion report below.

---

## Completion report: `reinforce-cw-maintainer-reviews`

**SHA:** `c81e3641` (pushed to `origin/main2`)

### The gap (confirmed)
A trusted maintainer/contributor REVIEW carrying inline comments was dropped when **both** (1) its top-level body was EMPTY — `comment-source-gh.sh` did `select((.body//"")!="")`, dropping empty-body reviews outright so the review was invisible — and (2) the inline comments were *declarative* design decisions ("Per-design files are the source of truth", "Keep indefinitely"), so the imperative/verb heuristic from the prior fix never matched. Unacted-on three times: endo-but-for-bots #503/#96 and **kriskowal/garden #4** (reviews `4573331488` + `4573434772`).

### What changed
- **`scripts/jobs/handlers/comment-source-gh.sh`** — for each open PR, compute the set of review ids that carry ≥1 inline comment (from `pulls/<n>/comments`); surface a `pr-review-body` line when the body is non-empty **OR** the review is inline-bearing, marking inline-bearing reviews `[INLINE-REVIEW]`. An empty review with **no** inline comments is still dropped.
- **`scripts/jobs/comment-watcher.sh` `classify()`** — a `pr-review-body` marked `[INLINE-REVIEW]` from a **trusted** sender now mints a deterministic `review` job (return 0), **keyed per review id** (`<slug>-pr<N>-review-<hash(reviewid)>`), with **no** verb / @-mention / non-empty body / imperative phrasing required. The job body instructs the gardener to enumerate and resolve EVERY inline comment tied to the review (`gh api .../pulls/N/comments --jq 'select(.pull_request_review_id==REVIEW_ID)'`). Added `verb_action review` and a review-specific job-body branch.

### Classification change (before → after)
| Input | Before | After |
|---|---|---|
| Trusted sender, COMMENTED, **empty body**, has inline comments | dropped at source + classify→none | source surfaces `[INLINE-REVIEW]`; classify→`review` job (one, per review id) |
| Trusted sender, declarative-inline review (non-empty body, no verb) | classify→none (dropped) | classify→`review` job |
| **Untrusted** sender, same inline-bearing review | dropped | **still dropped** (sender gate preserved) |
| Review with no inline comments and no body | dropped | **still dropped** (source omits it) |

### Tests & verification
- Added watcher-level cases **N** (trusted empty-body inline review → exactly one per-review `review` job + idempotent re-poll), **O** (same from untrusted → dropped), **P** (trusted, no inline + empty body → nothing), and source-level **Q** (`comment-source-gh.sh` surfaces the inline-bearing empty-body review with `[INLINE-REVIEW]`, drops the empty no-inline review) — using a compact `gh` stub and real `jq`.
- Full suite: **44 passed, 0 failed** (all 33 prior cases still green — no regressions). `bash -n` and `shellcheck` clean (the only shellcheck output is pre-existing SC2034 on `GARDEN_TAG`/`bot`, read indirectly via `common.sh`).

### Deployment
The watcher is `Type=oneshot`, timer-driven; `ExecStart` runs the script fresh from disk each tick. The on-disk scripts under `/home/kris/scripts` match the pushed commit, and both `garden-comment-watcher@endojs-endo-but-for-bots.timer` and `@kriskowal-garden.timer` are active/waiting — the next tick picks up the fix with no daemon restart. Isolated-worktree build off `origin/main2`; worktree torn down.

### Follow-up
- **Historical backfill:** the watcher clamps `since` to a 24h lookback floor, so the *specific already-dropped* reviews (e.g. kriskowal/garden #4 `4573331488`/`4573434772`) will only be re-caught if they fall within the last 24h. The fix guarantees **forward** coverage; if the maintainer wants those exact historical reviews actioned now, a one-off "address review #4" job (or a temporary cursor rewind) would be needed — I did not manually fire a tick or post into kriskowal/garden, to avoid acting outside a clearly-authorized autonomous scope without a signal.
