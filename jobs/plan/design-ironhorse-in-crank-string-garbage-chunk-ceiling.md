---
gate: deferred
priority: normal
posted_by: producer
posted_at: 2026-11-01T15:11:12Z
---

---
arc: ironhorse-test262-ratchet
role: designer
tier: mentor
fallback-tier: minion
dispatch: automatic
---
Design work on endojs/endo-but-for-bots (ironhorse, rust/engine): about 820 test262 rows (built-ins/RegExp/property-escapes/generated, unicodeSets/generated, CharacterClassEscapes) are `skip:ironhorse-aborted-limit` because the run halts with HeapExhausted on the 256 MiB chunk ceiling. The harness's `buildString` (harness/regExpUtils.js) runs `result += String.fromCodePoint.apply(null, chunk)` about 110 times, and the old strings, about 250 MiB, are never reclaimed inside a crank: `Interp::collect_garbage` is only admitted at quiescence. XS collects during the run and completes. Verified 2026-11-01: with a 512 MiB ceiling, ASCII.js and Script_-_Old_Turkic.js complete on both engines with matching results. The regexp backtrack-state limit that blocked these rows first was fixed in https://github.com/endojs/endo-but-for-bots/pull/1618.
Write down the options and recommend one: (a) in-crank collection at safe points, (b) concatenation that does not copy the whole string (ropes, or growing a uniquely held tail chunk in place), (c) a larger chunk ceiling for the test262 harness only, which hides the gap rather than fixing it. Also include the related 2026-10-16 review points from RGX-1: report a matcher ceiling as a catchable error rather than a machine halt, and clamp quantifier bounds above 2^31-1 as XS does.
