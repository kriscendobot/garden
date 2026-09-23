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
2. **Sections** table listing every section file filed under this topic, with a one-line abstract per row (copy the section's abstract first sentence). Add rows to this table with `scripts/jobs/insert-sections-table-row.sh` (see § Ingestion procedure, step 5), which anchors on the table boundary rather than placing the row by hand.
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
5. For each topic the section touches, add a row to that topic page's **## Sections** table by calling the deterministic inserter — never by hand-constructing the whole-file body for a row insertion:

   ```sh
   scripts/jobs/insert-sections-table-row.sh <topic-file> "| [<section>](../sections/<source-slug>--<section-slug>.md) | <topics> | <one-line abstract> |"
   ```

   The inserter anchors on the table's own boundary — its last existing `|`-leading data row and the blank line that terminates the table — so the new row lands as the table's last data row. It **never** anchors on a trailing `## See also` heading, which is frequently absent: a topic page's see-also block is often a bare bullet list with no heading, so an "insert before `## See also`, else append at end-of-file" heuristic drops the row *outside* the table (this caused the 2026-06-28 erights-part-2 mis-placement on `pass-style.md`, journal entry 161137Z). Create the topic file (with the topic-page shape above) if it is new, then insert each row with the helper rather than rewriting the whole file.
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

## Sources from external papers

Starting 2026-05-15, the library absorbs external published papers alongside its repo-derived sources. The first such ingest is Miller-Yee-Shapiro's 2003 *Capability Myths Demolished* (`papers--miller-capability-myths-demolished-2003`). This section documents the schema, the slug convention, and the idempotency anchor that papers use, which differ from the repo sources because papers have no `git log` history to read.

### Slug pattern

```
papers--<lastname-first>-<short-title-dashed>-<year>
```

The `papers--` prefix mirrors the existing `<owner>--` slug discipline for repo sources, and groups all external papers in `library/sources/` listings. Use the *first listed author's* last name. For multi-author papers with co-equal billing (Karp/Stiegler/Close-style), use the first listed author. Examples:

- `papers--miller-capability-myths-demolished-2003`
- `papers--miller-concurrency-among-strangers-2005` (queued)
- `papers--stiegler-trademarks-2005` (queued; Stiegler first author)

### Source-file frontmatter (paper schema)

Repo sources use `source_repo` / `source_path` / `source_commit`. Papers use:

```yaml
---
source_kind: paper                       # the discriminant: paper vs repo
source_authors: [Author One, Author Two] # full names, first listed first
source_title: <paper title>
source_year: <four-digit year>
source_venue: <conference / journal / tech-report series>
source_url: <canonical URL>              # one canonical URL even if you fetched from a mirror
source_pdf_sha256: <full 64-char SHA-256># idempotency anchor — replaces source_commit
source_pdf_pages: <integer>              # optional but useful for budget planning
source_mirror_url: <URL>                 # optional; the URL actually used when canonical was unreachable
ingested: <YYYY-MM-DD>
ingested_by: <role>
section_count: <integer>
status: current
---
```

`source_kind` discriminates schema variants. Repo sources are `source_kind: repo` (implicit if absent for backward compatibility); paper sources are `source_kind: paper`. The discriminant lets future schema additions (`source_kind: chat-cluster`, `source_kind: standards-doc`) stay backward-compatible without breaking the existing source-file shape.

### Section-file frontmatter (paper schema)

Section files filed under a paper inherit the paper schema with one extra field: `source` is the human-readable paper title, not a repo-relative path. The section frontmatter:

```yaml
---
title: <section heading>
source: <paper title>                    # e.g., "Capability Myths Demolished (SRL2003-02)"
source_kind: paper
source_authors: [Author One, Author Two]
source_year: <year>
source_venue: <venue>
source_url: <URL>
source_pdf_sha256: <full sha256>
ingested: <YYYY-MM-DD>
ingested_by: <role>
topics: [<topic-slug>, ...]
status: current
---
```

### Idempotency anchor

`source_pdf_sha256` replaces `source_commit` as the anchor for the idempotency check. Papers are static (the bytes do not change once published), so the check is degenerate: if the source file already exists with the same SHA, no re-ingest is needed. If a paper is re-published with revisions (rare; usually a new venue with a new SHA), the new ingest gets its own source slug (`papers--miller-foo-2003` vs `papers--miller-foo-revised-2005`) rather than overwriting, since the older argument is itself worth indexing.

### Translation-block convention

E-vat-language papers use idiom that diverges from Endo's surface (send vs E(), vat vs compartment, sealer vs brand, etc.). Each section file authored under a paper source includes a brief `## Translation` table where the idiom differs, mapping paper-side terms to Endo equivalents. The table is *not* an exhaustive glossary; it covers the terms the section actually uses. Recurring translations (the universal E-to-Endo table) live in the paper-corpus inbox message (`entries/2026/05/15/053206Z-message-liaison-9b4330.md`) and may be lifted into this conventions file once a few papers are in.

### PDF acquisition guidance

Mark Miller's authoritative site (`erights.org`) **refuses connections from the bot sandbox.** For ANY `erights.org` (or `caplet.com`) URL, the canonical substitute is the GitHub Pages mirror **`https://erights.github.io/erights-org-website/<path>`** — it preserves the original paths and serves the full-fidelity HTML site, and `fetch-source.sh` rewrites erights.org/caplet.com URLs to it automatically (see below). The mirror does NOT carry PDFs / talk files (those 404), so for a *paper PDF* prefer, in order:

1. The original venue's PDF (Springer LNCS, ACM Digital Library, IEEE) when accessible.
2. Author / collaborator faculty pages (e.g., Jonathan Shapiro's JHU SRL page, Bill Tulloh's, Tyler Close's).
3. CiteSeerX cached copies.
4. Google Scholar's cached-PDF link.
5. `papers.agoric.com` (Agoric's mirror of Mark's papers — reachable as of 2026-05-15 from the bot sandbox).
6. arXiv (later SES / verification work only; not the 2003 papers).

Compute the SHA-256 of the bytes you actually ingested, regardless of which source you fetched from. The SHA pins the bytes; the canonical URL stays a fixed pointer for the source-file frontmatter.

**Deterministic acquisition — `scripts/jobs/fetch-source.sh`.** Do not re-derive the fetch-and-hash dance by hand. Run `scripts/jobs/fetch-source.sh <url>`: it tries a direct `curl`; on a connection refusal (recurring for `erights.org` and its `caplet.com` mirror from the bot sandbox) it substitutes, IN ORDER — (1) the **erights.org GitHub Pages mirror** `https://erights.github.io/erights-org-website/<path>` (the PRIMARY substitute; it rewrites the URL preserving the path and serves the HTML site at full fidelity), then (2) the **Internet Archive** original-bytes capture `http://web.archive.org/web/<ts>id_/<url>` (the `id_` form returns unmodified bytes, reachable via plain curl even though WebFetch refuses `web.archive.org`) for what the mirror lacks (PDFs / talk files 404 on the mirror). It records which substitute served in `source_fetched_via` (`direct|mirror|wayback`) and prints `source_content_sha256` (plus the effective URL and `source_wayback_timestamp` when the archive served) — the idempotency anchor the source-file frontmatter records. The preference order above still chooses *which URL* to hand the script when a live venue copy beats the substitute; the script encodes the *fetch → mirror → archive-fallback → hashing* mechanics so the anchor comes out identical every cycle.

**Deterministic hub-child reachability — `scripts/jobs/check-source-children.sh`.** When the source is a hub / nav `index.html` whose child links you intend to ingest as sections (`elang/`, `data/`, `guarding/`, ...), do not hand-probe each link for reachability. Run `scripts/jobs/check-source-children.sh <hub-url>`: it fetches the hub through `fetch-source.sh` (the same direct → mirror → Internet-Archive `id_` fallback above), extracts the hub's same-host child hrefs (resolving relative links and normalizing `../`), probes each child through that same `fetch-source.sh` logic — retrying the toggled www / no-www host form before giving up — and emits a one-line-per-child manifest classifying each as `child_status=reachable` (with `child_via=direct|mirror|wayback`) or `child_status=dead` (404 on both the mirror and the Archive). Plan sections from that deterministic reachable/dead list rather than re-deriving the "verify reachability via `fetch-source.sh` before planning sections" probe by hand — the recurring caution whose omission once burned a whole ingest cycle chasing the never-written `elang/guarding/style.html`.

### Reading PDFs

The Read tool accepts `pages: "<range>"`. Maximum 20 pages per call. For ~15-20 page papers, one call suffices. For a 250-page thesis (Miller PhD 2006), plan multi-cycle ingest — one chapter or one cohesive argument cluster per cycle, not the whole document at once.

### Per-cycle pacing

Papers are denser than design docs. The recommended pacing is **one paper per cycle** (4-6 sections plus the source-file + topic + concept-page + keyword writes), not 3-5 like for repo sources. Continue chat-cluster / repo ingest in parallel cycles; a reasonable cadence is to alternate paper-cycle, chat-cycle, paper-cycle until either backlog drains.

## Sources from longform comments

Starting 2026-05-15, the library absorbs longform in-code comments out of repository source files as a third source kind alongside repo documents and external papers. The first such ingest is `packages/eventual-send/src/handled-promise.js`'s comment cluster covering the forwarding-forest, isSafePromise, and `dispatchToHandler` reductions. This section documents the schema, the slug convention, and the idempotency anchor that comment fragments use, which differ from repo doc-file sources because the relevant material is one comment block (or a small cluster) inside a larger source file rather than the whole file.

### What counts as a longform comment

- A JSDoc block (`/** ... */`) that goes substantially beyond type annotations: multiple paragraphs of prose, not just `@param`/`@returns` lines. Rule of thumb: ≥25 lines of comment with ≥3 paragraphs of prose, or ≥40 lines total.
- A bare-block comment (`/* ... */`) of similar length explaining a non-obvious mechanism, an invariant, or a design decision.
- Runs of `// ...` lines ≥8 consecutive lines explaining one cohesive idea.
- A file-level header comment that spans ≥20 lines of prose explaining the file's reason-for-existing.

Skip pure type-annotation JSDoc, copyright headers, and trivial `// XXX fixme` notes; those carry no library value.

### Slug pattern

```
<owner>--<path-dashed-no-extension>--<subject-dashed>
```

The `<path-dashed-no-extension>` is the full repo-relative path with `/` flattened to `-` and the file extension dropped. The `<subject-dashed>` is a short kebab-case description of the cohesive argument the comment makes. Avoid line numbers in the slug; line numbers shift, subjects do not. Examples:

- `endo--packages-eventual-send-src-handled-promise-js--handler-protocol` (source-file slug for the comment cluster as a whole).
- `endo--packages-eventual-send-src-handled-promise-js--forwarding-forest-union-find` (one section under that source, for the forwarding-graph argument).
- `endo--packages-marshal-src-encodetosmallcaps-js--smallcaps-rationale` (queued as a likely second pick).

The new slug convention diverges from the older `endo--pkg-<short>-...` shortening that existed for repo doc-file sources (e.g., `endo--pkg-eventual-send-readme`). The comment-fragment corpus uses the full path-dashed form per the inbox message `entries/2026/05/15/205458Z-message-liaison-0460cf.md`; new repo doc-file ingests are not retroactively renamed.

### Source-file frontmatter (comment-fragment schema)

Repo doc-file sources use `source_repo` / `source_path` / `source_commit`. Comment-fragment sources extend that schema with a line range and a subject line:

```yaml
---
source_kind: comment-fragment           # the discriminant: comment-fragment vs repo vs paper
source_repo: endojs/endo
source_path: packages/eventual-send/src/handled-promise.js
source_line_range: "44-389"             # the range *as of the recorded source_commit*; document this is a snapshot, not a live cursor
source_commit: <full sha>               # file-path-specific sha: `git --git-dir=worktrees/<owner>-<repo>.git log -1 --format=%H master -- <path>`
comment_subject: <one-line description of the cohesive argument cluster the comment makes>
source_authors: [<name>, ...]           # primary authors of the source FILE (git log over the file)
ingested: <YYYY-MM-DD>
ingested_by: <role>
section_count: <integer>
status: current
---
```

### Section-file frontmatter (comment-fragment schema)

Sections under a comment-fragment source inherit the schema and add their own `source_line_range` for the *specific* lines the section covers (which is often a sub-range of the source-file's range):

```yaml
---
title: <section heading>
source: <repo-relative source path>
source_kind: comment-fragment
source_repo: endojs/endo
source_path: <repo-relative source path>
source_line_range: "67-111"             # the lines covered by THIS section
source_commit: <full sha>
comment_subject: <one-line description>
ingested: <YYYY-MM-DD>
ingested_by: <role>
topics: [<topic-slug>, ...]
status: current
---
```

### Idempotency anchor

`source_commit` (file-path-specific sha, identical to repo doc-file ingests) is the anchor. The freshness check on later cycles compares the recorded `source_commit` to the current `git --git-dir=worktrees/<owner>-<repo>.git log -1 --format=%H master -- <path>`. If they differ, the scholar must verify the comment still exists in roughly the same shape: line ranges may have shifted, but the comment subject should still match. If the comment was rewritten substantively, re-ingest as new section files with `supersedes:` pointing at the prior section. If it was just moved, update `source_line_range` (this is the second permitted in-place edit on a section file, alongside the `status` flip).

### Section granularity

A single longform comment often deserves multiple section files: each cohesive argument cluster (a "subject" in the comment) is its own section. The source file's *Sections* table lists them the same way papers and repo doc-files do. Section count per comment-fragment source is typically 2-4; large comment clusters (e.g., a long file-header explaining a multi-stage algorithm) can yield more.

### Translation block convention

Comment-fragment sections occasionally include a brief `## Translation` table when the comment's idiom diverges from a reader's likely vocabulary (e.g., the shim-author's "operation reduction" vs the handler-implementer's "method call"). The convention is the same as the paper-source translation block: not exhaustive, just the terms the section actually uses.

### Per-cycle pacing

Comment fragments are denser per byte than design docs but typically shorter per *source* than papers. The recommended pacing is **one source file per cycle** (yielding 2-4 sections), not the 3-5 of repo doc-file ingest or the 1 of paper ingest. The three-lane round-robin (chat-cluster → external papers → comment fragments → chat-cluster → ...) accommodates this density: each cycle picks from the next lane.

### Notice/investigate/propose discipline

If a longform comment makes a claim the surrounding code does not honor (drift between comment and code), the scholar should *notice* during ingest, investigate against the rest of the codebase, and if a real divergence is found draft a boatman missive proposing whichever direction is right (update the comment to match the code, or update the code to match the comment). Comment-vs-code drift is one of the highest-payoff upstream-contribution classes for this corpus, since the maintainer values comment accuracy.

## Sources from the web

The library absorbs canonical web pages — external documentation, vendor reference, historical ocap essays — as a fourth source kind alongside repo documents, external papers, and longform comments. The first batch was the cloud-marketplace / TLS / signed-update reference set ingested 2026-06-11 for the gateway packaging milestone; the equality-taxonomy batch (`web--miller-equality-*`, `web--miller-grant-matcher-*`, ingested 2026-06-27) carries the fullest form of the contract because its canonical host was unreachable and it was captured from the Internet Archive. This section documents the schema, the slug convention, the content-hash idempotency anchor, and the Internet-Archive `id_` acquisition recipe — derived from those existing web sources so the written schema matches current practice.

### When it is appropriate

Ingest a web page when it is the **canonical source-of-truth** for material the corpus needs and there is no repo file or published paper to ingest instead: vendor documentation (AWS/Azure/GCP marketplace policy, Let's Encrypt ACME, TUF), historical ocap essays that exist only as web pages (Mark Miller's `erights.org` equality taxonomy), and similar. A web page is mutable in principle, so pin the bytes you actually ingested (see the idempotency anchor below) rather than trusting the live URL to be stable.

### Slug pattern

```
web--<short-title-dashed>
```

The `web--` prefix mirrors the `papers--` and `<owner>--` slug disciplines and groups generic web sources in `library/sources/` listings. Examples:

- `web--miller-equality-object-sameness`
- `web--aws-marketplace-ami-requirements`
- `web--lets-encrypt-acme-challenges`

A page that is part of a **named thematic cluster** rather than a one-off reference may take a thematic prefix instead of `web--` (e.g. `kriskowal-com--giants` for the `web-essay` kind, `ocap-history--e-capdesk-polaris` for the `web-survey` kind), the way papers group under `papers--`. Reserve the bare `web--` prefix for generic single-page reference ingests; use a thematic prefix only when a coherent multi-source cluster justifies its own namespace. This thematic-cluster-vs-bare-prefix rule is enforced deterministically by `scripts/jobs/library-slug-prefix-check.sh` (the source-slug prefix-divergence check): it maps each new source's upstream host to the slug prefixes its siblings already use and fails (or warns) when a proposed slug diverges, naming the canonical sibling prefix — pass `--allow-new-prefix` to register a genuinely-new thematic cluster on purpose.

### Source-file frontmatter (web schema)

Repo sources use `source_repo` / `source_path` / `source_commit`; papers use `source_pdf_sha256`. Web sources use a URL plus a content hash:

```yaml
---
source_kind: web                         # the discriminant: web vs repo vs paper vs comment-fragment
source_url: <canonical URL>              # the live, canonical page URL — a fixed pointer even if you fetched a snapshot
source_snapshot: <Internet-Archive id_ URL>  # the exact bytes-capture you ingested; present when fetched from an archive (see recipe below)
source_content_sha256: <full 64-char SHA-256> # idempotency anchor over the bytes you actually ingested — replaces source_commit
source_authors: [<name>, ...]           # primary authors of the page
source_date: <YYYY-MM-DD>               # the page's own publication / last-modified date; era approximation for undated pages
source_mirror_url: <URL>                 # optional; an alternate host, recorded when one exists
retrieved: <YYYY-MM-DD>                 # the date the bytes were fetched (distinct from `ingested`)
ingested: <YYYY-MM-DD>
ingested_by: <role>
section_count: <integer>
status: current
notes: <provenance one-liner; see below>
---
```

`source_kind: web` discriminates the schema variant. Two thematic-cluster variants are in use — `source_kind: web-essay` (a single authored essay; `source_author` singular) and `source_kind: web-survey` (a page synthesized from several already-ingested sources) — sharing the same `source_url` / `source_date` backbone; they are not new top-level kinds so much as labelled web sources. Prefer plain `web` unless the page is genuinely an essay or a synthesized survey.

When the page was **fetched live** and reachable (e.g. the 2026-06-11 marketplace batch), `source_url` + `source_date` carry the provenance and `source_snapshot` may be omitted. When the page was **captured from an archive** because the canonical host was unreachable (the 2026-06-27 `erights.org` batch — that host is documented as intermittently down in § PDF acquisition guidance), record both `source_snapshot` and `source_content_sha256`, and say so in `notes:` (which host was unreachable, that the bytes came from the `id_` capture, and that the idempotency anchor is the content hash, not a git SHA). For undated pages, set `source_date` to an era approximation and note it.

### Section-file frontmatter (web schema)

Section files filed under a web source inherit the source schema; `source` is dropped in favour of `source_url` (web pages have no repo-relative path). The section frontmatter:

```yaml
---
title: <section heading>
source_kind: web
source_url: <canonical URL>
source_content_sha256: <full sha256>
source_authors: [<name>, ...]
source_date: <YYYY-MM-DD>
ingested: <YYYY-MM-DD>
ingested_by: <role>
topics: [<topic-slug>, ...]
status: current
---
```

### Idempotency anchor

`source_content_sha256` replaces `source_commit` as the anchor for the idempotency check; web pages have no `git log` history to read. Compute it over the exact bytes you ingested (the `id_` capture's body, or the live response body), regardless of which host you fetched from — the canonical `source_url` stays a fixed pointer in frontmatter while the hash pins the bytes. On a later cycle, re-fetch the same `source_snapshot` (Internet-Archive captures are immutable, so the hash is stable) and compare; a mismatch means the page changed and warrants re-ingest. The check is degenerate for archive-pinned pages, exactly as it is for papers.

### Internet-Archive `id_` acquisition recipe

When the canonical host is unreachable, fetch the page's **original bytes** from the Internet Archive Wayback Machine using the `id_` ("identity") modifier on the timestamp:

```
http://web.archive.org/web/<timestamp>id_/<original URL>
```

The `id_` suffix tells the Wayback Machine to return the *original captured bytes unmodified* — no link rewriting, no injected toolbar, no banner — which is what makes the resulting `source_content_sha256` a stable, reproducible anchor. (Without `id_`, the Wayback Machine rewrites the response and the hash drifts between fetches.) The `<timestamp>` may be a partial date (a bare year such as `2020`) which the Wayback Machine resolves to the nearest capture. Worked example from the equality batch:

```
source_url:      https://erights.org/elib/equality/same-object.html
source_snapshot: http://web.archive.org/web/2020id_/http://www.erights.org/elib/equality/same-object.html
```

Record the resolved snapshot URL (as returned, with the concrete timestamp the Archive redirected to, when you can capture it) in `source_snapshot`, hash the fetched body into `source_content_sha256`, and keep the live canonical page in `source_url`.

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

Add rows to the `## Sections that touch this concept` table with the same deterministic `scripts/jobs/insert-sections-table-row.sh <concept-file> "<row>"` used for topic pages — it anchors on the concept-page heading variant too, so the row lands inside the table without hand-constructing the whole-file body. (Before job `improve-sections-table-row-concept-heading` the inserter matched only the bare `## Sections` heading, so concept-page rows had to be placed by hand each cycle.)

The `See also` block is allowed (and encouraged) to point at concept-ids that *contradict* or *abandon* the same concept under a different framing. See `crdt-in-formula-persistence` for a worked example: that page covers both where CRDT *shape* is used and where a bidirectional CRDT was *rejected*.

### Keyword index shape

`keywords.md` is a single file, one entry per line:

```
- <keyword or phrase>[, <synonym>, ...] -> <concept-id>
```

Multiple keywords may resolve to the same concept-id and are clustered as a comma-separated list in one bullet. Code-symbol keywords are written in backticks (`` `LOCAL_NODE` ``, `` `EndoGateway.followRetentionSet` ``); prose keywords are plain (`destruction by cohort`, `Karp Stiegler Close`). Letter case is preserved when meaningful. Both kinds live in the same file so a maintainer can scan synonym clusters easily.

The index is meant to be **grepped, not read by eye**. Use the [`library-lookup`](../../../skills/library-lookup/SKILL.md) skill rather than reading `keywords.md` linearly.

### Indexing on the fly

The librarian's job is not just to find information but to ensure that the *next* search for the same information either succeeds where it did not before, or succeeds faster than it did before. Every lookup is therefore both a *find* operation and an *index-improvement* operation. The `library-lookup` skill is the operational form of this discipline.

Three corresponding maintenance actions, performed by the caller of the skill at the point of lookup (not deferred to a future scholar cycle):

1. **Add the shortcut.** If the lookup reached the right concept page only via flat-grep across `sections/` (the keyword index did not have the term the caller used), add the term to `keywords.md` pointing at the concept-id the search converged on.
2. **Prune the distraction.** If a section came up in flat-grep but was the wrong answer for this query, record a one-line *disambiguation* on the right concept page so the next reader does not waste time on the false positive. The line goes in a `## Common confusions` block below `See also`.
3. **Draft the missing concept.** If no concept page existed for the term and the caller has enough context to write one, draft the page and add the keyword. Drafts get `status: draft` in frontmatter; a follow-up missive to scholar (one per cycle, not one per page) requests review and topic-page integration.

Permission: any role that uses the `library-lookup` skill may write these inline maintenance updates. Major restructuring (new topics, source-index changes, concept merges) remains scholar's province.

The skill's responsibility is to make this discipline trivial — its procedure section names when to perform each of the three actions, and the skill packages the writeback so the caller does not have to remember the file paths.
