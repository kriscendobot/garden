Shepherded kriscendobot/agoric-sdk PR #7 to effectively green: **68 pass, 11 skipping, 1 fail** (the lone fail is pre-existing fork drift, not this PR's).

## What I did

Diagnosed every red check on PR #7, classified each as PR-owned vs. flaky vs. pre-existing, fixed what the PR owns, re-ran the flakes, and posted a top-level summary comment on the PR (per the comms directive). All work kept base+head on the `kriscendobot/agoric-sdk` fork branch `fix/internal-hex-bufferish-validation`; no upstream interaction.

## What changed (2 commits pushed to the fork branch)

The branch's new standalone benchmark scripts (`packages/internal/benchmark/{hex-decode-bench-core.js,-node.mjs,-xs.mjs}`) tripped three lint/typecheck gates:

- **`58fffff`** — `dprint fmt` the three files (fixes `lint-rest` dprint step); ignore `packages/internal/benchmark/` in `eslint.config.mjs` (fixes `lint-primary` project-service parse errors — the dir isn't in the package tsconfig).
- **`0b7c21b`** — exclude `packages/internal/benchmark` from `tsconfig.check.json`/`tsconfig.quickcheck.json` (fixes `lint-rest`'s `typecheck-quick` step, which globs `packages/**/*.*js` and was type-checking the intentionally-untyped benchmark scripts), mirroring how `packages/benchmark` is already excluded.

After the re-run: `lint-primary`, `lint-rest` → **pass**. The test failures (`test-quick node-old/node-new`, `test-boot (node-new,2,4)`, `test-boot (xs,2,4)`) were flaky/unrelated (swing-store exit-129 teardown crash; orchestration `numWantsSatisfied` offer assertion) and went **green on re-run** with no code change.

## Remaining red — explained, not PR-owned

- **`test-codegen`** — codegen-idempotence check fails because `packages/orchestration/src/fetched-chain-info.js` is dirty after re-running orchestration codegen. This PR touches only `packages/internal/`; the same job fails identically on docs-only PR #6, proving it's fork-master-level codegen drift, not introduced here.

Verified the hex/Bufferish runtime change introduces no regression: it only adds validation (rejecting already-malformed input) and rebuilds a byte-identical table; consumers (`pos-evm.flows.ts` encode-only, `solo` valid tx hashes) are unaffected, and all functional shards pass.

## Follow-ups

- Fork `master` needs `packages/orchestration/src/fetched-chain-info.js` regenerated to clear `test-codegen` for all PRs (affects #6 and #7 alike) — out of scope for this hex PR; better fixed at master than smuggled into this diff. Not escalated to fixer since it's neither caused by nor fixable within this PR's concern.
- PR remains DRAFT (unchanged); next stage in the gamut is the panel/judge per normal flow.
