---
aliases: [pi-vfs, oh-my-pi VFS, ShellFilesystem, FileSystem provider]
kind: concept
---

# pi-vfs

`pi-vfs` is oh-my-pi's injectable filesystem layer. Its asynchronous and blocking facades use native host operations by default, while a `FileSystem` provider can own URL-addressed files, handles, metadata, and directory entries without creating host files. The embedded shell, builtins, and selected native tools share this boundary.

## Sections that touch this concept

| Section | What it contributes |
|---------|---------------------|
| [injectable virtual filesystem](../sections/oh-my-pi--crates-pi-vfs-src-lib--injectable-virtual-filesystem.md) | Defines the facade, provider, URL-path, threading, and close contracts. |
| [feature-gated shell builtins](../sections/oh-my-pi--crates-pi-builtins-src-lib--feature-gated-shell-builtins.md) | Shows in-process utilities consuming the shell host view. |
| [N-API ripgrep search](../sections/oh-my-pi--crates-pi-natives-src-grep--napi-ripgrep-search.md) | Searches provider-backed files through an optional `ShellFilesystem`. |
| [N-API virtual glob walk](../sections/oh-my-pi--crates-pi-natives-src-glob--napi-virtual-glob-walk.md) | Walks provider URL trees through `BlockingFs`. |
| [N-API shell sessions and filesystem injection](../sections/oh-my-pi--crates-pi-natives-src-shell--napi-shell-sessions-and-filesystem-injection.md) | `ShellFilesystem` backs a whole shell session or replaces it for a single run. |
| [ast-grep search over injected filesystems](../sections/oh-my-pi--crates-pi-natives-src-ast--ast-grep-search-over-injected-filesystems.md) | Structural search and rewrite resolve, walk, read, and write through the injected filesystem. |

## See also

- [[pi-native-search]] for the JavaScript-facing grep, glob, and fuzzy-find boundaries.
- [[pi-iso]] for workspace copy-on-write and diffing, which is a different layer from virtual file access.
