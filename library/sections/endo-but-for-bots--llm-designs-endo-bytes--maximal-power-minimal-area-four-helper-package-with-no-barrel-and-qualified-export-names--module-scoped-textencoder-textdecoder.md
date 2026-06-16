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
title: §Module-scoped TextEncoder / TextDecoder
parent: endo-but-for-bots--llm-designs-endo-bytes--maximal-power-minimal-area-four-helper-package-with-no-barrel-and-qualified-export-names
---

> *Module-scoped `TextEncoder` and `TextDecoder` instances
> are created once at module load and frozen. They are
> passed as captured constants; no globals are read after
> module init.*

§Capture-at-module-load: §no-per-call-allocation;
§captured-before-lockdown-can't-be-defeated-post-lockdown.

§Why-this-matters-for-SES: a globalThis modification after
lockdown can't affect a captured constant. §Closure-over-
captured-bindings is the §defense.

§Cycle-167-where/index.js doesn't have a similar capture
because path-resolution functions take env/info as args.
§Different-substrate-different-pattern.
