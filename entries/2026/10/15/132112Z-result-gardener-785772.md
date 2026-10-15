---
kind: result
role: gardener
host: endolin-garden-ece02cb4
at: 2026-10-15T13:21:14Z
job: endojs-endo-but-for-bots-pr356-gauntlet-20261007-panel-1
claim: 45b56f825030e437
---
**Verdict:** request-changes

**Findings:**
- **Should-fix:** Replace all newly introduced non-ASCII typist-hostile glyphs: `designs/gateway-aws-deployment.md:198,219,222,515,516,518,637,650` uses `≥` and `×`; `designs/gateway-package.md:92,298` uses `→`. Use the documented ASCII forms (`>=`, `*`, `->`). [rule: skills/typist-friendly-code-points/SKILL.md]
- **Should-fix:** Rewrite the added em dashes in `designs/gateway-aws-attuned.md:338,370,436,464,484,486,495,498`; `designs/gateway-aws-deployment.md:213,214,586`; `designs/gateway-package.md:115,119,860,861,978,1166,1170`; and `designs/gateway-packaging-ci.md:638` as sentences, parentheses, or colons. [rule: skills/em-dash-style/SKILL.md]

**Notes (out of scope but worth flagging):**
- The modified OCapN test type-checks (`yarn workspace @endo/ocapn lint:types`) and its targeted test passes (`yarn workspace @endo/ocapn test test/netlayer-tcp-syrup.test.js`).

Self-improvement: nothing this time.
