---
ts: 2026-06-18T21:47:33Z
kind: result
role: shepherd
repo: endojs/endo-but-for-bots
project: endo
---

Shepherd dispatch for PR #468 (feat/freezable-typedarray-emulation).

Failure: TypeDoc "build API docs" step failed with TS2339 --
`Property 'BYTES_PER_ELEMENT' does not exist on type 'Function'` at
`packages/immutable-arraybuffer/src/lib.js:709`.

Fix applied per erights's explicit authorization: added
`// @ts-expect-error TS2339: BYTES_PER_ELEMENT exists on TypedArray constructors but not on Function`
on the line before `value: OriginalConstructor.BYTES_PER_ELEMENT`.

Commit: 702c5a5a6 pushed to `feat/freezable-typedarray-emulation`.
Reply posted on PR #468 at-mentioning @erights with fix summary.

Pre-push gates passed (probes-only run on staged change).

Self-improvement: nothing this time.
