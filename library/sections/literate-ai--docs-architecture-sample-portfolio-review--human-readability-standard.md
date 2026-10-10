---
title: "Sample portfolio review: human readability standard"
source: docs/architecture/sample-portfolio-review.md
source_repo: jordanhubbard/literate-ai
source_commit: fcc40bc617a2bc2455627db7396a1e016ebfbab6
source_date: 2026-09-30
source_authors: [Jordan Hubbard]
ingested: 2026-10-10
ingested_by: scholar
topics: [agentic-sdlc]
status: current
---

> Abstract: Every top-level sample must lead with a domain story and diagram before normative requirements, keep its Markdown Component manifest readable, and pass conformance checks that preserve the problem-led title, portfolio role, diagram, and separation between domain specifications and portable implementation skills.

Every top-level sample now opens with a domain story and a diagram before its normative
requirements. The prose explains why someone would reuse the Component; the requirement
and scenario blocks retain exact behavior; the diagram shows the transformation or
Component boundary without restating framework mechanics. Component manifests are
readable Markdown frontmatter, so coordinates, capabilities, skills, Flavors, and
acceptance intent remain reviewable beside the behavioral prose.

Conformance enforces those reader-facing properties for every catalog entry. A new
sample cannot silently regress to a mechanism-only title, omit its portfolio role, drop
its diagram, or minify a Component manifest. Domain-specific guidance stays in the spec;
portable generation, build, testing, and composition guidance stays in skills.

Source: [docs/architecture/sample-portfolio-review.md](https://github.com/jordanhubbard/literate-ai/blob/fcc40bc617a2bc2455627db7396a1e016ebfbab6/docs/architecture/sample-portfolio-review.md) at commit `fcc40bc` (source lines 51–63).
