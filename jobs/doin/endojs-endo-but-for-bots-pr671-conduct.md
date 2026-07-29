---
role: conductor
---

# Finalize (curate → merge) endojs/endo-but-for-bots PR #671

A trusted maintainer APPROVED this PR and a shepherd confirmed it is OPEN,
mergeable, and checks green. This is the CURATION step: dispatch the
**conductor** to un-draft (if the PR is still draft) and merge. Do NOT name
a merge method — the conductor owns that choice (roles/conductor/AGENT.md).

Guards (the shepherd already enforced these; re-verify before merging):
  - Bot repo only (endojs/endo-but-for-bots). NEVER merge agoric-sdk or the
    endojs/endo upstream — those are the maintainer's / boatman's call.
  - The PR must still be OPEN, mergeable, and checks green. If it has
    regressed (conflicts, red CI), dispatch the shepherd/fixer instead of
    forcing the merge.
  - Idempotent: if the PR is already merging/merged/closed, do nothing.

Source: pr-review-body by kriskowal
Approval: https://github.com/endojs/endo-but-for-bots/pull/671#pullrequestreview-4803447943

## Why this job was minted by hand

The comment-watcher's APPROVAL -> finalization path fell back to a shepherd
instead of minting this conductor, because the DEPLOYED copy of
`scripts/jobs/handlers/pr-maintainer-approval-gh.sh` on the leader host still
blocks whenever GitHub's `reviewDecision` rollup is empty. `endojs/endo-but-for-bots`'s
default branch `llm` carries a `pull_request` ruleset with
`required_approving_review_count: 0`, so GitHub reports `reviewDecision: ""` for
every `llm`-based PR, and the stale gate false-negatives on all of them. The fix
is already on `main2` (`c510ec1b4f`, 2026-07-29T00:24:54Z) and is pending deploy;
its unit test pins the empty-rollup case. That approval's watcher cursor has
already slid, so nothing re-mints the conductor for #671 — hence this hand post.

Evidence gathered 2026-07-29T02:30Z (all re-verifiable):
  - head `7e2bc0b9e510b2de1f8e7c1d74b4e7d417368cef`, state OPEN, not draft,
    base `llm`, `mergeable: MERGEABLE`, `mergeStateStatus: CLEAN`.
  - 24/24 check-runs on that head conclude `success`; no failing, queued, or
    in-progress check.
  - kriskowal's APPROVED review 4803447943 carries
    `commit_id == 7e2bc0b9e510b2de1f8e7c1d74b4e7d417368cef` (the current head),
    so the approval is not stale.
  - `scripts/jobs/handlers/pr-mergeable-gh.sh endojs/endo-but-for-bots 671` run
    from a `main2` checkout (with the deployed fix) exits 0.

---
claim:
  host: endolin-garden2-5bcdff64
  gardener: 8
  worker_kind: gardener
  claimed_at: 2026-07-29T02:32:13Z
