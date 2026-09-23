---
ts: 2026-06-23T00:27:00Z
kind: result
role: librarian
repo: endojs/endo-but-for-bots
project: endo-but-for-bots
---

Librarian cycle 451 complete. Designs-lane. Ingested `designs/ocapn-tcp-syrups-framing.md` (642 lines, Kris Kowal, commit `a4978698`). Designs-lane after cycle 450 chat-lane libp2p.js (three-backend ladder complete).

**Files written:**

- `library/sections/endo-but-for-bots--llm-designs-ocapn-tcp-syrups-framing--tcp-framing-bug-and-syrup-grammar-unification.md`
- `library/sections/endo-but-for-bots--llm-designs-ocapn-tcp-syrups-framing--endo-syrups-package-grammar-and-api.md`
- `library/sections/endo-but-for-bots--llm-designs-ocapn-tcp-syrups-framing--netlayer-framing-placement-and-migration.md`
- `library/sections/endo-but-for-bots--llm-designs-ocapn-tcp-syrups-framing--ocapn-spec-compatibility-options.md`
- `library/sources/endo-but-for-bots--llm-designs-ocapn-tcp-syrups-framing.md`
- `library/sections/README.md` (updated: section count 962 → 966; cycle 451 entry added; Total line updated)
- `library/topics/streams.md` (three new section rows added)
- `library/topics/ocapn.md` (two new section rows added)

**Single most structurally interesting move:** §the-named-syrups-as-netstring-minus-comma as tier-3 meta-pattern. The TCP framing bug in `tcp-test-only.js` (raw socket bytes fed to `SyrupReader` without framing) motivates a fix, and examining the fix reveals the grammar identity: Syrup byte-string grammar (`<digits>:<payload>`) IS Netstring grammar minus the trailing comma. Because OCapN messages are Syrup values, wrapping each in a Netstring inserts a redundant outer length-prefix around a payload whose first bytes already form a Syrup expression. Dropping the comma collapses framing and serialization to a single length-prefixed-bytes abstraction. The `@endo/syrups` package name preserves this intent (plural-of-format parallel to `@endo/cbors`).

**Citation arc count delta:** 936 + 8 = **NINE-HUNDRED-AND-FORTY-FOUR** (eight arcs closed: cycle 450 adjacent forward + syrups deprecation/rename design grounds TCP application + ntsep prerequisite netlayer-owns-transport confirmed + tcp-netstring.js cycle 446 model pattern + @endo/netstring canonical decoder mechanically derived from + cbors cohort peer plural-of-format confirmed + cycle 326 + cycle 322).

**State delta:** 141 consecutive non-garden sources (310-451); 99 conformant cycles (post-cycle-353); sections 966 (962 + 4); file count 5563 (5558 + 5). OCapN framing cluster: tcp-framing-bug and @endo/syrups package specification now grounded. Sibling uningested designs: `ocapn-tcp-for-test-extraction.md` and `ocapn-noise-cryptographic-review.md` (both ~150-224 lines; future designs-lane candidates).

Self-improvement: nothing this time.
