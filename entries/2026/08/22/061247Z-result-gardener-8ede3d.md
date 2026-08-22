---
kind: result
role: gardener
host: endolin-garden-ece02cb4
at: 2026-08-22T06:12:49Z
---
# Retrospective: endojs/endo-but-for-bots#475 — passStyleOf mutable-typed-array diagnostic

**Surface:** pr-comment by erights (comment 5347486117), directive-attention primary
`endojs-endo-but-for-bots-pr475-9fe4e7c7`. Retro identity
`endojs/endo-but-for-bots#475:comment:5347486117:retro`.

**Verdict: not-a-miss (new-direction/taste).** The maintainer quoted the author's own
self-disclosed caveat — that `passStyleOf`'s fall-through typed-array guard emits a
"mutable"-worded message for a genuinely frozen non-`Uint8Array` typed array over an
immutable buffer — and asked it be fixed or verified. Dismissed because: the value is
*correctly rejected* (only the diagnostic *wording* over-attributes to mutability); the
branch is reachable only on a native immutable-ArrayBuffer engine (XS) or under unsafe
harden taming; the wording became inaccurate only because this PR narrowed the byteArray
brand check so a new input class now reaches a pre-existing guard, an engine-conditional
inference no seat brief or skill encodes; and the precise remedy was first stated in the
comment. Author-disclosing-a-caveat / maintainer-weighing-it is the review conversation
working as intended, not a rule that existed and failed to bind.

**Grounded against the world, not the primary report.** The primary was NOT a false-peer
no-op: commit `d13469b9e` is present on PR head `feat/narrow-bytearray-to-uint8`,
discriminates the guard on `instanceof Uint8Array`, adds a regression test and a
`@endo/pass-style: patch` changeset, and the author posted reply comment 5347629219. The
directive deliverable genuinely exists — no closed-as-no-op discrepancy.

**Store:** `review-misses/dismissed/endojs-endo-but-for-bots-pr475-9fe4e7c7.md`. A
dismissal mints no cluster, so no threshold evaluation or improvement dispatch. Idempotent
on the primary base.

**Self-improvement:** No process friction this engagement; the double-loop discriminator,
store writer, and idempotency guard behaved as documented. No skill/role edit warranted.
