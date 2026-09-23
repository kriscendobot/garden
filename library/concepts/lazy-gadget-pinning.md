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
| [Chat code base — epochs, pins, and generations](../sections/cloudflare-os--packages-workshop-shared-src-api--chat-code-base-epochs-and-pins.md) | The shipped ChatCodeBase contract: lazy first-write pins, epoch reset on accept, and content-preserving vs destructive generation bumps. |
| [Accept, mainline merge, and revert](../sections/cloudflare-os--packages-workshop-shared-src-api--accept-mainline-merge-and-revert.md) | Fast-forward-only accept that closes an epoch, 3-way update-from-mainline, and destructive revert/discard. |
| [Proposed-change fold and epoch boundaries](../sections/cloudflare-os--packages-workshop-backend-src-agent-compaction--proposed-change-fold-and-epoch-boundaries.md) | How a compaction checkpoint folds pins and the epoch over the compacted span under one merge/revert rule. |

## See also

- [[git-backed-gadget-code]]
- [[cloudflare-os-gadget]]
