---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
`scripts/jobs/handlers/comment-source-gh.sh` crash-loops forever on any repo whose issues are DISABLED. Failure signature (garden-comment-watcher@kriscendobot-cosgov, exit 1, every tick):

    WARN: gh api repos/kriscendobot/cosgov/issues/comments?since=...&per_page=100 failed (definitive, rc=1); not retrying: gh: Not Found (HTTP 404)
    FETCH-FAIL: surface issues/comments failed to enumerate — freezing cursor
    FETCH INCOMPLETE for kriscendobot/cosgov ... exiting nonzero
    FATAL: comment source failed for kriscendobot/cosgov (rc=1)

Root cause: GitHub returns a definitive 404 on the repo-level `repos/<o>/<r>/issues/comments` endpoint when the repo has `has_issues: false`. Verified: `gh api repos/kriscendobot/cosgov` → 200 with `has_issues:false, fork:true, parent:DCFoundation/cosmos-proposal-builder`; that endpoint 404s, while `repos/kriscendobot/finbot/issues/comments` (has_issues:true) returns `[]`. The existing REPO-GONE degrade at comment-source-gh.sh:322-380 does not fire (correctly — the repo is alive), so surface 1 at line 158 calls `note_fetch_failure` on every tick, the tail exits nonzero, and the watcher freezes the cursor permanently. This is structural, not an enumeration blip: no retry can ever clear it.

Blast radius: 12 of 15 armed own forks have issues disabled (agoric-3-proposals, agoric-sdk, cosgov, endo, endo-but-for-bots, list, moddable, ocapn, proposal-compartments, test262, vattr97, ymax-stdio-mcp). Forks default to issues-off and `fork-watch-provisioner.sh` auto-arms own forks, so every auto-provisioned fork hits this. And because the source exits nonzero the watcher discards ALL surfaces for the tick — the section-3 review-body/inline walk included — so comment surveillance on those forks is entirely dead, not just missing true-issue comments.

Change to make, in `scripts/jobs/handlers/comment-source-gh.sh`:

1. Add an ISSUES-DISABLED degrade alongside the existing REPO-GONE one. When surface 1's gh call fails with a DEFINITIVE 404 (reuse the `*"Not Found"*|*"HTTP 404"*|*'"status":"404"'*` matcher from `repo_is_definitively_gone`), consult `gh api repos/$repo --jq .has_issues`; if it is `false`, treat the surface as legitimately EMPTY — log once at info ("issues are disabled on <repo>; repo-level issues/comments is permanently 404 — skipping that surface") and do NOT set `fetch_failed`. Only a 404 with `has_issues == true` (or an unreadable has_issues probe) stays a fetch failure. Keep the probe cheap: one extra API call only on the failure path, and fail CLOSED (still set `fetch_failed`) if the probe itself errors, so a genuine outage is never mistaken for issues-off.

2. Do not silently drop PR-conversation comments on those repos. With the repo-level endpoint gone, cover them by fetching `repos/$repo/issues/<n>/comments?since=$since&per_page=100` for each open PR already enumerated by the section-3 open-PR walk, emitting the same `pr-comment` TSV rows surface 1 would have (`.[] | select(.created_at >= $since) | select(.user.login != $bot)`); a failure there is a real fetch failure and must set `fetch_failed`. Verified this path works with issues disabled: `repos/kriscendobot/endo/issues/2/comments` and `repos/kriscendobot/agoric-sdk/issues/18/comments` both return `[]` (200), not 404. True-issue comments are genuinely unavailable and unreachable on such a repo — that is correct, since the repo has no issues.

3. Add regression coverage in `scripts/jobs/test/comment-watcher-test.sh` next to the existing REPO-GONE cases: a stub `gh` where `repos/<r>` returns `has_issues:false` and `repos/<r>/issues/comments` exits 1 with `gh: Not Found (HTTP 404)` must make the source exit 0 with the surviving surfaces intact (asserting the tick is NOT discarded and the cursor advances), while the same 404 with `has_issues:true` must still exit nonzero and freeze the cursor. Add one case asserting a PR-conversation comment on an issues-disabled repo is still surfaced as `pr-comment` via the per-PR fallback.

Verify after the change by running `scripts/jobs/comment-watcher.sh` once against `kriscendobot/cosgov` (0 open PRs, issues disabled: must exit 0 and post nothing) and against `kriscendobot/endo` (open PRs, issues disabled: must exit 0 and enumerate normally), then confirm `garden-comment-watcher@kriscendobot-cosgov` stops failing.

<!-- garden-reap-now -->
---
claim:
  host: endolin-garden2-5bcdff64
  gardener: 1
  worker_kind: cleric
  tier: 
  provider: openai
  model: 
  claimed_at: 2026-08-17T13:34:50Z
