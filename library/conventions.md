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
source_commit: <full sha>             # the FILE-SPECIFIC commit: `git --git-dir=worktrees/<owner>-<repo>.git log -1 --format=%H <branch> -- <path>` on the upstream bare clone at ingest time. NOT the repo's HEAD. The scholar's idempotency check (`roles/scholar/AGENT.md` § Per-cycle procedure step 4) compares this to the upstream's current file-specific commit; matching means the section file set is already current and no re-ingest is needed. Recording the repo's HEAD here breaks the idempotency check because every cycle would see a mismatch.
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
source_commit: <full sha>             # file-specific commit per the section schema above
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

### Soft-flag for cross-source overlap (not contradiction)

When two sources address the same material at different abstraction levels (reference-shaped summary vs background-shaped detail vs tutorial-shaped walkthrough), keep both with `status: current` and use the `notes:` field to cross-reference. This is **not** a contradiction; the shapes serve different reader needs. Reserve `status: conflicted` for actual semantic disagreements about the same concept at the same level.

Examples of soft-flag cross-source overlap surfaced during the 2026-05-13–14 ingestions:

- `docs/lockdown.md`'s 14 per-option H2 sections (canonical detail) versus `docs/reference.md`'s `lockdown-options-summary` (reference summary) versus `docs/guide.md`'s `what-lockdown-does-removes-adds` (guide-shape).
- The 4 separate per-API-verb sections in `docs/reference.md` versus the single consolidated `api-overview` in `docs/guide.md`.
- `packages/ses/README.md`'s `ecosystem-compatibility` versus `docs/guide.md`'s `library-compatibility`.

The pattern of soft-flagging rather than hard-flagging emerged after the docs/reference.md cycle (cycle 8) and was used uniformly through cycle 12 (docs/guide.md). See `entries/2026/05/14/051241Z-message-scholar-1f9a9e.md` for the consolidation review naming the overlap clusters; a maintainer-driven cleanup pass could consolidate further if desired.

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

## Sectioning shapes by source type

Default: one section per H2 (with H3 descent only when an H2 wraps several substantially-different H3 topics).

Exceptions that have proven useful as the corpus grew:

- **Alphabetical or otherwise non-thematic reference documents** (env-var catalogs, error-code lists, glossaries): aggressively consolidate into 1–3 sections that preserve the source's H2 anchors inline for grep-based lookup, rather than mirroring N entries as N sections. Per-entry splits bloat the section index without aiding agent navigation. (Pattern from cycle 29's agoric-sdk/docs/env.md.)
- **Single-screen reference docs**: consider a single `overview` section if the H2s do not partition naturally into distinct concepts.

## Consolidation as a cycle output

