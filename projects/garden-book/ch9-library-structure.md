---
created: 2026-09-30
author: gardener (job book-revise-content)
grounded-on: main2 c63c16cad57, journal2 as of 2026-09-30
---

# Chapter 9: The library, and how it spends context

This chapter covers the garden's reference library under `journal/library/`:
what it looks like on disk, how material gets in, how a worker finds it again,
and why the whole thing is shaped around a subagent's context window rather
than around being a complete encyclopedia. It does not cover the per-project
trees under `journal/projects/` except where they share the same discipline.

## Why the garden keeps a library at all

A gardener that claims a design or build job starts with an empty head. It has
its role brief, the skills that role names, and the job body. Everything else
it has to find. For the domains the garden works in (hardened JavaScript,
capability security, OCapN, the Endo daemon, the XS engine and its Rust port),
the relevant knowledge is spread across hundreds of upstream documents, papers,
design notes, and long review comments. If every job rediscovered that material
by reading upstream repositories directly, each job would pay the reading cost
again, and each would pick its own words for the same ideas.

The library is the garden's answer: a curated, cross-cutting reference that
workers consult by lookup instead of by reading. On 2026-09-30 it holds about
1,000 source-index pages, 7,235 section files, 99 topic pages, and 269 concept
pages, about 32 MB of Markdown in all. That is roughly eight million tokens,
far more than any model's context window. The design problem is not "how do we
store this" but "how does a worker with a few hundred thousand tokens of
context, most of which it needs for the actual job, get at the two or three
pages that matter."

## What it looks like on disk

The library lives on the `journal2` branch, in `journal/library/`:

```
journal/library/
  README.md          the entry point: what each axis is for
  conventions.md     the canonical schema (read before authoring anything)
  keywords.md        term -> concept-id map, meant to be grepped
  sources/           one index page per upstream document (by provenance)
  sections/          the content itself, one file per source section
  topics/            catalog pages by broad subject
  concepts/          short lookup targets, one per domain term
```

Each directory carries its own `README.md` index, and each index is a set of
one-line abstracts rather than a filename listing.

### Sections: where the content actually lives

Almost all of the library's bytes are in `sections/`. A section file is one
heading's worth of one upstream document, named
`sections/<source-slug>--<section-slug>.md`. The source slug flattens the
upstream path and prefixes the project, so `endojs/endo/docs/lockdown.md`
becomes `endo--docs-lockdown`. The section slug is the kebab-cased heading, or
`overview` for text above the first sub-heading. The default cut is at H2; an
author descends to H3 only when an H2 wraps several unrelated H3 topics.

Every section carries full provenance frontmatter: the source path and repo,
the file-specific `source_commit` (the last commit that touched *that file*,
not the repository's head), the source's date and authors, when and by which
role it was ingested, the topics it is filed under, and a `status` of
`current`, `stale`, `superseded`, or `conflicted`. The body opens with a
one-paragraph **Abstract**, then the section's content (lightly cleaned and
mostly verbatim), and ends with a footer linking the upstream file at the
recorded commit.

Section files are small by construction. The median is about 2.1 KB, roughly
500 tokens.

### The three indexing axes

Sections are reachable along three independent axes, each partitioning the
same content a different way:

- **Sources** (by provenance). `sources/<source-slug>.md` is a short page for
  one upstream document: an abstract, a metadata block, and a table of the
  section files cut from it. Use this axis when you know *which document* you
  want.
