---
ts: 2026-06-04T00:00:14Z
kind: dispatch
role: liaison
host: endolinbot
repo: endojs/endo-but-for-bots
project: endo-but-for-bots
to: fixer
dispatch_root: /home/kris/dispatches/fixer--6e66fe
prs:
  - repo: endojs/endo-but-for-bots
    pr: 417
    role: target
refs:
  - https://github.com/endojs/endo-but-for-bots/pull/417
  - https://github.com/endojs/endo-but-for-bots/pull/417#pullrequestreview-4423599405
  - entries/2026/06/03/233040Z-result-fixer-ca5ba1.md
---

# dispatch: fixer — #417 implement bytes-spackle + eslint rule + ses permits; rewrite README for users

Maintainer review `4423599405` (CHANGES_REQUESTED, 2026-06-03T23:49:27Z):

> Please implement the changes described and then reconstruct
> the README such that the audience is users rather than a
> scratch space for the design.

The prior dispatch landed the README reiteration only. This
dispatch lands the implementation work that was previously
flagged as out-of-scope, then rewrites the README to a
user-facing shape.

User explicit ask: do all steps sequentially in ONE subagent
dispatch.

## Target

- PR: endojs/endo-but-for-bots#417
- Branch: `mirror/3164-freezable-typedarrays`
- Head: `4f28fc697` (post README reiteration).
- Base: `master` (`ba26f4cdb`).
- State: OPEN, not draft.

## Sequential steps (in order)

### Step 1: `@endo/bytes` spackle install

Per the README's elaborated proposal:
- Install six-operation spackle on intrinsics via registered
  Symbol.for(...) keys:
  - `ArrayBuffer.prototype[Symbol.for('sliceBufferToImmutable')]`
    → calls through to `@endo/immutable-arraybuffer`'s
    `sliceBufferToImmutable`, hardens result. First-writer
    race; subsequent loads of `@endo/bytes` go through
    installed function.
  - `Uint8Array[Symbol.for('toUtf8String')]` — text-codec
    capture-on-intrinsic.
  - `Uint8Array[Symbol.for('fromUtf8String')]` — text-codec
    capture-on-intrinsic.
  - `freezableConstructor` symbol per TypedArray family
    (one constructor per realm; portable instanceof/
    construction/usage).
  - Two more operations from the README's six-operation list
    (`bytesToImmutable`, `bytesFromImmutable`,
    `concatImmutables` — pick the right six per the README's
    earlier list).
- Capture `TextEncoder` / `TextDecoder` on intrinsics at
  module load (load-bearing against compartment-global
  endowment override).
- Internalize `makePseudoTypedArrayConstructor` (move from
  public export to internal-only).
- Add tests in `packages/bytes/test/` covering each spackle
  operation.

### Step 2: `@endo/eslint-plugin` rule

- Forbid identifiers: `TextEncoder`, `TextDecoder`, all
  TypedArray constructors (`Uint8Array`, `Int8Array`, …),
  `ArrayBuffer` as a NewExpression callee.
- Whitelist exception: spackle's capture-at-module-init site
  (whitelisted by module path).
- Fix-it hints map each forbidden identifier to its
  `@endo/bytes` equivalent.
- Default `warn`, opt-in `error`.
- Add to recommended config.
- Tests + fixtures.

### Step 3: `@endo/ses` permits update

- Admit the registered `Symbol.for(...)` keys (the symbols
  installed by `@endo/bytes` spackle) in SES's permits.
- Tests.

### Step 4: README user-facing rewrite

After steps 1-3 land, rewrite
`packages/immutable-arraybuffer/README.md` for users:

- Lead with what a user does to use the spackle, NOT the
  design discussion.
- Code examples first; rationale brief.
- Imports + canonical usage patterns prominent.
- Move the design / proposal text either to a separate
  `DESIGN.md` or to a "Background" appendix.
- Remove "scratch space for the design" feel: linear
  user-onboarding flow, not a chronological proposal trace.

### Step 5: Run full gauntlet

Per-package: `yarn lint`, `yarn lint:types`, `yarn ava`.
Across the workspace: `yarn build:types:check`.

### Step 6: Commit shape

Recommended: ONE commit per step (4 commits total), so the
PR's git log reads as a clean progression. OR fewer commits if
some steps are interleaved.

Use judgment. The branch shape isn't load-bearing (this is a
mirror PR with documentation-grade reviews; the upstream
endo#3164 will land with whatever shape erights prefers).

### Step 7: Push + reply

Regular append push to `mirror/3164-freezable-typedarrays`.
Post a top-level PR comment summarizing each step's
outcome.

## Per-action authorizations

- Read all relevant files. Authorized.
- Edit `packages/bytes/`, `packages/eslint-plugin/`,
  `packages/ses/`, `packages/immutable-arraybuffer/`.
  Authorized.
- Add tests, fixtures, recommended-config entries.
  Authorized.
- Multiple regular-append commits + push.
  Authorized.
- Top-level PR comment. Authorized.

## Not authorized

- Modifying upstream endo#3164.
- Modifying any other package source.
- Force-pushing.
- Touching `packages/ses` lockdown behavior beyond the
  permits update (no scope creep into other SES changes).
- Modifying `@endo/eslint-plugin`'s OTHER rules.
- XS-runner toolchain work (Moddable SDK not available).

## Dispatch protocol

Read in order:

1. `/home/kris/dispatches/fixer--6e66fe/garden/roles/COMMON.md`
2. `/home/kris/dispatches/fixer--6e66fe/garden/roles/fixer/AGENT.md`
3. Other skills referenced just-in-time.

Project worktree at `project/` on `mirror/3164-freezable-typedarrays`
(head `4f28fc697`).

## Report

A `result` journal entry. Include:

- Per-step verdict (applied / partial / blocked).
- Per-step new head SHA + commit message.
- Tests added per step.
- Local gate exit codes.
- Top-level PR comment ID.
- Any judgment calls (especially: spackle install race
  shape; eslint rule scope decisions).
- Note on whether the README rewrite was completed in this
  dispatch or deferred.
