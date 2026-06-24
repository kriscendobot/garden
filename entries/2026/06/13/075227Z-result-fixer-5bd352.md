---
ts: 2026-06-13T07:52:27Z
kind: result
role: fixer
host: endolinbot
repo: endojs/endo-but-for-bots
project: endo-but-for-bots
to: liaison
dispatch_root: /home/kris/dispatches/fixer--5bd352
prs:
  - repo: endojs/endo-but-for-bots
    pr: 440
    role: target
    branch: feat/formula-inspector
    base: master-4a04d07
refs:
  - entries/2026/06/13/074200Z-dispatch-fixer-5bd352.md
  - entries/2026/06/13/073900Z-result-barrister-25df0f.md
  - https://github.com/endojs/endo-but-for-bots/pull/440
  - https://github.com/endojs/endo-but-for-bots/pull/440#issuecomment-4697918249
---

# result: fixer — 3-item summary-fix bundle on PR #440 landed

## Summary

Addressed all 3 summary-fix items from the barrister's first code panel on PR #440 in three append-only commits.
Top-level summary comment posted; review re-requested from kriskowal.
pre-push-gates clean; daemon lint clean; all targeted tests pass.

## Pre / post SHAs

- Pre: `be93dadbb` (barrister's reviewed head)
- Post: `3243134a2`

## Commits (one per item, per fixer norms)

1. `822cf363a` — `fix(daemon): normalize getFormula unknown-identifier error`
   - `packages/daemon/src/host.js`: wrap `getFormulaForId` in try/catch; rethrow via `makeError` as `getFormula could not resolve unknown identifier: <id>`, carrying the persistence-layer error as `cause` (per `@endo/errors` `AssertMakeErrorOptions`).
   - `packages/daemon/test/endo.test.js`: add `getFormula normalizes unknown-identifier-on-local-node error`. Uses the existing test pattern: resolve a real local identifier (via `host.identify('ten')`), parse to discover the local node-part, construct a same-node identifier whose formula number is randomly generated, assert the normalized error message.
   - Lint-driven incidental edit: added an `await null` preamble per the jessie.js `safe-await-separator` rule (the rule fires because the try/catch's `await` is now the first awaited statement in the async body).

2. `9f87c1d1f` — `test(daemon): pin makeFormulaRecord default-fallthrough contract`
   - `packages/daemon/test/formula-record.test.js` (new): one ava test that constructs a stub formula `{ type: 'not-a-real-formula-type', number, extra: 'should-not-appear' }` and asserts the returned record's shape (same type, same number, empty `properties` map). Pins the forward-compatibility contract documented in the switch's `default` arm.

3. `3243134a2` — `docs(daemon): clarify EndoInspector deprecation scope and removal target`
   - `packages/daemon/src/types.d.ts`: strengthen both `@deprecated` notes on `EndoInspector<RecordT>` and `KnownEndoInspectors`. Chose the "scope as non-public" path because grep confirms both types are already internal: they live in `src/types.d.ts` and are not re-exported through the package-public `packages/daemon/types.d.ts` (which exports only `Config`, `start`, `stop`, `restart`, `terminate`, `clean`, `purge`, `makeEndoClient`). Strengthened notes spell out: (a) internal-only fact, (b) kept-only-for-on-disk-formulas rationale (the daemon revives existing `pet-inspector` formula entries into something callable), (c) concrete removal target paired with the on-disk `pet-inspector` retirement, no earlier than `@endo/daemon@4.0.0`. No runtime change.

## Per-item resolution

| Item | Barrister citation | Resolution | Commit |
|------|-------------------|------------|--------|
| 1 | `host.js:693-709` | Wrapped in try/catch + `makeError` with `cause`; added regression test | `822cf363a` |
| 2 | `formula-record.js:227-233` | New `formula-record.test.js` with default-fallthrough test | `9f87c1d1f` |
| 3 | `types.d.ts:735-744` | "Scope as non-public" path; strengthened JSDoc with removal target | `3243134a2` |

## Test results

- `yarn ava test/formula-record.test.js`: 1 / 1 pass.
- `yarn ava test/endo.test.js --match "*getFormula*"`: 6 / 6 pass (5 existing + 1 new).
- `yarn ava test/formula-type.test.js`: 3 / 3 pass (sanity).

## pre-push-gates result

`bash garden/skills/pre-push-gates/pre-push-gates.sh --summary` from project root:

```
yarn format            pass (auto-fixed 4 paths; re-staged)
yarn lint --fix        pass (auto-fixed 4 paths; re-staged)
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

result: gate passed.
```

The format / lint auto-fixes were idempotent on the working changes (they re-staged the same files; no incidental drift surfaced).

## Reply and re-request URLs

- Top-level summary comment: https://github.com/endojs/endo-but-for-bots/pull/440#issuecomment-4697918249
- Re-request review: `gh api repos/endojs/endo-but-for-bots/pulls/440/requested_reviewers --input -` with `{"reviewers":["kriskowal"]}` returned 201; PR's `requested_reviewers` now contains `kriskowal`. No separate URL — the action surfaces in the PR's activity timeline.

No inline review-thread replies were needed: the barrister's review carried 0 inline `pulls/440/comments`; all 3 summary-fix items were embedded in the review body text only.

## Post-state

- PR #440 head: `3243134a2`
- isDraft: true
- reviewDecision: "" (no formal verdict yet)
- requested_reviewers: includes kriskowal
- CI will re-run on the new head; the prior head was 15 / 15 green, the new commits add tests + JSDoc + one try/catch wrap, so a green re-run is expected. The dispatch brief explicitly excluded un-draft (that remains the maintainer's APPROVED-then-conductor flow or a follow-up justice terminator).

## Out-of-scope items the brief named (not addressed)

- Cut-3 chat impasse (`packages/chat` vs `packages/goblin-chat`): unchanged. Stays with the maintainer in the PR body's Design departures section.
- PR #441 (llm-base, design-doc-only): untouched.
- Un-draft: deferred per brief.

## Followups owed (per barrister, for the orchestrator to ledger)

The barrister surfaced 2 `follow-up`-disposition items in `entries/2026/06/13/073900Z-result-barrister-25df0f.md`:

1. CLI demo coverage for eval / lookup / guest / host (current `inspect-formula.js` covers only `make-bundle`). Owed in a follow-up PR.
2. `@info` retirement migration note in the release announcement. Owed at merge time.

These are not the fixer's lane on this dispatch; the orchestrator decides whether to ledger them per the project's followup conventions.

Self-improvement: nothing this time. The dispatch brief, the barrister's verdict body, and the role file's "Summary-fix dispatches are one-shot" operating norm aligned cleanly. The one fiddly bit (the `await null` preamble required after wrapping the `await getFormulaForId` in a try/catch shifted it to first-await position under `@jessie.js/safe-await-separator`) is a per-codebase tooling artifact, not a garden-level rule, and the `yarn lint` flagged it as soon as it surfaced.
