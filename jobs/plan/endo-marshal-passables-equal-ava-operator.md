---
gate: deferred
priority: normal
posted_by: designer
posted_at: 2026-08-23T03:12:08Z
---

---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
# ava context patch: byteArray-aware passablesEqual operator

Follow-up from the kriskowal review on endojs/endo-but-for-bots PR #475
(inline comment on packages/marshal/test/marshal-smallcaps.test.js:56):
"How much trouble would it be to introduce an `ava` context patch that
provides a `passablesEqual` operator with the same diagnostic detail as
`deepEqual` but taking byte arrays into account?"

Motivation: several marshal round-trip tests special-case `byteArray`
passables by spreading them into plain arrays before `t.deepEqual`, because
ava's `deepEqual` does not compare emulated/immutable byte arrays
structurally. A `t.passablesEqual(a, b)` operator that falls back to
deepEqual for non-byteArray values and does a readable structural byte
compare for byteArrays would remove the aberration and read cleanly.

Effort assessment (recorded on the PR thread): moderate and self-contained.
ses-ava already wraps ava's `t`, so the operator can live there (or in a
marshal test helper). The "same diagnostic detail as deepEqual" requirement
is the interesting part: ava's diff detail comes from concordance, so either
teach concordance to render passable byteArrays, or implement a comparator
that delegates to deepEqual for the non-byteArray structure and produces a
byte-level diff for byteArray leaves. Design + build follow-up; out of scope
for the byteArray-narrowing PR itself.
