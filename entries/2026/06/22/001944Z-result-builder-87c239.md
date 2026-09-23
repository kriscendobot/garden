---
ts: 2026-06-23T00:19:44Z
kind: result
role: builder
repo: endojs/endo-but-for-bots
project: endo-but-for-bots
refs:
  - entries/2026/06/22/001944Z-result-builder-87c239.md
---

RSVP to kriskowal comment id=4774064120 on PR #475 requesting a test262-style
parity test for the pass-style bytes modules.

Added 13 test262-style tests under:
`packages/test262-runner/test262/test/built-ins/ImmutableArrayBuffer/pass-style-bytes/`

All 13 files carry `features: [ses-xs-parity, immutable-arraybuffer, pass-style-bytes]`
and are picked up by both `test262:node` and `test262:xs` via the existing
`--features-include ses-xs-parity` filter.

Tests cover all six modules: `toBytes`, `fromBytes`, `concatBytes`, `encodeUtf8`,
`decodeUtf8`, `strictDecodeUtf8` across a range of inputs including empty, full
byte range, subarray windows, malformed UTF-8 (lenient and strict), and round-trips.

A shim-vs-native path test verifies that `sliceToImmutable` is present and the
passable byteArray shape is correct regardless of whether the
`@endo/immutable-arraybuffer` shim ran or a native engine implementation was
detected and skipped.

Harness additions:
- `src/node-prelude.js` and `src/xs-prelude.js`: expose the six pass-style modules
  as globals for test262 test files.
- `scripts/generate-preludes.js`: prepend a cross-realm TextEncoder/TextDecoder shim
  to the bundled node prelude. The eshost node runner's `vm.createContext` lacks these
  web-platform APIs; the shim wraps the host's `util.TextEncoder`/`TextDecoder`, copying
  bytes through VM-realm `Uint8Array` values to avoid a cross-realm ArrayBuffer mismatch
  that would cause `buf.sliceToImmutable` to appear absent on the host realm's prototype.
- `package.json`: added `@endo/pass-style` and `@endo/utf8` as workspace dependencies;
  `tsconfig.composite.json` regenerated.

Local results: 26/26 new tests pass under Node.js+SES. XS binary not installed locally;
CI (test-xs job) will exercise that path. Two pre-existing Compartment/lockdown failures
are unrelated to this change.

New HEAD: ce8d05782743410efb75818626cd2cfb5c551f68
Lease anchor: 6a9d11152
Summary comment: https://github.com/endojs/endo-but-for-bots/pull/475#issuecomment-4774346293

Self-improvement: the test262-harness eshost node runner uses `vm.createContext` with
only `{setTimeout, require, console, print}`, which excludes TextEncoder/TextDecoder.
Preludes that import modules which eagerly capture those globals at initialization time
need a cross-realm wrapper that copies bytes into VM-realm Uint8Arrays before the bundle
IIFE runs. Future builder dispatches to `@endo/test262-runner` that add prelude
dependencies on web-platform APIs should route through `generate-preludes.js` header
injection, not through the ESM bundle itself.
