---
title: Vendored brush-parser and its here-document fix
source: crates/vendor/brush-parser/README.md
source_repo: can1357/oh-my-pi
source_commit: 7755c6d0c3f9073cf691843c19e82f1386779a81
source_date: 2026-09-26
source_authors: [roboomp]
ingested: 2026-10-07
ingested_by: scholar
topics: [shell-runtimes, programming-language-design, tooling]
status: current
---

> Abstract: oh-my-pi vendors brush-parser 0.4.0, the tokenizer and parsers behind its embedded shell, at `crates/vendor/brush-parser`, routed through `[patch.crates-io]`, to fix how `$(...)` command substitutions containing here-documents are delimited. The README lists every local change, says everything else is byte-identical to the 0.4.0 release, and states the condition for removing the vendored copy.

## What is vendored and why

The README calls this a "vendored copy of brush-parser 0.4.0, the tokenizer and parsers behind the embedded shell (`crates/vendor/brush-core`)". The workspace `Cargo.toml` redirects the registry dependency here through `[patch.crates-io]`, with a comment giving the reason: the latest release "re-parses `$(...)` bodies without here-document awareness; the vendored copy fixes it." The crate stays MIT licensed.

## Local changes

- **`src/word.rs`, `src/tokenizer.rs`.** The word grammar delimits `$(...)` with the tokenizer's here-document-aware scan (`command_substitution_body_len`) instead of re-parsing the body as words. Re-parsing let quotes and parentheses inside a quoted here-document body end the substitution early or swallow its closing parenthesis; `"$(...)"` then fell back to literal text and ran backtick spans from the body (oh-my-pi#13307). Upstream tracks the family as reubeno/brush#1066.
- **`src/tokenizer.rs`.** A newline token cut short by a construct's terminating character (the `)` in `$(...)`) is delimited as a newline, so a here-document body that starts with `)` no longer closes the substitution.
- **`Cargo.toml`.** `publish = false`; examples, the benchmark, and the dev-dependencies only they used are dropped.
- **`src/snapshot_tests.rs`.** Dropped, because it globbed test cases from the sibling `brush-shell` crate, which is not vendored.
- The crates.io `Cargo.lock` and VCS metadata are dropped; `BUILD.bazel` and `rustfmt.toml` are workspace wiring.

"Everything else is byte-identical to the 0.4.0 release." The exit condition: remove the directory and its patch entry "once a brush-parser release delimits command substitutions containing here-documents correctly."

## Why this matters to an agent shell

The bug was a correctness issue with a security flavor: a mis-delimited substitution could execute backtick spans that were meant to be literal here-document text. Because the output minimizer's planner also classifies commands from brush ASTs ([parser-based rewrite safety](oh-my-pi--crates-pi-shell-src-minimizer-plan--parser-based-rewrite-safety.md)), a parser fix changes both what the shell runs and what the minimizer believes it ran. The vendoring is a narrow, documented patch with a removal condition, not the supply-chain or offline-build policy a third-party explainer attributes it to ([divergence ledger](web--oh-my-pi-design-rust-core--divergence-ledger-against-source.md)).

Source: [crates/vendor/brush-parser/README.md](https://github.com/can1357/oh-my-pi/blob/7755c6d0c3f9073cf691843c19e82f1386779a81/crates/vendor/brush-parser/README.md) at commit `7755c6d0`.
