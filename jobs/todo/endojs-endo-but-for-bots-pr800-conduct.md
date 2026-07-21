<!-- garden-promoted-from-plan: gate=orchestrated priority=normal at=2026-07-21T03:16:03Z -->

# Finalize (curate → merge) endojs/endo-but-for-bots PR #800

A trusted maintainer APPROVED this PR and it was OPEN, mergeable, and green
when the stack collapse began. It was then auto-closed by GitHub when the
PR #799 conductor deleted its base branch (`base_ref_deleted`); the press
driver reopened it, retargeted it to `llm`, and merged current `llm` into
its head (`f45ef36aa`) to clear the zizmor stale-pin failure. This is the
CURATION step: dispatch the **conductor** to wait for checks green and
merge. Do NOT name a merge method — the conductor owns that choice
(roles/conductor/AGENT.md).

Guards (re-verify before merging):
  - Bot repo only (endojs/endo-but-for-bots). NEVER merge agoric-sdk or the
    endojs/endo upstream — those are the maintainer's / boatman's call.
  - The PR must be OPEN, mergeable, and checks green on the current head.
    If it has regressed (conflicts, red CI), dispatch the shepherd/fixer
    instead of forcing the merge.
  - Idempotent: if the PR is already merging/merged/closed, do nothing.
  - Head `f45ef36aa` = approved `f6618b3803` + the separately
    approved-and-merged PR #801 + a clean merge of `origin/llm`
    (docs + workflow-pin repin only). Context:
    https://github.com/endojs/endo-but-for-bots/pull/800#issuecomment-5029759008
  - IMPORTANT: open PR #802's base is `reland/endor-run-exec-hardening`, an
    ancestor of this PR's head — do NOT delete that branch here. Deleting
    `feat/endor-npm-run` after merge is safe (no open PR uses it as base).

Source: press tick endo-npm-cas-registry-press-20260721-030507
Approval: https://github.com/endojs/endo-but-for-bots/pull/800#pullrequestreview-4740263926
