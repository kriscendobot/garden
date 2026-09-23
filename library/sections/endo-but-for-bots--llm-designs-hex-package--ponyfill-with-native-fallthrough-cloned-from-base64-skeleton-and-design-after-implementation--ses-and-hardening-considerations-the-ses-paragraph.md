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
title: §SES-and-hardening-considerations (the SES paragraph)
parent: endo-but-for-bots--llm-designs-hex-package--ponyfill-with-native-fallthrough-cloned-from-base64-skeleton-and-design-after-implementation
---

```
- Every named export has a companion harden() call.
  Module-level constants (hexAlphabetLower, hexAlphabetUpper) are
  hardened at declaration.
- The native method is looked up once at module load and bound
  into a local const.  A malicious compartment that tampers with
  Uint8Array.prototype.toHex after module initialization cannot
  redirect our call site.  (SES lockdown already freezes the
  prototype, but the pattern matches @endo/base64's defensive
  stance regardless.)
- Input validation happens in the JS path unconditionally.
- No module-scope mutable state; detection is pure and
  deterministic.
```

§Four-SES-bullets: §every-export-hardened + §native-bound-at-
module-load + §input-validation-in-JS-path-unconditionally +
§no-module-scope-mutable-state.

§The-third-bullet-is-the-most-interesting: input validation runs
on the JS path *unconditionally*. §When-we-delegate-to-the-
native-path, we rewrap native errors. §The-validation-cost-is-
paid-twice-in-the-error-path (once in native, once in rewrap),
but §never-twice-on-the-happy-path. §This-is-§belt-and-
suspenders-for-input-but-not-for-output.