After a baseline is built, cycles routinely produce overlap reviews (see `entries/2026/05/14/051241Z-message-scholar-1f9a9e.md` for the first such review and `entries/2026/05/14/053037Z-message-liaison-7c4e02.md` for the maintainer's 2026-05-14 discretion mandate). When the scholar identifies a cluster of soft-flagged sections that overlap at the same abstraction level:

1. Pick one section as the canonical (the one with the most context, the cleanest framing, or the broadest reader audience).
2. Flip the others' `status:` to `superseded` and add `superseded_by:`, `superseded_on:`, `superseded_reason:` fields. Do **not** delete the section file; the journal is append-only.
3. Update the canonical's `notes:` to name the now-superseded sections it consolidates.
4. In every topic page that lists these sections, move the superseded rows out of the main *Sections* table into a *Superseded sections* subsection that points to the canonical.
5. Topic-section counts on `topics/README.md` stay the same (the corpus still includes the superseded file).

Soft-flagging (keep both, cross-reference via `notes:`) remains the **default** when the overlap serves different reader audiences (reference vs guide vs tutorial — see Cluster D in the cycle-30 review). Hard-supersede only when the overlap is at the same shape and the canonical strictly dominates.

## Structural principles from cycles 41-43

Three patterns emerged during the cycle-39-to-43 endo-but-for-bots design ingest. They are general enough to apply to any future ingestion of similar material.

### Shape, not content, for upstream meta-tables

When an upstream document's value is a meta-index of other items (every-design-status table, every-package-state table, every-tenant list) whose rows change at upstream's cadence rather than the library's, **capture the table's shape — column structure, taxonomy, current row count, query-upstream pointer — but do not transcribe the rows**. The library would otherwise become a stale mirror that diverges silently. Example: `endo-but-for-bots--llm-designs-readme--summary-shape-and-counts` (cycle 41) captures the design-summary table's shape without its 100+ rows.

### Consumers own rendering; producers own typed shape

When a system produces typed structured values that multiple consumers render differently (CLI string vs chat markup vs JSON), **the producer owns the typed shape; each consumer owns its rendering**. A producer-side string-rendering method saves canonical-form effort at one consumer but forces other consumers to re-parse those strings to recover segment boundaries they could read straight from the typed value. The typed shape is the backbone that keeps two renderings from drifting. Example: `endo-but-for-bots--llm-designs-rpn--alternatives-and-decisions` (cycle 42) rejects daemon-side `describeRetentionPaths` for this reason — daemon returns typed `RetentionPath`, CLI owns string notation, chat UI owns markup.

### Hidden-intrinsic sampling via throwaway-instance-prototype-walk

When taming a host-provided built-in whose methods return objects with their own prototype chain (iterators, callables, etc.), the return-value prototype is reachable only by **constructing a throwaway instance and walking `Object.getPrototypeOf` from a method return**. SES's permits graph won't visit those prototypes unless explicitly seeded. Sample during the intrinsics-collection pass, add to the permits graph under a synthetic name (e.g., `%URLSearchParamsIteratorPrototype%`), list permitted properties, harden along with the rest of the intrinsics. SES already does this for `%IteratorPrototype%` and `%ArrayIteratorPrototype%`; new tamed built-ins join the list. Example: `endo-but-for-bots--llm-designs-hurl--iterator-prototype-sampling` (cycle 43).

## Sources from unmerged PRs

Most library sources are drawn from a repository's default branch — the idempotency check (`git --git-dir=worktrees/<owner>-<repo>.git log -1 --format=%H <default-branch> -- <path>`) is meaningful only because the default branch is the canonical state. Occasionally a canonical-quality design document exists only on a PR branch that has not yet merged. The library may absorb such material with care; this section names the discipline. (First worked example: `endo--designs-daemon-persistence` from endojs/endo#3121, ingested cycle 47.)

### When it is appropriate

Ingest from an unmerged PR when the PR is the **canonical source-of-truth** for a design that has not landed because implementation work is in flight (the design and the implementation are co-evolving and the design is stable enough to teach from). Do not ingest speculative PRs that may be discarded, or PRs whose author has signalled the design is provisional.

### How to record provenance

The source-index file gains two extra frontmatter fields and an explicit `notes:` flag. Use `status: current` + `source_pr_state: draft|open|…`; do **not** invent a new `status:` value (e.g. `draft`) — taxonomy proliferation makes the library harder to query. The combination of fields is sufficient.

```yaml
source_repo: <owner/name>
source_branch: <PR branch name>
source_commit: <PR head SHA, full>
source_pr: <owner/name>#<number>
source_pr_state: draft | open | …
status: current
notes: |
  Sourced from an **unmerged draft PR**. Re-check freshness against
  PR head <SHA>. On force-push to the branch → re-ingest from new
  HEAD. On merge → rewrite source_branch to the default branch and
  refresh source_commit. On close-without-merge → mark this source
  and all `<slug>--*` sections **stale**.
```

Section files filed under this source inherit the same `source_pr` / `source_pr_state` fields.

### Slug convention

Use the same `<repo>--<area>-<file-slug>--<section>` form as for default-branch sources. **Do not** embed the PR number or branch name in the slug; the slug should remain stable across the PR's merge → default-branch transition so that section identities (and inbound cross-references) survive the merge. Branch information lives in frontmatter, not the slug.

### How to keep the source fresh

Each scholar cycle that touches a topic this source files under must re-check the PR head:

```sh
git --git-dir=worktrees/<owner>-<repo>.git fetch origin pull/<N>/head:refs/pull/<N>/head
git --git-dir=worktrees/<owner>-<repo>.git log -1 --format=%H refs/pull/<N>/head -- <path>
```

If the SHA differs from the recorded `source_commit`, treat as a normal idempotency mismatch and re-ingest.

### Lifecycle of an absorbed PR source

| Upstream event | Library response |
|---|---|
| PR force-push (rebases, edits) | Re-ingest from new HEAD; bump `source_commit`; sections may need rewriting if the design changed materially. |
| PR merges to default branch | Rewrite `source_branch:` to the default branch; refresh `source_commit:` to the merged commit; drop `source_pr_state:` (or set to `merged`); update `notes:` to remove the unmerged-PR caveat. |
| PR closes without merging | Mark `status:` of the source and all its sections **stale**; leave the section files in place (journal is append-only); add a `notes:` line explaining the close. Deletion requires explicit maintainer authorization in a journal `message` entry. |

## Concepts and the keyword index

A third indexing axis exists next to `sources/` (by provenance) and `topics/` (by broad subject taxonomy): the **keyword index** (`keywords.md`) and the **concept directory** (`concepts/<id>.md`). The keyword index is a grep-friendly map from a domain term or phrase (a code symbol, a proper name, a domain phrase) to a concept-id; each concept page is a short lookup target containing a one-paragraph definition + a table of section files that touch the concept (with one-line summaries) + a `See also` list of adjacent concepts.

Use this axis when the agent has a *specific term* in mind but does not know which source document or which broad topic owns it. Topics partition by subject; sources partition by provenance; concepts partition by the unit a reader is actually looking up.

### Concept page shape

Frontmatter (YAML):

```yaml
---
id: <concept-id>                    # kebab-case slug, stable across rename
aliases: [keyword1, keyword2, ...]  # all the keywords that resolve here
topics: [topic1, topic2, ...]       # topic pages this concept files under
---
```

Body (Markdown, kept short — a concept page is a lookup target, not a primer):

```markdown
# <concept-id>

One-paragraph definition / framing.

## Sections that touch this concept

| Section | One-line summary |
|---|---|
| [path/to/section](../sections/...) | summary |

## See also

- [[other-concept-id]] — relationship.
```

The `See also` block is allowed (and encouraged) to point at concept-ids that *contradict* or *abandon* the same concept under a different framing. See `crdt-in-formula-persistence` for a worked example: that page covers both where CRDT *shape* is used and where a bidirectional CRDT was *rejected*.

### Keyword index shape

`keywords.md` is a single file, one entry per line:

```
<keyword or phrase> | <concept-id>
```

Multiple keywords may resolve to the same concept-id (synonyms cluster). Code-symbol keywords are written in backticks (`` `LOCAL_NODE` ``, `` `EndoGateway.followRetentionSet` ``); prose keywords are plain (`destruction by cohort`, `Karp Stiegler Close`). Letter case is preserved when meaningful. Both kinds live in the same file so a maintainer can scan synonym clusters easily.

The index is meant to be **grepped, not read by eye**. Use the [`library-lookup`](../../../skills/library-lookup/SKILL.md) skill rather than reading `keywords.md` linearly.

### Indexing on the fly

The librarian's job is not just to find information but to ensure that the *next* search for the same information either succeeds where it did not before, or succeeds faster than it did before. Every lookup is therefore both a *find* operation and an *index-improvement* operation. The `library-lookup` skill is the operational form of this discipline.

Three corresponding maintenance actions, performed by the caller of the skill at the point of lookup (not deferred to a future scholar cycle):

1. **Add the shortcut.** If the lookup reached the right concept page only via flat-grep across `sections/` (the keyword index did not have the term the caller used), add the term to `keywords.md` pointing at the concept-id the search converged on.
2. **Prune the distraction.** If a section came up in flat-grep but was the wrong answer for this query, record a one-line *disambiguation* on the right concept page so the next reader does not waste time on the false positive. The line goes in a `## Common confusions` block below `See also`.
3. **Draft the missing concept.** If no concept page existed for the term and the caller has enough context to write one, draft the page and add the keyword. Drafts get `status: draft` in frontmatter; a follow-up missive to scholar (one per cycle, not one per page) requests review and topic-page integration.

Permission: any role that uses the `library-lookup` skill may write these inline maintenance updates. Major restructuring (new topics, source-index changes, concept merges) remains scholar's province.

The skill's responsibility is to make this discipline trivial — its procedure section names when to perform each of the three actions, and the skill packages the writeback so the caller does not have to remember the file paths.
