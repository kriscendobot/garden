---
title: §Two surfaces in priority order — primary + secondary
source-slug: endo-but-for-bots--llm-designs-cli-edit-verb
section-slug: first-Proposed-status-and-Source-metadata-field-instantiated-and-original-framing-corrected-and-two-surfaces-in-priority-order-and-the-Alternatives-considered-section-and-two-named-Open-Questions-sections
source-url: https://github.com/endojs/endo-but-for-bots/blob/master/designs/cli-edit-verb.md
source-repo: endojs/endo-but-for-bots
source-path: designs/cli-edit-verb.md
source-author: Kris Kowal (prompted)
total-lines: 1394
ingest-cycle: 279
ingest-date: 2026-06-10
lane: designs
scope: structural-pattern-observations
parent: endo-but-for-bots--llm-designs-cli-edit-verb--first-Proposed-status-and-Source-metadata-field-instantiated-and-original-framing-corrected-and-two-surfaces-in-priority-order-and-the-Alternatives-considered-section-and-two-named-Open-Questions-sections
---

Lines 45-58:

> *The two surfaces in priority order:*
>
> *1. **Primary: `E(guest).edit(directoryRef, path, patch, options)`.** The daemon-side eventual-send API. This is what an agent's tool-call lands on. It performs the read, anchor validation, splice, and write under a single mount-internal critical section.*
>
> *2. **Secondary: `endo edit <name-path> --patch <file> --format hashline`.** A thin CLI wrapper that resolves the name path, reads the patch from a file or stdin, and delegates to the same daemon API as a single eventual send.*

§First-explicit-observation in library: **§two-surfaces-in-priority-order-named-explicitly (primary + secondary) — §the-design-distinguishes-primary-from-secondary-surfaces + §the-naming-IS-explicit-not-implicit + §the-cli-surface-IS-secondary-not-primary-despite-being-the-historical-default**.

§Sibling-pattern to cycle 269's §two-co-equal-halves (Chat + Debugger) — but here the two surfaces are **NOT** co-equal; one is **primary** and one is **secondary**. §two-named-design-shapes-for-multi-surface-features (co-equal + primary-secondary).

§First-explicit-observation in library: **§two-named-design-shapes-for-multi-surface-features (co-equal-halves cycle 269 + primary-and-secondary-surfaces cycle 279) — §the-cluster-now-distinguishes-two-named-multi-surface-relationships**.
