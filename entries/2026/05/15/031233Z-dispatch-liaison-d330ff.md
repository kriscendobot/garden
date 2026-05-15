---
ts: 2026-05-15T03:12:33Z
kind: dispatch
role: liaison
project: endo-but-for-bots
to: "*"
refs:
  - https://github.com/endojs/endo-but-for-bots/pull/240
---

# Dispatch: builder lands Cut 1 of devDep-cycle factoring (@endo/ses-test) — unblocks #240

Dispatch root: `dispatches/builder--d330ff/`. Project worktree on `endojs/endo-but-for-bots@llm` (matches the prior cuts' base; the other four cuts landed on llm).

Maintainer directive (2026-05-15): "Please do" — dispatch a builder for Cut 1 (`@endo/ses-test`) of the devDep-cycle factoring design. Cut 1 is the load-bearing missing piece blocking #240's `^build` flip; it eats 11 edges (the largest of the 5 cuts).

## Design reference

`designs/break-dev-dependency-cycles.md` on llm § Per-cycle cuts § Cut 1: `@endo/ses-test` (eats 11 edges). A new package `packages/ses-test/` hosts the SES test files currently in `packages/ses/test/` that need cycle-creating devDeps (`@endo/eventual-send`, `@endo/init`, `@endo/ses-ava`, `@endo/module-source`, `@endo/lockdown`, etc.). The SCC of 9 packages (`@endo/lockdown ↔ @endo/eventual-send ↔ @endo/init ↔ @endo/ses-ava ↔ @endo/module-source ↔ @endo/evasive-transform ↔ @endo/compartment-mapper ↔ @endo/test262-runner ↔ ses`) is the target.

After this cut, only Cut 3 (`@endo/zip` unused devDeps) remains. The design's projected final state: 5 sink-only test packages + clean DAG.

## Pattern to follow

Mirror the shape of:

- PR #210 (Cut 4, `@endo/harden-test`) — merge commit `9371b1bf` on llm.
- PR #211 (Cut 2, `@endo/hex-test`).
- PR #247 (Cut 5, `@endo/eventual-send-test`) — recent.

Each cut creates a new private sink-only package, moves test files via `git mv`, adds the `test-endo-<pkg>` exports condition where tests reach internal symbols, removes the cycle-creating devDeps from the source package, includes the canonical `SECURITY.md` per the uniformity check, excludes the new package from `tsconfig.json` and `typedoc.json` alongside the prior siblings.

## Per-action authorization

Standing on endo-but-for-bots: push, open draft PR.

## Task

1. **Read the design's Cut 1 section in full**: `designs/break-dev-dependency-cycles.md` on llm. Cite specific edges and test files.

2. **Identify which test files in `packages/ses/test/`** currently use cycle-creating devDeps (`@endo/eventual-send`, `@endo/init`, `@endo/ses-ava`, `@endo/module-source`, `@endo/lockdown`, etc.). Grep + read each test's imports.

3. **Create `packages/ses-test/`** with:
   - `package.json` declaring deps on `ses` + the moved-tests' actual imports (`@endo/eventual-send`, `@endo/init`, `@endo/ses-ava`, etc.); `private: true`; canonical SECURITY.md per uniformity check; canonical LICENSE; standard `tsconfig.json`, ava scripts. Match the structure of `harden-test`, `hex-test`, `eventual-send-test`.
   - `test/` directory with the moved test files (via `git mv`).
   - If any test reaches internal `packages/ses/src/*` symbols, add a `test-endo-ses` exports condition on `packages/ses/package.json` and have the test use it.

4. **Remove cycle-creating devDeps from `packages/ses/package.json`** — the ones that the moved tests carried. Keep `ava`, `c8`, and any non-cycle devDeps.

5. **Exclude `packages/ses-test/`** from `tsconfig.json` + `typedoc.json` alongside the prior siblings.

6. **Verify locally**:
   - `yarn install` clean.
   - `yarn workspace @endo/ses-test test` — all tests pass.
   - `yarn workspace @endo/ses test` — what remains still passes.
   - **`yarn turbo run test --dry=json --filter=...[origin/llm]`** — verify the cyclic-dep warning is gone (the design's success criterion). If a smaller SCC remains, surface it for follow-up.

7. **Per today's self-improvement** (filed at `015257Z`): commit + push BEFORE extended local validation.

8. **Open as DRAFT PR** against `llm`. Branch: `feat/ses-test` (matching the prior `feat/eventual-send-test` etc.). Title: `feat(ses,ses-test): break devDep cycle via @endo/ses-test (Cut 1 of #206 design)`. Body cites the design + prior cuts + the SCC eliminated.

9. **Separate `chore: Update yarn.lock`** commit per `skills/yarn-lock-separate-commit/SKILL.md`.

## Out of scope

- No upstream ferry. Boatman re-ferries when maintainer asks.
- No edit to #240.
- No un-draft. Cleaner + judge run via steward's per-cycle scan after builder's result lands.

## Report

≤ 400 words: PR URL, head SHA, files moved (count + brief list), cycle-creating devDeps removed, turbo cycle-check outcome (gone / smaller / unchanged), local test results, one-line `Self-improvement: ...`.
