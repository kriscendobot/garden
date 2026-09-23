---
source: designs/hex-package.md
source_repo: endojs/endo-but-for-bots
source_branch: llm
source_url: https://github.com/endojs/endo-but-for-bots/blob/llm/designs/hex-package.md
section_kind: design
ingested: 2026-06-03
ingested_by: scholar
contributors:
  - Kris Kowal (prompted)
topics:
  - hardened-javascript
  - tooling
status_at_ingest: Complete
genre: §endo-but-for-bots-design §canonical-leaf-package-pattern
cycle: 180
lane: designs
status: current
title: §Eight-Design-Decisions (the structured rationale)
parent: endo-but-for-bots--llm-designs-hex-package--ponyfill-with-native-fallthrough-cloned-from-base64-skeleton-and-design-after-implementation
---

| # | Decision | Reason |
|---|----------|--------|
| 1 | New package, not addition to @endo/base64 | Two RFCs (RFC 4648 § 4 vs § 8); TC39 split; bundler cost scoping |
| 2 | encodeHex/decodeHex naming, not toHex/fromHex | Matches @endo/base64 canonical model; re-export alias migrates call sites |
| 3 | No shim.js | No legacy global like atob/btoa for hex; future shim deferred |
| 4 | Node boundaries keep direct hex usage | digest('hex') returns hex directly; no clarity benefit forcing through @endo/hex |
| 5 | options.uppercase only on encode; decodeHex accepts both | Symmetric to TC39 proposal; additive extension delegates to fallback |
| 6 | Error rewrapping at native boundary | Stable error contract; try/catch cost paid only on error path |
| 7 | Detection one-shot at module load | Standard Hardened-JS pattern; belt-and-suspenders with SES lockdown |
| 8 | Audit drives scope | Exhaustive audit table lets review be mechanical |

§Compare-to-cycle-178-daemon-xs-worker-snapshot's §six-Design-
Decisions and cycle 174 gateway-package's §eight-Design-
Decisions. §The-§eight-Design-Decisions count is shared. §Each-
decision-numbered-with-a-bold-statement-then-rationale — the
§canonical-Design-Decisions-format across endo-but-for-bots
designs.
