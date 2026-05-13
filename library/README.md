# Library

Cross-cutting reference library of documentation digested from upstream sources. Each ingested document is split into short section files (`sections/`); each source document has a small index (`sources/`) listing its sections; topics partition the section set by concept (`topics/`). An agent using the [journalism](../../../skills/journalism/SKILL.md) skill arrives here when it needs background on a concept, module, or design goal that is not local to one project's rules of engagement.

The library is **cross-cutting**: project-specific rules of engagement live in `../projects/<slug>/README.md`; reusable conceptual material lives here. A given source document (e.g., `endojs/endo/docs/lockdown.md`) is digested once into the library; multiple project READMEs may link to the same library sections.

Authored by: liaison (bootstrap, 2026-05-13).

## Layout

```
library/
  README.md         (this file)
  conventions.md    ingestion conventions: frontmatter schema, naming, staleness policy
  sources/          one index file per ingested source document
    README.md       master index of source documents
    <slug>.md       section list + metadata for one source doc
  topics/           one page per concept; lists section files relevant to the topic
    README.md       taxonomy index (all topics with one-line abstracts)
    <slug>.md       per-topic page
  sections/         one file per ingested section
    README.md       flat index of all section files (sorted by source-slug)
    <source>--<section>.md
```

## How to find something

An agent reaching the library:

1. Reads this README's abstract; if the query is library-shaped, descend.
2. Goes to `topics/README.md` and matches the query against the topic abstracts.
3. Follows the matching topic page, which lists section files with one-line abstracts.
4. Reads matching section files.

The hierarchy is two-deep by design (top-level → topic → section). The source-doc index (`sources/`) is the alternative entry point for "what did the upstream doc named X say" queries.

## How to ingest

Read [`conventions.md`](conventions.md) before adding section files. The conventions cover:

- Frontmatter schema (source path, commit, date, authors, topics, status).
- File naming (`<source-slug>--<section-slug>.md`).
- Staleness and contradiction flagging.
- When a section gets its own file vs. when it stays nested.

## Indexes

- [Topics](topics/README.md): concept-keyed taxonomy.
- [Sources](sources/README.md): source-document-keyed inventory.
- [Sections](sections/README.md): flat index of every ingested section.

## Status

Bootstrapped 2026-05-13 by the in-session liaison after a maintainer ask to start the library. Pilot batch covers `endojs/endo`'s `AGENTS.md`, `docs/security.md`, and `docs/errors.md`. The pilot is intentionally small so the schema can be audited before scaling to the rest of the endo corpus (~72 substantive markdown files: top-level, `docs/`, per-package READMEs, per-package `docs/` and `doc/` sub-trees).
