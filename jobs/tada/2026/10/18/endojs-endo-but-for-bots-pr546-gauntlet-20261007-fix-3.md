# PR #546, gauntlet fix round 3: fixes pushed, CI green

I fixed the must-fix items from the round-3 panel review on `87152ec247` and pushed four follow-up commits to `mirror/endo-3137-build-ts`. CI on the new head `abd614ba59` passed: 16 of 16 checks.

**What changed**
- **`4e73b6c8fe`: removed the `amaro/strip` runtime hook from `@endo/cli` and `@endo/daemon`.** This covers the decomplector's must-fix and the spec-keeper and engine-realist findings.
  - The hook only helped on Node.js 22.0–22.17, and it crashed on 22.0–22.5.
  - Node.js already strips TypeScript types by default from 22.18 and 23.6. So the repo root, CLI and daemon now declare `engines.node` as `^22.18.0 || >=23.6.0`, which covers the integrator's finding on the root's `>=16`.
  - `endo.cjs` now checks `process.features.typescript` directly instead of comparing the major version.
  - I deleted `amaro-exec-argv.js` and its test, the `execArgv` plumbing, and the `amaro` dependency in both packages.
  - A new CLI test runs `endo` with and without `--no-experimental-strip-types` (prover and corner-prober findings).
  - Removing the helper also clears the breaker's bare-`--import` finding, the stylist's `arg` rename and the fast-checker follow-up.
  - `docs/typescript.md` and the CLI changeset are updated to match.
- **`8336b582cd`: tightened the `no-nonrelative-ts-import` lint rule.** It now exempts `.d.ts`, `.d.mts` and `.d.cts` files only for `import type` and `export type`. Runtime imports, `export *` and dynamic `import()` of a declaration file are now reported (saboteur and breaker). New tests cover `.d.mts`/`.d.cts` and absolute and `file:` URL paths (corner-prober).
- **`1fb9ba95a3`: rewrote `.changeset/build-ts-support.md`** as a short note that no longer contradicts itself. I also removed the private-package commentary from the CLI changeset (changeset-auditor) and updated the `docs/lockdown.md` stack examples to `E.ts:248:29` (integrator).
- **`abd614ba59`:** a separate `chore: Update yarn.lock` commit for the removed dependencies.
- **PR body:** trimmed per the pruner, from 545 to 326 words. It now also says why `@endo/eslint-plugin` has no XS test (coverage-auditor).
- **Summary comment:** posted the commit-by-commit summary the scribe asked for: https://github.com/endojs/endo-but-for-bots/pull/546#issuecomment-6244655874

**Declined (reasons are in the summary comment)**
- **Major version bumps for `@endo/eventual-send` and `@endo/patterns`** (migrator and changeset-auditor, both must-fix). The published packages are unchanged; only loading them from source changed, and the new root `engines` floor states that. A major bump of these widely used packages should be a maintainer's call. **Expect the next panel round to raise this again until a maintainer decides.**
- **`types-index.js` re-export deprecation** (reexport-auditor): the re-export existed before this PR, which only renamed its target.
- **bigint `mustMatch` label test** (corner-prober): `bigint` was already in the base code's docs, and the runtime code is identical to the base.
- **CI lane pinned to the exact Node floor** (spec-keeper): the runtime check now enforces the floor, and adding a lane is a CI-cost decision.
- **Moving the `yarn.lock` changes out of `eb7b31251a` and `55c2aa5365`** (packager): that rewrites already-pushed history, so it belongs in a retcon job.

**Verification:** locally on Node.js 22.23.3, the lint-rule tests, the new CLI test and the daemon bundle test pass, and ESLint and Prettier are clean on the touched files. I did not run the full daemon suite locally; CI ran it and passed.

**Follow-ups**
- A maintainer decision on the patch-vs-major bump.
- An optional retcon job to split `yarn.lock` out of the older commits.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr546-gauntlet-20261007-fix-3.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 80 tokens (3822124 cached reads)
- Output: 24132 tokens
- Cost: $2.1218408000000006
- Wall-clock: 1463s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
