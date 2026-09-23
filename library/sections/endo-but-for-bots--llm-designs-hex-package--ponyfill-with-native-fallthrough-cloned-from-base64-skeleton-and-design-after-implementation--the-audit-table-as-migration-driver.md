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
title: §The-audit-table-as-migration-driver
parent: endo-but-for-bots--llm-designs-hex-package--ponyfill-with-native-fallthrough-cloned-from-base64-skeleton-and-design-after-implementation
---

```
Every byte-level hex encode/decode site in the monorepo, excluding the
vendored `packages/test262-runner/test262/` fixtures (which are
externally maintained and not migration targets).
```

§Audit-section-is-23-rows-of-byte-array-sites + §9-rows-of-non-
migration-sites. §Each-row-names: file + line range + direction
(encode/decode) + case (lower/upper) + form (template) + notes.

§Compare-to-cycle-172-endo-bytes which had a 16-row audit; this
design's 23 + 9 = 32-row audit is §exhaustive-by-construction.
§Design-Decision-8 codifies this: "Audit drives scope. The audit
table is deliberately exhaustive so the migration review can be a
mechanical check against it. Non-migration sites are listed so
reviewers can confirm nothing is missed."

§This-is-§extra-audit-effort-buys-mechanical-review. §A-reviewer-
doesn't-need-to-grep-the-repo; the design has already done that.
§The-cost-is-borne-once-by-the-designer; §the-benefit-is-borne-
many-times-by-reviewers.

§The-audit-distinguishes-three-classes-of-site:
1. **§Byte-array-migration-targets** (23 rows) — encode/decode
   Uint8Array ↔ string.
2. **§Boundary-sites** (5 rows) — Node `crypto.createHash().digest('hex')`
   and `crypto.randomBytes(n).toString('hex')` — kept at the Node
   powers boundary, not migrated.
3. **§Non-byte-array-sites** (9 rows) — `BigInt.toString(16)`,
   IPv6 group parsing, Unicode code-point formatting — out of
   scope.

§This-three-way-classification-is-explicit-and-defended in Design
Decision 4 ("Node boundaries keep their direct hex usage").
