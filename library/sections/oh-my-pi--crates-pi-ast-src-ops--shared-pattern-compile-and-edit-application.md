---
title: pi-ast shared operations — language resolution, pattern compilation, and edit application
source: crates/pi-ast/src/ops.rs
source_repo: can1357/oh-my-pi
source_commit: e4517e1586ac56d2806a9a466e0f3f58aa4b587d
source_date: 2026-10-06
source_authors: [can1357, Brit, metaphorics]
ingested: 2026-10-07
ingested_by: scholar
topics: [programming-language-design, tooling]
status: current
notes: The source has no module-level prose header; this section records the contracts its code and function doc comments add beyond the pi-natives ast binding sections.
---

> Abstract: `pi_ast::ops` is the shared engine behind `pi-natives`' `astGrep` and `astEdit`. An explicit `lang` always wins over file-extension inference. A pattern that parses as several root nodes is retried inside a language wrapper (currently only JSON, as `{ … }` selecting `pair`). Edits are sorted, byte-identical duplicates collapse, and any remaining overlap is an error. Multi-rule rewrites re-parse the source after each rule, so later rules see earlier rewrites.

The [N-API ast binding](oh-my-pi--crates-pi-natives-src-ast--ast-grep-search-over-injected-filesystems.md) imports this module as `shared_ops`. It calls `resolve_supported_lang`, `resolve_language`, `is_supported_file`, `compile_pattern`, and `apply_edits` from here, so these contracts hold for JavaScript callers too.

## Language resolution

- `resolve_language(lang, path)`: a non-blank explicit `lang` is resolved through the alias map, failing with "Unsupported language '…'. Supported: <sorted aliases>". Otherwise the language is inferred from the path, failing with "Unable to infer language from file extension … Specify `lang` explicitly."
- `is_supported_file(path, lang)` is always true when `lang` is given. An explicit language therefore forces *every* candidate file to be treated as that language, whatever its extension.
- Strictness is the six-level ast-grep enum (`Cst`, `Smart`, `Ast`, `Relaxed`, `Signature`, `Template`).

## Pattern compilation and the multi-node fallback

`compile_pattern` uses `Pattern::contextual(pattern, selector)` when a selector is given, and `Pattern::try_new` otherwise. A fragment like `"key": $V` parses to several root nodes and is rejected as `MultipleNode`. Before giving up, the compiler retries with a language-specific wrapper template. Currently only JSON has one: the fragment is spliced into `{ … }` and the `pair` node is selected. Because JSON accepts a bare `$V` only inside a string, value-position metavariables are first quoted (`"$V"`), "ast-grep still reads the quoted `"$V"` as capture `V`". Any other error, or a failed fallback, keeps the original message, so "genuinely-bad patterns behave as before."

## Edit application

`apply_edits(content, edits)`:

1. sorts edits by position, then deleted length, then inserted text;
2. collapses byte-identical edits ("multiple patterns matching the same node collapse instead of tripping the overlap check. Only divergent overlaps are ambiguous");
3. fails with "Overlapping replacements detected; refine pattern to avoid ambiguous edits" if any remaining edit starts before the previous one ends;
4. checks that every range is in bounds and on UTF-8 character boundaries, and that every replacement is valid UTF-8;
5. builds the output in one forward pass that copies gaps and replacements, instead of shifting the string tail per edit.

`rewrite_source(source, lang, rules)` applies each rule's patterns in order. After every pattern that produced edits it re-parses the updated text, so rule *n+1* matches against the output of rule *n*. It returns the final text and the total replacement count.

## Host-only helper

`collect_matched_files(cwd, patterns)` walks `cwd` on the host with the `ignore` crate: hidden files included, and `.gitignore`, global gitignore, and `.git/info/exclude` honored. It matches relative paths against glob patterns or exact strings and returns them sorted. Nothing in `pi-natives` calls it: the N-API binding walks through the injected filesystem instead (see the [pi-vfs](oh-my-pi--crates-pi-vfs-src-lib--injectable-virtual-filesystem.md) contract). So this helper is not the path JavaScript callers take.

Source: [crates/pi-ast/src/ops.rs](https://github.com/can1357/oh-my-pi/blob/e4517e1586ac56d2806a9a466e0f3f58aa4b587d/crates/pi-ast/src/ops.rs) at commit `e4517e15`.
