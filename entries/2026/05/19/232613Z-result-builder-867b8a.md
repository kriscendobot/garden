---
ts: 2026-05-19T23:26:13Z
kind: result
role: builder
project: endo-but-for-bots
refs:
  - entries/2026/05/19/231500Z-dispatch-liaison-867b8a.md
  - https://github.com/endojs/endo-but-for-bots/pull/303
---

# Result: builder 867b8a — devDep-cycle Cuts 1-5 mirrored onto master

PR: https://github.com/endojs/endo-but-for-bots/pull/303 (DRAFT).
Branch: `feat/break-devdep-cycles-master`. Head SHA: `e64274246`.

## Shape chosen: A (single bundled PR)

Rationale: the maintainer's bullet on Shape A recommended it "unless the
diff is unreviewable in one PR". The combined diff is ~1100 net lines
across 6 source-touching commits (design + 4 cuts + 1 hygiene), with the
ses-test cut being the bulk. Reviewable side-by-side with the merged
llm-side series; single CI gate; one rebase if conflict ever needed. The
boatman will ferry the whole branch upstream in one push.

## Commits on the branch (in order; one line each)

1. `design(workspace): break devDependency cycles via synthetic test packages (mirror of #206)`. Adds `designs/break-dev-dependency-cycles.md` (final form on llm HEAD; 694 lines).
2. `chore(zip): break devDep cycle (Cut 3 of #206 design)`. Drops two unused `@endo/zip` devDeps (`@endo/eventual-send`, `@endo/ses-ava`). No changeset (per llm review).
3. `chore(hex,hex-test): break devDep cycle via @endo/hex-test (Cut 2 of #206)`. Extracts `packages/hex-test/` (private). New `test-endo-hex` exports condition on `@endo/hex` exposes `./src/*`. Removes 4 cycle devDeps from `@endo/hex`.
4. `chore(harden,harden-test): break devDep cycle via @endo/harden-test (Cut 4 of #206)`. Extracts `packages/harden-test/` (3 tests + `_lockdown.js`). New `test-endo-harden` condition. Removes `ses` devDep from `@endo/harden`.
5. `feat(eventual-send,eventual-send-test): break devDep cycle via @endo/eventual-send-test (Cut 5 of #206 design) (#247)`. Extracts `packages/eventual-send-test/` (8 tests, incl. 2 new `local`/`message-breakpoints` tests that did not exist on master pre-cut). New `test-endo-eventual-send` condition. Removes `@endo/lockdown`, `ses`, `tsd` devDeps from `@endo/eventual-send`.
6. `chore(ses,ses-test): break devDep cycle via @endo/ses-test (Cut 1 of #206 design)`. Largest cut. Extracts `packages/ses-test/` (17 test files, test262, bundle scripts). New `test-endo-ses` condition. Removes `@endo/compartment-mapper`, `@endo/module-source`, `@endo/test262-runner`, four `@babel/*`, `terser` from `@endo/ses`. Includes kriskowal-review fixup keeping `node.test.js` in `@endo/ses` (`5f4811ecc`).
7. `chore(harden-test,hex-test): add missing SECURITY.md files` (mirror of #245).
8. `chore: Update yarn.lock` (per `skills/yarn-lock-separate-commit/SKILL.md`).

Per the recurring 2026-05-19 self-improvement: pushed commits 1-7 before running extended validation, then force-pushed `chore: Update yarn.lock` once `yarn install` settled.

## Local validation

- **Tarjan SCC pass** (custom node script, since master lacks `scripts/dependency-graph.js`): combined `dep+devDep` graph has **0 non-trivial SCCs**, down from **1 SCC of 14 packages** on master. Dependencies-only subgraph: 0 SCCs (unchanged; was already clean).
- **`yarn install`**: clean (only the pre-existing peer-dep warnings inherited from master).
- **Tests**: `@endo/ses` 341 pass; `@endo/ses-test` 160 pass; `@endo/eventual-send-test` 61 pass; `@endo/hex-test` 13 pass; `@endo/harden-test` 3 pass; `@endo/harden` 29 pass; `@endo/zip` 2 pass.
- **`yarn lint`**: 8 `import/no-unresolved` errors on the new `*-test` packages (e.g. `@endo/hex/src/encode.js` under `test-endo-hex`). Root cause: master's recent switch (`638306eac`, 5 days ago) aliases `eslint-plugin-import` to `eslint-plugin-import-x@4.16.2`, whose bundled `unrs-resolver` does not honour custom exports conditions. The llm branch still uses the original `eslint-plugin-import: ^2.31.0`, which is why these packages lint clean on llm. Runtime resolution under `--conditions=test-endo-<pkg>` works correctly. Documented in the PR body as a master-only follow-up; not introduced by the cycle-breaking work.

## Deviations from the llm-side surface (with citations)

- Cut 1 sourced from `origin/feat/ses-test` head `5f4811ecc` rather than verbatim from the (still-open) PR #261. Includes the kriskowal `node.test.js` fixup (`5f4811ecc`) per the brief's note.
- The babel devDep pins on `@endo/ses-test` were down-leveled from `~7.29.x` (llm) to `~7.28.x` to match master's `@endo/ses` pins; otherwise the yarn.lock would carry two versions of every `@babel/*` for no benefit.
- The Cut 2 `packages/hex-test/package.json` reformatted to multi-line `conditions: [...]` array (yarn install's prettier reformatted it; harmless).
- No SECURITY.md uniformity check on master (PR #228 is llm-only). The Cut 7 hygiene commit adds the files anyway; harmless on master, sets up the surface for boatman ferry.

## Eight commits on the branch are the deliverable

Branch head pushed to `origin/feat/break-devdep-cycles-master` (force-with-lease). PR #303 opens as DRAFT against `endojs/endo-but-for-bots@master`. No upstream-ferry, no un-draft, no comments on the original llm-side PRs per the dispatch's per-action authorization. Boatman handles ferry to `endojs/endo@master` in a separate dispatch under kriskowal credentials.

Self-improvement: the cherry-pick conflicts on `tsconfig.json` / `typedoc.json` were all the same shape — llm's per-Cut commit listed all the llm-only packages (chat, fae, familiar, genie, lal, etc.) in the `exclude` block alongside the new test package. A retroactive `dispatch-prepare`-time helper that pre-cleans these llm-only entries from a master-base cherry-pick (or a `--strategy-option=patience`-aware helper that recognises the pattern) would have saved ~5 minutes of resolution. Logging to liaison as a candidate skill addition; threshold-decision left to liaison per `skills/self-improvement/SKILL.md`.
