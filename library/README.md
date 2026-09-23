# Library

Cross-cutting reference library of documentation digested from upstream sources. Each ingested document is split into short section files (`sections/`); each source document has a small index (`sources/`) listing its sections; topics partition the section set by concept (`topics/`). An agent using the [journalism](../../../skills/journalism/SKILL.md) skill arrives here when it needs background on a concept, module, or design goal that is not local to one project's rules of engagement.

The library is **cross-cutting**: project-specific rules of engagement live in `../projects/<slug>/README.md`; reusable conceptual material lives here. A given source document (e.g., `endojs/endo/docs/lockdown.md`) is digested once into the library; multiple project READMEs may link to the same library sections.

Authored by: liaison (bootstrap, 2026-05-13).

## Layout

```
library/
  README.md         (this file)
  conventions.md    ingestion conventions: frontmatter schema, naming, staleness policy
  keywords.md       grep-friendly index from a domain term/phrase to a concept-id
  sources/          one index file per ingested source document
    README.md       master index of source documents
    <slug>.md       section list + metadata for one source doc
  topics/           one page per concept; lists section files relevant to the topic
    README.md       taxonomy index (all topics with one-line abstracts)
    <slug>.md       per-topic page
  concepts/         one short page per lookup-unit concept
    README.md       seed inventory + how-to
    <id>.md         per-concept page: definition + section table + see-also
  roles/            one landing page per specialist role
    README.md       landing-page discipline + current inventory
    <role>.md       per-role landing: curated topics/concepts/sources/conventions for that specialist
  sections/         one file per ingested section
    README.md       flat index of all section files (sorted by source-slug)
    <source>--<section>.md
```

## How to find something

Four indexing axes, picked by what you have in hand:

- **Specific term in mind** (a code symbol, a proper name, a domain phrase) — use the `garden/skills/library-lookup/SKILL.md` skill. It grep-resolves the term in `keywords.md`, walks to the right `concepts/<id>.md`, opens the relevant section files, and *indexes on the fly* so the next reader's search succeeds where yours did not.
- **Broad subject** (capability-security, daemon, hardened-javascript) — start at `topics/README.md`, scan the topic abstracts, follow the matching topic page.
- **Provenance** ("what did upstream doc X say") — start at `sources/README.md`.
- **A specialist role you're dispatched as** (designer-protocol, designer-security, builder, etc.) — start at `roles/<your-role>.md` for a curated landing of the topics, concepts, sources, and conventions most relevant to your discipline.

All four axes converge on the same section files; the index is the difference. The first three are *content-organized* (by topic / source / term); the fourth is *reader-organized* (by who's reading).

## How to ingest

Read [`conventions.md`](conventions.md) before adding section files. The conventions cover:

- Frontmatter schema (source path, commit, date, authors, topics, status).
- File naming (`<source-slug>--<section-slug>.md`).
- Staleness and contradiction flagging.
- When a section gets its own file vs. when it stays nested.

## Indexes

- [Keywords](keywords.md): grep-friendly map from a term to a concept-id.
- [Concepts](concepts/README.md): per-concept lookup pages with section tables.
- [Topics](topics/README.md): broad-subject taxonomy.
- [Roles](roles/README.md): per-specialist-role landing pages, reader-organized.
- [Sources](sources/README.md): source-document-keyed inventory.
- [Sections](sections/README.md): flat index of every ingested section.

## Status

Bootstrapped 2026-05-13 by the in-session liaison after a maintainer ask to start the library. Pilot batch covers `endojs/endo`'s `AGENTS.md`, `docs/security.md`, and `docs/errors.md`. The pilot is intentionally small so the schema can be audited before scaling to the rest of the endo corpus (~72 substantive markdown files: top-level, `docs/`, per-package READMEs, per-package `docs/` and `doc/` sub-trees).
