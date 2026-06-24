---
ts: 2026-05-13T21:47:06Z
kind: message
role: liaison
to: "*"
---

# New: `journal/library/` — cross-cutting reference library

A new top-level tree exists in the journal. Authored by the in-session liaison at the maintainer's request: build out a library of digested human-legible documentation so agents using the [journalism](../../../../../skills/journalism/SKILL.md) skill can find conceptual material on projects, packages, modules, design goals, and overarching concepts.

## Where

`journal/library/` is a sibling of `journal/projects/`, `journal/agents/`, and `journal/entries/`. Top-level abstract lives in `journal/library/README.md`. Ingestion conventions (frontmatter schema, naming, staleness policy, taxonomy seed) live in `journal/library/conventions.md`.

## Shape

The tree is **cross-cutting** (intentionally distinct from `journal/projects/<slug>/`, which is project-bound). Three peer indexes route to one flat section corpus:

```
library/
  README.md
  conventions.md
  sources/<source-slug>.md      one per ingested source document
  topics/<topic-slug>.md        one per concept; lists relevant section files
  sections/<source>--<section>.md   the actual library content
```

Each section file carries frontmatter capturing source path, source repo, source commit, last-modified date, primary authors (from `git log`), ingestion date, ingester role, topic tags, and a `status` field (`current` | `stale` | `superseded` | `conflicted`). The abstract-at-the-top contract from [`context-library`](../../../../../skills/context-library/SKILL.md) applies at every level.

## Pilot batch (2026-05-13)

Three endo source documents, end-to-end:

- `endojs/endo/AGENTS.md` (6 sections)
- `endojs/endo/docs/security.md` (3 sections)
- `endojs/endo/docs/errors.md` (7 sections)

16 section files, 3 source indexes, 13 topic pages, 3 master index READMEs. Captured at endo commit `052b0487`.

## How to find things in the library

An agent reaching the library:

1. Reads `journal/library/README.md`'s abstract.
2. Picks the right index: `topics/README.md` for concept queries, `sources/README.md` for "what did the upstream doc named X say" queries.
3. Follows the matching topic or source page to its sections table.
4. Reads relevant sections.

Two-deep hierarchy by design. Most queries resolve in two reads after the entry index.

## Backlog and growth path

The endo corpus has ~70 substantive markdown files remaining (top-level `README.md` and `CONTRIBUTING.md`; six more `docs/*.md` files including the large `docs/lockdown.md`; 47 per-package READMEs; 13 per-package `docs/`/`doc/` files; 13 changesets; 13 SES error-code references). The `sources/README.md` § Backlog enumerates them by priority.

The pilot is intentionally small so the schema can be audited before scaling. Open questions for follow-up:

- **Who owns ongoing ingestion?** Three options were sketched in the bootstrap discussion: extend the scholar to handle external-doc ingestion alongside entry-growth; introduce a new role (`indexer` or `cataloguer`); or continue with liaison-driven passes. Pending maintainer call.
- **Contradiction surfacing.** The conventions allow per-section `status: conflicted` with a `contradicts:` list, but no role currently sweeps for cross-section contradictions. A maintenance pass should run after the corpus reaches enough mass to be interesting.
- **Stale-content marking.** Some source files (e.g., `docs/security.md`, `docs/errors.md`) show only one commit in `git log`, likely post-rename; their content may predate the captured date. The pilot flagged these in per-source `notes:` fields. A future pass that recovers pre-rename history would let us pin true content-age.

## To other roles

- **Scholar**: when you run cycles on `journal/projects/<slug>/`, you can cross-link your project topic files to `journal/library/sections/...` rather than restating concept material. The library is the canonical home for reusable concept content.
- **Designer**: for any new design, check `journal/library/topics/` for prior material before re-establishing context.
- **Fixer**: when a review comment cites a convention or rule, the library may have the digested rule (e.g., `endo--agents--typescript-usage` for TS rules in endo).
- **Librarian** (the dispatch-on-demand journal-search role): you are the read-side consumer of this tree. The `topics/` and `sources/` indexes are designed for your two-step walk.
- **Gardener**: the question of who owns ongoing ingestion (scholar vs. new role vs. liaison-driven) is yours to land when the maintainer decides.

## Self-improvement

The pilot revealed two things worth recording. First, splitting at H2 vs. H3 is a judgment call best made per source: documents with thinly-related H3s (like the six TS sub-rules in `AGENTS.md`) consolidate well at H2; documents whose H2s already partition substantively (like `docs/errors.md`) split cleanly. The `conventions.md` § File naming captures this. Second, some endo source files have lost their pre-rename `git log` history, which makes "capture dates and names" harder than expected; the workaround for now is to record what `git log` shows and flag the file as having pre-rename history we cannot see.
