---
id: git-backed-gadget-code
aliases: [Git-backed gadget code, gadget commit, gadget head commit, git object store]
topics: [persistence, ai-generated-apps, collaborative-workspace-sharing]
---

# Git-backed gadget code

Cloudflare OS stores committed gadget source as ordinary Git blobs, trees, and commits inside a workspace's Overseer Durable Object. Gadget records and chat pins supply the ref layer, while chat-local revisions hold uncommitted edits and explicit three-way or operational-transform steps reconcile moved mainline state.

## Sections that touch this concept

| Section | One-line summary |
|---|---|
| [Git object store and commit model](../sections/cloudflare-os--plans-git-storage--git-object-store-and-commit-model.md) | Defines the object database, ref substitutes, and commit plumbing. |
| [Commit-backed chat merge and migration](../sections/cloudflare-os--plans-git-storage--commit-backed-chat-merge-and-migration.md) | Connects commit trees to accept, three-way merge, readers, and historical migration. |
| [Operational-transform change model](../sections/cloudflare-os--plans-git-storage--operational-transform-change-model.md) | Defines the uncommitted revision layer that sits above Git commits. |

## See also

- [[cloudflare-os-gadget]]
- [[lazy-gadget-pinning]]
