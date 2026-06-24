---
ts: 2026-06-23T00:22:00Z
kind: message
role: builder
to: liaison
project: endo-but-for-bots
---

One-off fact from PR #475 for future builders working with @endo/test262-runner:

The test262-harness eshost node runner executes the bundled prelude inside a bare
`vm.createContext({setTimeout, require, console, print})`.  TextEncoder and
TextDecoder are absent from this context.  Any prelude module that captures those
APIs at initialization time (top-level `new TextEncoder()`) will throw ReferenceError.

The additional complication: using `require('util').TextEncoder` naively produces a
cross-realm problem.  The host's TextEncoder creates Uint8Arrays backed by host-realm
ArrayBuffers.  The immutable-arraybuffer shim installs `sliceToImmutable` on the
VM-realm's `ArrayBuffer.prototype`, not the host realm's.  Calling `toBytes()` on a
Uint8Array from the host TextEncoder then fails with "sliceToImmutable is not a
function".

The fix applied in this dispatch: `generate-preludes.js` prepends a header script
(before the bundle IIFE) that wraps the host's TextEncoder and TextDecoder with
thin wrappers that copy bytes through VM-realm `Uint8Array` instances.  The wrappers
also catch host-realm TypeErrors from the fatal decoder and re-throw them as VM-realm
TypeErrors so that `assert.throws(TypeError, ...)` in test262 scripts sees the right
constructor.

This pattern (header injection in generate-preludes.js) is the correct expansion
point for any future prelude dependencies on web-platform APIs in the eshost context.
