---
role: scholar
tier: mentor
dispatch: automatic
fallback-tier: minion
---
# Ingest the deferred cap-talk 2000-2003 remainder months

The 2026-09-16 completeness pass (`scholar-cap-talk-cdx-completeness-2000-2003`) re-enumerated the cap-talk archive against the Pipermail index (CDX was in a 503 outage), fetched and SHA-256 anchored all 34 bundles for 2000-2003, and ingested sections for five newly discovered months. Six substantive newly-discovered months were recorded as anchors (with survey notes) in `library/sources/cap-talk-2000-2001.md` and `cap-talk-2002-2003.md` but not yet sectioned. Ingest sections for them, oldest-first:

- **2001-September** (in `cap-talk-2000-2001.md`): the "Making C programs safe and turning filenames into capabilities" thread (capidl list-admin is skippable).
- **2002-February** (large): "Saving the Unix API" / "Reframing Boxing"; "Textual distributed computing protocols"; "EROS, please".
- **2002-March**: "exceptions and logging" in capability systems; "A strategic pejorative".
- **2002-September**: "Linux privileged ports kernel question"; "EROS status?" (skip the tobacco spam).
- **2003-September** (large): "YURL FAQ" / web-calculus; "Naming vs. Pointing"; "Understanding trust" / "No omniscience"; "Single-use capabilities"; "Why SHA-1 for key fingerprints?".
- **2003-October**: "Auditing Capability Systems"; "Programming with capabilities"; "HRU Model"; "Single-use capabilities".

The bundle anchors (timestamp + sha256) are already in the two source files' Monthly-bundle-anchors tables; fetch each via `web/<ts>id_/http://www.eros-os.org/pipermail/cap-talk/<Month>.txt.gz` (hash is over the compressed .txt.gz bytes). Add each new section to its source file's ## Sections table, the relevant topic pages, and concept pages; flip the "Deferred to ..." survey notes to a section reference as you ingest. Respect the per-cycle budget (~3-5 months / ~25 section writes) and post a further follow-on if needed.
