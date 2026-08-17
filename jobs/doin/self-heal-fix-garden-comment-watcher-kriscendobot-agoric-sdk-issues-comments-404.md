---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
Fix the permanent comment-watcher crash loop on forks whose Issues feature is disabled.

Failure signature (garden-comment-watcher@kriscendobot-agoric-sdk, exit 1, every tick):
  WARN: gh api repos/kriscendobot/agoric-sdk/issues/comments?since=...&per_page=100 failed (definitive, rc=1); not retrying: gh: Not Found (HTTP 404)
  FETCH-FAIL: surface issues/comments failed to enumerate — freezing cursor
  FETCH INCOMPLETE for kriscendobot/agoric-sdk ... exiting nonzero
  FATAL: comment source failed for kriscendobot/agoric-sdk (rc=1)

Root cause: `kriscendobot/agoric-sdk` has `has_issues: false` — GitHub's default for a new fork — and GitHub answers the repo-wide `/repos/<repo>/issues/comments` feed with 404 when the Issues feature is off. Verified: that endpoint 404s through both `scripts/jobs/bin/gh` and `/usr/bin/gh`; the sibling `pulls/comments` returns 200; the identical endpoint on `endojs/endo-but-for-bots` (`has_issues:true`) returns 200.

Why the existing degrade misses it: in `scripts/jobs/handlers/comment-source-gh.sh`, surface 1 (~line 158) calls `note_fetch_failure "issues/comments"`, then the tail block (~lines 364-385) consults `repo_is_definitively_gone()`, which probes `repos/<repo>` — that answers 200, so it returns 1 ("a real lost fetch") and the source falls through to `exit 1`. The watcher treats a definitive 404 as structural and dies loud, so systemd restarts in perpetuity. The repo-gone block models only a REPO-level 404; this is a SURFACE-level 404 on a live repo.

Do NOT fix this by treating the 404 as an empty surface. Per this file's own header, `issues/comments` folds in a PR's CONVERSATION comments (`surface=pr-comment`) — the comment-watcher's UNIQUE surface — so swallowing the 404 would silently drop maintainer directives forever, exactly the lost-fetch invariant the file exists to protect. The comments really are there: `repos/kriscendobot/agoric-sdk/issues/4/comments` returns `.../pull/4#issuecomment-4482711879` (a kriskowal COLLABORATOR comment) with `has_issues:false`.

Change to make, in `scripts/jobs/handlers/comment-source-gh.sh`:
1. On a DEFINITIVE 404 from the repo-wide `issues/comments` feed, confirm the cause narrowly before degrading: `gh_api_retry "repos/$repo" --jq '.has_issues'` returns `false`. Only then classify it as "surface absent by repo configuration". A 404 with `has_issues:true`, or a transient signature, must keep today's freeze-the-cursor behavior — never widen this into a blanket 404 swallow.
2. In that confirmed case, do not set `fetch_failed`. Instead FALL BACK to per-PR enumeration: for each open PR already enumerated for the section-3 review walk (reuse that open-PR list; do not add a second `gh pr list`), fetch `repos/$repo/issues/<n>/comments?since=$since&per_page=100` and emit the same TSV rows with the same `pr-comment`/`issue-comment` html_url split, the same `created_at >= $since` filter, and the same self-authored (`$bot`) drop. If the fallback itself fails to enumerate for any PR, THEN call `note_fetch_failure` so the cursor still freezes — the invariant must survive the new path.
3. Log the degrade once per tick at WARN so it stays diagnosable in the journal (e.g. "issues/comments surface absent (Issues disabled on <repo>) — enumerating PR conversation comments per-PR instead").

Generality — this is fleet-wide, not one repo: `scripts/jobs/fork-watch-provisioner.sh` auto-arms a comment watcher for every fork owned by `config/fork-owners`, and GitHub disables Issues on new forks by default, so EVERY auto-provisioned fork that never had Issues turned on crash-loops its comment-watcher from the moment it is armed. While in here, check whether `scripts/jobs/issue-inbox-watcher.sh` (which also reads `issues/comments?since=`, ~line 608) needs the same guard; it currently targets the garden's own repo where Issues are enabled, so it may only need a comment noting the dependency.

Regression test: add a case beside the existing surface-failure tests in `scripts/jobs/test/run-test.sh` (see the 403 fixture at ~line 3351, and `scripts/jobs/test/gh-api-retry-test.sh:174`). Two assertions: (a) stub `issues/comments?` → 404 with `repos/<repo>` → `has_issues:false`, and assert the source exits 0, emits the PR conversation comment via the per-PR fallback, and does NOT log FETCH INCOMPLETE; (b) stub `issues/comments?` → 404 with `has_issues:true` and assert the unchanged FETCH INCOMPLETE + nonzero exit, so the narrow guard cannot silently widen.

One observation to save the fixer confusion: the very first probe of the failing endpoint during diagnosis returned a comment successfully, then twelve consecutive identical calls 404'd (rate limit was healthy at 4849/5000 remaining, so throttling is not the cause). Treat the 404 as the structural steady state driven by `has_issues:false`; the fallback above is correct either way and is robust to that flap.

---
claim:
  host: endolin-garden2-5bcdff64
  gardener: 1
  worker_kind: gardener
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-08-17T14:10:48Z
