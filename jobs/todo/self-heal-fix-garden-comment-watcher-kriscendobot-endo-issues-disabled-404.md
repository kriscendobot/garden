---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
scripts/jobs/handlers/comment-source-gh.sh

Add an ISSUES-DISABLED degrade for the repo-wide issue-comments surface, sibling to the existing REPO-GONE degrade.

Failure signature (blob `9bba821b`, `garden-comment-watcher@kriscendobot-endo`, exit 1, restart loop):
```
WARN: gh api repos/kriscendobot/endo/issues/comments?since=…&per_page=100 failed (definitive, rc=1); gh: Not Found (HTTP 404)
FETCH-FAIL: surface issues/comments failed to enumerate — freezing cursor
FATAL: comment source failed for kriscendobot/endo (rc=1)
```

Root cause: `kriscendobot/endo` has `has_issues: false` (GitHub's default for a fork), so `GET /repos/<repo>/issues/comments` returns a permanent 404. The repo itself answers, so `repo_is_definitively_gone()` (line 347) correctly declines to deactivate, and the LOST-FETCH invariant exits 1 at line 381 on every tick forever. 12 of the 15 armed watch repos are in this state (`agoric-3-proposals`, `agoric-sdk`, `cosgov`, `endo`, `endo-but-for-bots`, `list`, `moddable`, `ocapn`, `proposal-compartments`, `test262`, `vattr97`, `ymax-stdio-mcp`) — all latent permanent restart loops.

What to change, in the section-1 failure path (line 158-169):

1. When the section-1 fetch fails with a DEFINITIVE (non-transient, per `_gh_api_stderr_is_transient`) 404, probe `gh_api_retry "repos/$repo" --jq '.has_issues'` once. Only on `false` take the new path; anything else falls through to the unchanged `note_fetch_failure` freeze-and-retry. Like the REPO-GONE probe, this runs ONLY on the already-failed path so a healthy tick pays nothing.

2. Do NOT treat the surface as empty. PR conversation comments live in this same feed and section 1 splits them out by `html_url | test("/pull/")` (line 163) into surface `pr-comment`, which the watcher always keeps. Blanking it would silently drop every PR conversation comment on those 12 repos — the exact class of drop the LOST-FETCH invariant was written for (cf. the r3566529028/#678 loss documented at lines 116-129).

   Instead, enumerate per-PR: for each open PR already walked in section 3 (the activity-bounded open-PR list), fetch `repos/$repo/issues/<n>/comments?since=$since&per_page=100` under `--paginate` and emit the same TSV rows with surface `pr-comment`. Verified working: `repos/kriscendobot/endo/issues/2/comments` returns 200 with Issues disabled — only the repo-wide aggregate endpoint 404s. If ANY per-PR call fails, that IS a real lost fetch: call `note_fetch_failure` and keep the existing freeze semantics.

   True-issue comments are genuinely absent (issues are disabled, so none can exist) — correctly nothing to enumerate, and the watcher skips `issue-comment` in PR-only mode anyway.

3. Log the degrade once per tick at the existing `log` shape, e.g. `ISSUES DISABLED: <repo> has_issues=false — the repo-wide /issues/comments feed 404s permanently; enumerating PR conversation comments per-PR instead`. No `alert_maintainer` here: unlike REPO-GONE this is a healthy, expected fork configuration requiring no human action, and it would fire against 12 repos.

Secondary, same file's caller: `scripts/jobs/comment-watcher.sh:379-381` uses the same repo-wide endpoint as its jq-blindness probe. With Issues disabled it gets empty output and returns 0 ("inconclusive"), so it is benign but permanently unable to detect blindness on those repos. Point it at the same per-PR endpoint, or note the limitation in a comment.

Regression tests in `scripts/jobs/test/comment-watcher-test.sh` (the SS1 family around line 1392 already stubs `/issues/comments` and is the natural home): (a) repo-wide `/issues/comments` 404 + `repos/<repo>` returning `has_issues:false` → source exits 0, emits `pr-comment` rows gathered from the per-PR endpoint, cursor advances; (b) same 404 but `has_issues:true` → unchanged freeze, exit 1 (a real outage must still freeze); (c) `has_issues:false` and a per-PR call fails → freeze, exit 1 (no silent partial); (d) the existing 403 case at `run-test.sh:3351` still freezes.
