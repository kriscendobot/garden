---
title: "The E Language (index / landing)"
source_kind: web
source_url: http://erights.org/elang/index.html
source_effective_url: https://erights.github.io/erights-org-website/elang/index.html
source_fetched_via: mirror
source_content_sha256: 77f5814bce5dbbd8b320205b9a6b706a9e15b321ef686ba33986ab3186d0d7fa
source_authors: [Mark S. Miller]
source_date: 1998-10-03
ingested: 2026-06-28
ingested_by: scholar
topics: [e-language, capability-security]
status: current
notes: >
  Primary-source HTML fetched via the erights.org GitHub Pages mirror
  (the bare erights.org host refuses connections from the bot sandbox).
  This is the actual landing page; the prior synthesized survey
  ocap-history--e-capdesk-polaris uses the same URL but was reconstructed
  from secondary sources because the site was unreachable. Soft-flag
  cross-source overlap (primary vs survey), not a contradiction.
---

## Abstract

The navigation hub for Mark Miller's documentation of **E**, the
capability-secure distributed programming language that is the direct
intellectual ancestor of Hardened JavaScript / Endo. The page catalogs E's
documentation tree under five headings (Introductory Material, Language
Specification, Primitive Data Types, Concurrency / Soft Type Checking, and
Historical / Tools), and frames E with its design tagline (Alan Kay's "Simple
Things Should Be Simple, Complex Things Should Be Possible") and its one-line
self-description: "Cryptographic Capabilities for Distributed Smart
Contracting." This section captures the page's value as a map: it is the entry
point a reader uses to find the substantive E subpages, several of which the
library ingests on their own (Sameness, the E Tutorial, the grammar /
Kernel-E specification) and several of which remain queued.

## What E is

E is a programming language for writing distributed, capability-secure
programs. Its keyword self-description (from the page's metadata) is
*"Cryptographic Capabilities for Distributed Smart Contracting,"* and its
recurring themes are object capabilities, message-pipelining, vats and the
event loop, persistent objects, and the Granovetter diagram. E's syntax is an
LALR(1) grammar whose semantics is defined by expansion to a small core called
**Kernel-E** ("special forms"). The language combines a scripting surface with
strong cryptographic distribution: inter-machine communication is protected by
E's **Pluribus** protocol (the cryptographic enactment of capability semantics
described in the already-ingested *Capability-Based Financial Instruments*
paper).

## The documentation tree (this page's map)

The landing page organizes the E corpus as follows. Pages marked *(ingested)*
have their own library source; the rest are queued (see the
`scholar-ingest-erights-2` follow-on).

**Introductory Material**

- *The E Language in a Walnut* — Marc Stiegler's draft introductory book
  (hosted off-site at skyhunter.com).
- *E Tutorial* (`intro/index.html`) — the main tutorial hub: Starting E and
  Elmer, Finding Text, Standalone E Programs, *A 15 Minute Introduction to E*
  (Stiegler), Lambda-Based Objects, Introducing Remote Objects, Secureit-Echat,
  and the Simple Money Example. (queued)
- *E Idioms Quick Reference Card* (`quick-ref.html`). (queued)

**Language Specification**

- *Language Grammar* (`grammar/index.html`) — the full LALR(1) syntax;
  semantics defined by expansion to Kernel-E. (queued)
- *Block & Scope Structure* (`blocks/index.html`). (queued)
- *Kernel-E* (`kernel/index.html`) — the special forms, their semantics, and
  their translation to XML and Java. (queued)
- *Sameness* (`same-ref.html`) — E's notion of synchronous equality.
  **(ingested: `erights--elang-same-ref`)**

**Primitive Data Types**

- *Scalars* (`scalars/index.html`), *Collections* (`collect/index.html`), *IO*
  (`io/index.html`). (queued)

**Concurrency and checking**

- *Concurrency* (`concurrency/index.html`) — the event-loop / vat / eventual-send
  model, including *Introducing Remote Objects*. (queued)
- *Soft Type Checking* (`guarding/index.html`) — E's guards. (queued)
- *Annotated EChat* (`echat/index.html`), *On-Line Help* (`help.html`). (queued)

**Historical and tools**

- E's Original Design Goals, World Scripting Examples, "Satan Comes to Dinner",
  the Updoc/Elmer testing tools, the EBrowser, and the ENative project.

## Translation (E to Endo)

| E term | Endo / Hardened JavaScript equivalent |
|---|---|
| E (the language) | Hardened JavaScript / SES + `@endo/eventual-send` (the lineage descendant) |
| vat | compartment / per-agent event-loop domain |
| Pluribus | CapTP + OCapN (the capability transport protocol family) |
| Kernel-E (special forms) | the SES intrinsics + the small set of endowed globals |
| eventual-send (`<-`) | `E(target).method(...)` |

## Source

Source: [elang/index.html](https://erights.github.io/erights-org-website/elang/index.html) (mirror of `http://erights.org/elang/index.html`), last modified 1998-10-03, content SHA-256 `77f5814bce5dbbd8b320205b9a6b706a9e15b321ef686ba33986ab3186d0d7fa`, fetched via the erights.org GitHub Pages mirror.
