---
id: pi-ast-grep
aliases: [astGrep, astMatch, astEdit, pi-natives ast, ast-grep N-API, oh-my-pi structural search, oh-my-pi structural rewrite]
topics: [programming-language-design, tooling, virtual-filesystems]
---

# pi-ast-grep

oh-my-pi's `pi-natives` `ast` module exposes ast-grep structural search and rewrite to JavaScript over `pi-ast`'s language registry. `astGrep` searches files on a host path or `scheme://` URL through an injected `ShellFilesystem`; `astMatch` searches an in-memory string; `astEdit` applies pattern-to-template rewrites, dry run by default, staged in memory and flushed only after the whole pass computes. This is the real native AST surface; the `parseAst`/`findNode`/`replaceNode`/`serializeAst` API in a third-party explainer does not exist.

## Sections that touch this concept

| Section | One-line summary |
|---|---|
| [ast-grep search over injected filesystems](../sections/oh-my-pi--crates-pi-natives-src-ast--ast-grep-search-over-injected-filesystems.md) | Search options, candidate discovery through the injected filesystem, ordering, paging, diagnostics. |
| [staged, dry-run-by-default structural rewrite](../sections/oh-my-pi--crates-pi-natives-src-ast--staged-dry-run-structural-rewrite.md) | Rewrite defaults, mixed-language rules, edit dedupe, staging, and its non-transactional flush. |

## See also

- [[pi-native-search]]: grep and glob share the injected filesystem; `fuzzyFind` stays host-path-only.
- [[pi-vfs]]: the filesystem abstraction search and rewrite go through.
