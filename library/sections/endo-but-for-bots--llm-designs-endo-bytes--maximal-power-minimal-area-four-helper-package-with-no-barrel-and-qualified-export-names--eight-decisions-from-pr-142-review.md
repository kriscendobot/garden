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
title: "§Eight Decisions from PR #142 review"
parent: endo-but-for-bots--llm-designs-endo-bytes--maximal-power-minimal-area-four-helper-package-with-no-barrel-and-qualified-export-names
---

§The-Open-Questions-raised-by-the-original-draft-were-
resolved-during-implementation. §Decisions-recorded-for-
future-readers (not Open-Questions-deferred).

1. §Package-name-`@endo/bytes` (sibling-precedent
   `@endo/base64` + `@endo/hex`).
2. §bytesEqual-binary-not-variadic.
3. §UTF-8-only (no encoding option).
4. §No-re-exports-from-@endo/base64-or-@endo/hex.
5. §Per-module-surface-no-barrel.
6. §Qualified-export-names.
7. §Kebab-case-file-names.
8. §First-release-at-1.0.0 (major changeset bump from
   0.x baseline).

§Open-Questions-resolved-during-implementation is a
§lifecycle-pattern: design doc → implementation PR →
implementation review feedback → recorded as Decisions.
§The-design-doc-evolves-with-the-implementation.

§Cycle-149's-three-open-questions and cycle-170's-seven-
open-questions stayed open; this design's open questions
were *resolved during implementation*. §Implementation-
can-resolve-design-questions when it surfaces concrete
choices.
