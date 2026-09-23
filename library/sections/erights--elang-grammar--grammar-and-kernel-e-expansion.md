---
title: "Grammar and Expansions: the two-layer E specification (E grammar → Kernel-E)"
source_kind: web
source_url: http://erights.org/elang/grammar/index.html
source_effective_url: https://erights.github.io/erights-org-website/elang/grammar/index.html
source_fetched_via: mirror
source_content_sha256: ee71fa888d3243274321e5e7caf58661d8e041dd90f48419235073f04a79baae
source_authors: [Mark S. Miller]
source_date: 1998-10-03
ingested: 2026-06-28
ingested_by: scholar
topics: [e-language]
status: current
notes: >
  Primary-source HTML via the erights.org GitHub Pages mirror. This is the
  grammar chapter's landing page: it states the two-layer specification method
  (full E grammar defined by canonical expansion to a small Kernel-E core) and
  maps the per-construct child pages. The per-construct grammar tables (precedence
  list, primitive expressions, patterns, quasi-literals, methods/matchers, lexical
  tokens) and the Kernel-E manual itself are queued in scholar-ingest-erights-3.
---

## Abstract

The **Grammar and Expansions** chapter establishes how E is specified, and it is
the architectural key to the whole language: E is defined in **two layers**.
First the full **E grammar** (the LALR(1) surface syntax a programmer writes);
then a **canonical expansion** of every surface construct into **Kernel-E**, a
small lambda-calculus-like subset in which every valid Kernel-E program is also a
valid E program of the same meaning. Kernel-E is deliberately tiny so that
automatic program analyzers can reason about it; the expansion of a surface
construct to Kernel-E *is the only precise meaning* of that construct. This is
the same "small trusted core, sugar defined by translation to it" discipline that
reappears in Hardened JavaScript's distinction between the SES intrinsics/core
and the larger surface language. This section captures the chapter's method and
its child-page map; the per-construct tables themselves are queued.

## The two-layer specification method

> We specify the E Language in two layers. First, we present the E grammar, and
> show an expansion to Kernel-E. Kernel-E is a small subset of E — every valid
> Kernel-E program is also an E program of the same meaning. Kernel-E is a small
> lambda language suitable for analysis by automatic program analyzers.

For each construct of the E grammar the chapter gives **both an informal and a
formal meaning**. If the construct is itself part of the Kernel-E subset, the
chapter simply points to the corresponding section of the Kernel-E manual for its
formal meaning. Otherwise it shows the **canonical expansion** of the construct
to Kernel-E — and that expansion is "the only precise meaning of these
constructs." In other words, surface E is sugar; Kernel-E is semantics.

## The child pages (this chapter's map)

The grammar chapter presents each construct group on its own page. As of this
ingest these remain queued (see the `scholar-ingest-erights-3` follow-on); they
are reachable on the mirror at the URLs below:

- **Expressions by precedence and associativity** — the full operator
  precedence/associativity table.
- **Primitive Expressions** (no precedence needed).
- **Patterns** (including variable declaration).
- **Quasi-Literal Expressions and Patterns** — see also the draft proposal
  *Quasi-Literals and XML*.
- **Methods and Matchers** (object behavior).
- **Lexical Grammar (Tokens)** — the tokenizer-level grammar.

The companion **Kernel-E** chapter (`elang/kernel/index.html`) is the special-forms
manual the expansions point at; it is the large queued page deferred to the
follow-on cycle.

## Source

Source: [elang/grammar/index.html](https://erights.github.io/erights-org-website/elang/grammar/index.html) (mirror of `http://erights.org/elang/grammar/index.html`), last modified 1998-10-03, content SHA-256 `ee71fa888d3243274321e5e7caf58661d8e041dd90f48419235073f04a79baae`, fetched via the erights.org GitHub Pages mirror.
