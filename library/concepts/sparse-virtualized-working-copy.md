---
id: sparse-virtualized-working-copy
aliases: [sparse checkout, virtualized checkout, optional working copy, demand-materialized working copy]
topics: [source-control-architecture, agent-workspaces]
---

# sparse-virtualized-working-copy

A source-control client view that materializes only requested trees and blobs, possibly only when a process reads them. In Scion, the working copy is optional because repository queries and some writes are server APIs; when files are required, the client recursively fetches named immutable objects through cache tiers instead of negotiating a complete repository or packfile.

## Sections that touch this concept

| Section | One-line summary |
|---|---|
| [agent-scale principles](../sections/web--anthropic-redesigning-source-control--agent-scale-principles.md) | The working copy is optional; sparse and virtualized clients pay only for data they read. |
| [scalable object delivery](../sections/web--anthropic-redesigning-source-control--scalable-object-delivery.md) | Clients recursively request named missing trees and blobs, making partial materialization the normal protocol. |

## See also

- [[scion-source-control]] — the service architecture that makes the working copy optional.
- [[cloudflare-artifacts]] — includes ArtifactFS, a FUSE-based lazy working-tree client for Git-compatible repositories.
- [[pi-iso]] — copy-on-write isolated agent workspaces, a different concern at the workspace layer.
