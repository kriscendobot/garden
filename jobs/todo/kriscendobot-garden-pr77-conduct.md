---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
# Conduct kriscendobot/garden PR #77 onto journal2

Maintainer kriskowal APPROVED PR #77 (reviewDecision=APPROVED,
review 5098520612) with the single directive: **"conduct onto `journal2`"**.
This is the finalization/curation step: land the campaign artifacts on the
live `journal2` board branch (merge = arming the minion.town eval campaign).

- Repo: `kriscendobot/garden` (the garden's OWN repo, bot-owned — merging is
  authorized here. This is NOT agoric-sdk or endojs/endo; no ferry.)
- PR: https://github.com/kriscendobot/garden/pull/77
- Head branch: `campaign/minion-town-eval`
- Current base: `journal2-44e1227` (a FROZEN snapshot of journal2 cut at
  PR-open, per skills/frozen-base-branch).
- Live trunk to land on: `journal2`.
- State at hand-off: OPEN, not draft, mergeable CLEAN, no CI configured on
  the garden repo (`gh pr checks` reports none — do not block on CI here).
- reviewDecision APPROVED by kriskowal (a maintainers/allowlist login).
- Only PR #77 uses `journal2-44e1227` as its base (verified) — so the
  frozen branch is safe to delete after merge.

## IMPORTANT — the automated spine will NOT unfreeze this base

`scripts/jobs/gardening/ci-wait-merge.sh`'s `unfreeze_base_if_frozen` only
recognizes `^(llm|main|master)-[0-9a-f]{4,40}$`. A `journal2-<sha>` base does
NOT match, so the spine would treat it as already-live and merge PR #77
directly onto the frozen `journal2-44e1227` snapshot — leaving the live
`journal2` board WITHOUT the campaign artifacts. Do **not** rely on the
automatic unfreeze; **hand-drive** the unfreeze per the conductor brief
("If you drive the states by hand instead"):

1. Repoint the PR base to live journal2:
   `gh pr edit 77 -R kriscendobot/garden --base journal2`
2. Rebase `campaign/minion-town-eval` onto freshly-fetched `origin/journal2`.
   The diff is adds-only under `jobs/plan/` and `jobs/orch/` (new filenames),
   so the rebase over the moving journal is expected conflict-free
   (safe-rebase discipline; if a real code/mixed conflict appears, stall
   `needs weave`, do not resolve on discretion).
3. Merge as a merge commit (`gh pr merge 77 --merge`) so the campaign commit
   lands as a discrete, unit-revertible cluster on journal2.
4. Post-merge frozen-base sweep: delete the `journal2-44e1227` branch in the
   fork (no other open PR uses it as base).

## Approval / rebase-staleness note

Ordinarily a rebase invalidates a maintainer's approval signature (the
reviewed head SHA changes). Here the rebase is a pure mechanical replay of
adds-only new files over an advanced orphan board branch — no reviewed
content changes — and kriskowal's directive "conduct onto `journal2`"
explicitly authorizes landing exactly these artifacts on the live journal
(the PR body's "What merging does (merge = arming)" section spells out this
unfreeze+rebase+merge path as the intended mechanic). Treat the approval as
covering the rebased head; do NOT stall for a re-approval on a no-content
adds-only rebase. If the rebase surfaces any real conflict (content actually
changed), THEN stop and surface it.

## Why this matters

Merging arms the campaign: the leader's `garden-orchestrate` timer (~3 min)
promotes the first child and the run begins. There is no second confirmation
step — the maintainer's approval IS the go signal.
