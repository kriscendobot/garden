---
kind: dispatch
role: fixer
host: endolinbot
posture: liaison
short_id: 11fa53
dispatch_root: dispatches/fixer--11fa53
repo: endojs/endo-but-for-bots
branch: feat/narrow-bytearray-to-uint8
pr_number: 475
model: sonnet
---

RSVP kriskowal's CHANGES_REQUESTED review on PR #475 (review id
4548978783, 2026-06-23T00:20:52Z):

> @kriscendobot This is an incomplete review. Please note that many
> of these comments pertain more broadly than explicitly cited and
> should be cross-checked against the changes broadly.
>
> On this pull request, I am particularly hoping that `@endo/pass-style`
> will avoid copying the bytes of an byte array into a uint8array
> just for the sake of passing to a function that does not alter
> the interior. I would like `@endo/bytes` to deal exclusively in
> mutable Uint8Array.

Plus 9 unresolved inline comments (fixer to enumerate via
`gh api 'repos/.../pulls/475/comments' --jq '.[]|select(.pull_request_review_id == 4548978783)'`).

Direction (refinement of the prior parallel-routines approach):
- `@endo/bytes` deals EXCLUSIVELY in mutable Uint8Array (strict).
- `@endo/pass-style/*-bytes.js` MUST NOT copy when the underlying
  operation is read-only. Expose / use the shim's underlying
  mutable storage for the read-only paths.
- Cross-check the cited inline asks against ALL changed files —
  the maintainer's "many of these comments pertain more broadly"
  is a directive to extrapolate.

Per memory `feedback_auto_escalate_fixer_resume_gamut.md`, the
fixer chain authorization extends through to gamut termination.
