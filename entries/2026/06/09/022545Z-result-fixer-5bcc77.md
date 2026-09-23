---
ts: 2026-06-09T02:25:45Z
kind: result
role: fixer
host: endolinbot
repo: endojs/endo-but-for-bots
project: endo-but-for-bots
worktree: dispatches/fixer--5bcc77/project
prs:
  - repo: endojs/endo-but-for-bots
    pr: 430
    role: target
refs:
  - https://github.com/endojs/endo-but-for-bots/pull/430
  - https://github.com/endojs/endo-but-for-bots/pull/430#issuecomment-4655393379
  - https://github.com/endojs/endo-but-for-bots/pull/430#issuecomment-4641694062
---

# result: fixer: premise 2 landed on PR #430 per erights's option (a)

Applied erights's directive on PR `endojs/endo-but-for-bots#430`
(top-level reply 4655393379 to the original premise-2 deferral
question 4641694062): option (a), migrate `@endo/bytes` to call
the shim-installed `ArrayBuffer.prototype.sliceToImmutable`,
have `@endo/bytes` import the shim itself so the race-to-install
handles eval-twin, and restrict the
`@endo/immutable-arraybuffer` package exports to the shim only.

Pre-head `740259d2b`, post-head `de03c8026` (one commit).

## Commit

| sha | headline |
| --- | -------- |
| `de03c8026` | feat(immutable-arraybuffer): premise 2: migrate @endo/bytes to shim method, restrict package exports to shim |

## Changes

- **`packages/bytes/src/to-immutable.js`**:
  - Replaced `import { sliceBufferToImmutable } from '@endo/immutable-arraybuffer';` with a side-effect `import '@endo/immutable-arraybuffer/shim.js';`.
  - Body now reads `view.buffer.sliceToImmutable(view.byteOffset, view.byteOffset + view.byteLength)` instead of calling the pony function.
  - JSDoc rewritten to describe the shim-method shape and to note that `@endo/bytes` imports the shim itself, so callers do not need to arrange install order; the shim's race-to-install (`'sliceToImmutable' in arrayBufferPrototype` detect-then-skip) yields silently to any prior installer.

- **`packages/immutable-arraybuffer/package.json`**:
  - Dropped the `.` entry from `exports`. Remaining entries: `./shim.js` and `./package.json`.
  - The pony surface (`sliceBufferToImmutable`, `isBufferImmutable`, `optTransferBufferToImmutable`) is no longer reachable from outside the package; the shim is the sole public entry per premise 2.
  - The `main` and `module` fields still name `./index.js` and the file is retained as the in-package pony definition the shim transitively imports; the exports restriction is the operative encapsulation.

## Rebase

Local `project/` worktree was prepared at `1ef6c174d` (the
pre-prior-fixer tip named in this dispatch's brief). The
remote had advanced to `740259d2b` (the prior fixer's four
review-feedback commits, dispatch `fixer--aa4be4`). Rebased
the one new commit onto `740259d2b` cleanly (no conflicts);
the rebase changed the commit's parent and SHA from
`5d8ff5000` to `de03c8026`.

## Verification

- `yarn install` clean (one warning about pnpm linker peer
  dependencies, pre-existing).
- `cd packages/bytes && yarn lint`: clean (types + eslint).
- `cd packages/immutable-arraybuffer && yarn lint`: clean.
- `cd packages/immutable-arraybuffer && yarn test`: 50 passed,
  1 known expected-fail (the pre-existing
  `(TypedArray|Buffer).(slice|subarray) on freezable
  TypedArray` Buffer.prototype.subarray case).
- `cd packages/bytes && yarn test`: still fails with the
  pre-existing `@endo/harden` `make-hardener.js:264:1`
  assertion failure that already failed at `1ef6c174d`
  before this change (confirmed via stash + retry on the
  base SHA). This is the same class of pre-existing CI
  failure the prior dispatch documented; not introduced by
  this commit.

## Pre-push gate

Ran `pre-push-gates.sh --probes-only`. Same two pre-existing
`filename-no-stutter` findings on the
`immutable-arraybuffer-{shim,pony}*.js` files that the prior
fixer dispatch documented (oldest blame on master: well
before this branch). Not introduced. All other probes pass:
`no-ascii-banners`, `no-inline-import-jsdoc`,
`no-non-ascii-in-source`, `no-pull-citations`,
`security-md-hash-uniform`, `sentence-per-line-md`,
`test-package-no-main`.

## Reply posted

Top-level summary comment on PR #430 acknowledging erights's
direction and citing the addressing commit:
https://github.com/endojs/endo-but-for-bots/pull/430#issuecomment-4655439350

Did not reply on the original inline comments (those were
already addressed in `fixer--aa4be4`). Did not reply
threaded under erights's directive comment because the
top-level summary already cites the addressing SHA in the
same conversation.

## Out-of-scope items honored

- Did NOT re-request review (per dispatch authorization
  scope; the maintainer / senior contributor sets the pace
  on a draft experiment).
- Did NOT shepherd CI; the previously-pre-existing 12 CI
  FAILUREs from the original premise-2 deferral may now
  resolve with this change, but driving them green is
  out of this dispatch's scope.
- Did NOT touch other PRs.
- Did NOT trigger panel / judge.

Self-improvement: nothing this time.
