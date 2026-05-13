# Library ingestion conventions

How to add a source document to the library. Read this before authoring any new file under `sections/`, `sources/`, or `topics/`.

Authored by: liaison (bootstrap, 2026-05-13).

## File naming

```
sections/<source-slug>--<section-slug>.md
sources/<source-slug>.md
topics/<topic-slug>.md
```

`<source-slug>` compresses the source path into kebab-case with directory boundaries flattened to single hyphens, prefixed by the upstream project. Examples:

- `endojs/endo/AGENTS.md` → `endo--agents`
- `endojs/endo/docs/lockdown.md` → `endo--docs-lockdown`
- `endojs/endo/packages/ses/README.md` → `endo--pkg-ses-readme`
- `endojs/endo/packages/ses/docs/secure-coding-guide.md` → `endo--pkg-ses-docs-secure-coding-guide`

`<section-slug>` is the kebab-case of the section heading text (drop backticks, drop possessives), or `overview` for content above the first sub-heading. Use the H2 heading as the section boundary by default; descend to H3 only when an H2 is a thin wrapper around several substantially-different H3 topics.

`<topic-slug>` is a short kebab-case concept name (e.g., `hardened-javascript`, `capability-security`, `marshal`, `eventual-send`, `repository-governance`). New topics get added to `topics/README.md` with a one-line abstract when first used.

## Section file frontmatter

```yaml
---
title: <section heading text>
source: <repo-relative path>          # e.g., AGENTS.md, docs/lockdown.md
source_repo: endojs/endo
source_commit: <full sha>             # the sha the section was digested from
source_date: <YYYY-MM-DD>             # last-modified date of the source FILE
source_authors: [<name>, ...]         # primary authors of the source file (git log)
ingested: <YYYY-MM-DD>                # date this section file was created
ingested_by: <role>                   # role of the agent that did the ingestion
topics: [<topic-slug>, ...]           # topic-slugs the section is filed under
status: current                       # current | stale | superseded | conflicted
supersedes: [<section-slug>, ...]     # optional; sections this replaces
contradicts: [<section-slug>, ...]    # optional; sections this conflicts with
notes: <optional one-liner>           # optional; e.g., why status is not current
---
```

After the frontmatter, the body opens with a one-paragraph **Abstract** specific enough to use as an exit criterion (per [`skills/context-library/SKILL.md`](../../../skills/context-library/SKILL.md)), then the section's content (lightly cleaned, mostly verbatim from source).

End the body with a one-line **Source** footer linking to the upstream file at the captured commit:

```
Source: [<repo-relative path>](https://github.com/endojs/endo/blob/<sha>/<path>) at commit `<short-sha>`.
```

## Source-document index frontmatter and shape

`sources/<source-slug>.md` is short: an abstract for the document as a whole, a metadata block (authors, last-modified, ingestion date, commit), and a table listing the section files derived from it.

```yaml
---
source: <repo-relative path>
source_repo: endojs/endo
source_commit: <full sha>
source_date: <YYYY-MM-DD>
source_authors: [<name>, ...]
ingested: <YYYY-MM-DD>
ingested_by: <role>
section_count: <integer>
status: current
---
```

Body: one-paragraph abstract describing what the source document covers, then a table:

```markdown
| Section | Topics | Status |
|---------|--------|--------|
| [overview](../sections/<source-slug>--overview.md) | <topics> | current |
| ... |
```

## Topic-page shape

`topics/<topic-slug>.md` has no frontmatter (topics are catalog pages, not first-class content). Body:

1. One-paragraph **Abstract** of the concept.
2. **Sections** table listing every section file filed under this topic, with a one-line abstract per row (copy the section's abstract first sentence).
3. **See also** list of related topic slugs.

## Staleness, supersession, contradiction

The journal is append-only. We do not edit prior section files in place when they become wrong; instead:

- Mark a section's `status` field as `stale`, `superseded`, or `conflicted` and add a `notes:` line explaining.
- If a new section replaces an older one, the new section's `supersedes:` list names the older's slug; the older section's `status` flips to `superseded`.
- If two sections conflict but neither cleanly supersedes the other, both get `status: conflicted` and `contradicts:` lists naming each other. The next reader (likely an indexer or scholar) resolves later.

Source documents whose content is contradicted by a newer source (e.g., a `designs/<slug>.md` superseding an older `docs/<topic>.md`) are flagged at the source-index level (`status: superseded`) with `notes:` pointing at the successor.

## What goes in the library vs. the project tree

- **Library (`journal/library/`)**: reusable conceptual material, API documentation, security policies, design rationale, agent-facing technical notes. Cross-cutting; one section may apply to multiple projects.
- **Project (`journal/projects/<slug>/`)**: rules of engagement, identity and credentials, project-specific authority structure, project-bound topic files the scholar grows from `project:`-tagged journal entries.

A section that is unmistakably about one project's *operational rules* (e.g., "how the boatman ferries syrups-class work to endo upstream") belongs in `journal/projects/endo/`. A section about *technical content* (e.g., "what `harden` does to an object") belongs in the library.

## Topic taxonomy (seed)

The seed taxonomy below is a starting partition. Add new topics as the corpus reveals them; merge or split topics if their abstracts begin overlapping per the [context-library](../../../skills/context-library/SKILL.md) partitioning rule.

- `hardened-javascript`: SES, lockdown, frozen intrinsics, taming.
- `capability-security`: object capabilities, ocap, principle of least authority.
- `compartments`: SES compartments, module isolation, endowments.
- `marshal`: pass-style, smallcaps, serialization of capabilities.
- `eventual-send`: E(), promise pipelining, HandledPromise.
- `captp`: capability transport protocol.
- `ocapn`: OCapN protocol family (netstring, noise, codecs).
- `exo`: Exo class definitions, Far, Remotable.
- `patterns`: shape matching, kind kinds.
- `bundles`: bundle-source, compartment-mapper, import-bundle, module-source.
- `daemon`: endo daemon, capability bank, process model.
- `errors`: error-handling, panic, taming, error-codes.
- `streams`: stream, stream-node, async iteration.
- `testing`: ses-ava, test262-runner, testing conventions.
- `tooling`: where, zip, lp32, base64, hex, cjs-module-analyzer, eslint-plugin.
- `repository-governance`: contributing, security policy, commit conventions, repository structure.
- `agent-conventions`: agent-facing operating notes within a repository.
- `typescript-conventions`: TypeScript usage rules within a repository.
- `security-disclosure`: vulnerability disclosure, supported versions.
- `getting-started`: tutorials, first steps, install.

## Ingestion procedure (one source document)

1. Identify the source: path, commit, last-modified date, primary authors.
2. Read the source heading structure; decide section boundaries (H2 by default; H3 when the H2 wraps several substantially-different H3 topics).
3. For each section: extract the body, write `sections/<source-slug>--<section-slug>.md` with full frontmatter, abstract, body, and source footer.
4. Write `sources/<source-slug>.md` with the section table.
5. For each topic the section touches, append a row to `topics/<topic-slug>.md`'s section table (create the topic file if new).
6. Update `topics/README.md` with any new topic abstracts.
7. Update `sources/README.md` with the new source row.
8. Update `sections/README.md` (or rely on directory listing if it grows beyond pragmatic).
