---
title: Problem and detection strategy — ponyfill-shim pattern for TC39 native base64 intrinsics
source: designs/base64-native-fallthrough.md
source_repo: endojs/endo-but-for-bots
source_branch: llm
source_commit: 102a94bc9a36cac4d98ca24bc7c6e3dd9820d2a3
source_date: 2026-04-23
source_authors: [Kris Kowal]
topics: [tooling, hardened-javascript]
status: current
notes: **Status: Not Started** upstream. Third member of the *vetted-shim-or-ponyfill* design family alongside `hardened-url-shim` and `hardened-text-codecs-shim`. The detection-and-capture-before-lockdown pattern shared with the two prior shims gets its first full treatment here as a deliberate API discipline. Sibling design `@endo/hex` applies the identical structure to `Uint8Array.fromHex` / `Uint8Array.prototype.toHex`.
kind: index
section_count: 3
---

`@endo/base64` is on the hot path of the Endo stack: every byte that
crosses a CapTP boundary, every `endoZipBase64` bundle envelope, every
`streamBase64` daemon call, every `@endo/exo-stream` reader/writer
flows through `encodeBase64` / `decodeBase64`. The package today
implements both in pure JavaScript — correct on every engine, including
XS, but measurably slower and larger than the engine-native
implementations now shipping under the TC39 *"Uint8Array to/from
base64"* proposal (stage 3, in V8, SpiderMonkey, JavaScriptCore, and
Node.js 22+).

The native intrinsics:

- `Uint8Array.fromBase64(string, options?) → Uint8Array` — static method.
- `Uint8Array.prototype.toBase64(options?) → string` — instance method.
- `Uint8Array.prototype.setFromBase64(string, options?) → { read, written }` — write-into-existing-buffer variant; not used here.

The native implementations run an order of magnitude faster on short
strings and several orders of magnitude faster on the megabyte-scale
inputs common for bundle transfer, and shipping them as the default
would also remove a few kilobytes of polyfill code from every bundle
that includes `@endo/base64`.

Sections:

- [Why a new pattern is needed](endo-but-for-bots--llm-designs-b64nf--problem-and-detection-strategy--why-a-new-pattern-is-needed.md)
- [The ponyfill-shim pattern (detection + capture-before-lockdown)](endo-but-for-bots--llm-designs-b64nf--problem-and-detection-strategy--the-ponyfill-shim-pattern-detection-capture-before-lockdown.md)
- [Why this is a family, not a one-off](endo-but-for-bots--llm-designs-b64nf--problem-and-detection-strategy--why-this-is-a-family-not-a-one-off.md)
