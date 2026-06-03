---
ts: 2026-06-03T00:12:53Z
kind: result
role: builder
worktree: dispatches/builder--10f81a/project
repo: endojs/endo-but-for-bots
project: endo-but-for-bots
---

Built `designs/inventory-grouping-by-type.md` against `endojs/endo-but-for-bots:llm`.
Opened PR #405 (DRAFT, base `llm-c85d618`, head `feat/inventory-grouping-by-type`):
https://github.com/endojs/endo-but-for-bots/pull/405

Three commits on the head branch:

1. `feat(daemon): include formula type in followNameChanges add events`
   - `enrichWithType` wrapper on `makeDirectoryNode.followNameChanges`
     yields. Plumbs the daemon's existing `getTypeForId` through every
     directory-shaped follower so consumers see `{ add, value, type }`
     instead of `{ add, value }`.
   - 4 new tests in `packages/daemon/test/endo.test.js` covering
     `storeValue` → `marshal`, `provideWorker` → `worker`, existing-name
     batch including `@self` → `handle`, and `remove` events not carrying
     `type`. All 10 followNameChanges tests pass; regression-evidence
     established by sabotaging `enrichWithType` to short-circuit and
     observing the 3 type-asserting tests fail closed.

2. `feat(chat): group inventory items by formula type`
   - Four collapsible group sections at the top of the inventory:
     Handles, Hubs, Workers, Everything Else, with item counts and
     unicode-glyph icons (silhouette / folder / gear / circle).
   - Per-item type badge chip showing the formula type next to the
     pet name. Reads from `change.type` when daemon supplies it,
     falls back to `locate()`-derived type otherwise.
   - Channel mode and nested expansions remain flat. The existing
     show-special toggle propagates through group bodies via
     descendant selectors.

3. `feat(cli): add --grouped and --type flags to endo list`
   - `endo list -g` buckets output by the same four groups.
   - `endo list -t <type>` filters to a single formula type.
   - `--follow` tags each `+name` line with its type when the
     daemon's change event carries one.

Changeset bumps `@endo/daemon`, `@endo/chat`, `@endo/cli` minor.

Coordination with the prompt's named carry-forwards:
- PR #131 (drag-and-drop, cancel, **type badges**): #131 already
  lands a type badge derived from the locator URL. This PR adds
  its own badge using the new daemon `type` field plus a `locate()`
  fallback. The two PRs touch overlapping lines in
  `inventory-component.js` and `index.css`; whichever lands second
  will need a small CSS reconciliation (the badge selectors differ
  slightly). The PR body calls this out.
- PR #404 (`design(chat): inventory + create menu and new-agent
  wizard`): named in PR body as the companion design whose UI
  lives alongside the grouping built here.

CLI flag: included (`--grouped` and `--type`); both options route
through the same locate-based type resolution and use the existing
context/printer scaffolding, so the change was trivial-extension
shape rather than a refactor. No deferral to a follow-up.

Pre-push gate: ran with `--probes-only --summary`. All my-diff
probes pass. Two unrelated findings (pre-existing inline
`import()` JSDoc tags in files my diff touched, and a long-standing
absent `packages/endo/SECURITY.md`) are over-flagged by the probe
scoping rules and are not from this diff. `yarn format` and
`yarn eslint` clean on the changed files.

Refs:
  - design: `project/designs/inventory-grouping-by-type.md`
  - PR: endojs/endo-but-for-bots#405
  - dispatch root: /home/kris/dispatches/builder--10f81a

Self-improvement: nothing this time. The dispatch's reading list,
the pre-existing `getTypeForId` seam in the daemon, and the
already-shaped `IdRecord`-bearing change event in pet-store all
made this an additive change end-to-end. The skill files (builder,
pre-push-gates, frozen-base-branch, changeset-discipline) covered
the procedural decisions without ambiguity.
