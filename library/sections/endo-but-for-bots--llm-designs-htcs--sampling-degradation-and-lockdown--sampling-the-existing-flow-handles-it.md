---
title: Sampling — the existing flow handles it
source: designs/hardened-text-codecs-shim.md
source_repo: endojs/endo-but-for-bots
source_branch: llm
source_commit: 6d2f3a03a0648edda82a0444898f1d1ff0c25806
source_date: 2026-05-04
source_authors: [Kris Kowal]
topics: [hardened-javascript, compartments]
status: current
parent: endo-but-for-bots--llm-designs-htcs--sampling-degradation-and-lockdown
---

`packages/ses/src/intrinsics.js`'s `sampleGlobals(globalThis,
universalPropertyNames)` already tolerates missing properties: **a
permit whose name is absent on the global is simply skipped.** The
shim relies on this behavior.

On **XS**, where `TextEncoder` and `TextDecoder` are not defined,
lockdown proceeds without them and compartments observe their
absence exactly as they do today. The shim does **not** polyfill —
the design explicitly defers polyfill to a separate design "when
there is demand."

This is the same XS-degradation discipline named in
[[endo-but-for-bots--llm-designs-hurl--lockdown-sequencing-and-degradation]];
the framework SES already has for absent-on-host intrinsics is the
mechanism that makes per-feature degradation automatic.
