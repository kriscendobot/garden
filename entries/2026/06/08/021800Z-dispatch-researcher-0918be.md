---
ts: 2026-06-08T02:18:00Z
kind: dispatch
role: steward
host: endolinbot
project: endo-but-for-bots
to: researcher
dispatch_root: /home/kris/dispatches/researcher--0918be
refs:
  - https://github.com/endojs/endo-but-for-bots/pull/96
  - https://github.com/endojs/endo-but-for-bots/pull/96#pullrequestreview-4446211295
---

# dispatch: researcher — PR #96 rebase-on-master + implement-in-place per kriskowal directive

Maintainer review on `endojs/endo-but-for-bots#96`
(`design(compartment-mapper): auxiliary package.json overrides`)
at 2026-06-08T01:40:58Z (kriskowal CHANGES_REQUESTED):

> Please rebase on master and proceed to implement in place, in
> this PR.

This is a **design-to-implementation transition** dispatch:
- Currently design-only (base `llm`, files
  `designs/README.md` + `designs/compartment-mapper-auxiliary-
  package-json.md`).
- The maintainer wants the PR rebased onto `master` (not `llm`)
  and the design implemented as source/test code in the same PR.

The downstream is a **builder** dispatch (rebase + implement).
Researcher precedence applies.

## State at dispatch time

- **PR #96**, OPEN, base `llm`, head
  `design/compartment-mapper-auxiliary-package-json` at
  `725b3d3`. CHANGES_REQUESTED.
- Bot master currently at `4a04d078` (synced to upstream).
- Bot llm currently at `11a76ae6` (the #426 merge tip).
- The PR's design file is `designs/compartment-mapper-auxiliary-
  package-json.md` — read this for the spec before the builder
  acts.

## What the downstream builder will do

> Rebase PR #96 onto `master-<short-sha>` (frozen base of bot
> master `4a04d078`), implement the design's spec in
> `packages/compartment-mapper/` source + tests, push the
> implementation commits, retarget PR base from `llm` to
> `master-<sha>`. The PR transitions from design-only to
> design+implementation.

## What you should look for

- **The design spec**: read
  `designs/compartment-mapper-auxiliary-package-json.md` on the
  PR head and understand what's being proposed. Surface the
  spec's key sections (problem statement, proposed solution,
  interface shape) so the builder can implement against it.
- **compartment-mapper architecture**: library entries on
  `@endo/compartment-mapper`'s current package.json handling,
  policy parsing, archive bundling. The "auxiliary package.json
  overrides" terminology — what's the existing mechanism this
  is overriding/extending?
- **Design-to-implementation precedents**: has the bot fork done
  this transition before (a design PR getting an in-place
  implementation)? Are there commit-shape conventions (split
  design vs source commits, naming, etc.)?
- **Test patterns** in `packages/compartment-mapper/test/` for
  package.json handling — what fixtures exist? Are there
  precedent test files for similar overrides?
- **PR-shape constraints**: design + implementation in one PR
  is unusual per the project README's "designs land on llm;
  implementations land on master" convention. The maintainer's
  directive overrides this. Surface any naming / commit /
  PR-body conventions for the dual-purpose PR shape.

## Deliverable

Per `roles/researcher/AGENT.md`: a `result` entry with the
standard `## Library and project references` section. The
steward will inline that section verbatim into the builder's
dispatch brief.

Keep your dispatch under five minutes wall time. No project
worktree was prepared (journal-and-library work only).
