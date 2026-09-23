---
ts: 2026-06-14T10:43:57Z
kind: result
role: fixer
repo: endojs/endo-but-for-bots
project: endo-but-for-bots
worktree: dispatches/fixer--9bf98b/project
refs:
  - entries/2026/06/14/095115Z-result-barrister-103358.md
---

# Fixer result: PR #440 barrister's must-fix-loop and summary-fix bundle

PR endojs/endo-but-for-bots#440 (`feat(daemon,cli,chat): drop @info name hub for formula-inspector design (#439)`), branch `feat/formula-inspector`.

Pre-fixer head: `888951a9f` (cleaner pass, the cut-3 prettier landed).
Post-fixer head: `93b399160` (three new commits).

## Per-item resolution mapping

### must-fix-loop (3)

1. `packages/daemon/src/formula-record.js:98-103` (the `case 'make-bundle':` unreachable arm) and the related `host` case at `:74-96` (read `formula.worker` against `HostFormula` that has no `.worker` field). Fix: drop the `'make-bundle'` arm; add `'make-archive'` (archive/powers/worker) and `'make-from-tree'` (tree/powers/worker) per `formulateArchive`/`formulateFromTree` at `daemon.js:4903`/`:4945`; rewrite the `host` arm to surface `handle`/`hostHandle`/`mainWorker`/`nodeWorker`/`inspector`/`petStore`/`mailboxStore`/`mailHub`/`endo`/`networks`/`pins`. Commit `ef6fb7950`.
2. `packages/cli/test/demo/inspect-formula.js:18` (the `^make-bundle {2}[0-9a-f]{128}` regex was wrong on two axes: wrong type and wrong number-length). Fix: re-derive all four assertions from the daemon's actual output (`make-archive  <64-hex>` first line, `"type": "make-archive"` in JSON, `"archive"` reference). Commit `275480ecb`.
3. `packages/chat/test/unit/formula-view-registry.test.js:13-49` + `packages/chat/formula-view-registry.js:224-229` (the `keypair` orphan canonical claim). Fix: drop `keypair` from the canonical-list test and update the registry comment to mark `keypair` as reserved for a future daemon-side type; the privacy-suppression test for `privateKey` keeps the registry-shape coverage. Also dropped `make-bundle` and added `make-archive`/`make-from-tree` to the canonical list. Commit `93b399160`.

### summary-fix (5 in the barrister's count; 7 total in the body)

4. `packages/chat/formula-view-registry.js:128-132` (the `make-bundle` registry entry). Fix: dropped along with the canonical-list adjustment. Commit `93b399160`.
5. `packages/chat/formula-view-registry.js:52` (`REGISTRY = { ... }` plain object literal). Fix: `{ __proto__: null, ... }` with `// @ts-expect-error confused by __proto__` matching the `eventual-send/src/message-breakpoints.js:108` pattern. Commit `93b399160`.
6. PR body open-question 1 ("`make-bundle` is present at line 20"). Fix: rewrote to acknowledge the researcher was right and explain what the daemon emits. PR body updated via `gh pr edit`.
7. PR body cut 3 paragraph 1 ("covering the canonical daemon formula types"). Fix: rephrased to "the canonical daemon formula types (per `packages/daemon/src/formula-type.js`) plus forward-looking types and one user-side spec (`keypair`) reserved for an anticipated daemon-side surface". PR body updated via `gh pr edit`.
8. `packages/chat/value-component.js:255-258` and `:285-298` (the `valueComponent` JSDoc did not spell out back-face mount-point optionality). Fix: added a paragraph above the param block. Commit `93b399160`.
9. `packages/chat/value-component.js:651` and `inventory-component.js:739-751` (gear icon visibility advertising an unreachable back-face action). Took option (a) per "either is fine; (a) is the cleaner surface": only render the gear when `showValueFormula` is provided; renamed the test from `gear falls back to showValue ...` to `gear is omitted when showValueFormula is not provided` and rewrote the assertions. Commit `93b399160`.

### Pre-existing CI red folded in

