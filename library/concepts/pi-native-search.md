---
aliases: [pi-natives search, native grep, native glob, fuzzyFind, ripgrep N-API]
kind: concept
---

# pi-native search

oh-my-pi's `pi-natives` search surface exposes Rust search and traversal machinery to JavaScript through N-API. `grep` and `glob` accept the shell's injected filesystem and can traverse provider URLs; `fuzzyFind` currently resolves only a host path. The boundary carries structured options and results, cancellation, promises, and threadsafe callbacks rather than exposing ripgrep or walker objects directly.

## Sections that touch this concept

| Section | What it contributes |
|---------|---------------------|
| [N-API ripgrep search](../sections/oh-my-pi--crates-pi-natives-src-grep--napi-ripgrep-search.md) | Defines in-memory and filesystem search, structured results, and streaming backpressure. |
| [N-API virtual glob walk](../sections/oh-my-pi--crates-pi-natives-src-glob--napi-virtual-glob-walk.md) | Defines provider-aware traversal and structured glob results. |
| [N-API fuzzy path discovery](../sections/oh-my-pi--crates-pi-natives-src-fd--napi-fuzzy-path-discovery.md) | Defines bounded fuzzy path ranking and its current host-only boundary. |

## See also

- [[pi-vfs]] for the provider abstraction used by grep and glob.
- [[pi-builtins]] for the matcher policy shared with the native grep binding.
