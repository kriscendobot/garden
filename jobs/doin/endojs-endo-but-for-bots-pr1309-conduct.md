---
role: conductor
tier: mentor
fallback-tier: minion
dispatch: automatic
---

# Finalize (curate → merge) endojs/endo-but-for-bots PR #1309

A trusted maintainer (kriskowal) APPROVED this PR (review 5271637936, an
approval bundled with asks). All review asks have been resolved:

  - Inline feedback on `packages/daemon/src/shutdown-signals.js` ("make this
    configurable and less frequent by default") is resolved at head `76012c0e`:
    the orphan watch is now the `orphanCheckMs` option / `ENDO_ORPHAN_CHECK_MS`
    env var, default 5000ms (was 1000ms). Threaded reply posted
    (comment 4067539158).
  - The **retcon** ask is satisfied: the branch is already in canonical retcon
    shape — a single `fix(daemon): …` commit scoped to `packages/daemon`,
    implementation and tests bundled, conventional-commit message, no
    dependency change so no `yarn.lock` delta. No force-push (byte-identical
    tree; reproducing would only reset CI).
  - The review body was responded to (top-level comment issuecomment-5769506233).

This is the CURATION step: un-draft (the PR is already non-draft) and merge. Do
NOT name a merge method — the conductor owns that choice (roles/conductor/AGENT.md).

Guards (re-verify before merging):
  - Bot repo only (endojs/endo-but-for-bots). NEVER merge agoric-sdk or the
    endojs/endo upstream.
  - The PR must be OPEN, mergeable, and checks green. As of dispatch the
    `test (…)` matrix jobs were still in progress — wait for green. If it has
    regressed (conflicts, red CI), dispatch the shepherd/fixer instead of
    forcing the merge.
  - Idempotent: if the PR is already merging/merged/closed, do nothing.

Source: pr-review-body by kriskowal
Approval: https://github.com/endojs/endo-but-for-bots/pull/1309#pullrequestreview-5271637936

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 3
  worker_kind: cleric
  tier: 
  provider: openai
  model: 
  claimed_at: 2026-09-22T00:36:51Z
