---
title: §Opt-in-submodule-with-cost-asymmetry
source: endo-but-for-bots designs/patterns-diagnostic-feedback.md
source-slug: endo-but-for-bots--llm-designs-patterns-diagnostic-feedback
ingest-cycle: 198
ingest-date: 2026-06-06
lane: designs
status: Proposed (2026-05-19 created; 2026-05-20 round-3 reshape)
author: Kris Kowal (prompted by maintainer kriskowal)
related:
  - endo--packages-pass-style (cycle 71+: passable substrate matched against)
  - endo--packages-marshal-src-marshal-justin-and-marshal-stringify-js (cycle 189: passableAsJustin diagnostic rendering)
  - endo-but-for-bots--llm-designs-endoclaw (cycle 196: §honest-architectural-difference + §multi-author-quote-blocks; sibling §genre but different shape)
  - endo--packages-panic (cycle 197: §honest-design-evolution-in-the-README; this design's §three-revision-rounds is a more extreme instance)
  - endo--packages-eventual-send-src-message-breakpoints-js (cycle 147: also @endo addresses-diagnostic-surface-shape problem)
  - endo--packages-ses-src-error-tame-console-js (cycle 106: SES error-observation surface — `applyLabelingError` rides on top of this)
keywords:
  - three-revision-pivots visible in Prompt section
  - the-data-is-already-there-just-locked discovery
  - sibling-package to submodule pivot
  - opt-in submodule with cost-asymmetry
  - non-throwing matcher mirroring matches() shape
  - compact-default + expanded-opt-in
  - AI-agent-token-economy rationale
  - Rust-compiler-error analogy
  - all-alternatives-reported no-heuristic
  - rich-not-configurable convention
  - column separator | not JSON-Lines
  - ASCII not unicode for terminal/log/CI
  - tracing recursion reuses helpers in place (no parallel implementation)
  - two-consumer-postures (library users + AI agents)
parent: endo-but-for-bots--llm-designs-patterns-diagnostic-feedback--three-revision-pivots-and-the-data-is-already-there-discovery-and-non-throwing-matcher-shape
---

§Package boundary unchanged. `package.json` `exports` simply lists the new entry alongside the existing main entry:

```json
{
  "./explain-mismatch.js": "./src/explain-mismatch.js"
}
```

§Production-matcher-path pays §zero-additional-cost. Bundlers and Node's ESM loader pull a submodule only when an import names it; `./explain-mismatch.js` appears nowhere on the production matcher's import graph. §Callers-that-never-import-it-never-pay-for-it.

§Submodule-direct-access-to-matchHelpers — the submodule has direct access to `matchHelpers` registry and `confirmMatches` recursion without re-export hoops. §There-is-exactly-one-source-of-matcher-truth. §No-API-contract-the-package-would-otherwise-not-need.

§Why-not-sibling (round-3's reshape, named in Design Decision 1):
- Sibling would either re-implement the matcher (drift risk and duplicated maintenance) or expose a stable internal surface for the sibling to consume (an API contract the package would otherwise not need).
- §The-submodule-has-neither-problem.

§Why-not-thread-payloads-through-matcher (round-1's reshape):
- Production matcher is loaded by every application that uses `mustMatch`, `assertMatches`, or an `InterfaceGuard`.
- §Download-size-plus-startup-cost-felt-across-the-whole-audience.
- §A-diagnostic-facility-that-adds-even-a-few-kilobytes-to-the-production-matcher-path-is-a-regression-for-callers-who-never-read-the-resulting-message.

§The-three-rejected-framings — original carry-on-error / sibling package / two-function API — each had a specific cost that named its rejection.
