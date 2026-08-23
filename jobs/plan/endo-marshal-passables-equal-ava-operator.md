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

## Reviewer-supplied concrete sketch (gibson042, review 5003580709)

@gibson042 seconded the request and posted a concrete implementation sketch
on the same thread (comment id 3839822712, reply to 3836343387):
https://github.com/endojs/endo-but-for-bots/pull/475#discussion_r3839822712

His shape: `passablesEqual(t, actual, expected, message)` that internally
does `t.deepEqual(makeComparable(actual), makeComparable(expected))` — i.e.
the "delegate to deepEqual for structure, byte-level for leaves" option
above, realized concretely. Building blocks in the sketch:

- `getDiffs(actual, expected, path=[])` — recursive passStyle-aware compare
  that returns a list of `{ path, actualPassStyle, expectedPassStyle,
  actual, expected }` divergences; primitives / error / promise / remotable
  compare by identity, `byteArray` via `compareByteArrays`, records/arrays
  recurse (tracking `<missing>` keys on either side).
- `makeComparable(value, diffs)` — projects a passable into a plain
  deepEqual-able shadow only along the diverging paths: byteArrays become
  `{ value: toHex(value) }` tagged with `Symbol.toStringTag`, identity
  passables become `{ comparableId, value }`, records/arrays map through.
- `pathKeyToString(key)` and `makeAssertionMessage(detail, prefix)` render a
  readable "Divergences at paths: […]" assertion message.

The eventual worker should build FROM this sketch, not copy it verbatim: it
carries small defects to fix — the top-level-path branch reads
`diffs[0].expectedStyle`/`actualStyle` where the objects use
`expectedPassStyle`/`actualPassStyle`; `getDiffs`'s extra-actual-key branch
references `key` outside its loop scope (should be `actualKey`); and it
assumes `compareByteArrays` and `toHex` imports. Treat it as the design
input that answers "how", pending the design step's decision on WHERE it
lives (ses-ava's `t` wrapper vs. a marshal test helper) and whether to reach
for concordance instead.
