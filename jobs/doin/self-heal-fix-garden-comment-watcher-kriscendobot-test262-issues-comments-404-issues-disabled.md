---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
In `scripts/jobs/handlers/comment-source-gh.sh`, teach the LOST-FETCH invariant to distinguish a **surface-disabled 404** from a lost fetch, so an issues-disabled fork stops failing its tick forever.

Failure signature (self-heal blob `104ade6d`, `garden-comment-watcher@kriscendobot-test262`, exit 1, recurring every tick):
```
FETCH-FAIL: surface issues/comments failed to enumerate — freezing cursor
WARN: gh api repos/kriscendobot/test262/issues/comments?since=…&per_page=100 failed (definitive, rc=1); not retrying: gh: Not Found (HTTP 404)
FETCH INCOMPLETE for kriscendobot/test262 … exiting nonzero
FATAL: comment source failed for kriscendobot/test262 (rc=1)
```

Cause: `kriscendobot/test262` is a fork with `has_issues:false` (GitHub's default for forks). GitHub hard-404s the repo-wide `GET /repos/{o}/{r}/issues/comments` when Issues are disabled. Section 1 (line ~158) sets `fetch_failed`; the tail block's only escape (`repo_is_definitively_gone()`, line ~347) probes `gh api repos/$repo`, which SUCCEEDS (the repo exists), so it falls through to `exit 1` at line ~381 — a permanent systemd failure loop identical in shape to the one the repo-gone hatch was written to prevent. This affects 11 of 15 armed repos (every issues-disabled own-fork auto-armed by `fork-watch-provisioner.sh`), not just test262.

What to change:
1. Add a `surface_is_structurally_disabled()` sibling to `repo_is_definitively_gone()`: when section 1's `issues/comments` fails and the stderr is a definitive 404 (reuse the existing `_gh_api_stderr_is_transient` guard so "could not ask" is never "disabled"), probe `gh_api_retry "repos/$repo" --jq '.has_issues'`. If it answers `false`, log the skip at INFO and do NOT set `fetch_failed` — Issues are off, so there are no issue comments to enumerate and the cursor may advance safely. Any other 404 keeps today's freeze-and-fail behavior.
2. Recover PR-conversation comments, which today reach the source ONLY through that repo-wide list. Verified: the per-PR `issues/{n}/comments` endpoint still returns 200 on issues-disabled forks (checked `kriscendobot/endo-but-for-bots` #3 and `kriscendobot/endo` #2). Section 3 already enumerates all open PRs, so when the surface is skipped, fetch `repos/$repo/issues/<n>/comments?since=$since` inside that existing walk and emit each as surface `pr-comment` with the same jq shape/bot-filter as section 1. A failure THERE is a real lost fetch and must still set `fetch_failed`.
3. Cache the `has_issues` probe for the tick (one extra API call at most, only on the 404 path).
4. Regression test in `scripts/jobs/test/comment-watcher-test.sh`, alongside the existing FETCH-INCOMPLETE / repo-gone cases: stub `gh` so `repos/<r>` returns `has_issues:false` and the repo-wide `issues/comments` returns HTTP 404 — assert the source exits 0, does not log `FETCH INCOMPLETE`, and that a PR-conversation comment on an open PR is still emitted as `pr-comment` via the per-PR path. Also assert a 404 with `has_issues:true` still freezes and exits nonzero.

Do not unwatch test262 or add a `watch-optout` tombstone — the repo is live and legitimately armed; the source's surface classification is the defect.

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 1
  worker_kind: cleric
  tier: 
  provider: openai
  model: 
  claimed_at: 2026-08-17T13:37:58Z
