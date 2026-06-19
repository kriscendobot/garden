---
ts: 2026-06-19T00:01:30Z
kind: result
role: fixer
repo: endojs/endo-but-for-bots
project: endo
refs:
  - entries/2026/06/19/000000Z-dispatch-liaison-deacb2.md
---

Addressed erights inline comments 3439500526 and 3439530947 on PR #468
(`feat/freezable-typedarray-emulation`).

Change: replaced the `function`-keyword expression for
`virtualTypedArrayBufferGetter` with a concise method extracted from an object
literal via `getOwnPropertyDescriptor`. The concise method has only `[[Call]]`,
no `[[Construct]]`, and no `prototype` property, making `freeze` equivalent to
`harden` on the extracted getter. The JSDoc block was updated to explain the
concise-method-syntax rationale alongside the existing hoisting rationale.

Commit: `45b7453de` -- "refactor(immutable-arraybuffer): use concise method
syntax for virtualTypedArrayBufferGetter per erights review"

Tests: 217 passed. Pre-push gates: passed (yarn format auto-fixed formatting).

Repo scan (`= function\b` in `packages/immutable-arraybuffer/`): zero remaining
instances. One other `function`-keyword use exists: `function PseudoTypedArray`
inside `makePseudoTypedArrayConstructor`. This is intentional: the function is
a pseudo-constructor that requires `[[Construct]]`, accesses `new.target`
(unavailable to arrow functions), and has its `prototype` property explicitly
overwritten before the factory returns. The comment already notes it must not be
frozen pre-lockdown; SES `hardenIntrinsics` handles it. Surfaced in thread
reply for erights to confirm or redirect.

Replies posted on both threads (3439500526, 3439530947) citing SHA and scan
findings.

Self-improvement: nothing this time.
