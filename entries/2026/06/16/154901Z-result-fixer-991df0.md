---
ts: 2026-06-16T15:49:03Z
kind: result
role: fixer
repo: kriscendobot/agoric-sdk
project: agoric-sdk
refs:
  - entries/2026/06/16/091300Z-result-fixer-cb75d8.md
  - entries/2026/06/16/084200Z-dispatch-fixer-cb75d8.md
---

# Fixer: OODA cycle 8 on PR #5 (multichain-testing yarn.lock drift)

OODA cycle 8 on `kriscendobot/agoric-sdk#5`. Cycles 4-7 churn across
package.json files left `multichain-testing/yarn.lock` out of sync
with its dependencies' updated manifests. CI's lint-primary job
failed at the multichain-testing step with `YN0028: The lockfile
would have been modified by this install, which is explicitly
forbidden.` Cycle 7's run did not catch this because multichain-testing
runs in a separate working-directory step under yarn's hardened mode.

## Pre / post

- Pre HEAD: `a67ed42db5db13ab027154d43c965a35e6919b53`
- Post HEAD: `dc7b13e31bcbede08c351d85c292fc6daae4e4be`
- 1 commit pushed (append, no force).

## Procedure

1. Root `corepack yarn install` (mutable). Lock clean (no diff).
2. `corepack yarn install` in `multichain-testing/` failed initially
   with `@aglocal/fast-usdc-deploy@portal:../../agoric-sdk/packages/...
   Manifest not found`. The `resolutions` block uses sibling-of-
   multichain-testing layout (`portal:../../agoric-sdk/packages/...`)
   which assumes the project lives at `<parent>/agoric-sdk/multichain-testing/`.
   Per cb75d8's `cp -r` workaround note, instead created a symlink
   `dispatches/fixer--991df0/agoric-sdk -> project` so the portal
   path resolves to the project worktree's packages. Symlink removed
   after the install completed.
3. `corepack yarn install` in `multichain-testing/` succeeded after
   the symlink (regen pulled ava 7.0.0, @endo/evasive-transform
   2.3.0, etc.; dropped 52 old @babel/* entries).
4. `git status`: only `multichain-testing/yarn.lock` modified.
5. `corepack yarn install --immutable` in `multichain-testing/`:
   clean (no YN0028).
6. Committed `chore: Update yarn.lock` (1 file, -643 / +117 lines).
7. Pushed append-only to `mirror/12527-endo-sync-refresh`.

## Local validation

- Root `corepack yarn install`: lockfile clean.
- `multichain-testing/` `corepack yarn install`: succeeds, regenerates.
- `multichain-testing/` `corepack yarn install --immutable`: passes
  (YN0028 cleared).
- `multichain-testing/` `corepack yarn lint`: out of scope (this fixer
  addressed only the install-step drift). The lint step's TS errors
  surface the pre-existing Class B `@agoric/cosmic-proto` /
  `@agoric/client-utils` portal-resolution issues called out in
  cycle 7's result, which are inherited monorepo state and not a
  lockfile concern.

## Why root `lint:primary` was not run

The dispatch brief asked for `corepack yarn lint:primary`. There is
no root-level `lint:primary` script; the name refers to the CI job
that composes `yarn lint:eslint --quiet`, `yarn typecheck-all`, and
the multichain-testing `yarn install && yarn lint && yarn ava
test/imports.test.ts` sub-step. The failure CI surfaced was the
sub-step's `yarn install` (YN0028). The CI never reached the
sub-step's `yarn lint` because install aborted. The fix is targeted
at clearing YN0028; cycle 7's diagnostic on remaining Class B issues
holds.

## PR comment

Posted top-level summary @-mentioning @kriskowal with the cycle-8
fix, the lock regen scope, the symlink workaround note, and the
recommendation to advance to OODA-observation:
<https://github.com/kriscendobot/agoric-sdk/pull/5#issuecomment-4720650874>

## Recommended next stage

`next: ooda-observation`.

The signature should shrink in the next CI run (lint-primary clears,
revealing whatever the next layer is). Likely next surfaces: (a)
lint-primary now reaches `yarn lint` in multichain-testing and may
expose pre-existing TS errors (cycle 7's Class B), (b) the
`test-quick` / `test-portfolio-contract` / `test-swingset` matrix
that was cascade-cancelled will run for real. If the cascade-tests
all pass, this clears the way to consider un-drafting per cycle 7's
strategic option 3.

Self-improvement: the standalone multichain-testing yarn project's
lockfile is a CI failure mode that doesn't surface in any root-level
script — `yarn install` at root succeeds, root `yarn lint` doesn't
touch it, and `yarn typecheck-all` doesn't cover it. The fixer's
pre-push-gates (`skills/pre-push-gates/SKILL.md`) does not currently
include a `cd multichain-testing && yarn install --immutable` probe.
Consider adding one as a deterministic probe in the gate, parametrized
on the existence of `multichain-testing/yarn.lock`. The cost is one
extra immutable install (~2-3 seconds); the benefit is catching this
class of drift before the push instead of in the next CI cycle.
