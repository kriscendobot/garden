The work is complete and landed on `main2`. Here is my completion report.

---

## Completion report — `harden-comment-watcher-review-comment-drops`

**Root cause fixed.** The comment-watcher advances its durable cursor over whatever the source emits per tick. `comment-source-gh.sh` degraded a failed surface fetch (`| jq … || true`, or an open-PR list demoted to empty) into a *partial subset returned with rc 0* — so the cursor slid past comments on the failed surface and they were never re-polled. That is exactly how maintainer inline review comment `r3566529028` on #678 was dropped while issue-comments survived.

**What changed (landed on `main2`, commit `2722507d3c`):**

1. **Cursor-safety fix — `scripts/jobs/handlers/comment-source-gh.sh`.** Every surface fetch is now guarded: `issues/comments`, the open-PR list, per-PR `pulls/<n>/comments` (review-id map), per-PR `pulls/<n>/reviews`, and the inline `pulls/comments` surface. A persistent failure on ANY of them sets `fetch_failed`, echoes the underlying gh signature to stderr, and the source **exits nonzero**. The watcher discards a nonzero-rc source's output and either **skips the tick (transient → cursor frozen)** or **dies loud (structural)** — the cursor can no longer advance past un-enumerated comments. `gh_api_retry` still absorbs a genuine blip first, so this fires only on a persistent failure.

2. **Backfill — `scripts/jobs/backfill-dropped-review-comments.sh`** (new). Bounded, idempotent, **dry-run by default**. Re-enumerates the review surfaces (via the same hardened source) over the 24h window on open PRs and mints the watcher's `review` job for any trusted-maintainer directive with no owning job. Deduped four ways (base / identity / board-body needle-grep / post-job identity), monitoring-safety-gated to comment-watched repos only, trust = allowlist ∪ maintainers. **Ran it dry against live state:** examined 12 in-window reviews, **all 12 already owned** (incl. #678's recovered `pr678-review-4d666bb1`/`d461c045`), **0 to recover** — the known drop was already handled manually and no OTHERS exist. Its base-keys matched the watcher's exactly, proving parity. `--apply` was therefore unnecessary (nothing to post).

3. **Regression tests — `scripts/jobs/test/comment-watcher-test.sh`.** `RCF` (source-level): a failed inline-comment surface fails the whole tick with no silent partial subset, logs the incomplete enumeration, and surfaces the transient signature. `RCF2` (watcher-level, multi-surface one-fails-others-succeed): tick 1's source failure freezes the cursor (no job, no advance); a subsequent healthy tick recovers the review comment and posts exactly one `review` job. Suite **213 → 221 assertions, all green**.

**Injection discipline preserved:** enumeration stays deterministic (no `claude -p`); recovered job bodies name the review URL and mark all fetched text UNTRUSTED. **Watch set unchanged** (no new repo, no authorization needed).

**Deploy note:** the comment-watcher is a leader-only singleton (currently garden2). The fix takes effect on **garden2's next deploy**; the backfill is a manual one-shot already exercised against live state.

Follow-ups: none required. The backfill can be re-run (`--apply`) at any future point if a fresh drop appears within its 24h window.
