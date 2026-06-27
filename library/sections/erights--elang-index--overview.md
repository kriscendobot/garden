---
title: "The E Language — documentation index (erights.org/elang)"
source_kind: web
source_url: https://erights.org/elang/index.html
source_effective_url: https://erights.github.io/erights-org-website/elang/index.html
source_fetched_via: mirror
source_content_sha256: 77f5814bce5dbbd8b320205b9a6b706a9e15b321ef686ba33986ab3186d0d7fa
source_authors: [Mark S. Miller]
source_date: 1998-10-03
ingested: 2026-06-27
ingested_by: scholar
topics: [capability-theory, capability-security]
status: current
notes: |
  Primary erights.org E-language documentation index, fetched from the
  erights.github.io GitHub Pages mirror (erights.org refuses connections from the
  sandbox; `source_fetched_via=mirror`). This is Mark S. Miller's own
  table-of-contents for E's documentation — distinct from the secondary-source
  market-history survey ocap-history--e-capdesk-polaris, which synthesizes the
  Miller papers + Wikipedia + the Waterken project page. The page itself records
  a last-modified date of 1998-10-03; the byte-identity anchor is
  source_content_sha256 (the mirror serves the original site paths verbatim).
---

## Abstract

The primary erights.org documentation index for **E**, the object-capability language Mark S. Miller describes as "Cryptographic Capabilities for Distributed Smart Contracting." The page is the navigational root of E's documentation tree — it does not teach E so much as enumerate, in Miller's own organization circa 1998, the introductory material, language specification, primitive data types, concurrency and type-checking facilities, historical design notes, and tooling that made up the E project. It is the canonical primary artifact behind the library's secondary-source survey of E/CapDesk/Polaris, and it grounds the lineage that the Miller papers (Concurrency Among Strangers, The Structure of Authority) trace forward into Endo's vat / eventual-send / promise-pipelining model.

## The page

**Title:** The E Language. **Tagline:** *"Simple Things Should Be Simple, Complex Things Should Be Possible."* — Alan Kay. **Author:** Mark S. Miller. **Self-description (meta):** "E: Cryptographic Capabilities for Distributed Smart Contracting." The page's own keyword list names the project's preoccupations: peer-to-peer objects, capability security, cryptography, distributed and persistent objects, lambda calculus, a capability shell over Java, smart contracting, Agoric e-commerce, message pipelining, quasi-literals, **vat**, **event loop**, and the **granovetter diagram**.

### Introductory Material

- **[The E Language in a Walnut](http://www.skyhunter.com/marcs/ewalnut.html)** — Marc Stiegler's draft book introducing E.
- **E Tutorial** (`elang/intro/`) — more introductory material.
- **E Idioms Quick Reference Card** (`elang/quick-ref.html`) — fast reminders.

### Language Specification

- **Language Grammar** (`elang/grammar/`) — "The full E language syntax is given by an LALR(1) grammar, and its semantics is defined by expansion to Kernel-E."
- **Block & Scope Structure** (`elang/blocks/`).
- **Kernel-E** (`elang/kernel/`) — "The E 'special forms', their semantics, and their translation to XML & Java." Kernel-E is the small core that the full surface grammar expands into.
- **Sameness** (`elang/same-ref.html`) — "E's notion of synchronous equality."

### Primitive Data Types

- **Scalars** (`elang/scalars/`).
- **Collections** (`elang/collect/`).
- **IO** (`elang/io/`).

### Behavior and tooling facilities

- **Concurrency** (`elang/concurrency/`) — E's event-loop / vat concurrency model (the subject the Miller papers develop in depth).
- **Soft Type Checking** (`elang/guarding/`) — E's guard-based optional type discipline.
- **Annotated EChat** (`elang/echat/`).
- **On-Line Help** (`elang/help.html`).

### Historical

- **E's Original Design Goals** (`e/e-goals.html`).
- **E World Scripting Examples** (`e/e-world-scripting.html`).
- **"Satan Comes to Dinner" in E** (`e/satan/`).

### Tools

- Testing: **Updoc & Elmer** (`elang/tools/updoc.html`).
- Editing and browsing: **[EBrowser](http://www.skyhunter.com/marcs/eBrowserIndex.html)**.

### The ENative Project

(`enative/`) — framed by a single question: *"How fast can a simple implementation of E be?"*

### Site navigation and license

The page sits in the erights.org documentation tree alongside **ELib** (inter-object semantics), **Smart Contracts**, **Related** work, **Download**, the **FAQ** (`mumble.net/e/faq.html`), the **API** javadoc, the **Mail Archive** (`eros-os.org/pipermail/e-lang/`), and **Donate**. Miller places "all text on this page which is either unattributed or by Mark S. Miller … in the public domain."

## Translation

| E (this page) | Endo equivalent |
|---|---|
| vat (heap + thread + pending-delivery queue) | compartment + bundle (eventual-send delivery turns) |
| Kernel-E (small core the surface grammar expands to) | no direct analogue; compare the kernel/surface split to SES's intrinsics-vs-surface taming |
| eventual-send / message pipelining | `E()` / promise pipelining (HandledPromise) |
| Sameness (synchronous equality) | `@endo/pass-style` sameness / key equality |

Source: [The E Language](https://erights.org/elang/index.html) (erights.org/elang/index.html), authored by Mark S. Miller, last modified 1998-10-03. Fetched 2026-06-27 from the GitHub Pages mirror `https://erights.github.io/erights-org-website/elang/index.html` (`source_fetched_via=mirror`); content sha256 `77f5814bce5dbbd8b320205b9a6b706a9e15b321ef686ba33986ab3186d0d7fa`.
