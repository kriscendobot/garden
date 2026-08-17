---
tier: minion
model-burned: mentor
fallback-tier: 
dispatch: automatic
---
Fix the permanent restart loop in `scripts/jobs/handlers/comment-source-gh.sh` when a watched repo has GitHub Issues disabled.

**Failure signature** (from `garden-comment-watcher@kriscendobot-vattr97`, exit 1, every tick):
```
WARN: gh api repos/kriscendobot/vattr97/issues/comments?since=...&per_page=100 failed (definitive, rc=1); not retrying: gh: Not Found (HTTP 404)
FETCH INCOMPLETE for kriscendobot/vattr97: one or more comment surfaces failed to enumerate — exiting nonzero
FATAL: comment source failed for kriscendobot/vattr97 (rc=1)
```

**Cause.** `kriscendobot/vattr97` has `has_issues: false` (GitHub's default for forks). The repo-wide `GET /repos/{o}/{r}/issues/comments` endpoint 404s for issues-disabled repos. Surface 1 (line ~158) records this via `note_fetch_failure`; the tail block (line ~368) then asks `repo_is_definitively_gone()`, which probes `repos/$repo`, gets a healthy 200, and returns 1 — so the script falls through to `exit 1`. The script models only two outcomes, *lost fetch* (retry) and *gone repo* (exit 0 + alert); an issues-disabled repo is a third case — **a surface that cannot exist** — so it retries forever against a condition retrying can never clear.

**Scope: 11 of 17 armed comment-watch repos**, all currently looping or failed: `agoric-3-proposals, agoric-sdk, cosgov, endo, endo-but-for-bots, list, moddable, ocapn, proposal-compartments, test262, vattr97`. Forks default to Issues-disabled and `fork-watch-provisioner.sh` arms every own fork, so each new fork reproduces this. Comment watching is dead on the majority of the garden's own forks, with cursors frozen — a real maintainer PR comment on any of them goes unseen.

**Required change.** Add a third classification alongside `repo_is_definitively_gone()` — call it e.g. `repo_issues_are_disabled()`: on a definitive 404 from surface 1, probe `gh api repos/$repo --jq '.has_issues'`, and if it answers `false`, treat surface 1 as **structurally empty rather than failed** (do not set `fetch_failed` for it, do not exit nonzero). Reuse the existing discipline in `repo_is_definitively_gone()`: a transient/unaskable probe (`_gh_api_stderr_is_transient`) must NOT be classified as issues-disabled — never guess a state; fall back to the current freeze-and-retry.

**Do not simply skip the surface** — that would silently drop PR-conversation comments (`pr-comment`), the watcher's most important signal. With Issues disabled, true-issue comments genuinely cannot exist (zero loss), but PR-conversation comments remain reachable per-PR: `repos/kriscendobot/vattr97/issues/1/comments` returns 200 (verified). So in the issues-disabled fallback, enumerate PR-conversation comments **per open PR** via `repos/$repo/issues/<n>/comments?since=$since&per_page=100`, emitting the same `pr-comment` TSV rows (same fields, same `$bot` self-filter, same `created_at >= $since` filter) that surface 1 emits. Section 3 already walks all open PRs with correct pagination — ride that walk rather than adding a second one. A per-PR fetch failure inside the fallback MUST still set `fetch_failed` (the lost-fetch invariant is preserved for the surface that does exist).

**Secondary, same cause — note but keep the behavior.** `scripts/jobs/comment-watcher.sh` lines ~379/381 use the same repo-wide endpoint as a jq-blindness canary with `2>/dev/null || true`. It fails open (`return 0`, inconclusive), so it does not fail a tick, but it is permanently inconclusive on these 11 repos — the jq-outage canary is silently disarmed there. Either point it at a surface that exists on issues-disabled repos or add a comment recording that the canary is inert for them; do not make it fail a tick.

**Verification.** Add a regression test under `scripts/jobs/test/` in the style of the existing `fake-gh.sh`-driven tests: a fake `gh` where `repos/<r>` returns `has_issues: false` and the repo-wide `issues/comments` 404s while `issues/<n>/comments` succeeds — assert the source exits 0, emits the per-PR `pr-comment` rows, and does NOT freeze the cursor; plus a case where the `has_issues` probe itself fails transiently — assert it still exits nonzero (freeze). Then confirm the live units settle: `systemctl --user list-units 'garden-comment-watcher@*'` should show no member stuck in `activating start`.

<!-- garden-reaped: 1 -->

---
claim:
  host: endolin-garden2-5bcdff64
  gardener: 1
  worker_kind: cleric
  tier: 
  provider: openai
  model: 
  claimed_at: 2026-08-17T13:54:47Z
