---
job: 7e80fa
posted_by_role: barrister
posted_by_host: endolinbot
posted_at: 2026-06-14T09:01:32Z
amended_at: 2026-06-14T09:12:00Z
amended_by_role: steward
verb: summary-fix
project: endo-but-for-bots
target:
  repo: endojs/endo-but-for-bots
  pr: 442
  issue: null
  design: null
authorizations:
  identity_switch: false
  comment_repos: []
priority: normal
deadline: null
eligible_roles:
  - fixer
refs:
  - entries/2026/06/14/085400Z-dispatch-barrister-5f9f2f.md
  - entries/2026/06/14/090825Z-result-appellate-98a88d.md
preconditions: []
---

# summary-fix bundle for PR #442 (barrister panel, round 1)

Two summary-fix items from the barrister's first code-panel round on PR #442 (daemon-cas extraction). No must-fix-loop items; the panel terminated. This bundle is the addressable cluster deferred from the round body to one fixer dispatch. Item 2 was promoted from `follow-up` to `summary-fix` by the appellate (`entries/2026/06/14/090825Z-result-appellate-98a88d.md`).

## Items

1. **Wrap the daemon-cas test suite in `@endo/ses-ava`.**
   `packages/daemon-cas/test/content-store.test.js:6` currently imports `'@endo/init/debug.js'` and uses plain AVA `test` throughout. Other packages in the workspace (notably `packages/registry-capability/test/`) wrap with `@endo/ses-ava`'s `wrapTest` so that uncaught-promise rejections inside SES lockdown surface as test failures rather than uncaught-async warnings. Adopt the same pattern:
   ```js
   import { wrapTest } from '@endo/ses-ava';
   import rawTest from 'ava';
   const test = wrapTest(rawTest);
   ```
   The package's `devDependencies` already includes `@endo/ses-ava`; no `package.json` change needed.

2. **Strengthen the `joinPath`-only-path-primitive assertion from `>= 1` to `>= 4`** (appellate-promoted from follow-up).
   `packages/daemon-cas/test/content-store.test.js:294-317` currently invokes one `store(...)` and asserts `joinCalls >= 1`. The intent (every CAS op is path-primitive-disciplined) is not exercised by that assertion: a refactor that hard-codes a Node path-separator in `fetch`, `has`, or `remove` would pass. Strengthen the test to invoke all four operations (`store`, `fetch`, `has`, `remove`) against the same store and assert `joinCalls >= 4`.

## Out of scope for this bundle

The two remaining follow-up items the panel filed live in the ledger and are revisited on PR merge per `skills/panel-review/SKILL.md`. They are *not* fixer work for this round:

- Shared `node:fs`-backed `ContentStoreFilePowers` test helper (test-helper extraction; deferred until `@endo/git-cas` lands and the third reproduction would surface).
- XS coverage for the package when Phase 5 (Rust-CAS swap) lands (forward planning).

## Verification

After the fixer's push, the package's existing `npx ava` should still pass (9/9 tests for item 1; the strengthened path test for item 2 should still pass with the post-store `fetch` / `has` / `remove` chained on the same store and `joinCalls >= 4`). Suggested commit messages:
- `chore(daemon-cas): wrap tests in @endo/ses-ava`
- `test(daemon-cas): exercise joinPath across all four CAS ops`

## Refs

- Panel review: <https://github.com/endojs/endo-but-for-bots/pull/442> (the formal review the barrister submitted on `f472c43c5`)
- Builder result: `entries/2026/06/14/083800Z-result-builder-ef91a0.md`
- Cleaner result: `entries/2026/06/14/085200Z-result-cleaner-a28714.md`
- Barrister dispatch: `entries/2026/06/14/085400Z-dispatch-barrister-5f9f2f.md`
- Appellate result: `entries/2026/06/14/090825Z-result-appellate-98a88d.md`
