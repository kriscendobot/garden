---
id: brush-shell
aliases: [brush, brush-core, brush-parser, reubeno/brush, vendored brush, Bo(u)rn(e) RUsty SHell]
topics: [shell-runtimes, programming-language-design]
---

# brush-shell

brush is an MIT-licensed, bash- and POSIX-compatible shell written in Rust, split into a parser crate (`brush-parser`: tokenizer, parsers, shell AST) and an interpreter crate (`brush-core`: `Shell`, builtins, expansion, jobs). It is embeddable through `brush_core::Shell`. oh-my-pi vendors both crates under `crates/vendor/` via `[patch.crates-io]`: brush-parser 0.4.0 for a documented here-document fix, and brush-core 0.5.0 with ongoing, undocumented local changes. Not `crates/brush-core-vendored/`, the path a third-party explainer gives.

## Sections that touch this concept

| Section | One-line summary |
|---|---|
| [vendored brush-parser and its here-document fix](../sections/oh-my-pi--crates-vendor-brush-parser-readme--vendored-parser-with-heredoc-fix.md) | Why brush-parser is vendored, every local change, and when to drop it. |
| [brush-parser tokenizer and parser surface](../sections/oh-my-pi--crates-vendor-brush-parser-src-lib--tokenizer-and-parser-surface.md) | Public AST and tokenizer/parser entry points. |
| [brush, a bash-compatible shell in Rust](../sections/oh-my-pi--crates-vendor-brush-core-readme--brush-bash-compatible-rust-shell.md) | Upstream feature and compatibility claims; silent on oh-my-pi's patches. |
| [brush-core interpreter and embedding surface](../sections/oh-my-pi--crates-vendor-brush-core-src-lib--interpreter-and-embedding-surface.md) | Embedding types, spawn observation, and in-process-safe `ulimit` state. |

## See also

- [[pi-shell-output-minimizer]]: its planner classifies commands from brush ASTs.
- [[pi-builtins]]: oh-my-pi's in-process utilities registered on a brush shell.
- [[oh-my-pi-design-explainer]]: the third-party page that misplaces and misexplains the vendoring.
