---
ts: 2026-06-03T20:14:20Z
kind: dispatch
role: liaison
host: endolinbot
repo: endojs/endo-but-for-bots
project: endo-but-for-bots
to: fixer
dispatch_root: /home/kris/dispatches/fixer--0b44dc
prs:
  - repo: endojs/endo-but-for-bots
    pr: 400
    role: target
refs:
  - https://github.com/endojs/endo-but-for-bots/pull/400
  - https://github.com/endojs/endo-but-for-bots/pull/400#pullrequestreview-4415515901
---

# dispatch: fixer — #400 milestone renumbering per kriskowal review 4415515901

User explicit correction:

> This seems to have been missed. Please dispatch a fixer.
> https://github.com/endojs/endo-but-for-bots/pull/400#pullrequestreview-4415515901

Steward had earlier misclassified this as "contractor scope"
because the contractor opened #400. Per `roles/steward/AGENT.md`
§ Subordinate roles: a maintainer roadmap-edit directive
surfaces a groom (or fixer) dispatch — the contractor and
steward are peers, not parent/child.

## Target

- PR: endojs/endo-but-for-bots#400
- Title: `groom: rebucket roadmap for shortest-route MCP-bridge gateway`
- Branch: `groom/mcp-bridge-rebucket`
- Head: `0289d3759`
- Base: `llm`
- State: DRAFT.

## Maintainer directive (review `4415515901`, body)

> Please resequence milestones starting with the number 1 and
> incrementing by whole numbers. The milestones will be approached
> sequentially. Milestone 0 and half are complete and should be
> renumbered 1 and 2. Milestones A and B will need to be assigned
> numbers. Dependencies of designs in one milestone should not
> appear in a later milestone. Satisfying this criterion may
> require finer grained buckets. Again, we are prioritizing work
> that leads to a hosted Gateway service and work that is not
> entrained by that north star can be deferred to later
> milestones.

Concrete asks:

1. Start milestone numbering at 1, integer-increment only.
2. Rename "Milestone 0" → "Milestone 1" and "Milestone half" →
   "Milestone 2" (both complete; preserve completion status).
3. Assign integer numbers to "Milestone A" and "Milestone B".
4. Enforce dependency ordering: no later milestone should be a
   dependency of an earlier one. Finer-grained buckets are OK
   if needed for ordering.
5. Hosted-Gateway-service north star: work NOT entrained by
   that north star defers to LATER milestones.

## Procedure

1. Read the current roadmap file (likely `designs/README.md` on
   the bot fork; verify in the worktree).
2. Read the design files referenced by each milestone to
   compute the dependency DAG.
3. Renumber per the directive: 1 (complete) → 2 (complete) →
   3 (was A) → 4 (was B) → … keeping the dependency-respecting
   order. Use finer buckets if a single number can't satisfy
   dependency ordering.
4. Prioritize milestones entrained by the hosted Gateway
   service; defer un-entrained work to later milestones.
5. Commit one or more regular-append commits + push to
   `groom/mcp-bridge-rebucket`.
6. Post a top-level PR comment on #400 summarizing the new
   numbering scheme and the rationale (especially: which
   milestones are gateway-entrained vs deferred).

## Per-action authorizations

- Read the roadmap file + referenced design docs. Authorized.
- Edit the roadmap file. Authorized.
- One or more regular-append commits + push to
  `endojs/endo-but-for-bots:groom/mcp-bridge-rebucket`.
  Authorized.
- Top-level PR comment on #400. Authorized.

## Not authorized

- Editing files outside the roadmap file (no design-doc
  rewrites in this dispatch; those would surface as separate
  follow-ups).
- Force-pushing.
- Un-drafting / merging.

## Dispatch protocol

Read in order:

1. `/home/kris/dispatches/fixer--0b44dc/garden/roles/COMMON.md`
2. `/home/kris/dispatches/fixer--0b44dc/garden/roles/fixer/AGENT.md`
3. `garden/skills/pr-review-thread-replies/SKILL.md` if you
   need to inline-reply (the review is body-only so a top-level
   comment likely suffices).

Project worktree at `project/` on `groom/mcp-bridge-rebucket`
(head `0289d3759`).

## Report

A `result` journal entry. Include:

- Old → new milestone numbering map.
- Dependency DAG note (or summary).
- Which milestones are gateway-entrained vs deferred.
- New head SHA + commit message(s).
- Top-level PR comment ID.
- Any judgment calls.
