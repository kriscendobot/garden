---
ts: 2026-06-09T03:13:26Z
kind: result
role: fixer
host: endolinbot
repo: endojs/endo-but-for-bots
project: endo-but-for-bots
worktree: dispatches/fixer--3642b3/project
prs:
  - repo: endojs/endo-but-for-bots
    pr: 430
    role: target
refs:
  - https://github.com/endojs/endo-but-for-bots/pull/430
  - https://github.com/endojs/endo-but-for-bots/pull/430#issuecomment-4655619577
  - https://github.com/endojs/endo-but-for-bots/pull/430#issuecomment-4655451705
  - https://github.com/endojs/endo-but-for-bots/pull/430#issuecomment-4655677131
  - https://github.com/endojs/endo-but-for-bots/actions/runs/27180009707
---

# result: fixer diagnosed PR #430's 12 CI failures per erights @-mention

## Ask

erights (`#issuecomment-4655619577`): "please diagnose the CI
failures. Would these failures disappear after you do as I
requested in `#issuecomment-4655451705`?"

## Verification

- PR head: `a5e31162903dced8920eb153e16a256152ab39f2`.
- CI run head SHA confirmed: workflow run
  [27180009707](https://github.com/endojs/endo-but-for-bots/actions/runs/27180009707)
  ran on `a5e31162...` (matches PR head; CI is current).
- Rollup: 3 SUCCESS / 12 FAILURE / 0 PENDING.

## Failure categories examined

Pulled logs from six representative jobs across categories:

| job-id | name | failed step |
| --- | --- | --- |
| 80236875338 | lint | Run yarn build |
| 80236875371 | test (22.x, ubuntu-latest) | Run yarn build |
| 80236875332 | cover | yarn build |
| 80236875374 | test-xs | Run yarn build |
| 80236875327 | test-hermes | Run yarn build |
| 80236875344 | test262 (22.x, ubuntu-latest) | yarn build |
| 80236875358 | test-ocapn-python | Build Endo |
| 80236875350 | viable-release | build |

All eight emit the identical exception text at the `yarn
build` step in the `ses` workspace:

```
SES_UNCAUGHT_EXCEPTION: TypeError#1: Unexpected [[Prototype]] at
  intrinsics.%BigInt64ArrayPrototype%.__proto__ (expected %TypedArrayPrototype%)
  at visitPrototype       (packages/ses/src/permits-intrinsics.js:155:11)
  ...
  at removeUnpermittedIntrinsics (packages/ses/src/permits-intrinsics.js:282:3)
  ...
  at globalThis.lockdown (packages/ses/src/lockdown-shim.js:16:28)
```

No job runs its own logic (lint, ava, c8, etc.); they all
abort at the shared build step. **Single root cause, 12
downstream FAILURE conclusions.**

## Root cause

The shim's `makePseudoTypedArrayConstructor`
(`packages/immutable-arraybuffer/src/freezable-typedarray-pony.js`
line 170) replaces each TypedArray constructor's `.prototype`
slot with `PseudoTypedArrayPrototype`, whose `[[Prototype]]`
is `freezableTypedArrayInternalPrototype` (a
`makeInternalHeir` of `%TypedArrayPrototype%`). After install,
`BigInt64Array.prototype.__proto__` is the internal heir, not
`%TypedArrayPrototype%`.

`packages/ses/src/permits.js` line 393 declares every
`TypedArrayPrototype('Foo')` entry as
`'[[Proto]]': '%TypedArrayPrototype%'`. The intrinsic walk in
`permits-intrinsics.js` `visitPrototype` rejects the
mismatch on the first TypedArray it encounters
(`BigInt64Array` alphabetically).

The `'%FreezableTypedArrayPrototype%'` entry added to
`permits.js` (line 1199) is structurally unreachable: it is
not referenced from any constructor's `prototype` entry, so
adding it does not satisfy the per-constructor `[[Proto]]`
invariant.

## Answer to erights's question

**Yes.** Under the redesign proposed in
`#issuecomment-4655451705`:

- Rename pony → lib (file rename only; not load-bearing for
  this failure).
- Pseudo-prototypes become **property records** the shim
  copies onto the actual `%TypedArrayPrototype%` (and per-
  subclass prototypes).
- No pseudo-constructors; no constructors reference pseudo-
  prototypes.
- Remove `%FreezableTypedArrayPrototype%` from `permits.js`.

`BigInt64Array.prototype.[[Prototype]]` then remains the
genuine `%TypedArrayPrototype%`, `visitPrototype` passes, and
`lockdown` succeeds. The "drop-in replacement" methods live
on the genuine prototype itself, switching internally on
emulated vs. genuine `this`. No new intrinsic exists to permit.

## Action taken

Posted the diagnostic reply as
[#issuecomment-4655677131](https://github.com/endojs/endo-but-for-bots/pull/430#issuecomment-4655677131)
on PR #430.

## Authorizations honored

- **Reply comment** on PR #430: posted (per dispatch brief).
- **Push CI-fixables**: NOT exercised. The single root cause
  is not surgical-scope CI noise; it is the design signal the
  redesign addresses. Pushing a permits-bandaid ahead of the
  redesign would just be rework, as noted in the reply.
- **Flake re-runs**: NOT exercised. The 12 failures are not
  flakes; they are deterministic and stem from the same
  installed shim under SES lockdown.
- **NOT re-request review**: honored.
- **NOT touch other PRs**: honored. Only PR #430 was inspected.
- **NOT regress premise-2**: honored. No code or branch change.

## Out of scope honored

- No code push to the PR branch.
- No panel / judge dispatch.
- No edits to other PRs or repos.

Self-improvement: nothing this time.
