---
tier: minion
model-burned: mentor
fallback-tier: 
dispatch: automatic
---
Fix `scripts/jobs/handlers/comment-source-gh.sh` so a repo with **Issues disabled** does not fail every comment-watcher tick forever and silently freeze its cursor.

Failure signature (blob `347557136`, unit `garden-comment-watcher@kriscendobot-agoric-3-proposals`, exit 1, recurring): `gh api repos/kriscendobot/agoric-3-proposals/issues/comments?since=… failed (definitive, rc=1); not retrying: gh: Not Found (HTTP 404)` → `FETCH-FAIL: surface issues/comments failed to enumerate — freezing cursor` → `FETCH INCOMPLETE … exiting nonzero` → watcher `FATAL`.

Cause: `kriscendobot/agoric-3-proposals` has `has_issues: false` (forks default to Issues off), so GitHub's **repo-level** list-issue-comments endpoint 404s permanently. The surface-1 call at line 158 treats that as a lost fetch (`note_fetch_failure`, line 168), and the LOST-FETCH invariant at line 368 exits 1. The existing REPO-GONE degrade (`repo_is_definitively_gone`, line 347) correctly does NOT fire, because the repo itself answers — this is the symmetric, uncovered case: a **live repo with a structurally-absent surface**, where freeze-and-retry can never recover.

Scope: fleet-wide. 11 of 17 armed `comment-repos/` slugs are `has_issues: false` forks auto-armed by `fork-watch-provisioner.sh` (`agoric-3-proposals`, `agoric-sdk`, `cosgov`, `endo`, `endo-but-for-bots`, `list`, `moddable`, `ocapn`, `proposal-compartments`, `test262`, `vattr97`, `ymax-stdio-mcp`). Each fails every tick AND — because the watcher discards a nonzero-rc source's output — never emits inline review comments or PR-conversation comments for those forks. `kriscendobot/agoric-sdk` has open PRs today, so real maintainer comments are being dropped. Do not "fix" this by suppressing the surface: that would convert the crash-loop into a permanent silent drop, exactly what the LOST-FETCH invariant exists to prevent.

Required change — an ISSUES-DISABLED degrade that substitutes an equivalent enumeration rather than skipping it:

1. On a definitive failure of the surface-1 call, probe `gh_api_retry "repos/$repo" --jq '.has_issues'` (only on the already-failed path, mirroring `repo_is_definitively_gone`'s cost discipline). A transient stderr signature (`_gh_api_stderr_is_transient`) means "could not ask" → fall through to today's unchanged freeze-and-retry; never guess the state.
2. If the repo answers with `has_issues == false`, do NOT call `note_fetch_failure`. Instead enumerate PR-conversation comments **per open PR** via `repos/$repo/issues/<n>/comments?since=$since&per_page=100` over the open-PR list section 3 already builds — verified to return `[]` rather than 404 on a disabled-issues repo (PRs are issues even when the Issues tab is off). Emit the identical TSV shape and the same `test("/pull/")` html_url classification as line 159-166, and keep the `.created_at >= $since` and `!= $bot` filters. Only if one of those per-PR calls fails definitively do you `note_fetch_failure` — the invariant still holds for a genuine gap.
3. Ordering: the fallback needs section 3's open-PR list, so either hoist that list above section 1 or defer the fallback to run after section 3 (the same deferral section 2 already uses); keep the emit order contract the watcher depends on.
4. True-issue comments cannot exist when Issues are disabled, so surface `issue-comment` is legitimately empty in this mode — say so in a comment at the degrade so the next reader does not read it as a dropped surface.
5. If the repo answers with `has_issues == true` and `issues/comments` still 404s, that is unexplained — preserve today's freeze-and-exit-1 behavior.

Regression coverage in `scripts/jobs/test/comment-watcher-test.sh`, alongside the existing repo-gone test near line 1614 and the frozen-cursor tests near 1731/1763: a repo whose `repos/<r>` probe returns `has_issues: false` and whose repo-level `/issues/comments` returns HTTP 404, carrying a PR-conversation comment reachable only via `issues/<n>/comments` — assert the source exits 0, the comment IS emitted as `pr-comment`, and the cursor advances. Add the negative case too: `has_issues: true` plus a 404 on the same surface must still exit nonzero with the cursor frozen.

Run `scripts/jobs/test/comment-watcher-test.sh` and `shellcheck` on the handler. No arming records or journal state should change — the watch set is correct; the handler's surface handling is what is wrong. In particular do NOT add a `watch-optout` tombstone for any of these forks.

<!-- garden-reaped: 3 -->

---
claim:
  host: endolin-garden2-5bcdff64
  gardener: 1
  worker_kind: cleric
  tier: 
  provider: openai
  model: 
  claimed_at: 2026-08-17T14:13:18Z
