---
id: pi-iso
aliases: [pi-iso, oh-my-pi isolation PAL, Rcopy]
topics: [sandbox-platforms, file-systems, agent-workspaces]
---

# pi-iso

`pi-iso` is oh-my-pi's cross-platform workspace layer. It presents a writable view over a read-only tree through native copy-on-write, overlay, or projection facilities, with Git worktree or recursive-copy fallback, and produces a diff of the resulting changes. Despite its name, it does not itself confine process authority.

## Sections that touch this concept

| Section | One-line summary |
|---|---|
| [cross-platform copy-on-write workspaces](../sections/oh-my-pi--crates-pi-iso-src-lib--cross-platform-copy-on-write-workspaces.md) | Native workspace backends, Git fallback, diff contract, and the process-sandbox boundary. |
| [N-API isolation lifecycle and the unavailable-error protocol](../sections/oh-my-pi--crates-pi-natives-src-iso--napi-isolation-lifecycle.md) | JavaScript-facing probe/resolve/start/stop/diff and the `ISO_UNAVAILABLE:` fallback signal. |
| [Rcopy fallback backend](../sections/oh-my-pi--crates-pi-iso-src-rcopy--git-worktree-or-recursive-copy-fallback.md) | Git-worktree materialization with dirty-state replay, or recursive copy; always available. |
| [overlayfs with fuse-overlayfs fallback](../sections/oh-my-pi--crates-pi-iso-src-overlayfs--kernel-overlay-with-fuse-fallback.md) | Kernel overlay mount, fuse fallback on refusal, per-mount teardown flavor. |
| [backend resolution priority](../sections/oh-my-pi--crates-pi-iso-src-lib--backend-resolution-priority.md) | Per-OS automatic order, preferred-first resolution, `Resolution` fields, and tree-cloning candidates. |

## See also

- [[opensandbox]] for an execution-isolation platform.
- [[design-out-the-hazard]] for the garden's distinct per-worktree isolation pattern.