10. `packages/daemon/test/endo.test.js` prettier drift on the new `getFormula resolves a caplet to its worker formula` test. Fix: `corepack yarn format` reformatted in-place; folded into commit `ef6fb7950`.
11. `packages/daemon/src/formula-record.js` TypeScript errors (`host.worker` and `'make-bundle'` literal). Fix: resolved by the must-fix item 1 fix; `lint:types` clean. Commit `ef6fb7950`.

### Out-of-band finds

12. `packages/daemon/src/interfaces.js` — `HostInterface` was missing a method guard for the new `getFormula`. Every `start()` of the daemon was failing with `methods ["getFormula"] not guarded by "EndoHost"`. Fix: added `getFormula: M.call(IdShape).returns(M.promise())`. Commit `ef6fb7950`.
13. `packages/daemon/test/endo.test.js` — two `getFormula` tests called `cryptoPowers.randomHex512` (no such helper; formula and node numbers are 64 hex chars per `assertValidNumber`'s `[0-9a-f]{64}` regex, so the right helper is `randomHex256`). Fix: rewrote both call sites. Commit `ef6fb7950`.
14. `packages/daemon/test/endo.test.js` — the `getFormula resolves a caplet to its worker formula` test called `E(host).write(['counter-worker'], workerId)`. `write` is on `EndoMount`, not `EndoHost`; the host-side method is `storeIdentifier`. Fix: rewrote. Commit `ef6fb7950`.

## Test results per workspace

- `corepack yarn workspace @endo/daemon test`: 1 pre-existing failure (`git > Git.status reports merge conflicts with mount entries`, failed on unmodified `888951a9f` too), 4 pre-existing skipped, all other tests pass; all 6 `getFormula` tests pass.
- `corepack yarn workspace @endo/cli test`: 15 passed (including `demo > index > inspect-formula`).
- `corepack yarn workspace @endo/chat test`: 496 passed.
- `corepack yarn lint`: zero errors; 2174 pre-existing warnings (none in changed files added by this dispatch).
- `pre-push-gates --probes-only`: the gate fires on pre-existing repo-wide issues (filename-no-stutter, no-ascii-banners on `designs/trust-on-first-bind.md`, etc.); none of my added lines triggered a new finding once I rewrote a `§` to parenthetical English in the `formula-view-registry.js` keypair-reserved comment.

## PR body changes

Via `gh pr edit 440 -R endojs/endo-but-for-bots --body-file <path>`:
- Cut 1 type list: dropped `make-bundle`; added `make-archive` and `make-from-tree`; refined the "all 24 canonical types" framing to the actual count and the default-arm forward-compatibility contract.
- Cut 3 paragraph 1: tightened the `keypair` framing to "reserved for an anticipated daemon-side surface".
- Open-question 1: acknowledged the researcher was right; explained the daemon's emission per `formulateArchive`/`formulateFromTree`/`formulateUnconfined`.
- Compatibility considerations: rewrote the gear-icon bullet (no longer falls back; is hidden on hosts that have not adopted the cut).

## PR comment

Top-level summary at <https://github.com/endojs/endo-but-for-bots/pull/440#issuecomment-4701498636>. At-mentions @kriskowal. Names each item by SHA. Does not re-request review (per dispatch brief: justice will after panel re-run).

## Did not do (per dispatch brief)

- Did NOT mark PR ready (justice un-drafts after panel re-run).
- Did NOT re-request review.
- Did NOT touch the 5 follow-up ledger items (those revisit at merge time per `journal/projects/endo-but-for-bots/followups/endo-but-for-bots--440.md`).

## Recommended next stage

`next: justice` for the panel re-run on PR #440 (per `roles/barrister/AGENT.md` § Hand off to the justice).

Self-improvement: nothing this time. The dispatch brief was missing the per-commit suggested messages it referenced ("suggested messages in the brief"), so I devised three commit groupings from the panel report's natural clustering (daemon, cli, chat). The structural lesson would be for the orchestrator's dispatch-brief template to either include the per-commit messages or to explicitly defer them to the fixer's judgment; deferral worked fine here.
