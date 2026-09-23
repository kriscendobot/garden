---
kind: review-miss-dismissed
primary_job: endojs-endo-but-for-bots-pr475-9fe4e7c7
verdict: not-a-miss
category: new-direction
review_at: 2026-08-19T20:15:05Z
repo: endojs/endo-but-for-bots
comment_url: https://github.com/endojs/endo-but-for-bots/pull/475#issuecomment-5347486117
identity: endojs/endo-but-for-bots#475:comment:5347486117
---

On the byteArray-narrowing PR, the maintainer quotes the author's own written caveat —
that `passStyleOf`'s fall-through typed-array guard also fires, with a "mutable"-worded
message, for a genuinely frozen non-`Uint8Array` typed array over an immutable buffer —
and asks that it be fixed or verified already fixed, on the devex ground that an error
blaming mutability when mutability is not the problem is misleading.

Grounds: this is a taste/quality-bar judgment call on a transparently self-disclosed,
edge-only diagnostic *wording* issue, not an indictment of the review process, so it is
dismissed as new-direction. Three grounded reasons. (1) It is not a correctness bug: the
value is *correctly rejected* in every case; only the explanatory string over-attributes
the cause to mutability. (2) The scenario is only constructible on a native
immutable-ArrayBuffer engine (XS) or on the Node shim leg under `LOCKDOWN_HARDEN_TAMING=
unsafe` — a rarely-reached branch, not the common lockdown/Node path — as the author's own
fix commit `d13469b9e` and completion report both attest. (3) The wording became newly
inaccurate *only because this PR narrowed* the byteArray brand check so that frozen
non-`Uint8Array` typed arrays now fall through to a pre-existing guard whose message was
accurate before the narrowing; catching it required the multi-step, engine-conditional
inference "narrowing diverts a new input class to this guard → the guard's existing
message is now false for that class → and that class is only realizable on XS/unsafe
taming." No garden seat brief, skill, or standing instruction encodes "when you narrow a
brand check, re-audit each downstream guard's error wording for the newly-diverted
inputs," so the panel had no written convention to bind to; and the precise remedy —
discriminate the message on element-type vs mutability — was first crisply stated in the
maintainer's comment, not before it. The author disclosing a known caveat and the
maintainer weighing whether to accept it or demand a fix is the maintainer-review
conversation working as intended, the classic new-direction/taste shape, not a
sense-and-correct failure with a rule that already existed and did not bind.

Verified against the world, not the primary report: the primary was not a false-peer
no-op — it did real work. Commit `d13469b9e` ("fix(pass-style): don't blame mutability
for a non-Uint8Array typed array") is present on the PR head `feat/narrow-bytearray-to-
uint8`, discriminates the guard on `instanceof Uint8Array` (keeping the accurate "mutable"
message for a mutable-backed `Uint8Array`, emitting "Cannot pass typed arrays other than
Uint8Array" for a non-`Uint8Array`), adds a regression test and a `@endo/pass-style: patch`
changeset, and the author posted an explanatory reply (comment 5347629219). The directive
deliverable therefore genuinely exists — there is no closed-as-no-op discrepancy to report.
