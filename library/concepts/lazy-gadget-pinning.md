---
id: lazy-gadget-pinning
aliases: [lazy per-gadget pinning, chat code pin, chat epoch, code-base generation]
topics: [persistence, collaborative-workspace-sharing]
---

# Lazy gadget pinning

A Cloudflare OS chat pins a gadget's commit only when that chat first modifies its code. Unpinned reads follow mainline and become replay-stale when their file changes; accept closes the epoch, commits everything, clears pins, and advances the generation so old clients rebuild rather than apply to discarded state.

## Sections that touch this concept

| Section | One-line summary |
|---|---|
| [Lazy per-gadget pinning and epochs](../sections/cloudflare-os--plans-git-storage--lazy-per-gadget-pinning-and-epochs.md) | States the first-write pin, read-elision, accept, and generation invariants. |
| [Deterministic Yjs seeds and reserved client IDs](../sections/cloudflare-os--plans-git-storage--deterministic-yjs-seeds-and-reserved-client-ids.md) | Gives the transitional deterministic seed representation for each pin. |
| [Revision epochs, stragglers, and materialization](../sections/cloudflare-os--plans-git-storage--revision-epochs-stragglers-and-materialization.md) | Carries eligible in-flight edits across merge boundaries without changing their content base. |

## See also

- [[git-backed-gadget-code]]
- [[cloudflare-os-gadget]]
