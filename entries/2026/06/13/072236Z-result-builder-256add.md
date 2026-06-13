---
ts: 2026-06-13T07:22:36Z
kind: result
role: builder
host: endolinbot
repo: endojs/endo-but-for-bots
project: endo-but-for-bots
to: liaison
dispatch_root: /home/kris/dispatches/builder--256add
prs:
  - repo: endojs/endo-but-for-bots
    pr: 440
    role: head
    branch: feat/formula-inspector
    base: master-4a04d07
  - repo: endojs/endo-but-for-bots
    pr: 441
    role: sibling
    branch: docs/formula-inspector-status
    base: llm
  - repo: endojs/endo-but-for-bots
    pr: 439
    role: source-design
refs:
  - entries/2026/06/13/062200Z-dispatch-builder-046024.md
  - entries/2026/06/13/061802Z-result-researcher-0ddf1e.md
  - entries/2026/06/12/152200Z-result-researcher-d73da3.md
  - https://github.com/endojs/endo-but-for-bots/pull/440
  - https://github.com/endojs/endo-but-for-bots/pull/441
  - https://github.com/endojs/endo-but-for-bots/pull/439
---

# result: builder - implement merged #439 formula-inspector design (cuts 1, 2, 4; cut 3 deferred)

## Summary

Opened **PR #440** (master-base) carrying the daemon and CLI cuts of the merged formula-inspector design, and **PR #441** (llm-base) carrying the design-doc status bump.
The chat-side cut is **deferred** at impasse: the design assumes a `packages/chat/*` file layout that exists only on the `llm` roadmap branch.
On `master`, the chat package is `packages/goblin-chat` with a fundamentally different shape (no value modal, no inventory component, no DOM frontend layer).
Surfacing the gap to the maintainer rather than guessing.

The prior builder dispatch `046024` hit rate-limit after 114 tool calls.
This dispatch followed the brief's efficiency guidance: opened the DRAFT PR after cut 1 landed and pushed cuts 2-4 as appends.

## PRs

- **PR #440 (master-base)**: `feat(daemon,cli,chat): drop @info name hub for formula-inspector design (#439)`.
  Status: DRAFT.
  Three commits over `master@4a04d078b`:
  - `55d58ff4d feat(daemon): add host-only getFormula and retire @info name hub (#439)`
  - `d39aa510c feat(cli): add endo inspect verb for formula records (#439)`
  - `121e4b1e6 chore(daemon): satisfy pre-push-gates probes on the daemon cut`

  Base: frozen `master-4a04d07`.
  URL: https://github.com/endojs/endo-but-for-bots/pull/440

- **PR #441 (llm-base)**: `docs(designs): bump formula-inspector status to In Progress (#439)`.
  Status: DRAFT.
  One commit over `llm`:
  - `8cadce62d docs(designs): bump formula-inspector status to In Progress (#439)`

  Base: `llm`.
  URL: https://github.com/endojs/endo-but-for-bots/pull/441

## Per-cut detail

### Cut 1: daemon (master-base, PR #440)

Files:

