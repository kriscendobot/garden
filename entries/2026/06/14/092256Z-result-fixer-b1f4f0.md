---
ts: 2026-06-14T09:22:56Z
kind: result
role: fixer
host: endolinbot
repo: endojs/endo-but-for-bots
project: endo-but-for-bots
prs:
  - repo: endojs/endo-but-for-bots
    pr: 442
    role: target
refs:
  - entries/2026/06/14/091300Z-dispatch-fixer-b1f4f0.md
  - jobs/claimed/20260614T091529Z--endolinbot--fixer--c24d--7e80fa--endo-but-for-bots-442-summary-fix.md
  - entries/2026/06/14/090300Z-result-barrister-9c09ea.md
  - entries/2026/06/14/090825Z-result-appellate-98a88d.md
  - https://github.com/endojs/endo-but-for-bots/pull/442
  - https://github.com/endojs/endo-but-for-bots/pull/442#issuecomment-4701318998
---

# result: fixer applied summary-fix bundle (job 7e80fa) on PR #442 (daemon-cas)

## Summary

Two summary-fix items from the barrister's first code-panel round on PR #442
(daemon-cas extraction), as consolidated by the appellate, applied as two
atomic commits and pushed (append-only) to `feat/daemon-cas-extraction`.

## Pre / post head SHAs

- Pre:  `f472c43c5` (`chore(daemon-cas): drop pull citation, apply prettier`).
- Post: `cd7adacd8` (`test(daemon-cas): exercise joinPath across all four CAS ops`).

Two-commit linear append; no rebase, no force-push.

## Commits

- `6a5a377df` `chore(daemon-cas): wrap tests in @endo/ses-ava`
- `cd7adacd8` `test(daemon-cas): exercise joinPath across all four CAS ops`

## Item-by-item resolution

1. **Item 1: wrap tests in `@endo/ses-ava`** (commit `6a5a377df`).
   - File: `packages/daemon-cas/test/content-store.test.js`.
   - Edits: added `import { wrapTest } from '@endo/ses-ava';` and `import rawTest from 'ava';` in place of the prior `import test from 'ava';`. Inserted `const test = wrapTest(rawTest);` right after the local-import block.
   - `@endo/ses-ava` was already in the package's `devDependencies`; no `package.json` change.
   - Effect: uncaught-promise rejections inside SES lockdown surface as test failures, matching `packages/registry-capability/test/`'s discipline.

2. **Item 2: strengthen `joinPath`-only-path-primitive assertion** (commit `cd7adacd8`).
   - File: `packages/daemon-cas/test/content-store.test.js`, the `store on Windows-style path: joinPath is the only path primitive` test (now at lines ~297-321).
   - Prior shape: one `store(...)` then `t.true(joinCalls >= 1)` with a trailing `t.true(await store.has(sha))`.
   - New shape: invokes all four CAS ops on the same store (`store` → `fetch` → `has` → `remove`), with `t.is(await blob.text(), 'joined')` and `t.true(await store.has(sha))` along the way, then asserts `t.true(joinCalls >= 4)`. A refactor that hard-codes a Node path separator in any one of the four operations would drop a `joinPath` call below the floor.

## Test result

`corepack yarn workspace @endo/daemon-cas test` — 9/9 passing after each commit
(verified after commit 1, then again after commit 2). No new tests added; the
strengthened assertion fits in the existing test.

## pre-push-gates result

Ran `bash garden/skills/pre-push-gates/pre-push-gates.sh --summary` from
`project/`. The gate reported `result: gate failed (exit 1)` but every probe
failure is pre-existing on `feat/daemon-cas-extraction` and untouched by this
PR:

- `no-ascii-banners` — `designs/trust-on-first-bind.md` ASCII `+---+` banner.
- `no-inline-import-jsdoc` — `packages/9p-server/src/fs-bridge.js` inline `import()` at lines 52, 54, 88.
- `no-non-ascii-in-source` — `packages/9p-server/src/fs-bridge.js:18` U+2014.
- `security-md-hash-uniform` — `packages/endo/SECURITY.md` missing.
- `sentence-per-line-md` — many `.md` files across the tree.
- `filename-no-stutter` — `packages/chat/chat-bar-component.js`.

My changed-file set is `packages/daemon-cas/test/content-store.test.js` only;
the file passes every probe. The auto-fix stages (`yarn format`, `yarn lint --fix`)
re-staged 14 files in unrelated packages (`packages/9p-server`, `packages/daemon`,
`packages/endo-fs`, `packages/endo-fs-exec`, `packages/evasive-transform`,
`packages/registry-capability`, `packages/ses`). I reverted those out-of-scope
re-stages per the dispatch's "do NOT touch packages outside `packages/daemon-cas/`"
guard. The result is a clean two-commit append.

## PR #442 comment

<https://github.com/endojs/endo-but-for-bots/pull/442#issuecomment-4701318998>
(top-level summary at-mentioning `@kriskowal` with both SHAs and the
item-by-item resolution).

## Recommended next stage

`next: orchestrator un-drafts PR #442 after CI green; then conductor for merge`.

The PR remains DRAFT. Both summary-fix items are addressed; the panel's
remaining `follow-up` items (shared `ContentStoreFilePowers` test helper;
Phase 5 XS coverage) live in the ledger and revisit on merge per
`skills/panel-review/SKILL.md`.

Self-improvement: the job-board `claim-job.sh` script computes its journal
worktree as `<script's GARDEN_ROOT>/journal`, which inside a per-dispatch
worktree triple resolves to `<dispatch-root>/garden/journal/` (does not exist)
rather than the dispatch's `<dispatch-root>/journal/` worktree. Subagents
dispatched directly off a job (with the claim authorization in the dispatch
brief) currently have to fall back to invoking the SKILL's git steps by hand.
Worth a gardener pass to either teach `claim-job.sh` to honor `JRN` from env or
to teach the dispatch prepare script to surface the right `GARDEN_ROOT` for the
job-board scripts.
