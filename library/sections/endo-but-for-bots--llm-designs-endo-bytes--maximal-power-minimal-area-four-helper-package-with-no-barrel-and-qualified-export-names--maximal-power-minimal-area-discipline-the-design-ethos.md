---
source: designs/endo-bytes.md
source_repo: endojs/endo-but-for-bots
source_url: https://github.com/endojs/endo-but-for-bots/blob/master/designs/endo-bytes.md
source_path: designs/endo-bytes.md
section_kind: design
ingested: 2026-06-03
ingested_by: scholar
contributors:
  - Designer (dispatched per kriskowal review)
topics:
  - tooling
  - patterns
  - pass-style
genre: §endo-but-for-bots-design
cycle: 172
lane: designs
status: current
title: §Maximal-power-minimal-area discipline (the design ethos)
parent: endo-but-for-bots--llm-designs-endo-bytes--maximal-power-minimal-area-four-helper-package-with-no-barrel-and-qualified-export-names
---

> *The principle (per the user's "maximal-power-minimal-
> area" guidance): ship the smallest API that retires the
> existing duplicates, add helpers when a real consumer
> asks.*

§User-guidance-cited-as-design-principle. §The-discipline
encodes:

- §Audit-first-design-second: count the existing
  duplicates before deciding what to include.
- §Justify-each-helper-with-existing-duplicate-count.
- §Defer-helpers-that-don't-yet-retire-duplicates.
- §Don't-build-for-hypothetical-future-consumers.

§Four-helpers-MVP: concatBytes + bytesEqual + bytesFromText
+ bytesToText. §Each-has-rationale-with-existing-
duplicates-count.

§Six-helpers-explicitly-deferred (with named-reasons): slice
(use subarray); fromBase64/toBase64 (use @endo/base64);
fromHex/toHex (use @endo/hex); compare (no current call
site); concatInto (TC39 may standardize); fromArrayBuffer
(one-liner already).

§Document-what's-not-included-and-why. §Negative-space-is-
load-bearing.
