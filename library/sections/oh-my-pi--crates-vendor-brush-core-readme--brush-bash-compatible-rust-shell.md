---
title: brush, a bash-compatible shell in Rust
source: crates/vendor/brush-core/README.md
source_repo: can1357/oh-my-pi
source_commit: 68d7593244bed56f1891e0ccb020414528c14f67
source_date: 2026-06-26
source_authors: [can1357]
ingested: 2026-10-07
ingested_by: scholar
topics: [shell-runtimes, tooling]
status: current
---

> Abstract: The README in oh-my-pi's vendored `brush-core` is upstream brush's project README: a bash- and POSIX-compatible shell written in Rust, validated against bash with a compatibility suite, embeddable through `brush_core::Shell`, with known gaps such as `select`. Unlike the vendored brush-parser README, it does not document oh-my-pi's local changes, even though the vendored brush-core is a modified 0.5.0 that oh-my-pi continues to patch.

## What brush is

`brush` (**B**o(u)rn(e) **RU**sty **SH**ell) is "a modern bash- and POSIX-compatible shell written in Rust", MIT licensed, from reubeno/brush. Its pitch: existing scripts and `.bashrc` run unchanged, with syntax highlighting and auto-suggestions built in, validated against bash by compatibility tests (the README cites about 1,700; a badge says 1,389), and "easily embeddable in your Rust apps using `brush_core::Shell`." That last property is the one oh-my-pi relies on.

## Feature claims

- **bash compatibility.** 50+ builtins; brace, parameter, arithmetic, command, and process-substitution expansion; globs with `extglob` and `globstar`; full control flow, subshells, and pipelines; here-documents, here-strings, fd duplication, and process-substitution redirects; indexed and associative arrays; programmable completion compatible with bash-completion; job control.
- **Partial.** `DEBUG`/`ERR`/`EXIT` traps work, while signal traps and some options are in progress. "Not everything works yet: `select` and some edge cases aren't supported."
- **Interactive experience** (not used by an embedded agent shell): reedline-based highlighting and history suggestions, `PS1`/`PROMPT_COMMAND` and starship-compatible prompts, TOML configuration, and experimental `fzf`/`atuin` and zsh-style `precmd`/`preexec` hooks.

The README also lists installation routes, related non-C shells (nushell, fish's Rust port, Oils, mvdan/sh, rusty_bash), and credited crates (reedline, clap, fancy-regex, tokio, nix).

## Vendoring status

The vendored `Cargo.toml` names `brush-core` version 0.5.0. The directory's commit history shows ongoing oh-my-pi changes (for example "fixed background builtins persisting and enable kill %N for internal jobs", 2026-10-07), but this README is unchanged upstream text and lists none of them. Unlike brush-parser, whose README inventories its patches and removal condition, the brush-core delta must be recovered from history. The compatibility numbers above describe upstream brush, not oh-my-pi's patched copy.

Source: [crates/vendor/brush-core/README.md](https://github.com/can1357/oh-my-pi/blob/68d7593244bed56f1891e0ccb020414528c14f67/crates/vendor/brush-core/README.md) at commit `68d75932`.
