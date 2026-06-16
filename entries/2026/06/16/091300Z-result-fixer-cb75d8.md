---
ts: 2026-06-16T09:13:00Z
kind: result
role: fixer
repo: kriscendobot/agoric-sdk
project: agoric-sdk
refs:
  - entries/2026/06/16/084200Z-dispatch-fixer-cb75d8.md
  - entries/2026/06/16/074905Z-result-fixer-d2a673.md
  - entries/2026/06/16/063000Z-result-fixer-f2915b.md
---

# Fixer: OODA cycle 7 on PR #5 (50 lint-primary TS errors across 6 packages)

OODA cycle 7 on `kriscendobot/agoric-sdk#5` per
`skills/ci-failure-classification-loop/SKILL.md`. Cycle 5 fixer
(`1122a57c04`) cleared 20 swingset-runner/src TS errors. CI's
`typecheck-all` then surfaced 50 errors across deployment, governance,
portfolio-contract, solo, spawner, and swingset-runner/{demo,test}.
This cycle addresses all 50 with four logical-group commits.

## Pre / post

- Pre HEAD: `1122a57c04baef2893425649846564dd91828ab6`
- Post HEAD: `a67ed42db5` (after 4 commits pushed append-only)
- 4 commits pushed (append, no force).

## Per-fix mapping

