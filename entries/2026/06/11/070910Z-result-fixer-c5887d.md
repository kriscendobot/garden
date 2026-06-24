---
ts: 2026-06-11T07:09:10Z
kind: result
role: fixer
project: endo
repo: endojs/endo-but-for-bots
worktree: dispatches/fixer--4ab426/project
refs:
  - https://github.com/endojs/endo-but-for-bots/pull/379
  - https://github.com/endojs/endo-but-for-bots/pull/379#pullrequestreview-4474269526
  - https://github.com/endojs/endo-but-for-bots/pull/379#discussion_r3393767528
  - https://github.com/endojs/endo-but-for-bots/pull/379#discussion_r3393779233
  - https://github.com/endojs/endo-but-for-bots/pull/379#issuecomment-4678065271
  - https://github.com/kriskowal/garden/blob/journal/entries/2026/06/11/063300Z-dispatch-fixer-4ab426.md
  - https://github.com/kriskowal/garden/blob/journal/entries/2026/06/11/021100Z-result-fixer-ee7c36.md
---

Fixer dispatch 4ab426 addressed both inline asks from kriskowal's CHANGES_REQUESTED review 4474269526 (2026-06-11T06:32:31Z) on PR endojs/endo-but-for-bots#379.

## What landed

Two append commits on branch `fix/issue-59-star-export-cycle`. Pre-dispatch tip `53d8662a7`; post-dispatch tip `cc23fca8f`.

- `b76ab1abd`: `docs(ses): archive construction-time-notifiers analysis to the garden journal`. Single-file project-side deletion: `packages/ses/designs/construction-time-notifiers.md`. The verbatim text was first copied into the garden journal at `projects/endo/drafts/construction-time-notifiers.md` (journal commit `f8f8a10e`, with a matching index row in `drafts/README.md`).
- `cc23fca8f`: `test(compartment-mapper): parity fixtures for the issue endojs/endo#59 TDZ matrix`. Seven new fixture directories under `packages/compartment-mapper/test/fixtures-cycle-{rename,named-reexport}-tdz-*`, one shared assertions module (`_cycle-rename-tdz-assertions.js`), and 14 test files (7 SES-side + 7 Node.js parity). The `import-gauntlet.test.js` header comment gains an inline cross-reference linking each matrix cell to its parity fixture.

## Ask 1: archive then delete construction-time-notifiers.md

