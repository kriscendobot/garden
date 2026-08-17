---
tier: minion
model-burned: mentor
fallback-tier: 
dispatch: automatic
---
Fix the permanent crash loop in `scripts/jobs/handlers/comment-source-gh.sh` on forks that have Issues disabled.

Failure signature (systemd restart loop, exit 1, every tick):
  `WARN: gh api repos/<repo>/issues/comments?since=…&per_page=100 failed (definitive, rc=1); not retrying: gh: Not Found (HTTP 404)`
  → `FETCH-FAIL: surface issues/comments failed to enumerate — freezing cursor`
  → `FATAL: comment source failed for <repo> (rc=1)`

Cause: GitHub disables Issues on forks by default (`gh api repos/kriscendobot/agoric-sdk --jq .has_issues` → `false`), and with Issues disabled the repo-level `/repos/<repo>/issues/comments` endpoint returns a hard 404. Section 1 of the source (around line 158) treats that as a lost fetch via `note_fetch_failure` (line ~137), so the cursor freezes and the tick exits nonzero forever. The existing `repo_is_definitively_gone()` degrade (line ~347) does NOT cover it, because `repos/<repo>` itself is readable and the PR walk succeeds. This currently affects 12 of 17 armed comment watches on this host (all `kriscendobot/*` forks except finbot/garden/minion.town/ymax-e2e), and `fork-watch-provisioner.sh` will keep re-creating the condition for every new own-fork.

What to change:

1. In `scripts/jobs/handlers/comment-source-gh.sh` section 1, when the repo-level `issues/comments` call fails, classify an ISSUES-DISABLED surface distinctly from a lost fetch: if gh's stderr is a definitive 404 (`Not Found` / `HTTP 404`, same matching as `repo_is_definitively_gone()`) AND `gh api repos/$repo --jq '.has_issues'` returns `false`, the surface is structurally ABSENT, not failed. Do not set `fetch_failed`; log at WARN once per tick that the repo has Issues disabled and the repo-level surface is being replaced by the per-PR fallback. Any other 404 (auth/permission/transient) must keep today's `note_fetch_failure` freeze-and-exit behavior — do not widen the swallow. Reuse the single `repos/$repo` probe rather than adding a second API call per tick if convenient.

2. Do NOT go blind: section 1 is the only supplier of `pr-comment` lines, so add the fallback that recovers that coverage. Inside the existing open-PR walk (section 3, ~lines 240-277, which already fetches `pulls/$n/comments` and `pulls/$n/reviews` per open PR), when the issues-disabled path is active, also fetch `repos/$repo/issues/$n/comments?since=$since&per_page=100`, filter `.created_at >= $since` and `user.login != $bot`, and emit the same TSV lines section 1 emits with surface `pr-comment` (classify via `html_url | test("/pull/")` exactly as section 1 does). Verified working: with `has_issues:false`, `repos/kriscendobot/agoric-sdk/issues/18/comments` returns 200 `[]` while the repo-level endpoint 404s. If a per-PR call fails, call `note_fetch_failure` for it — the freeze invariant must still hold for genuine enumeration gaps. True-issue comments cannot exist on an issues-disabled repo, so nothing else is lost; the `issue-comment` surface is legitimately empty there.

3. Regression test in `scripts/jobs/test/comment-watcher-test.sh`, in the style of the existing gh-stub cases (H / Q / Z): a stub where repo-level `issues/comments` returns 404 with `has_issues:false` and per-PR `issues/<n>/comments` returns a real comment must (a) exit 0, and (b) still surface that comment as a `pr-comment` line. Add the companion negative case: a 404 with `has_issues:true` must still exit nonzero (cursor frozen).

4. After the fix deploys, clear the accumulated restart-loop state: `systemctl --user reset-failed 'garden-comment-watcher@*'` and confirm the previously-`activating (start)` fork units settle.

Note for the claimer: this same failure will emit one self-heal job per affected repo slug; they are all the same bug. Fix once in the shared handler and close the siblings as duplicates rather than patching per-repo.

<!-- garden-reaped: 0 -->
