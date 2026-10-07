---
title: Multi-language source-analysis surface
source: crates/pi-ast/src/lib.rs
source_repo: can1357/oh-my-pi
source_commit: 010eda78348a5b0d9e31fc662fd67c1932d3f0e3
source_date: 2026-08-17
source_authors: [Sunil Srivatsa]
ingested: 2026-10-07
ingested_by: scholar
topics: [programming-language-design, tooling]
status: current
notes: The source has no crate-level prose header; this section records its module surface and avoids inferring undocumented behavior.
---

> Abstract: The `pi-ast` crate root exposes blocks, language support and parsers, AST operations, a parse cache, and summaries behind a single `SupportLang` language selector. It is the source-analysis substrate used by oh-my-pi features such as hashline, but the crate root alone does not document those consumers or their edit protocol.

The crate root declares five modules: `block`, `language`, `ops`, `parse_cache`, and `summary`. It re-exports `SupportLang` as the public language selector. There is no crate-level `//!` prose header, so stronger claims about parser implementation, caching behavior, or hashline semantics belong to those module sources and are deferred.

The garden already indexes oh-my-pi's hashline lineage through [`designs/cli-edit-verb`](../sources/endo-but-for-bots--llm-designs-cli-edit-verb.md). That design describes content-hash anchors as both line locators and stale-edit checks. This crate-root ingest only establishes the lower source-analysis package on which oh-my-pi's implementation sits; it does not equate `pi-ast` with the hashline protocol.

Source: [crates/pi-ast/src/lib.rs](https://github.com/can1357/oh-my-pi/blob/010eda78348a5b0d9e31fc662fd67c1932d3f0e3/crates/pi-ast/src/lib.rs) at commit `010eda78`.
