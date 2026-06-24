---
title: §No own-keys-count check — records have no count invariant
source-slug: endo--packages-pass-style-src-copyRecord-js
section-slug: CopyRecordHelper-third-PassStyleHelper-and-two-named-local-helper-functions-and-canBeMethod-guard-against-implicit-Remotable-and-work-distribution-between-phases-varies
source-url: https://github.com/endojs/endo/blob/master/packages/pass-style/src/copyRecord.js
source-repo: endojs/endo
source-path: packages/pass-style/src/copyRecord.js
source-author: Endo project (collective)
total-lines: 70
ingest-cycle: 264
ingest-date: 2026-06-10
lane: chat
parent: endo--packages-pass-style-src-copyRecord-js--CopyRecordHelper-third-PassStyleHelper-and-two-named-local-helper-functions-and-canBeMethod-guard-against-implicit-Remotable-and-work-distribution-between-phases-varies
---

In contrast to cycle 262 copyArray's `ownKeys(candidate).length === len + 1`, copyRecord has **no count check at all**. The implications:

- §a-record's-key-set-has-no-canonical-count-invariant — §the-keys-ARE-whatever-the-data-says-they-are.
- §the-side-channel-defense-is-different — §record-side-channels-can-only-come-via-non-string-keys-or-method-shaped-values + §those-are-caught-in-phase-1-not-via-count.
- §three-cycles-with-ownKeys-length-check-with-pass-style-specific-arithmetic-but-the-arithmetic-flavors-now-include-the-empty-set: byteArray `=== 0` + copyArray `=== len + 1` + copyRecord **no count check**; §three-cycles-with-pass-style-specific-side-channel-defense-but-not-always-arithmetic; §the-arithmetic-IS-replaced-by-key-and-value-rules-in-the-record-case.

§First-explicit-observation in library: **§the-side-channel-defense-takes-three-forms-across-the-triplet — count-zero (byteArray) + count-equal-to-len-plus-1 (copyArray) + per-key-and-per-value-rules (copyRecord)**.
