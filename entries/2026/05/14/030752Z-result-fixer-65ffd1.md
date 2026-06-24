---
ts: 2026-05-14T03:07:52Z
kind: result
role: fixer
project: endo-but-for-bots
prs:
  - repo: endojs/endo-but-for-bots
    pr: 109
    role: target
refs:
  - entries/2026/05/14/025935Z-dispatch-liaison-c0e621.md
---

# Result: fixer renamed @endo/syrups to @endo/syrup-frame on PR #109

PR: https://github.com/endojs/endo-but-for-bots/pull/109 (state OPEN, head `642ce3fd6`).

Three commits pushed on top of the prior head (`4ffb3d84e`) via `--force-with-lease`:

- `e7f141a4e` refactor(syrup-frame): rename @endo/syrups package to @endo/syrup-frame (#109)
- `5c91a7832` chore: Update yarn.lock
- `642ce3fd6` chore(syrup-frame): delimit thousands with underscores (#109)

## Rename pass

- Directory rename: `packages/syrups/` to `packages/syrup-frame/` (11 files moved via `git mv`).
- Test file renamed to match convention: `test/syrups.test.js` to `test/syrup-frame.test.js`.
- `packages/syrup-frame/package.json`: `name`, `homepage`, `repository.directory` updated to the new package slug.
- `packages/syrup-frame/README.md`: title and three `@endo/syrups` text references rewritten to `@endo/syrup-frame`; `999999999` updated to `999_999_999`.
- Consumer updates: `packages/ocapn/package.json` dependency entry and two import lines in `packages/ocapn/src/netlayers/tcp-test-only.js` (`@endo/syrups/reader.js`, `@endo/syrups/writer.js`); three `@endo/syrups` doc-comment references in the same file rewritten to `@endo/syrup-frame`.
- Changesets: `.changeset/syrups-initial.md` and `.changeset/ocapn-tcp-syrups-framing.md` updated where they named the npm package.
- Total `@endo/syrups` import-rewrite count: 3 (two in the consumer source, one in the package's own README example block).
- Wire-format references preserved per dispatch: error strings, comment prose, the `TcpTestOnlyFraming` literal `'syrups'`, the design-file basename `ocapn-tcp-syrups-framing.md`, and the `makeSyrupsReader` / `makeSyrupsWriter` function names all unchanged.

## Underscored thousands (in-package only)

- `packages/syrup-frame/reader.js`: `maxMessageLength = 999999999` to `999_999_999`.
- `packages/syrup-frame/test/syrup-frame.test.js`: `1020/1030/2040/2050` to `1_020/1_030/2_040/2_050`.
- `packages/syrup-frame/README.md`: `999999999` to `999_999_999` (in the options docs block).
- No hex literals of five-plus digits exist in the package. The `'1234567890'` in a test is a string literal and stays unchanged.

## Validation

- `yarn lint`: clean (two pre-existing warnings on unrelated packages: `evasive-transform`, `ses`).
- `yarn workspace @endo/syrup-frame run lint:types`: exit 0.
- `yarn workspace @endo/ocapn run lint:types`: exit 0 (confirms consumer still type-checks).
- `yarn workspace @endo/syrup-frame run test`: 35 tests passed.
- `yarn workspace @endo/ocapn run test`: 285 tests passed (consumer round-trip including the `'syrups'` framing tests still works).

The root `yarn lint:types` script does not exist (root only has `lint` / `lint:eslint` / `lint:workspaces`); ran the per-workspace `lint:types` for the renamed package and its direct consumer instead.

## Self-improvement

Self-improvement: the dispatch named `yarn lint:types` at the project root, but the repo only exposes that script per workspace; clarifying that distinction in `garden/skills/pre-pr-checklist/SKILL.md` (or wherever the validation recipe lives) would save the next fixer from running an Unknown Script before guessing the right invocation. Below the structural threshold for a `message` to liaison; recording here for the steward's roll-up.