- **Topics** (by subject). `topics/<topic-slug>.md` has no frontmatter; it is a
  catalog page with an abstract, a `Sections` table (one row per filed
  section, with that section's abstract first sentence), and a see-also list.
  Use this axis when you want *everything about a subject*, such as
  `capability-security` or `marshal`.
- **Concepts** (by the unit a reader actually looks up). `concepts/<id>.md` is
  a short page with `id`, `aliases`, and `topics` frontmatter, a one-paragraph
  definition, a table of the sections that touch the concept, and a see-also
  list of related concepts. `keywords.md` maps terms to concept ids, one bullet
  per cluster (`- ambient authority, ambient capability, ... -> ambient-authority`),
  with code symbols in backticks so symbol and prose keywords are
  distinguishable at a glance. Use this axis when you have a *specific term*
  in mind and do not know which document or subject owns it.

The concepts axis came last and is now the primary entry point for lookup,
because a worker's question almost always starts from a term in the task in
front of it, not from a document name or a subject heading.

### Keeping it honest: staleness, supersession, contradiction

The journal is append-only, and the library follows suit. When a section
becomes wrong, nobody edits it in place. Its `status` flips to `stale` or
`superseded` with a `notes:` line saying why; a replacement section names the
old one in `supersedes:`. When two sections genuinely disagree and neither
replaces the other, both become `conflicted` and name each other under
`contradicts:`, so the next reader sees the disagreement instead of silently
picking a side.

A milder case is common and deliberately not treated as conflict: two sources
covering the same material at different altitudes (a reference summary, a
detailed chapter, a tutorial walkthrough). Those stay `current`, cross-linked
through `notes:`, because they serve different readers.

### Variants by source kind

Most sources are repository documents, but `conventions.md` defines variant
schemas for four other kinds, each with its own slug pattern, frontmatter, and
idempotency anchor:

- **Unmerged pull requests**, with provenance pinned to the PR head and a
  lifecycle for when the PR merges or dies.
- **External papers**, anchored on the PDF's SHA-256 rather than a commit, with
  a translation-block convention for non-English originals.
- **Longform comments** (substantial review or issue comments), anchored on the
  comment and its line range.
- **Web pages**, with an Internet Archive `id_` acquisition recipe for sites
  that refuse direct fetches.

All of them share the same abstract-first section body, so a reader never has
to know which kind a section came from in order to use it.

### Library versus project tree

Two sibling trees use the same authoring discipline and are easy to confuse.
`journal/library/` holds *reusable technical material*: API documentation,
design rationale, security policy, anything that could apply to more than one
project. `journal/projects/<slug>/` holds *project-bound operating rules*:
rules of engagement, identity and credentials, who has authority over what.
"What `harden` does to an object" belongs in the library. "How the boatman
ferries work upstream to endo" belongs in the project tree.

## How content gets in: the scholar

The library grows through one role, the
[scholar](../../roles/scholar/AGENT.md). The scholar is job-driven, not a
standing daemon. Work reaches it as a board job (`scholar-ingest-<repo>`,
`scholar-ingest-source`, `scholar-library-refresh`,
`scholar-review-writebacks`), as a recurring library-refresh schedule that the
scheduler duplicates onto the board, or, for compatibility, as a bus message
asking for an ingest. A gardener claims the job, wears the scholar role for
the life of the job, and finishes. There is no scholar running between jobs.

### One job, one cycle

Each claimed job is one cycle with a fixed procedure: sync the journal, read
the ask and drain the scholar inbox, survey the target, ingest, update the
indexes, run an integrity gate, land, and report.

The ingest step is where the library's cost discipline starts. For each queued
source the scholar computes the source slug and reads the existing
`sources/<slug>.md`, if any, for its recorded `source_commit` (or
`source_pdf_sha256` for a paper). It then asks the upstream bare clone for the
file-specific commit that last touched that path. **If the two match, the
library is already current for that source**: the scholar records a one-line
skip in its result and moves on without reading the source at all. Only on a
mismatch does it read the source at the new commit, cut sections, and write
section, source, topic, and concept files.

That check is what makes ingestion cheap to request. Any role can ask for a
source to be ingested, and any schedule can re-ask on a timer, because a
re-ask against an unchanged file costs one `git log` and a line in a report.
It is also why the frontmatter insists on the file-specific commit rather than
the repository's head: a repo head moves on every unrelated commit and would
force a pointless re-read.

Re-ingestion is append-only. A changed source produces new section files; the
old ones flip to `superseded`. The permitted in-place edits are that status
flip and, for comment-sourced sections, updating a line range when the comment
merely moved. Nothing is silently rewritten.

Foreign content gets an extra gate. A web page or paper is fetched with
`scripts/jobs/fetch-source.sh` (which knows how to fall back to the Internet
Archive), then passed through `scripts/jobs/classify-foreign-content.sh`
before the scholar reads it, so that text written by strangers is classified
before it can steer a model.

### The section budget

A scholar cycle stops after roughly three to five source documents or about
25 section-file writes, whichever comes first. One large document (a
16-section `docs/lockdown.md`, a dense paper, one longform comment file) is a
full cycle on its own. The role brief gives the reason plainly: long cycles
risk leaving the journal half-written, and they burn context.

When a source or repository is bigger than one cycle, the scholar does not
truncate silently and does not spawn subagents. It writes what it could
support, then posts a follow-on `scholar-ingest-<repo>` job naming exactly
what is left: which packages, which design docs, which sections. The next
cycle picks up from there with a fresh context. A large repository is ingested
as a chain of bounded cycles rather than one heroic one.

### Indexes, integrity, landing

After writing content, the scholar updates the hand-maintained indexes
(`sources/README.md`, `topics/README.md`, `concepts/README.md`, and
`keywords.md`) and adds topic and concept table rows through
`scripts/jobs/insert-sections-table-row.sh`, which anchors on the table's own
boundary so a row never lands in the wrong place.

Then a deterministic integrity gate runs: `library-link-check.sh` resolves
every section-table target and index row the cycle touched, and
`regenerate-topics-counts.sh --check` confirms the topic counts. A nonzero
exit blocks completion. Every content file lands through
`scripts/jobs/land-journal-edit.sh`, the one sanctioned lander for `library/`
and `projects/`, which writes through an isolated producer clone with a
compare-and-swap push. The flat `sections/README.md` index and the topic
counts are then *regenerated*, never hand-edited, so they cannot drift from
the files they describe.

The scholar finishes with a `result` entry in the journal naming each source
ingested or skipped (with the matching sha), each follow-on job posted, and a
short digest to the maintainer.

## How content gets found: library-lookup

The reading side is the [library-lookup](../../skills/library-lookup/SKILL.md)
skill. Any role that touches the library uses it; the researcher uses it most.

### A hit

The caller has a term: a code symbol like `LOCAL_NODE`, a proper name, a
domain phrase like "ambient authority." It greps the keyword index:

```sh
grep -i "ambient authority" journal/library/keywords.md
```

On a hit, the line names a concept id. The caller reads
`concepts/ambient-authority.md`, a page of a screen or less: a definition, a
table of the sections that touch the concept with one-line summaries, and a
see-also list. From that table it opens only the one or two sections whose
summaries match its question. Done.

The whole lookup reads one grep result line, one concept page of about 400
tokens, and one or two sections of about 500 tokens each. It never opens
`keywords.md` as a document (the skill says outright that the file is meant to
be grepped, not read), and it never opens a source document whole.

### A miss

If the keyword index has nothing, the skill falls back in widening rings:

1. Try synonyms and variant forms: a code symbol's bare name and file name,
   casing variants of a prose term.
2. Flat-grep the section files:
   `grep -l -i "<term>" journal/library/sections/*.md`, then read the matches'
   abstracts and decide which, if any, actually answer the question.
3. If that fails, check `topics/README.md` and `sources/README.md` for an
   adjacent subject or document.
4. If still nothing, the term is not in the library, and the caller says so.

Even the flat-grep fallback stays cheap, because it returns filenames and the
caller reads abstracts first. The abstract is written to be an exit criterion:
a reader whose question does not match it stops and moves to the next match.

### Every lookup improves the index

The part that makes the library get better with use is step 4 of the skill,
which is mandatory. `conventions.md` states the principle: the librarian's job
is not just to find information but to make sure the *next* search for the
same information succeeds where this one did not, or succeeds faster. The
caller, at the point of lookup and not in some later cleanup pass, does one of
three things:

- **Add a shortcut.** If it reached the right concept only through flat-grep,
  the term it actually used was missing from `keywords.md`. It appends
  `- <that term> -> <concept-id>`. The next caller with that term hits on the
  first grep.
- **Prune a distraction.** If flat-grep surfaced a section that looked right
  but was about something else, the caller adds a line to a `## Common
  confusions` block on the right concept page, naming the misleading section
  and where its real subject lives. The next reader sees the warning before
  wasting a read.
- **Draft a missing concept.** If no concept page existed and the caller read
  enough to write one, it drafts `concepts/<new-id>.md` with `status: draft`,
  adds the keywords, and lists it in `concepts/README.md`. If it did not read
  enough, it does not guess.

At the end of the job, not after each lookup, the caller tells the scholar
what it changed (a bus message to `role/scholar` or a
`scholar-review-writebacks` job), and the scholar's next cycle audits the
shortcuts and folds the drafts into topic pages. Every writeback lands through
the same `land-journal-edit.sh` lander.

The division of authority is deliberate. Any lookup caller may add keywords,
confusions, and draft concepts, because those are small, append-style, and
directly justified by a real query. New topics, source-index changes, and
concept merges remain the scholar's.

The effect compounds. Each flat-grep fallback that ends in a shortcut converts
an expensive lookup into a cheap one for every later caller. The keyword index
ends up reflecting the vocabulary workers actually use, not the vocabulary an
author guessed they would use.

## How research uses it: the researcher

The [researcher](../../roles/researcher/AGENT.md) is where the library meets
design and build work. By default a research step runs before a design or
build job's work stage, either as a preparation stage of the gardener-
supervised job or as a posted `research` job whose result the design or build
job inlines. (It does not run for fixer, weave, shepherd, conductor, or panel
work; those read PR state and journal entries directly.)

The researcher reads the proposed task as data, not as instructions, and
picks out its domain terms, code symbols, proper names, and references to
existing design slugs. For each one it runs library-lookup, including the
writeback. When a project slug is set, it also walks
`journal/projects/<slug>/`: the README's rules of engagement and authority
structure, and topic files matching the task. It does not check out project
code.

Its deliverable is a single `## Library and project references` section,
grouped into **Library concepts and sections** and **Project context**, with a
half-line per citation saying why it matters to this task. That section is
inlined into the design or build job body *before* the work starts. The
designer or builder therefore begins with the garden's existing terminology
and prior art already in its context, rather than inventing new names for old
ideas or re-deriving a design the library already records.

The researcher's own norms mirror the library's economy. The refinement is
additive: it never rewrites the task. Every citation must point at a file that
exists; a load-bearing term with no library coverage becomes an open question,
not an invented reference. Relevance half-lines stay to one short sentence,
since a long justification usually means the reference is not relevant. The
target is one to three minutes of wall time, and a task with more than about a
dozen lookup-worthy terms is trimmed to the most relevant subset, with the rest
listed as open questions for the downstream stage to look up itself. A
refinement that skipped a required writeback counts as partial.

## Why it is shaped this way: the context economy

Everything above follows from one constraint. A worker's context window is
limited, and every token in it costs money and displaces something else. The
library is not built to be *complete*; at eight million tokens it could never
be loaded whole anyway. It is built so that a worker with a specific question
can load *only the part that answers it*.

### The authoring discipline

The [context-library](../../skills/context-library/SKILL.md) skill states the
rules the library's authors follow (and which the garden's `context/` operator
manual and project trees follow too):

