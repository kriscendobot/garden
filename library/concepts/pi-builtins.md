---
aliases: [pi-builtins, oh-my-pi builtins, BuiltinSet, ShellBuilderExt]
kind: concept
---

# pi-builtins

`pi-builtins` is oh-my-pi's feature-gated Rust collection of Bash builtins and in-process utilities. It exposes builder and factory interfaces to the embedding shell, a shared matcher used by grep surfaces, and optional process-inspection primitives; the utility implementations run against the shell's explicit host view.

## Sections that touch this concept

| Section | What it contributes |
|---------|---------------------|
| [feature-gated shell builtins](../sections/oh-my-pi--crates-pi-builtins-src-lib--feature-gated-shell-builtins.md) | Inventories modules and the smaller public Rust embedding surface. |
| [N-API ripgrep search](../sections/oh-my-pi--crates-pi-natives-src-grep--napi-ripgrep-search.md) | Reuses the builtins crate matcher and PCRE2 JIT policy. |

## See also

- [[pi-vfs]] for the injectable filesystem boundary used by shell utilities.
- [[pi-native-search]] for N-API functions that reuse builtins and walker machinery.
