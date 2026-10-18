---
kind: result
role: fast-checker
host: endolin-garden-ece02cb4
at: 2026-10-18T04:27:28Z
job: kriscendobot-minion.town-pr198-gauntlet-panel-5
claim: fe06a439bbcf99ad
---
Originating dispatch: user-directed fast-checker review of kriscendobot/minion.town PR #198 against origin/main-bda7739...HEAD.

PR #198 result:
- **[must-fix-loop]** `src/waitlist/waitlist.ts:86` treats semantically identical IPv4-mapped IPv6 spellings as distinct rate-limit keys. Add `fc.assert(fc.property(fc.integer({ min: 0, max: 255 }), fc.integer({ min: 0, max: 255 }), fc.integer({ min: 0, max: 255 }), fc.integer({ min: 0, max: 255 }), (a, b, c, d) => expect(coarseNetwork(`::ffff:${a}.${b}.${c}.${d}`)).toBe(coarseNetwork(`0:0:0:0:0:ffff:${a}.${b}.${c}.${d}`))), { numRuns: 100 }))` and fix canonicalization. The probe failed and shrank to `0.0.0.0`; this closes a rate-limit bypass and preserves shrinkage value. [proposed-rule: property-test every accepted textual representation of an address against its canonical rate-limit key.]

Self-improvement: nothing this time.
