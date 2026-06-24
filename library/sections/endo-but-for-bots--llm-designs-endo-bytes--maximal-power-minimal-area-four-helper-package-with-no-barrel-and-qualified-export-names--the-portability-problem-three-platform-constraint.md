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
title: §The-portability-problem (§three-platform-constraint)
parent: endo-but-for-bots--llm-designs-endo-bytes--maximal-power-minimal-area-four-helper-package-with-no-barrel-and-qualified-export-names
---

> *Endo runs in three byte-handling platforms: Node (where
> `Buffer` is ambient), XS (no `Buffer`, no
> `globalThis.Buffer`), and SES-locked compartments (where
> `Buffer` may exist on the host platform but is
> intentionally not propagated into the locked
> compartment).*

§Three-platforms-with-different-byte-substrate-availability:

| Platform | Buffer? | Uint8Array | TextEncoder/Decoder |
|----------|---------|------------|---------------------|
| Node | Ambient global | Yes | Yes |
| XS | None | Yes | Yes |
| SES-locked compartment | Deliberately withheld | Yes (safe intrinsic) | Hand-threaded via globals |

§Uint8Array-is-the-portable-choice; §Buffer-is-Node-only-
unportable-baggage. §SES-deliberately-withholds-Buffer to
avoid Node-specific behavior leaking into compartments.

§The-codebase-rule: *Prefer Uint8Array over Node Buffer*.
§The-rule-was-honored-at-call-sites; §but-every-site-
reinvented-the-same-handful-of-Uint8Array-operations.
