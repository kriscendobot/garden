---
ts: 2026-06-15T22:17:00Z
kind: result
role: fixer
repo: kriscendobot/agoric-sdk
project: agoric-sdk
refs:
  - entries/2026/06/15/205700Z-dispatch-fixer-ba72cd.md
---

# Fixer: PR #5 type-check residue (guarded LogStore mismatches)

Maintainer kriskowal asked on PR #5 (2026-06-15T20:55:07Z): "Please address the
remaining issues, which appear to all be guarded type mismatches as above.
Continue until all type checks pass in all jobs. The documentation job is
expected to fail." Per investigator 582439's prior diagnosis, the residue
consisted of `LogStore` typedef vs `Guarded<{...}>` exo guard inference
mismatches in `packages/async-flow/`.

## Resolution

Applied `@ts-expect-error` at every call site that triggered the mismatch.
The dispatch brief preferred `@ts-ignore` per copilot guidance, but ESLint's
`@typescript-eslint/ban-ts-comment` rule rejects `@ts-ignore` project-wide
(observed empirically on the first push). The corrective push switched
every directive to `@ts-expect-error` and dropped the directives on the two
sites where `log` is already cast to `LogStore` ("Unused '@ts-expect-error'
directive").

## Pre/post head

- pre: f295e0d7ab40d6ad52f14c49f4d96b25fa8e5e93
- post: c5689a5f96c637e17a1897195c53a1a109102f26

## Commits

- 4976195967103e036231cbc6df6e456fd428729c `fix(async-flow): @ts-ignore guarded type mismatches on LogStore typedef`
- c5689a5f96c637e17a1897195c53a1a109102f26 `fix(async-flow): switch to @ts-expect-error per ESLint ban-ts-comment`

## Sites touched (8 src + 11 test)

- `packages/async-flow/src/log-store.js`: 8 new `@ts-expect-error` on `tmp.for(self)` / `tmp.resetFor(self)` inside method bodies.
- `packages/async-flow/src/async-flow.js`: 1 new `@ts-expect-error` on the `log` argument to `makeReplayMembrane`.
- `packages/async-flow/test/log-store.test.js`: 2 new `@ts-expect-error` on `toPassableCap(log.dump()[N][1])` in `testLogStoreReplay`.
- `packages/async-flow/test/replay-membrane.test.js`: 4 new `@ts-expect-error` on `bijection.hasHost(hOrch7)` / `bijection.has(gOrch7, hOrch7)` plus 1 on the `log` argument.
- `packages/async-flow/test/replay-membrane-eventual.test.js`, `replay-membrane-settlement.test.js`, `replay-membrane-zombie.test.js`: 1 + 1 + 2 on `log` argument to `makeReplayMembrane[ForTesting]`.

## CI verification on c5689a5f96

- `lint-primary`: `yarn typecheck-all` PASS (13m 55s). Job fails downstream in `multichain-testing/test/imports.test.ts` (see below).
- `build (node-old)`, `build (node-new)`, `flake-check`: all PASS (previously red with 10 async-flow TS errors).
- `test-dapp (node-new)` (documentation job): expected fail per directive (endo dep skew against documentation dapp).

## Pre-existing non-typecheck failures (out of scope)

These failed identically on the prior CI run on this branch (head f295e0d7).
Surfaced in the maintainer-facing comment for visibility; not part of this
dispatch.

1. `lint-primary` after typecheck-all passes, now reaches the multichain-testing
   smoke (`yarn install && yarn lint && yarn ava test/imports.test.ts`) which
   fails with `AssertionError: null == true` in `test/imports.test.ts`. The
   test instantiates a Stargate client via `makeStargateClient(LOCAL_CONFIG,
   { fetch })` from `@agoric/client-utils`; the client is null. Same exact
   failure on the prior CI run on this branch (timestamp 2026-06-14T10:22:24Z
   in the prior log).
2. `test-cosmic-swingset (node-old)` exits 129 (SIGHUP) with all tests
   visibly passing in the log. Same on prior run.
3. `test-cosmic-swingset (node-new)` canceled (downstream of node-old).
4. `test-fast-usdc-deploy (node-old)` and `(node-new)`: known structural impasse
   per dispatch directive.

## Maintainer notification

- PR top-level comment posted with `@kriskowal` mention summarizing the fix,
  per-job mapping, sites touched, and the pre-existing non-typecheck failures:
  <https://github.com/kriscendobot/agoric-sdk/pull/5#issuecomment-4712920075>.
- Re-request via `gh api requested_reviewers` returned HTTP 422 ("Reviews
  may only be requested from collaborators"), as expected on a fork PR where
  the maintainer is not a collaborator. The `@kriskowal` mention in the
  top-level summary is the substitute per `roles/fixer/AGENT.md` § Operating
  norms.

## Local verification

- `yarn workspace @agoric/async-flow lint:types`: clean
- `yarn typecheck-all`: clean (31s)
- `yarn lint:eslint --quiet packages/async-flow/`: clean

## Recommended next stage

`next: liaison`. Maintainer review on the type-check fix and decision on
how to handle the multichain-testing imports test failure and the
cosmic-swingset SIGHUP (separate dispatches if desired, or accept as
out-of-scope for the endo-sync mirror).

Self-improvement: dispatch briefs that prefer `@ts-ignore` over
`@ts-expect-error` per copilot should be cross-checked against the project's
ESLint `@typescript-eslint/ban-ts-comment` config before the first push; the
fixer's first push burned an extra CI cycle that the eslint rule would have
caught locally with `yarn lint:eslint`.
