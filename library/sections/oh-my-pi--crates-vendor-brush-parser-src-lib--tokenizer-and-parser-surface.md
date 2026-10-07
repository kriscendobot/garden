---
title: brush-parser tokenizer and parser surface
source: crates/vendor/brush-parser/src/lib.rs
source_repo: can1357/oh-my-pi
source_commit: 240a4c27cfea2ee7ed75493b09904b6f42132b1c
source_date: 2026-09-26
source_authors: [roboomp]
ingested: 2026-10-07
ingested_by: scholar
topics: [shell-runtimes, programming-language-design]
status: current
---

> Abstract: The vendored brush-parser crate root ("Implements a tokenizer and parsers for POSIX / bash shell syntax") exposes public modules for the shell AST, arithmetic, words, patterns, prompts, readline bindings, and `test` expressions, plus re-exported tokenizer entry points, a configurable `Parser`, typed parse errors, and source positions and spans. This is the AST that both brush-core's interpreter and oh-my-pi's minimizer planner consume.

## Public modules

`arithmetic`, `ast`, `pattern`, `prompt`, `readline_binding`, `test_command`, and `word` are public. The parser, tokenizer, error, and source modules are private, with selected items re-exported.

## Re-exported entry points

- **Parsing.** `Parser`, `ParserBuilder`, `ParserImpl`, `ParserOptions`, `SourceInfo`, and `parse_tokens`, plus a `winnow_str` parser behind the `winnow-parser` feature.
- **Tokenizing.** `Token`, `TokenLocation`, `TokenizerError`, `TokenizerOptions`, `tokenize_str`, `tokenize_str_with_options`, `uncached_tokenize_str`, and `unquote_str`. The tokenizer is where the here-document-aware `$(...)` scan from the local patch lives ([vendored brush-parser and its here-document fix](oh-my-pi--crates-vendor-brush-parser-readme--vendored-parser-with-heredoc-fix.md)).
- **Errors.** `ParseError`, `ParseErrorLocation`, `BindingParseError`, `TestCommandParseError`, and `WordParseError`; a `miette`-based `PrettyError` exists behind the `diagnostics` feature.
- **Positions.** `SourcePosition`, `SourcePositionOffset`, and `SourceSpan`.

## Notes

The crate root still carries a crate-wide `#![allow(clippy::unwrap_used)]` with an upstream TODO to remove it. The file has no other prose; this section is a surface inventory, not narrative documentation.

Source: [crates/vendor/brush-parser/src/lib.rs](https://github.com/can1357/oh-my-pi/blob/240a4c27cfea2ee7ed75493b09904b6f42132b1c/crates/vendor/brush-parser/src/lib.rs) at commit `240a4c27`.
