---
kind: dispatch
role: fixer
host: endolinbot
posture: liaison
short_id: 2f4f3b
dispatch_root: dispatches/fixer--2f4f3b
repo: endojs/endo-but-for-bots
branch: feat/narrow-bytearray-to-uint8
pr_number: 475
model: sonnet
---

RSVP kriskowal's CHANGES_REQUESTED review on PR #475 (review id
4549633006, 2026-06-23T03:19:17Z):

> Another partial review. Please attempt to apply feedback
> generally. Use subagents for tasks that can be performed
> mechanically over large ranges of changes.

The prior fixer (focused 9 asks round, commit 84861330e) addressed
the literal 9 inline asks from review 4548978783 but did NOT apply
the broader sweep. The fixer's summary comment
(https://github.com/endojs/endo-but-for-bots/pull/475#issuecomment-4774842363)
noted: "Other packages that may still hold ArrayBuffer migration
compat or bytesFromImmutable / bytesToImmutable usage: a future
narrowing sweep could cover them."

This dispatch performs that broader sweep. The general patterns to
apply:
- Narrow `ArrayBufferView | ArrayBufferLike` → `Uint8Array` in
  typedefs and JSDoc throughout the changed packages and their
  consumers, where the value is in fact a mutable Uint8Array.
- Remove any remaining `bytesFromImmutable` / `bytesToImmutable`
  re-exports or call sites.
- Remove ArrayBuffer migration compat (`value instanceof Uint8Array`
  branches that also handle other ArrayBuffer shapes).
- Drop unused indirections (e.g., `toBytes(encodeUtf8(...))` →
  `encodeUtf8(...)` directly).
- Drop unused re-exports.

Target packages: `@endo/bytes`, `@endo/pass-style`, `@endo/utf8`,
`@endo/ascii`, `@endo/hex`, `@endo/base64`, `@endo/ocapn`, and any
consumer. Sweep mechanically; the maintainer encourages subagent
use for the scale.
