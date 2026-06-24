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
title: §Qualified-export-names (Decision 6)
parent: endo-but-for-bots--llm-designs-endo-bytes--maximal-power-minimal-area-four-helper-package-with-no-barrel-and-qualified-export-names
---

> *The exported identifier carries the `bytes` qualifier
> (`concatBytes`, `bytesEqual`, `bytesFromText`,
> `bytesToText`) so the call site reads unambiguously
> without an import rename.*

§File-name-doesn't-stutter (concat.js, not concat-bytes.js).
§Export-name-carries-the-qualifier (concatBytes, not just
concat).

§kriskowal-on-PR-142: *the exported module names do not
need to stutter 'bytes'. Just the exported names.*

§Reasoning: §at-import-site the qualifier helps reader
identify the package; §at-file-site stutter is redundant.

§Kebab-case-file-names-for-multi-word (from-string.js;
to-string.js); §single-word-files-keep-plain-form
(concat.js; equals.js). §Per-the-project-house-naming-
guide.
