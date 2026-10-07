---
title: pi-ast's statically linked tree-sitter language registry
source: crates/pi-ast/src/language/mod.rs
source_repo: can1357/oh-my-pi
source_commit: 11f3a2625b58a4ba702160b51417f9ffea0de377
source_date: 2026-09-08
source_authors: [Tobias Linn, can1357, omp, ryjm, Sunil Srivatsa, bling]
ingested: 2026-10-07
ingested_by: scholar
topics: [programming-language-design, tooling]
status: current
---

> Abstract: `pi-ast`'s language registry is a vendored and extended fork of `ast-grep-language` v0.39.9. It has 57 `SupportLang` variants, each backed by a native `tree-sitter-*` Rust crate compiled into the addon. Neither the registry nor the rest of `pi-ast` uses WASM grammars. Languages whose grammar rejects `$` in identifiers get an expando character that rewrites metavariables before pattern parsing. HTML extracts `<script>`/`<style>` regions as injected languages. Language inference uses special file names, extensionless shell rc files, and an extension table, with a lowercase alias map for explicit `lang` values.

## Provenance

The module header: "Vendored and extended language definitions for ast-grep integration. Originally derived from `ast-grep-language` v0.39.9, stripped of serde/ignore machinery, and extended with additional languages."

## The 57 languages, and the WASM claim

`SupportLang` enumerates Astro, Bash, C, CMake, C++, C#, Dart, Clojure, CSS, Diff, Dockerfile, Emacs Lisp, Elixir, Erlang, Fortran, Go, GraphQL, Haskell, HCL, HTML, INI, Java, JavaScript, JSON, Just, Julia, Kotlin, Lua, Make, Markdown, Nix, Objective-C, OCaml, Odin, PHP, PowerShell, Protocol Buffers, Python, R, Regex, Ruby, Rust, Scala, Solidity, SQL, Starlark, Svelte, Swift, TOML, TLA+, TSX, TypeScript, Verilog, Vue, XML, YAML, and Zig: 57 in all.

Every grammar comes from `parsers.rs`, where each `language_*()` function returns `tree_sitter_<lang>::LANGUAGE.into()` from a Rust grammar crate. A search of `crates/pi-ast` (source and `Cargo.toml`) finds no occurrence of "wasm". This settles the third-party explainer's claim of "50+ languages" with per-language WASM grammars: the count is roughly right, but the grammars are statically linked native code (see the [divergence ledger](web--oh-my-pi-design-rust-core--divergence-ledger-against-source.md) and the follow-up recorded in [native loader candidates and the absent JavaScript fallback](oh-my-pi--packages-natives-native-loader-state--native-loader-candidates-and-no-js-fallback.md)).

## Metavariables and the expando character

ast-grep patterns use `$NAME` metavariables. Two macros generate the language structs:

- `impl_lang!` "Use when the language grammar accepts `$VAR` as valid identifiers." It is used for 22 languages, including Bash, Java, JavaScript, TypeScript/TSX, JSON, Lua, Scala, Svelte, Vue, YAML, Markdown, TOML, and Dart.
- `impl_lang_expando!` "Use when the language does NOT accept `$` as a valid identifier character." It is used for 34 languages. Before parsing, `pre_process_pattern` replaces the `$` sigils of a metavariable (an uppercase or `_` name, or the `$$$` multi-match form) with a language-specific stand-in. The stand-in is `µ` for most languages (Go, Python, Rust, Ruby, PHP, Kotlin, Swift, SQL, ...), `𐀀` for C, C++, Objective-C, and Fortran, and `_` for CSS and Nix. The pattern then parses as ordinary code in that grammar.

HTML is hand-written. It uses an expando, and it implements injection: `injectable_languages` names `css`, `js`, `ts`, `tsx`, `scss`, `less`, `stylus`, and `coffee`. `extract_injections` collects the `raw_text` of each `script_element` (default `js`) and `style_element` (default `css`), keyed by the element's `lang`. Astro, Svelte, and Vue use the plain macro and declare no injections in this registry.

## Language inference and aliases

`SupportLang::from_path` checks, in order:

1. Special file names: `Makefile`/`makefile`/`GNUmakefile` map to Make; `Justfile` to Just; `CMakeLists.txt` to CMake; `Dockerfile`, `Dockerfile.*`, and `Containerfile` to Dockerfile; `.emacs` to Emacs Lisp.
2. Extensionless shell rc and profile files (`.zshrc`, `.bashrc`, `.profile`, `kshrc`, and so on, with or without the dot). These map to Bash, because otherwise they "would resolve to no language and disable block-aware ops on them."
3. The per-language extension table. For example, CUDA `.cu`/`.cuh` and Arduino `.ino` map to C++.

`from_alias` trims and lowercases its input, then looks it up in a compile-time `phf` map (`sh`/`zsh`/`ksh`/`bats` → Bash, `h` → C, `c++`/`cu` → C++, ...). The sorted alias list is what `pi-ast`'s operations print in the "Unsupported language" error.

Source: [crates/pi-ast/src/language/mod.rs](https://github.com/can1357/oh-my-pi/blob/11f3a2625b58a4ba702160b51417f9ffea0de377/crates/pi-ast/src/language/mod.rs) at commit `11f3a262`.
