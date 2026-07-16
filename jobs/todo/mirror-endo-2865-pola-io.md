---
role: weaver
---
# Mirror upstream endojs/endo#2865 (pola-io package) onto a frozen master base

Not yet started (no fork mirror; `packages/pola-io` absent on fork `llm` and `master`). Mirror
upstream **endojs/endo#2865** — "feat(pola-io): least-authority file, net, cmd access" (OPEN, draft,
base `master`, head `dc-pola-io`), a new `packages/pola-io/` package — into `endojs/endo-but-for-bots`.

## Task — plain mirror, based on master
- Faithfully bring #2865's content into the fork (do NOT re-derive the package). Fetch #2865's head
  `dc-pola-io`.
- Base on **`master`** via a frozen anchor (`skills/frozen-base-branch/SKILL.md`): snapshot current
  upstream `master` as `master-<7-char-sha>`, push it to the fork, place #2865's content on a fork
  head branch rebased onto that anchor, and open a **DRAFT** fork PR whose `base` is the frozen anchor.
  Do NOT target the moving `master` or recreate the mutable `master` (anchor branch only). Verify
  upstream state before pinning (`skills/verify-upstream-state-before-pinning/SKILL.md`).
- PR body: state it mirrors upstream `endojs/endo#2865`, link it, name the frozen-base sha.
- This is a **plain mirror**: leave it DRAFT; do NOT run the gauntlet (none was requested).

## Skills
`skills/frozen-base-branch/SKILL.md`, `skills/verify-upstream-state-before-pinning/SKILL.md`.

## Done
A DRAFT fork PR on `endojs/endo-but-for-bots` mirroring upstream `endojs/endo#2865`, based on a
frozen `master-<sha>` anchor. The `tada` report links #2865 and the new fork PR and names the
frozen-base sha.
