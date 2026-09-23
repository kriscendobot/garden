---
ts: 2026-06-14T09:51:15Z
kind: result
role: barrister
repo: endojs/endo-but-for-bots
project: endo-but-for-bots
refs:
  - entries/2026/06/14/094300Z-dispatch-barrister-103358.md
---

# Barrister result: PR #440 first-round code-panel verdict on the full cuts 1+2+3

PR endojs/endo-but-for-bots#440 (`feat(daemon,cli,chat): drop @info name hub for formula-inspector design (#439)`), branch `feat/formula-inspector`, head `888951a9f` (cleaner pass), base `llm` (the maintainer's 2026-06-14T07:54Z rebase directive). 12 commits from base.

This is the **first** barrister round on the full PR. A prior chain (barrister 7d1e on cuts 1+2 against frozen `master-4a04d07`; justice f73e re-run; fixer summary-fix bundle) ran before the rebase and cut-3 addition; that chain is implicitly superseded.

## Pre-dispatch state probe

`gh pr view 440 -R endojs/endo-but-for-bots --json state,isDraft,mergedAt` returned `state=OPEN, isDraft=true, mergedAt=null`. Proceeded.

## Panel-hints output (verbatim)

```
Panel-kind: code-panel
Always-on core (9): assessor, typist, stylist, packager, archivist, prover, saboteur, integrator, corner-prober
Always-fire (2): scribe, releaser
Path-triggered (5): breaker, changeset-auditor, curator, fast-checker, migrator
Content-triggered (5): engine-realist, locksmith, purist, spec-keeper, warden
Cross-panel (0): -
Suppressed (7): benchmarker, gateway, pruner, surfacer, wire-watcher, copyeditor, pedant
Recommended total: 21 of 26 code-panel seats.
```

## Panel composition (23 seats)

- Always-on core: assessor, typist, stylist, packager, archivist, prover, saboteur, integrator, corner-prober (9).
- Always-fire: scribe, releaser (2).
- Path-triggered: breaker, changeset-auditor, curator, fast-checker, migrator (5).
- Content-triggered: engine-realist, locksmith, purist, spec-keeper, warden (5).
- **Override (additions)**: copyeditor, pedant (2 cross-panel design seats), per dispatch-brief authorization ("PR has substantial markdown in the body" — 89-line PR body).
- **Override (subtractions)**: none.

Panel execution: **in-band-fallback** (no `Agent` tool surfaced in this dispatch; `ToolSearch` for `select:Agent` returned no match). Each seat composed as a per-seat block against the seat's role file under `roles/jurors/<seat>/AGENT.md`, aggregated after every block landed.

Panel kind: **code-panel** (cross-panel addition of copyeditor + pedant).

## Disposition counts

| Disposition | Count |
| --- | --- |
| must-fix-loop | 3 |
| summary-fix | 5 |
| follow-up | 5 |
| acknowledge | 4 |
| drop | 2 |
| **Total findings** | **19** |

### must-fix-loop items (3)

1. `packages/daemon/src/formula-record.js:98-103` — `case 'make-bundle':` is unreachable; `'make-bundle'` is not in `packages/daemon/src/formula-type.js`. The daemon emits `'make-archive'` (`daemon.js:4903` via `formulateArchive`), `'make-from-tree'` (`daemon.js:4945`), and `'make-unconfined'` (`daemon.js:4859`). Drop the `'make-bundle'` case; add `'make-archive'` (archive, powers, worker) and `'make-from-tree'` (tree, powers, worker) cases.
2. `packages/cli/test/demo/inspect-formula.js:18` — `stdout: /^make-bundle {2}[0-9a-f]{128}\n/u` will fail. `endo make counter.js` produces a `make-archive` formula. Re-derive every regex in this file from one end-to-end manual run of `endo inspect counter --json` against the actual daemon.
3. `packages/chat/test/unit/formula-view-registry.test.js:13-49` + `packages/chat/formula-view-registry.js:224-229` — `'keypair'` is not a formula type (no `type: 'keypair'` site anywhere in `packages/daemon/src/`, absent from `formula-type.js`). The unit test's `canonical` array falsely asserts `'keypair'` is canonical. Either drop `'keypair'` from registry + test, or keep the spec but mark it reserved-for-future-type with an inline comment and remove from the canonical-coverage assertion. Privacy-suppression test for `privateKey` keeps its value as a registry-shape test.

### Dropped findings (2, with rationale)

1. Saboteur flag on `formula-view-component.js` `JSON.stringify` cyclic-structure risk: already guarded by try/catch (line 41-43) with `'(unrenderable)'` fallback.
2. Breaker flag on `makeFormulaRecord` missing `harden()`: line 236 returns `harden({ type, number, properties })`.

## Post-aggregation actions

- **Formal review submitted** as `gh pr review 440 -R endojs/endo-but-for-bots --comment` (the `--request-changes` fallback per `skills/panel-review/SKILL.md` § Pitfalls: PR author = reviewing identity = `kriscendobot`, so GitHub blocks `--request-changes`; the verdict heading "must-fix-loop (3)" carries the disposition in the body).
  Review URL: <https://github.com/endojs/endo-but-for-bots/pull/440#pullrequestreview-4492739829>.
- **`@copilot` reviewer added** via `gh pr edit 440 -R endojs/endo-but-for-bots --add-reviewer @copilot` (fire-and-forget, idempotent on re-rounds).
- **Followup ledger appended**: `projects/endo-but-for-bots/followups/endo-but-for-bots--440.md` (new file; 5 parked items per the disposition rubric).
- **summary-fix job NOT posted** (loop did not terminate; barrister AGENT.md *Post-loop actions* posts summary-fix only on terminating first round). The 5 summary-fix items remain in the formal review body; the justice's re-run after the fixer addresses must-fix-loop will pick them up at termination.
- **Did NOT un-draft** (loop continues with must-fix-loop items).
- **Did NOT push to project** (per dispatch brief).
- **Proposed-rule message to gardener**: none (every finding traces to an existing rule).

## CI state at the time of review

`lint` and `test` jobs red on the same surface the cleaner reported:
- `lint`: prettier drift on `packages/daemon/test/endo.test.js`.
- `test`: TypeScript errors in `packages/daemon/src/formula-record.js` (`HostFormula` `.worker` absent on the `make-bundle` case, `'make-bundle'` literal mismatch).

The TypeScript red is the same defect as must-fix-loop item 1 (the unreachable `'make-bundle'` case). The fixer's retcon resolving the must-fix items should fold in the prettier fix on `endo.test.js` so the next round (justice) lands with green CI.

## Recommended next stage

**fix #440**. Orchestrator dispatches a fixer with the 3 must-fix-loop items inline (and the 2 pre-existing CI-red items in the same retcon for atomicity). After the fixer's `result`, the orchestrator dispatches the **justice** (not the barrister) for the panel re-run per `roles/barrister/AGENT.md` § Hand off to the justice.

Self-improvement: nothing this time.
