---
title: Abstract
source: packages/marshal/src/encodePassable.js
source_kind: comment-fragment
source_repo: endojs/endo
source_path: packages/marshal/src/encodePassable.js
source_line_range: "86-158"
source_commit: e6192056a5d7ff5acb084f6a58dca3663aa9943e
comment_subject: "IEEE-754 double-to-bits encoding with sign-aware bit-complement so the base-16 ASCII of the bytes sorts lexicographically in the same order the floats sort numerically; lockdown-independent NaN canonicalization with a WebIDL-shaped canonical NaN constant"
ingested: 2026-05-29
ingested_by: scholar
topics: [marshal, pass-style]
status: current
parent: endo--packages-marshal-src-encodepassable-js--number-encoding-binary64-bit-complement
---

`encodePassable.js`'s number encoder converts each JavaScript number
to a 16-hex-digit string prefixed by `f` such that the **lexicographic
sort order of the encoded strings matches the numeric sort order of
the original numbers**. The mechanism is a sign-aware bit-complement
of the IEEE-754 double's bit pattern: for positive values the sign
bit is flipped (so the sign-bit-zero encoding sorts above the
sign-bit-one encoding); for negative values *all* bits are flipped
(so larger negative magnitudes, which originally have larger
unsigned bit patterns, become smaller unsigned bit patterns and
sort below smaller negative magnitudes). The function also performs
two normalizations that the surrounding code points out are
not free: it normalizes `-0` to `0` (because the IEEE encoding of
the two differs but they compare equal under `===`), and it
substitutes a single **canonical NaN bit pattern** (`0x7ff8000000000000n`,
matching the WebIDL "unrestricted double" canonical NaN) for any
input that is NaN. The NaN substitution is performed *here* rather
than relying on lockdown's NaN canonicalization because
`@endo/marshal` does not depend on `ses`, so it cannot assume
`lockdown()` has been called and `DataView` has been tamed.

Source: [packages/marshal/src/encodePassable.js](https://github.com/endojs/endo/blob/e6192056a5d7ff5acb084f6a58dca3663aa9943e/packages/marshal/src/encodePassable.js#L86-L158) at commit `e6192056`.
