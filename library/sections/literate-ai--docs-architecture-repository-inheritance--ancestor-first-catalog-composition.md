---
title: Repository inheritance: ancestor-first catalog composition
source: docs/architecture/repository-inheritance.md
source_repo: jordanhubbard/literate-ai
source_commit: fcc40bc617a2bc2455627db7396a1e016ebfbab6
source_date: 2026-09-29
source_authors: [Jordan Hubbard]
ingested: 2026-10-10
ingested_by: scholar
topics: [agentic-sdlc, dynamic-composition]
status: current
---

> Abstract: Catalogs compose ancestor-first: Components inherit unless `component.md` says `inheritable: false`; a descendant may replace an item at the same catalog coordinate, but two incomparable parents defining one coordinate is rejected; nested items stay separate; workflow and routing documents stay independently provenance-bound; only regular, safe, bounded tracked files are admitted. Per-file provenance lands in `.literate/imports.json`. Without `--from`, the parent is the installed framework at its highest `vX.Y.Z` tag at or below the CLI version, never `HEAD`; samples are inspectable or explicitly copyable, not ambient authority.

Catalogs are composed in ancestor-first order:

- Components inherit by default; an individual `component.md` may declare `inheritable: false` when it is local teaching, qualification, or private composition authority that should not flow automatically to descendants;
- a descendant may deliberately replace a Component, Flavor, skill, workflow, or routing policy with the same catalog coordinate;
- two incomparable parents defining the same coordinate are rejected because neither has precedence;
- nested Components and skills remain separate items rather than being flattened into one context;
- global workflow and routing documents remain independently provenance-bound so an inherited Component retains its complete declared generation authority;
- only regular tracked files are admitted; links, Gitlinks, unsafe paths, invalid UTF-8 paths, oversized files, and oversized trees fail closed.

The derived project records exact per-file provenance in `.literate/imports.json` and includes that evidence in its initialization baseline. With no `--from`, the installed framework remains the default parent at its highest published `vX.Y.Z` tag at or below the installed CLI version, never `HEAD`. Its packaged scaffold supplies the same taxonomy without requiring callers to spell its URL.

Samples are therefore available without becoming ambient application authority. A developer may inspect a parent's samples or explicitly copy one with `litai catalog copy`; ordinary `init` and `update` omit Components that explicitly opt out. Flavors, skills, workflows, and routing policies retain their existing catalog inheritance semantics. The framework's portable `hello-component` deliberately keeps the default so each derived project receives one runnable host smoke test.

Source: [docs/architecture/repository-inheritance.md](https://github.com/jordanhubbard/literate-ai/blob/fcc40bc617a2bc2455627db7396a1e016ebfbab6/docs/architecture/repository-inheritance.md) at commit `fcc40bc`.