Verbatim text now at `journal/projects/endo/drafts/construction-time-notifiers.md` per the existing draft-design convention; index row added to `journal/projects/endo/drafts/README.md` naming the archival reason (kriskowal review 4474269526 on endojs/endo-but-for-bots#379). Project-side deletion in commit `b76ab1abd`.

Inline-thread reply: https://github.com/endojs/endo-but-for-bots/pull/379#discussion_r3393867371 (in_reply_to_id 3393767528).

## Ask 2: compartment-mapper parity for each gauntlet scenario

The two previously-covered scenarios from the prior fixers (the original endojs/endo#59 fixture and its unused-live-binding companion) already had compartment-mapper fixtures with Node.js parity tests (`cycle-rename.test.js` + `cycle-rename-node-parity.test.js`, `cycle-rename-unused.test.js` + `cycle-rename-unused-node-parity.test.js`). The seven new gauntlet scenarios added by the prior fixers (six-cell TDZ matrix for the cyclic star-export plus one named-reexport variant) needed matching fixtures.

Seven new fixtures under `packages/compartment-mapper/test/`, each with a `node_modules/app/{package.json,star-reexporter.js OR named-reexporter.js,export-renamer.js,main.js}` shape:

| Fixture | Probe expectation |
|---------|-------------------|
| `fixtures-cycle-rename-tdz-const-renamer-first` | `{kind:'error', name:'ReferenceError'}` |
| `fixtures-cycle-rename-tdz-let-renamer-first` | `{kind:'error', name:'ReferenceError'}` |
| `fixtures-cycle-rename-tdz-var-renamer-first` | `{kind:'value', value:undefined}` |
| `fixtures-cycle-rename-tdz-const-star-first` | `{kind:'value', value:42}` |
| `fixtures-cycle-rename-tdz-let-star-first` | `{kind:'value', value:42}` |
| `fixtures-cycle-rename-tdz-var-star-first` | `{kind:'value', value:42}` |
| `fixtures-cycle-named-reexport-tdz-const-renamer-first` | `{kind:'error', name:'ReferenceError'}` |

For each fixture, two new test files were added:

- `cycle-<fixture-slug>.test.js`: imports the fixture through the compartment-mapper scaffold; `t.plan(1)`; asserts the probe against the matching `expectedProbe<Cell>` constant.
- `cycle-<fixture-slug>-node-parity.test.js`: imports the same fixture via Node.js's native loader; `t.plan(1)`; asserts the same expected constant.

The expected probe values live in `_cycle-rename-tdz-assertions.js` so both layers compare against exactly one set of expectations. Parity is verified by construction: if both tests pass, SES enforces the same TDZ semantics on the cross-module namespace path that Node.js enforces natively.

The `import-gauntlet.test.js` header comment now lists the fixture-path pattern for the six star-reexport cells and the one named-reexport cell, so future maintainers can find both layers from either side.

Inline-thread reply: https://github.com/endojs/endo-but-for-bots/pull/379#discussion_r3393868902 (in_reply_to_id 3393779233).

## Test result

`corepack yarn workspace ses test`: 511 pass + 2 known failures + 2 skipped (unchanged from base).

`corepack yarn workspace @endo/compartment-mapper test`: 1014 pass + 6 known failures (was 930 + 6; the +84 new passes come from 7 new fixture variants times 12 scaffold-suite tests each, plus 7 Node.js parity tests).

## Pre-push gate

`pre-push-gates --summary .` reports clean for the diff under review after addressing one finding on first run:

- `no-pull-citations` flagged bare `#379` and `#59` references in two new files. Qualified the references (`endojs/endo-but-for-bots#379`, `endojs/endo#59`) and re-ran.

Two pre-existing probe failures inherited from master (same baseline as prior fixer `ee7c36`): `no-inline-import-jsdoc` on `packages/evasive-transform/src/index.js`, `security-md-hash-uniform` divergent SECURITY.md across `immutable-arraybuffer`, `bytes`, `hex`, `panic`. Not introduced by either commit.

Auto-fix stage touched `packages/evasive-transform/src/index.js` and `packages/ses/src/compartment.js` (the same pattern the prior fixers documented); both reverted before commit so the diff stays scoped.

## CI

All 15 of 16 checks pass at head `cc23fca8f`:

- build, check-action-pins, cover, lint, test (22.x x macos-15), test (22.x x ubuntu-latest), test (24.x x macos-15), test (24.x x ubuntu-latest), test-hermes, test-ocapn-python, test262 (22.x), test262 (24.x), test-xs, viable-release, zizmor: all pass.
- browser-tests: pending/long-running. This check has a consistent 30-minute timeout-cancellation pattern on this PR's prior commits and on the master branch's last several pushes (`endojs/endo-but-for-bots` master Browser Tests runs 26921024468, 27052742742, 27065459413 all cancelled at 30:19). Pre-existing infrastructure issue, not introduced by this PR.

## PR-side actions

- Inline reply on the design-archive thread (in_reply_to 3393767528): https://github.com/endojs/endo-but-for-bots/pull/379#discussion_r3393867371. Cites the addressing commit and journal archive paths.
- Inline reply on the parity-fixture thread (in_reply_to 3393779233): https://github.com/endojs/endo-but-for-bots/pull/379#discussion_r3393868902. Cites the addressing commit and enumerates the seven new fixtures.
- Top-level summary comment: https://github.com/endojs/endo-but-for-bots/pull/379#issuecomment-4678065271. Cites both addressing commits, lists the parity-test additions, confirms CI status with the browser-tests caveat, and re-mentions @kriskowal.
- Re-request review from kriskowal via the JSON-body shape: `echo '{"reviewers":["kriskowal"]}' | gh api repos/endojs/endo-but-for-bots/pulls/379/requested_reviewers --input -`. PR's `requested_reviewers` now lists kriskowal.

## Deliverable

PR endojs/endo-but-for-bots#379 head `cc23fca8f` (was `53d8662a7`). Two append commits: `b76ab1abd` (design archive + project-side deletion) + `cc23fca8f` (compartment-mapper parity fixtures + import-gauntlet.test.js header cross-references). One journal commit: `f8f8a10e` (verbatim archive in `journal/projects/endo/drafts/`). All seven new SES-side scaffold suites and seven Node.js parity tests pass on first run; no regressions in any tested package.

Self-improvement: the pre-push gate's `no-pull-citations` probe trailing-class regex permits `)` and `:` as boundaries but not `,` or ` `, so `(issue #59)` and `from issue #59:` slip through while `PR #379, ...` and `issue #59. Each` get flagged. Worth a small note in the gardener's eventual review of pre-push-gate probe tuning: the qualified form (`owner/repo#n`) sidesteps the question entirely and could become the documented house style for prose references in test-file headers.
