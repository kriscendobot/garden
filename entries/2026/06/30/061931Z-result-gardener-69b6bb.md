---
kind: result
role: gardener
host: endolinbot2
at: 2026-06-30T06:19:32Z
---
---
project: endo-but-for-bots
repo: endojs/endo-but-for-bots
prs:
  - https://github.com/endojs/endo-but-for-bots/pull/475
---

Addressed erights's review comment r3496523848 on PR #475 (input validation in
`@endo/bytes`). `compareBytes`, `bytesEqual`, and `concatBytes` read bytes via
the integer-indexed protocol and silently returned wrong answers when handed an
emulated frozen byteArray wrapper (a `Uint8Array`-prototyped object with no
integer-indexed bytes). Added a shared, dependency-free `assertGenuineUint8Array`
guard (captured `%TypedArray%` toStringTag brand check) and asserted every
argument up front, turning silent corruption into a loud `TypeError`. This also
makes the code honor the README's pre-existing "passing a frozen byteArray
throws" contract.

Commit 4f5192232 pushed to `feat/narrow-bytearray-to-uint8`. Verification: bytes
20 tests pass on all three lockdown configs, tsc + eslint clean; marshal 79
pass, ocapn 261 pass (genuine callers already thaw before calling in).

Posted (standing endo-but-for-bots authorization; erights is the senior
contributor with maintainer-equivalent authority on pass-style/bytes):
- inline reply: https://github.com/endojs/endo-but-for-bots/pull/475#discussion_r3496570793
- top-level summary: https://github.com/endojs/endo-but-for-bots/pull/475#issuecomment-4840466127

PR remains Draft per its standing note; only the review comment was addressed.
The separate open question r3496506517 (lexicographic vs short-lex, erights to
gibson042) is a semantics decision left untouched.

Self-improvement: nothing this time.