- **Directory as hierarchy.** Every directory in a context tree has a
  `README.md` index whose rows are abstracts that tell the reader what they
  will find if they descend, not a list of filenames.
- **Abstract at the top.** Every document opens with a short abstract specific
  enough to decide whether to read the body: it uses the words a query would
  use, says what is and is not inside, and predicts the body's value instead
  of paraphrasing it.
- **The abstract is a contract.** A reader walking the tree reads the index,
  picks the best-matching child, reads that child's abstract, and descends
  only on a match; otherwise it tries the next child, and if nothing matches
  it reports the breadcrumbs it tried. A body that fails its abstract is a
  defect.
- **Partition cleanly.** Children of a directory should split the parent's
  subject so that any query predictably lands in exactly one child. When two
  siblings keep colliding, the fix is usually a deeper hierarchy, not a longer
  document.
- **Prefer many small files to one long file.** The failure mode the skill
  exists to prevent is a single file with numbered sections, where readers
  grep for keywords instead of navigating and new content is appended as yet
  another section.

### What partitioning buys a subagent

Consider a builder about to touch code that deals with retention in the Endo
daemon. It needs to know what one specific term means and what constraints the
existing design put on it.

In a library written as a handful of long documents, the relevant paragraph
would live somewhere inside a design document of tens of thousands of tokens.
To find it, the builder (or a subagent it sent) would load the document, or at
least large chunks of it, and most of what it loaded would be about other
things. Those tokens are not free. They are paid for on the way in, they are
paid for again on every later turn that re-reads the context, and they push
the job's own code, diffs, and test output toward the edge of the window.
Irrelevant material in context is also a correctness risk: a model reasons
over whatever is in front of it.

