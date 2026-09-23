---
title: §The dual-purpose anchor — location identifier + staleness check
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

Lines 70-73:
> *Its insight: every line in a file gets a short content-hash anchor displayed alongside its line number whenever the agent reads the file, and edit operations reference those anchors instead of reproducing text.*

§First-explicit-observation in library: **§the-dual-purpose-anchor (location identifier + staleness check) — §the-content-hash-IS-both-WHERE-the-line-IS + §WHETHER-the-line-has-changed + §the-design-leverages-the-content-hash-twice-for-two-purposes-from-one-computation**.

§Sibling-pattern to many compare-and-swap conventions where the CAS token IS both the location and the staleness check. §the-content-hash-as-CAS-token-and-location-token-in-one.

§Three-named-properties-of-the-hashline-anchor:
1. **Short** — abbreviated content hash, not the full hash.
2. **Per-line** — every line has its own anchor.
3. **Displayed alongside the line number** — shown when read, used when edited.

§the-hashline-format-IS-a-display + reference-protocol-pair — §the-display-format-on-read + §the-reference-format-on-edit-operations.
