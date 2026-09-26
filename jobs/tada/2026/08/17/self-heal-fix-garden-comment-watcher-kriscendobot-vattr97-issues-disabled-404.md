Everything is verified complete on `origin/main2` (HEAD `48e25d3d33`), and my worktree is clean — the prior attempt already committed, pushed, and merged the full deliverable. Nothing more to write or push.

## Completion report

**Job:** `self-heal-fix-garden-comment-watcher-kriscendobot-vattr97-issues-disabled-404` — fix the permanent restart loop when a watched fork has GitHub Issues disabled.

**State on re-derivation:** The core deliverable was already committed and merged to `origin/main2` by a prior attempt (this is one of a per-repo job family; the sibling `…-endo-…` already `tada`'d). The fix is repo-agnostic, so it covers vattr97 and all 11 affected forks in a single change. My fresh worktree is identical to `origin/main2` — nothing left to write or push.

**What's in place (verified):**
- `scripts/jobs/handlers/comment-source-gh.sh` (commit `544355d714`): adds an ISSUES-DISABLED degrade sibling to REPO-GONE. On a *definitive* (non-transient) 404 from surface 1, it probes `repos/<repo>.has_issues` once (`repo_has_issues`, cached per tick); only on `false` does it enter issues-disabled mode — treating the repo-wide issues/comments aggregate as structurally empty (no `fetch_failed`, no exit 1). PR-conversation comments are **not** dropped: section 3's open-PR walk emits the same `pr-comment` rows from the per-PR `issues/<n>/comments` endpoint (verified 200 with Issues disabled). A per-PR fetch failure still sets `fetch_failed` → freeze, preserving the lost-fetch invariant. A transient/unaskable probe falls back to freeze-and-retry (never guesses state).
- `scripts/jobs/comment-watcher.sh` (secondary, `cb00b99e00`): documents the jq-blindness canary's known no-op on Issues-disabled repos rather than making it fail a tick.
- Regression tests pass: `comment-watcher-test.sh` → **332 passed, 0 failed**, including the required cases (404+`has_issues:false` → exit 0 + `pr-comment` rows + cursor advances; 404+`has_issues:true` → freeze; transient 5xx → freeze without probing; per-PR failure inside fallback → freeze/exit 1).

**Live unit:** `garden-comment-watcher@kriscendobot-vattr97` is no longer crash-looping — the timer is `active/waiting` and recent service runs finish `0/SUCCESS` (last failure 14:01:21, healthy since 14:02:44).

**One caveat (not this job's action):** The deployed garden root is still at `33127fab91`, *before* the fix commits, so vattr97's current healthy exits are because its activity window is momentarily idle (the old handler doesn't reach the 404 path when there are no recent events) — the durable fix lands when the root is deployed past the fix commits. That deploy is the deliberate, drained, leader-only `deploy-garden.sh` supervised by the liaison's deploy-on-upgrade Monitor (triggered automatically as main2 advanced), **not** a gardener job's action, and I must not git-operate in the deployed root. No follow-up job is needed — the deploy is standing infrastructure that will pick up the merged main2 automatically.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/self-heal-fix-garden-comment-watcher-kriscendobot-vattr97-issues-disabled-404.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 4 on 1 host(s) (3 unmetered)
- Input: 22 tokens (566714 cached reads)
- Output: 10546 tokens
- Cost: $0.986632 (3 engagement(s) unpriced)
- Wall-clock: 218s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
