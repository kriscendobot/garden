---
ts: 2026-06-15T06:27:00Z
kind: result
role: fixer
project: endo
repo: endojs/endo-but-for-bots
worktree: dispatches/fixer--b21718/project
refs:
  - entries/2026/06/15/061100Z-dispatch-fixer-35f98a.md
---

Carried boneskull's four upstream-review nits (review 4489675443 on endojs/endo#3276) onto the mirror PR endojs/endo-but-for-bots#379. All four addressed in three commits stacked atop ca17e11e4.

## Pre/post head SHAs

- Pre: `ca17e11e4`
- Post: `f87d0eb05`
- Pushed append-only to `fix/issue-59-star-export-cycle`.

## Per-nit resolution

| # | File:line | Resolution | Commit SHA |
| - | --------- | ---------- | --- |
| 1 | `packages/ses/src/notifier-with-resolver.js:1` | Added `@module` docstring at the top of the file. | `77e225b32` |
| 2 | `packages/ses/src/notifier-with-resolver.js:19` | Dropped the brittle "Used by `module-instance.js` `wireUpExportNotifier`..." paragraph from the helper's JSDoc; added `{@link makeNotifierWithResolver}` inside the inline narrative within `wireUpExportNotifier` in `module-instance.js`. Cross-reference is owned by the consumer. | `77e225b32` |
| 3 | `packages/ses/src/notifier-with-resolver.js:41` (and `resolve` below) | Restructured both `notify` and `resolve` to `if (resolvedTargetNotify === undefined) { ... } else { ... }`. Strict equality, no early return. Observable behavior unchanged. | `e67203485` |
| 4 | `packages/ses/test/import-cjs.test.js:700` | endojs/endo#3220 is still OPEN (`gh issue view 3220 --repo endojs/endo` confirms), so the real `CjsModuleSource` is not yet exported from `@endo/module-source`. Added `TODO(endojs/endo#3220)` at the local mock's definition (line 30) so the swap is discoverable when #3220 lands. | `f87d0eb05` |

## Test results

- `corepack yarn workspace ses test`: 511 tests passed, 2 known failures, 2 skipped. Baseline pre/post.
- `corepack yarn workspace @endo/module-source test`: 53 tests passed.

## Pre-push-gates result

The deterministic probes for my three changed paths all pass (`no-non-ascii-in-source`, `no-pull-citations`, `no-inline-import-jsdoc`, `sentence-per-line-md`, etc.). The gate's `--summary` exit was non-zero, but the two findings are both pre-existing in paths I did not touch:

- `no-inline-import-jsdoc fail: packages/evasive-transform/src/index.js: inline import() at line 23,26` (unchanged from baseline).
- `security-md-hash-uniform fail: divergent SECURITY.md` across `packages/{immutable-arraybuffer,bytes,hex,panic}/SECURITY.md` (unchanged from baseline).

Per the fixer skill's "The fixer's lane is the current PR" norm, I did not touch either. They are surfaceable as their own follow-up jobs if the steward chooses.

The `yarn format` and `yarn lint --fix` auto-fixers also touched two unrelated files (`packages/evasive-transform/src/index.js`, `packages/ses/src/compartment.js`) on every gate run; I reverted those each cycle so the three commits contain only nit-driven changes.

## PR #379 comment URL

<https://github.com/endojs/endo-but-for-bots/pull/379#issuecomment-4705150423>

Top-level summary @-mentioning @kriskowal with the 4-item resolution table and SHAs, per dispatch authorization.

## Recommended next stage

`next: liaison`. PR #379 is OPEN (not draft) and the maintainer has the load-bearing decision (rsvp upstream and / or request boatman ferry of these three follow-up commits onto endojs/endo#3276).

Self-improvement: nothing this time. The auto-fixer's repeated injection of bare `@param` lines into module-instance.js after I added a JSDoc block (which then broke TS at the 2-arg call site) was a wrinkle, but it surfaced once and I worked around it by reverting the JSDoc block and tucking the `{@link ...}` into the existing inline narrative; not yet a pattern that warrants a skill row.
