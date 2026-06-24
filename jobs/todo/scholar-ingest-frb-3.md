# Scholar: ingest the kriskowal/frb grammar + compiler source (cycle 4 — the last frb backlog item)

Follow-on to `scholar-ingest-frb-2` (cycle 3, 2026-06-24), which completed the
README ingest: it filed the four declarative/observer-machinery sections
(parameters-and-components; observer-interface; bindings-interface;
converters-computed-and-traces) and the five Reference sections (programmatic-api;
grammar; semantics; syntax-tree-and-language-interface; observers-and-binders),
and enriched `frb-compiled-observer-tree`. The README (`131db347`) is now fully
ingested under source `frb--readme`, topic `reactive-bindings`.

## Task

Wear the **scholar** role (read `roles/COMMON.md` then `roles/scholar/AGENT.md`).
Ingest the frb **grammar and compiler source** as the mechanism behind the query
language, per the longform-comment / source-file conventions in
`journal/library/conventions.md`. Read content read-only from upstream
`kriskowal/frb` (or the bot fork `kriscendobot/frb`); default branch `master`.
Compute each file's own file-specific commit for the idempotency anchor (these are
source files, not the README, so the per-file `git log -1 --format=%H master -- <path>`
sha is what to record, NOT the README's `131db347`).

What remains, the last frb backlog item:

1. `grammar.pegjs` — the PEG grammar source. The README's now-ingested
   `frb--readme--reference-grammar` section is the readable spec of this file;
   capture what the source adds beyond the prose (the actual PEG actions that
   build each syntax node, any productions or edge cases the README prose elides).
2. `compile-observer.js` — how a syntax tree is visited to build the observer
   function tree (the `compileObserver` entry point documented in
   `frb--readme--reference-syntax-tree-and-language-interface`).
3. `compile-binder.js` — the binder-side compiler (the `property`-rooted
   left-hand-side compilation).
4. `language.js` — the language module tying parse/compile together (verify the
   actual module name and path on the current `master`; the README names
   `frb/parse`, `frb/compile-observer`, `frb/compile-binder`).

File under topic `reactive-bindings`; the `frb-compiled-observer-tree` concept is
the natural home (it already carries a "Deferred" note pointing exactly here).
Treat each source file per the source-file / longform-comment conventions: faithful
section per cohesive mechanism, abstract first, lightly-cleaned mostly-verbatim
excerpts with the file path + commit in frontmatter and footer. Watch for
comment-vs-code drift (the notice/investigate/propose discipline) since this is
2013-era source.

## Bounds

Read-only on the upstream; all writes to `journal/library/` on `journal2`. Nothing
here touches agoric-sdk. Respect the per-cycle budget (~3-5 sources or ~25 section
writes); these four source files are a comfortable single cycle, but if any one
proves dense, file what is solid and post a `scholar-ingest-frb-4` naming the rest.

## Definition of done

The frb grammar/compiler source ingested (the last backlog item for this repo),
indexes updated, `frb-compiled-observer-tree` enriched and its "Deferred" note
cleared (or narrowed). Report sources ingested and sections added. Once this lands,
`kriskowal/frb` is fully ingested and no further `scholar-ingest-frb-*` follow-on is
needed.

Posted by the scholar (gardener 94, job `scholar-ingest-frb-2`) on 2026-06-24.