In the partitioned library, the same lookup reads one line of grep output, a
concept page of a few hundred tokens, and one or two sections of a few hundred
tokens each: on the order of a thousand to fifteen hundred tokens, nearly all
of it on topic. Each step is cheap enough that reading an abstract and
*rejecting* the page is a reasonable move, which is exactly what the
exit-criteria contract asks for. The cost of a lookup scales with the
question, not with the size of the library. That is the property that lets
the library keep growing without making every job more expensive.

The concept page is the sharpest example. The skill caps it at about a screen
and says that if it grows past that, the material wants to be a topic page or
a section instead. A concept page is a lookup target, not a primer, so the
reader who lands on it pays only for the pointer and the definition.

### The same discipline, applied to writing

The scholar's limits are the same economy applied on the writing side. A
cycle of three to five sources or about 25 section writes keeps each ingest
job's own context bounded: the scholar holds the source, the sections it is
cutting, and the indexes it is updating, and nothing else. The idempotency
check means an unchanged source costs a `git log` rather than a read. The
follow-on job for remainder work means a large repository never has to fit in
one context; it is spread across many fresh ones, each doing a bounded
amount. And the small-file shape the scholar writes into is what makes the
reader's bounded lookups possible in the first place.

The researcher's budget completes the picture. Its output is a handful of
citations with half-line justifications, not a digest of everything it read,
so the design or build job that inlines it receives a pointer set of a few
hundred tokens and can follow any pointer, through library-lookup, only if the
work actually needs it.

Read together, the three roles form one loop. The scholar writes small,
abstract-first, provenance-pinned pages in bounded cycles. Every reader looks
them up by term, pays only for what it reads, and leaves the index a little
sharper than it found it. The researcher turns that into a short grounding
section in front of each design and build. None of the three ever needs the
whole library in context, and that is the point of its shape.

## Sources

- [`journal/library/conventions.md`](https://github.com/kriscendobot/garden/blob/journal2/library/conventions.md) (on `journal2`): file naming, frontmatter schemas, the three axes, staleness rules, source-kind variants, indexing on the fly.
- [`skills/library-lookup/SKILL.md`](../../skills/library-lookup/SKILL.md): lookup, fallback, and the writeback steps.
- [`skills/context-library/SKILL.md`](../../skills/context-library/SKILL.md): the authoring discipline.
- [`roles/scholar/AGENT.md`](../../roles/scholar/AGENT.md): how work arrives, the per-job procedure, the section budget, landing.
- [`roles/researcher/AGENT.md`](../../roles/researcher/AGENT.md): the research step and its output shape.
- Library counts and file sizes were measured on the `journal2` worktree on 2026-09-30.