- **`packages/daemon/src/formula-record.js`** (new, 213 lines): `makeFormulaRecord(formula, number)` helper.
  Classifies each property of a `Formula` into one of `{ kind: 'literal', value }`, `{ kind: 'reference', identifier }`, or `{ kind: 'reference-list', entries }`.
  Coverage spans all 24 canonical formula types in `formula-type.js` (the design's table cites types that are forward-looking and not yet in the canonical list; the helper handles unknown types via an empty-properties fallback).
- **`packages/daemon/src/host.js`** (edits): removed `INFO: inspectorId` from the host's `specialNames` map at line 119; added a `getFormula(identifier)` method on the `EndoHost` facet that calls `parseId` to reject cross-peer locators and `getFormulaForId` to read the local formula, then `makeFormulaRecord` to normalize.
  `getFormulaForId` is now passed in to `makeHostMaker` from `daemon.js`.
  `inspectorId` parameter retained (vestigial) for on-disk backward compatibility with hosts whose formulas still carry an `inspector` field.
- **`packages/daemon/src/daemon.js`** (one-line edit): pass `getFormulaForId` into `makeHostMaker`.
- **`packages/daemon/src/types.d.ts`** (edits): add `EndoHost.getFormula(identifier)` to the `EndoHost` interface; add `FormulaRecord` and `FormulaProperty` exported types.
  Retained `EndoInspector` and `KnownEndoInspectors` with `@deprecated` JSDoc (rather than deleting outright) because `pet-inspector` formulas remain on-disk-loadable.
- **`packages/daemon/test/endo.test.js`** (edits): four prior `INFO`-based tests rewritten to call `getFormula(identifier)`; three new tests added (`getFormula returns per-type formula record (eval)`, `getFormula is absent on the guest facet`, `getFormula rejects cross-peer locators`); inline `import('ava').ExecutionContext` JSDoc hoisted to the file's top-level `@import` block.
- **`.changeset/formula-inspector-getformula.md`** (new): `@endo/daemon` minor + `@endo/cli` minor.

Verification: `yarn lint` clean; `yarn ava test/endo.test.js` 72 tests pass (5 of those are the new + rewritten getFormula tests).

### Cut 2: CLI (master-base, PR #440)

Files:

- **`packages/cli/src/commands/inspect.js`** (new, 99 lines): the `inspect` command.
  Two paths: `--identifier` interprets the argument as an already-encoded formula identifier; without it, resolves via `host.identify(...parsePetNamePath(arg))`.
  Calls `E(host).getFormula(identifier)` and renders either via the human-readable `renderHuman(record)` (type+number header, one row per property; references as `name -> identifier`; reference-lists nested; literals inline or indented for multi-line strings) or via `JSON.stringify(record, null, 2)` under `--json`.
- **`packages/cli/src/endo.js`** (edits): wired the `inspect <name-or-identifier>` verb with `-i,--identifier` and `--json` flags into the commander chain alongside the existing 41 verbs.
- **`packages/cli/test/demo/inspect-formula.js`** (new): an integration test that runs `endo inspect counter` (both default and `--json` modes) against the existing `counter-example.context` (an `endo make counter.js` make-bundle formula).
- **`packages/cli/test/demo/index.test.js`** (edits): registered the new `inspect-formula` test serial.

Verification: `yarn lint` clean; `yarn ava test/demo/ --match='*inspect-formula*'` passes (the test actually exercises the daemon's new `getFormula` method through the CLI socket; observed real `make-bundle` formula output with `bundle`/`powers`/`worker` reference fields).

### Cut 3: chat (DEFERRED at impasse)

The merged design's `packages/chat/*` file layout (`value-component.js`, `inventory-component.js`, `chat.js`, `index.css`, `formula-view-component.js`, `formula-view-registry.js`) **does not exist on master**.
The chat package on master is `packages/goblin-chat`, with a fundamentally different file layout (no value modal, no inventory component, no DOM frontend).
The `packages/chat` package exists only on the `llm` roadmap branch.

Per the builder role norm "A design that lives on the roadmap branch is read, not branched-from" and "Stop at impasse and surface the discrepancy rather than building against either side", the chat cut is deferred.
The maintainer needs to decide between:

- (a) Land the `packages/chat` migration onto master first (the design's assumed shape), then a follow-up builder dispatch implements the chat cut against `master`.
- (b) Re-target the chat-side design at `packages/goblin-chat` (which would mean a significant design revision).

PR #440's body section "Design departures" surfaces this gap explicitly so the judge and the maintainer see the disposition.

### Cut 4: design-doc status bump (llm-base, PR #441)

Files:

- **`designs/formula-inspector.md`**: status bumped from `Not Started` to `In Progress`; added a `## Status` section summarizing what shipped (daemon + CLI), what's deferred (chat cut), and what's retained as vestigial infrastructure (`pet-inspector` formula type, `InspectorHubInterface`).
- **`designs/README.md`**: summary table row updated to `In Progress`; M9 milestone detail row updated with the shipping note.

Per the project's split-PR convention (designs land on `llm`, implementations land on `master`), this is a separate PR rather than additional commits on PR #440.

## Open question dispositions

1. **`make-bundle` formula taxonomy**: the prior researcher's report claimed `make-bundle` was missing from `packages/daemon/src/formula-type.js`.
   This was incorrect.
   `make-bundle` is at line 20 of `formula-type.js`.
   The canonical type set has 24 entries, not 33; the design's per-type table includes forward-looking types (`channel`, `mount`, `git`, `git-credential`, `git-remote`, `keypair`, `timer`, `make-archive`, `make-from-tree`, `scratch-mount`) that are not yet in the canonical set.
   `makeFormulaRecord` handles unknown formula types via an empty-properties fallback rather than throwing.
   `make-bundle` is fully honored in the per-type record (`bundle`, `powers`, `worker` references).
2. **`Shift+P` modeline hint**: belongs in the chat cut.
   Deferred along with the chat cut; flagged as a follow-up for the `chat-command-bar.md` design.
   The builder does not author changes to `chat-command-bar.md`; that is a separate design's territory.
3. **Card-flip animation register**: belongs in the chat cut.
   Deferred along with the chat cut.
   Initial implementation will be inline CSS variables per the design.
   No chat-wide animation register exists yet; promotion of the variables into a register is a follow-up.
4. **`inspectorId` allocation chain (dead code post-`@info` removal)**: retained for on-disk backward compatibility.
   Existing host formulas have an `inspector: <pet-inspector-id>` field.
   New host formulas continue to allocate and write the field via `formulateNumberedPetInspector`.
   The `pet-inspector` formula type, its loader, and `makePetStoreInspector` are kept as vestigial infrastructure that no external surface reaches.
   Full removal of `InspectorHubInterface`, `InspectorInterface`, and the `pet-inspector` formula type is a follow-up that requires on-disk data migration; deferred to keep this PR focused on the surface contract change.

## File-by-file change summary

```
.changeset/formula-inspector-getformula.md            new (changeset: @endo/daemon minor, @endo/cli minor)
packages/daemon/src/formula-record.js                 new (213 lines, per-type record helper)
packages/daemon/src/host.js                           edit (drop INFO; add getFormula method; getFormulaForId dependency)
packages/daemon/src/daemon.js                         edit (pass getFormulaForId into makeHostMaker)
packages/daemon/src/types.d.ts                        edit (add getFormula to EndoHost; export FormulaRecord, FormulaProperty)
packages/daemon/test/endo.test.js                     edit (4 INFO tests rewritten + 3 new tests + import hoist)
packages/cli/src/commands/inspect.js                  new (99 lines, inspect command)
packages/cli/src/endo.js                              edit (register inspect verb)
packages/cli/test/demo/inspect-formula.js             new (integration test)
packages/cli/test/demo/index.test.js                  edit (register new test)
designs/formula-inspector.md                          edit (status In Progress + Status section, on llm)
designs/README.md                                     edit (summary table + milestone row, on llm)
```

## Test results

- `cd packages/daemon && yarn lint`: clean.
- `cd packages/daemon && yarn ava test/endo.test.js --timeout=180s`: 72 tests passed (including the 5 new + rewritten getFormula tests).
- `cd packages/cli && yarn lint`: clean.
- `cd packages/cli && yarn ava test/demo/ --match='*inspect-formula*'`: 1 test passed.
- Cross-package full-suite run not attempted in this dispatch (scope is the changed packages); cleaner and judge will surface any wider regressions.

## pre-push-gates result

PR #440 head (`121e4b1e6`) passes the gate:

```
yarn format            pass (auto-fixed 3 paths; re-staged)
yarn lint --fix        pass (auto-fixed 3 paths; re-staged)
probes:
  filename-no-stutter            pass
  no-ascii-banners               pass
  no-inline-import-jsdoc         pass
  no-non-ascii-in-source         pass
  no-pull-citations              pass
  security-md-hash-uniform       pass
  sentence-per-line-md           pass
  test-package-no-main           pass
yarn typecheck         skip (no typecheck script)
```

Two findings were addressed before the final push: non-ASCII section markers (`U+00A7`) in the new comments rewritten as plain ASCII; pre-existing inline `import('ava')` JSDoc hoisted to the file's top-level `@import` block.

## Recommended next stage

`next: cleaner` to start the gamut on PR #440.
PR #441 (llm-base, design-doc-only) can sit until the maintainer reviews the daemon and CLI cuts; if the maintainer accepts the deferral of the chat cut, PR #441 can ferry behind PR #440.

Self-improvement: noted that the dispatch brief's reported line numbers in the design (e.g., `interfaces.js:256-454`, `daemon.js:5704-5829`) were stale (the actual file sizes are much smaller).
A future researcher dispatch should verify line numbers against the project's HEAD before citing them; the current researcher writeups treat line numbers as load-bearing but they decay quickly.
Lesson is local to the researcher role's *Line-anchor freshness* discipline; not enough to warrant a structural change to the role file at this time.