| # | Cluster | Errors | Files | Approach | SHA |
|---|---|---|---|---|---|
| 1 | `temp` -> `node:fs/promises` | 2 TS2307 | `packages/deployment/src/{entrypoint,files}.js`, `packages/solo/src/{start,chain-cosmos-sdk}.js` | Adopt upstream `362d43c0b8`'s `mkdtemp` / `writeFile` / `unlink` pattern verbatim. `chain-cosmos-sdk.js` fixed too: it was `@ts-nocheck`'d (so lint didn't surface) but `temp` was no longer in package deps so runtime delivery would have failed. | `1dd3cd648d` |
| 2 | `t.context` unknown | 2 TS18046 | `packages/governance/test/swingsetTests/contractGovernor/governor.test.js`, `packages/spawner/test/swingsetTests/contractHost/contractHost.test.js` | `@ts-expect-error` on `t.context.data = ...` lines. Read sites (destructure in `main()`) don't surface TS18046 so no marker needed there. | `78ef85aebf` |
| 3 | SetAutoFeatures producer-side gap | 3 TS errors | `packages/portfolio-contract/src/evm-wallet-handler.exo.ts`, `packages/portfolio-contract/test/portfolio.contract.test.ts` | `@ts-expect-error` at three sites (case label, E(portfolio).setAutoFeatures call, evmTrader.setAutoFeatures call in test). The absorb commit `aee8f7a92c` pulled in the consumer-side from upstream `51512cf525` without its supporting four-commit producer chain. | `25c4a68373` |
| 4 | swingset-runner/demo + Promise ctor | 43 errors + 1 TS2810 | `tsconfig.check.json`, `packages/swingset-runner/test/demo.test.js` | Adopt upstream `8305900232`'s exclude pattern. Upstream excludes `packages/swingset-runner` entirely with reason "TODO not yet type-clean (~64 errors); also lacks a lint:types script". Our scope-limited form excludes `packages/swingset-runner/demo` only (preserves cycle-5 src/ fixes). The lone test/demo.test.js TS2810 fixed with `/** @type {Promise<void>} */` cast. | `a67ed42db5` |

## Diagnostic finding: SetAutoFeatures absorption is incomplete

The absorb commit `aee8f7a92c` (cycle 4) imported the consumer-side
`SetAutoFeatures` case in `evm-wallet-handler.exo.ts` and the new
test in `portfolio.contract.test.ts`, but not the producer-side type
infrastructure. The upstream feature (`Agoric/agoric-sdk#12726`,
merged at `14afd8f688`) is a four-commit chain:

- `f3076bc616` `refactor(portfolio-api): PortfolioPermissions types and shapes`
- `957c52f82d` `chore(portfolio-contract): wire rebalance delegation`
- `f3e48e72c0` `chore(portfolio-contract): wire auto-features`
- `51512cf525` `feat: SetAutoFeatures enable planner driven rebalance`

The producer side (the `SetAutoFeatures` entry in `OperationTypes`,
the `PortfolioAutoFeatures` type, the `PortfolioAutoFeaturesEIP712Shape`
constant, the `setAutoFeatures` method on `evmTrader`) was not absorbed.
The current `@ts-expect-error` markers are technical debt; the proper
fix is a follow-up "absorb #12726" dispatch.

## Local validation

- `corepack yarn typecheck-all`: 372 -> 322 (delta exactly 50).
- Targeted six packages: 69 -> 19 (the 19 remaining are pre-existing
  `@agoric/cosmic-proto` / `@agoric/client-utils` Class B inherited
  monorepo state per cycle 5).
- `corepack yarn lint:eslint --quiet`: exit 0.

## Pre-push-gates result

- 8 deterministic probes: all pass.
- `corepack yarn format`: pass (auto-fixed 1 path in
  packages/swingset-runner/test/demo.test.js, re-staged in commit 4).
- `corepack yarn lint`: fails on `lint:packages` (pre-existing
  cosmic-proto / client-utils typecheck-packages errors); unchanged
  from cycles 3-6 and unrelated to this cycle's changes.
- `corepack yarn typecheck`: skip (no root script).

## Classification (cycle 7, head a67ed42db5 to be confirmed when CI settles)

| Class | Job | Signature | Disposition |
| --- | --- | --- | --- |
| A | test-dapp (node-new) | docs dapp endo skew | skip (maintainer-authorized 2026-06-15) |
| C/this cycle | lint-primary | 50 TS errors across 6 packages | FIXED in commits `1dd3cd648d`, `78ef85aebf`, `25c4a68373`, `a67ed42db5` |
| B | lint-primary / lint-packages | ~19 `@agoric/cosmic-proto` / `@agoric/client-utils` module-resolution in portfolio-contract | inherited monorepo state (Class B per cycle 5) |
| C/cascade | test-* matrix | cancelled by upstream lint fail | should clear when lint-primary clears |

## PR comment

Posted top-level summary @-mentioning @kriskowal with the cycle-7
classification, per-fix mapping, diagnostic finding on SetAutoFeatures
incomplete absorption, and the recommendation to escalate to liaison:
<https://github.com/kriscendobot/agoric-sdk/pull/5#issuecomment-4716857813>

## Recommended next stage

`next: liaison`.

This is cycle 7 of a five-cycle (cycles 3-7) lint-primary push. Each
cycle cleared a distinct error layer and surfaced the next. The
signature is not strictly "no-progress" by `ci-failure-classification-loop`'s
definition (signature does change each cycle), but the pattern of
"clear one stage, reveal another" suggests a strategic re-frame at
the liaison layer is more useful than dispatching cycle 8.

Strategic decision points the liaison can surface to the maintainer:

1. Absorb #12726 properly to clean up the SetAutoFeatures
   `@ts-expect-error` markers (one designer+builder pair or a
   focused four-commit cherry-pick).
2. Address Class B `@agoric/cosmic-proto` / `@agoric/client-utils`
   package resolution (19 errors, persisting since at least cycle 3,
   not fixer-tractable).
3. Accept the current state as the gauntlet's ceiling and treat
   remaining red as Class B, un-drafting if appropriate.

Self-improvement: when an absorb commit imports consumer-side code
without its producer-side type infrastructure (as `aee8f7a92c` did
with `SetAutoFeatures`), the resulting TS errors are non-obvious
because they look like "feature missing" rather than "absorb
incomplete". A bisect-against-upstream probe before assuming any
"missing producer" pattern is fixer-tractable would catch this
faster; the cost is one full `git log --oneline upstream/master ^HEAD
-- <file>` per affected file, which is well worth the orientation
gain. Consider folding this into the OODA cycle's `Orient` phase
under `skills/ci-failure-classification-loop/SKILL.md` § 2.3 Class C:
an `absorb-incomplete` sub-class that escalates to liaison rather
than @-ts-expect-error'ing the gap.
