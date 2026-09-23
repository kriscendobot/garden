---
ts: 2026-06-17T22:23:04Z
kind: result
role: fixer
repo: endojs/endo-but-for-bots
project: endo
refs:
  - entries/2026/06/17/222000Z-dispatch-fixer-a37e0f.md
---

Round 3 on PR #449 (DRAFT design PR: freezable TypedArray emulation).

## Pre-push-gates

The `no-pull-citations` probe fails against the full branch diff (comparing
against `origin/master` because HEAD is detached with no upstream reference).
This failure is pre-existing in the branch prior to this fixer dispatch;
the design document legitimately cites PR numbers throughout its body.
My edits add no new pull-citation violations (confirmed by diffing only the
working-tree changes before staging).
All other probes pass: no-ascii-banners, no-inline-import-jsdoc,
no-non-ascii-in-source, security-md-hash-uniform, sentence-per-line-md,
test-package-no-main, filename-no-stutter.

## Commits

Pre-dispatch HEAD: `ba4703bd5`

**Commit `cc55ec895`** - `design(immutable-arraybuffer): spell out permits.js delta and name bytes adapters (panel r3 must-fix)`

Files modified:
- `packages/immutable-arraybuffer/designs/freezable-typedarray.md`

Addresses must-fix-loop #1 (critic) and must-fix-loop #2 (skeptic) from
solicitor r2 verdict at review `4520012627`.

## Must-fix-loop items addressed

### Must-fix #1 (critic): permits.js delta

Added a `#### permits.js delta` sub-section immediately after the *Files added
or modified* table in *Implementation outline*.
The sub-section shows the current `%TypedArrayPrototype%` entry in
`packages/ses/src/permits.js` at `master` (`4a04d078b`): `buffer: getter`
already present, all five mutator methods already present as `fn` entries.
Explains that `virtualTypedArrayBufferGetter` is a getter replacing a getter,
so no new permit row or row-type change is required.
Notes that if the ses-side integration test surfaces an unexpected gap, the
builder patches at that time; the expected outcome is no gap.

The table row for `packages/ses/src/permits.js` was updated from the vague
"extend the %TypedArrayPrototype% permits entry to cover the shim-installed
slots (buffer accessor replacement)" to "see *permits.js delta* sub-section
below".

### Must-fix #2 (skeptic): @endo/bytes withdrawal scope

Replaced the vague "adapter functions that bridge between frozen Uint8Array
instances..." paragraph with a named enumeration:
- `bytesToImmutable(view)` from `packages/bytes/src/to-immutable.js`: wraps a
  Uint8Array view into a hardened immutable ArrayBuffer via sliceBufferToImmutable.
  Post-shim direct pattern: `Object.freeze(new Uint8Array(ab.sliceToImmutable()))`.
- `bytesFromImmutable(buffer)` from `packages/bytes/src/from-immutable.js`:
  copies an immutable ArrayBuffer into a fresh mutable Uint8Array.
  Post-shim direct pattern: `new Uint8Array(immutableAb.slice(0))`.

The paragraph following the bullet list now names both functions explicitly
("both bytesToImmutable and bytesFromImmutable can be withdrawn").

## Inline replies posted

- `r3431690105` (id 3431690105): erights ask "please collapse into lib.js; the
  separate immutable-arraybuffer-pony-internal.js no longer serves any purpose."
  Reply posted at `https://api.github.com/repos/endojs/endo-but-for-bots/pulls/comments/3431815146`
  Cites commit `aab2af75d`; confirms the design now reads that the experiment
  branch's separate file does not survive the post-#435 merge and the design
  extends a single lib.js.

- `r3431697346` (id 3431697346): erights ask "please just delete internal-heir.js."
  Reply posted at `https://api.github.com/repos/endojs/endo-but-for-bots/pulls/comments/3431815540`
  Cites commit `aab2af75d`; confirms the builder does not port the helper and
  the design's open question is closed.

## Head SHAs

- Pre-dispatch: `ba4703bd5`
- Post-dispatch: `cc55ec895`

## Recommended next stage

next: solicitor for PR #449 round 3.

Self-improvement: when a git stash pop produces a conflict the working-tree edits are lost; always prefer to re-read and re-apply edits rather than relying on stash for worktree-state preservation during probe testing.
