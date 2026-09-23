---
title: "Obsolete: Quasi-Literals and XML (the abandoned XML/DOM universal-parse-tree proposal)"
source_kind: web
source_url: http://erights.org/elang/grammar/quasi-xml.html
source_effective_url: https://erights.github.io/erights-org-website/elang/grammar/quasi-xml.html
source_fetched_via: mirror
source_content_sha256: 0a9b3a9caaaa1bab476e8806e54932c75a87f44867efe2bff4aaecacef949966
source_authors: [Mark S. Miller]
source_date: 1998-10-03
ingested: 2026-06-28
ingested_by: scholar
topics: [e-language]
status: stale
notes: >
  Primary-source HTML via the erights.org GitHub Pages mirror. The page
  self-flags as OBSOLETE in its first line: it is preserved as a record of the
  plan that preceded E's decision to use Antlr-based Term / Functor trees instead
  of XML/DOM trees as the universal parse-tree structure. Captured at `status:
  stale` (not deleted) so the grammar chapter's child-page map resolves and the
  abandoned-design history is navigable, mirroring how
  `erights--elang-intro-starting-e` was kept though it self-flags obsolete. The
  live framework is `erights--elang-grammar-quasi-overview--quasi-literals`.
---

## Abstract

**Quasi-Literals and XML** is an obsolete E design proposal, preserved as
abandoned-plan history. Its own opening note states it is superseded: E chose
Antlr-based Term / Functor trees rather than the XML/DOM-tree direction this page
proposed. The proposal aimed to give XML the "best of both worlds" between a single
universal meta-notation (XML's strength and weakness) and many specialized
notations, by leveraging E's quasi-parser framework
(`erights--elang-grammar-quasi-overview--quasi-literals`). It proposed three
technologies: a parser generator whose actions build XML/DOM trees (for
notational interoperability), a quasi-parser for quasi-literal XML expressions and
patterns (so transformations could be written in the match-bind-substitute style),
and adoption of Minimal-XML (a downward-compatible XML subset) with a
correspondingly minimal DOM implementation. The enduring idea, independent of the
abandoned XML specifics, is that XML expresses trees of symbols much like Lisp
S-expressions or Prolog term-trees, so a parse tree is primarily a data structure
and only secondarily a notation. That tree-as-data-structure framing survived into
E's chosen Term/Functor design and is the conceptual through-line worth retaining.

## What it proposed (historical)

1. A **parser generator** whose semantic actions construct XML/DOM trees, giving
   notational interoperability across data formats.
2. A **quasi-parser** for quasi-literal XML expressions and patterns, letting
   programmers write XML transformation code in the match-bind-substitute paradigm
   inside general E code.
3. Adoption of **Minimal-XML** (a downward-compatible subset of XML, with most of
   XML embeddable in it via a Minimizer) plus a minimal DOM-tree implementation.

The abstraction the page draws: the essential idea of XML, syntax aside, is that
it expresses trees of symbols, the same thing Lisp S-expressions and Prolog
term-trees (Herbrand trees) express. Taking those structures as notations as well
as data structures is the unifying move; E generalized it through the quasi-parser
framework rather than through XML.

## Source

Source: [elang/grammar/quasi-xml.html](https://erights.github.io/erights-org-website/elang/grammar/quasi-xml.html) (erights.org GitHub Pages mirror), content SHA-256 `0a9b3a9caaaa`, last modified 1998-10-03. The page is upstream-flagged obsolete; ingested at `status: stale` for completeness of the grammar chapter's child-page map.
