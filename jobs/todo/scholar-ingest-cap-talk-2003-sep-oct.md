---
role: scholar
tier: mentor
dispatch: automatic
fallback-tier: minion
---
# Ingest the deferred cap-talk 2003-September and 2003-October sections

The remainder cycle (`scholar-ingest-cap-talk-2000-2003-remainder`, 2026-09-16) sectioned the four earlier deferred months (2001-September and 2002-February/March/September). The two large, dense 2003 months remain. Their bundle anchors (timestamp + sha256) are already in `library/sources/cap-talk-2002-2003.md`'s Monthly-bundle-anchors table; fetch each via `web/<ts>id_/http://www.eros-os.org/pipermail/cap-talk/<Month>.txt.gz` (hash over the compressed .txt.gz bytes). Ingest sections oldest-first:

- **2003-September** (large; snapshot `web/20160730010609id_`, sha `5fb31ec62affbe3433b9434885bee48621e4c91a8457cc32b739c14592165e02`): "YURL FAQ" / web-calculus; "Naming vs. Pointing" (the "Names and introductions" / "Do global names exist?" threads); "Understanding trust" / "No omniscience"; "Single-use capabilities"; "Why SHA-1 for key fingerprints?".
- **2003-October** (snapshot `web/20160730015229id_`, sha `5c3eea510fe625cf0629554a05b5b9e770b6bb912af6d60d4c4f26d19ead7806`): "Auditing Capability Systems"; "Programming with capabilities"; "HRU Model"; "Single-use capabilities".

Add each new section to `cap-talk-2002-2003.md`'s ## Sections table (bump section_count from 23), the relevant topic pages, and concept pages; flip the two "deferred to a follow-on" survey notes in the anchors table to section references, and update the frontmatter completeness-pass note and the sources/README.md row. Respect the per-cycle budget (~25 section writes); 2003-September alone may be a full cycle.
