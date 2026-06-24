---
kind: dispatch
role: builder
host: endolinbot
posture: liaison
short_id: 87c239
dispatch_root: dispatches/builder--87c239
repo: endojs/endo-but-for-bots
branch: feat/narrow-bytearray-to-uint8
pr_number: 475
model: sonnet
---

RSVP kriskowal's comment on PR #475 (id 4774064120,
2026-06-22T23:26:16Z):

> Please arrange for a test262 style test in our test262-harness
> that validates parity between XS+SES and Node.js+SES for the
> usage of pass-style bytes using `@endo/pass-style/*` bytes
> modules, such that we can be sure that the same usage patterns
> work for both the shimmed frozen-array-view-of-immutable-array-
> buffer (passable byte array) and their native equivalent. This
> will provide coverage over both paths through the shim.

Builder brief: locate the existing test262-harness in this repo
(likely `packages/test262-runner/` or similar), add a parity test
that exercises `@endo/pass-style/encode-utf8`, `decode-utf8`,
`strict-decode-utf8`, `concat-bytes`, `compare-bytes` (and
`to-bytes`, `from-bytes`) under both XS+SES and Node.js+SES, with
the same usage patterns. Cover both shimmed and native paths
through the immutable-arraybuffer shim.
