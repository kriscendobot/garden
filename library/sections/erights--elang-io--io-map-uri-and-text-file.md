---
title: "IO: URI Expressions and Text File IO as capabilities"
source_kind: web
source_url: http://erights.org/elang/io/index.html
source_effective_url: https://erights.github.io/erights-org-website/elang/io/index.html
source_fetched_via: mirror
source_content_sha256: 03ec2863fc0a2fd82d98b96b2e1ea1e0ab3a36a7fbc41d3ddd3a8fdd811ee85e
source_authors: [Mark S. Miller]
source_date: 1998-10-03
ingested: 2026-06-28
ingested_by: scholar
topics: [e-language, capability-security]
status: current
notes: >
  Primary-source HTML via the erights.org GitHub Pages mirror. The landing page of
  E's *Primitive Data Types / IO* chapter. It is a thin hub: a two-row map to its
  child chapters (The URI Expression, Text File IO). Captured as a single map
  section. The child chapters (uri-exprs.html, text-file-io.html) are navigable
  from the source page and queued only if a reader needs the file-capability and
  URI-syntax detail; the capability-security significance of file access being a
  granted object rather than an ambient operation is summarized inline here.
---

## Abstract

E's **IO** chapter is the landing hub of E's input/output facilities, the last of
the three Primitive-Data-Types chapters (after Scalars and Collections, before
Concurrency). The page itself is a two-entry map to its child chapters: **The URI
Expression** (`uri-exprs.html`) and **Text File IO** (`text-file-io.html`). Its
library value is structural and conceptual rather than detailed: in E, IO is
**capability-mediated** — a program reads or writes a file only by holding a
`File`-object granted to it (a directory `File`-object indexes by name to child
`File`-objects, as the Collections chapter showed), and a URI expression is the
syntax for naming an external resource as a capability. This is the E-language
root of the ocap principle that Endo / Hardened JavaScript enforce by removing
ambient authority: there is no global `open()` reachable by name; file and network
access arrive as objects passed in (the powerbox / `@endo/daemon` capability-bank
discipline).

## The IO chapter map

The IO chapter is a thin hub mapping to two child chapters:

| Child chapter | Subject |
|---------------|---------|
| [The URI Expression](https://erights.github.io/erights-org-website/elang/io/uri-exprs.html) | E's syntax for naming an external resource (a file, a remote object) as a URI-denoted capability. |
| [Text File IO](https://erights.github.io/erights-org-website/elang/io/text-file-io.html) | Reading and writing text files through granted `File`-objects; directory `File`-objects as name-to-file maps (the collection behavior the Collections chapter cross-references). |

The chapter's navigation places IO between Collections (previous) and Concurrency
in E (next, `erights--elang-concurrency-index--event-loop-concurrency-map`).

## Capability-mediated IO (the conceptual point)

E's IO is **capability-mediated**: a program performs file IO only by holding a
`File`-object that was granted to it, never by naming a global open-by-path
operation. A directory `File`-object maps from local file names to the `File`-
objects found there (the "other objects that act like collections" example from
`erights--elang-collect--collections-tables-spaces-and-the-for-loop`), so
authority to a subtree of the filesystem is conveyed by passing the corresponding
`File`-object, and nothing more. A URI expression names such a resource as a
capability rather than as an ambient path lookup.

This is the direct E-language ancestor of the no-ambient-authority discipline Endo
enforces: Hardened JavaScript removes the global IO primitives, and file / network
/ clock access reach a program only as objects injected through the powerbox or
the daemon's capability bank. "IO is an object you are handed, not a name you can
reach" is the same rule at both ends.

## Translation

| E term | Endo / Hardened JavaScript equivalent |
|--------|----------------------------------------|
| `File`-object (granted) | a file capability injected via the powerbox / daemon capability bank |
| directory `File`-object (name-to-file map) | a directory capability / `MapStore` of child file capabilities |
| URI expression | a capability name / locator (OCapN sturdyref ancestor) |
| capability-mediated IO | no-ambient-authority IO; intrinsics removed, authority injected |

Source: [elang/io/index.html](https://erights.github.io/erights-org-website/elang/io/index.html) (erights.org GitHub Pages mirror), content SHA-256 `03ec2863`, last modified 1998-10-03.
