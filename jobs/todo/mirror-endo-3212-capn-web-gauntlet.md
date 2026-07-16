---
role: builder
---
# Mirror upstream endojs/endo#3212 (Cap'n Web RPC package) onto a frozen master base, then run the gauntlet

Not yet started. Upstream **endojs/endo#3212** — "feat(capn-web): new package implementing Cap'n Web
RPC" (OPEN, draft, base `master`, head `claude/capn-web-implementation-a2eW5`) — should be mirrored
into `endojs/endo-but-for-bots` **based on `master`** (a frozen `master-<sha>` anchor) and taken
through the full gauntlet.

## 1. Mirror (based on master)
- This is a **mirror**, NOT a from-scratch build: bring upstream #3212's content into the fork
  **faithfully** — do not re-derive the package. Fetch #3212's head
  (`claude/capn-web-implementation-a2eW5`).
- Base on **`master`** via a frozen anchor (`skills/frozen-base-branch/SKILL.md`): snapshot current
  upstream `master` as `master-<7-char-sha>`, push it to the fork, place #3212's content on a fork
  head branch rebased onto that anchor, and open a **DRAFT** fork PR whose `base` is the frozen
  anchor. Do NOT target the moving `master` or recreate the mutable `master` (anchor branch only).
  Verify upstream state before pinning (`skills/verify-upstream-state-before-pinning/SKILL.md`).
- PR body: state it mirrors upstream `endojs/endo#3212`, link it, and name the frozen-base sha.

## 2. Run the gauntlet
- Run the full PR-creation chain on the new fork PR — **clean -> panel review -> fix-loop ->
  un-draft** (`skills/pr-creation-flow/SKILL.md`) — driving it to a review-ready, un-drafted state,
  or surfacing a blocker if the panel / fix-loop cannot converge.

## Skills
`skills/frozen-base-branch/SKILL.md`, `skills/verify-upstream-state-before-pinning/SKILL.md`,
`skills/pr-creation-flow/SKILL.md`.

## Done
A fork PR on `endojs/endo-but-for-bots` mirroring upstream `endojs/endo#3212`, based on a frozen
`master-<sha>` anchor, taken through the gauntlet (cleaned, panel-reviewed, fix-looped, un-drafted).
The `tada` report links #3212 and the new fork PR, names the frozen-base sha, and summarizes the
gauntlet outcome.
