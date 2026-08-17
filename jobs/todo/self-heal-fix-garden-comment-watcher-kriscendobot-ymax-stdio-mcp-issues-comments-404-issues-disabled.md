---
tier: minion
model-burned: mentor
fallback-tier: 
dispatch: automatic
---
Fix the permanent comment-watcher crash-loop on forks that have the GitHub Issues feature DISABLED. Failure signature (blob 59d7fc62, and identically on kriscendobot-endo / -moddable / 8 more): `gh api repos/<repo>/issues/comments?since=…` returns a DEFINITIVE `404 Not Found`, `note_fetch_failure "issues/comments"` sets fetch_failed, the LOST-FETCH invariant exits 1, and the unit fails every tick forever.

Cause: `scripts/jobs/handlers/comment-source-gh.sh` section 1 fetches the repo-wide `/repos/<repo>/issues/comments` feed, which GitHub 404s whenever `.has_issues == false` — the default on forks, so `fork-watch-provisioner.sh` auto-arming own forks walks straight into it. The existing REPO-GONE degrade (`repo_is_definitively_gone()`, ~line 347) does not and should not fire: the repo answers 200, is not archived, and has open PRs. 11 of 16 armed comment-watch slugs are in this state right now.

Do NOT fix this by treating the 404 as an empty surface. PR conversation comments ARE issue comments, and they stay reachable per-PR even with Issues off — verified: `repos/kriscendobot/ymax-stdio-mcp/issues/1/comments` → HTTP 200 `[]` while the repo-wide feed 404s. Swallowing the 404 would silently drop the exact comment class the LOST-FETCH invariant was written to protect (the r3566529028 drop on #678).

Implement an ISSUES-DISABLED surface degrade in section 1, parallel in shape to the REPO-GONE degrade:
1. When the section-1 fetch fails and `_gh_api_stderr_is_transient` says the error is DEFINITIVE, probe `gh_api_retry "repos/$repo" --jq '.has_issues'`. Only an authoritative `false` arms the degrade; a transient probe failure or a `true` falls through to today's unchanged freeze-and-retry (never guess a state).
2. On `has_issues == false`, re-enumerate the conversation-comment surface per open PR: for each open PR from the list section 3 already builds, fetch `repos/$repo/issues/<n>/comments?since=$since&per_page=100` (paginated) and emit the same TSV lines section 1 emits, with surface hardcoded to `pr-comment` — with Issues disabled, a true-issue comment cannot exist, so the html_url `/pull/` classification is unnecessary. Keep the bot-login and `created_at >= $since` filters identical.
3. Preserve the invariant on the fallback: if any per-PR fetch fails definitively, call `note_fetch_failure` so the cursor still freezes. Only a fully successful fallback enumeration clears fetch_failed for this surface.
4. Log the degrade once per tick at info level, naming the repo and that the repo-wide feed is 404 because Issues is disabled, so the journal stays diagnosable.
5. Extend the section-1 comment block to document the new degrade alongside the LOST-FETCH and REPO-GONE exceptions, including the verified fact that per-PR `/issues/<n>/comments` remains 200 when the repo-wide feed 404s.

Regression test in `scripts/jobs/test/comment-watcher-test.sh`, following the existing gh-stub pattern: stub `repos/<repo>` → `{"has_issues":false}`, repo-wide `*/issues/comments*` → 404 rc=1, `*/issues/1/comments*` → one non-bot comment inside the window. Assert the source exits 0, emits that comment with surface `pr-comment`, and does NOT log FETCH INCOMPLETE. Add a companion case asserting that `has_issues:true` plus a 404 on the repo-wide feed still freezes the cursor and exits 1 (the degrade must not widen).

After landing, the 11 affected units clear on their next timer tick with no reconcile; confirm with `systemctl --user --failed`.

<!-- garden-reaped: 0 -->
