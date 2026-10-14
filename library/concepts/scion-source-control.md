---
id: scion-source-control
aliases: [Scion, Anthropic Scion, agent-scale source control]
topics: [source-control-architecture, agentic-sdlc]
---

# scion-source-control

Scion is Anthropic's centralized source-control system for an enormous, agent-heavy monorepo. It assumes online clients, performs commits and history operations on horizontally scalable servers, stores first-parent-relative changesets with content-addressed blobs, computes query indexes as derived data, and materializes sparse working copies through object-cache tiers.

## Sections that touch this concept

| Section | One-line summary |
|---|---|
| [overview](../sections/web--anthropic-redesigning-source-control--overview.md) | Scion replaced Anthropic’s Git monorepo path after merge volume increased more than tenfold. |
| [agent-scale principles](../sections/web--anthropic-redesigning-source-control--agent-scale-principles.md) | The service assumes online clients, server-side operations, horizontal scale, and optional sparse working copies. |
| [scalable object delivery](../sections/web--anthropic-redesigning-source-control--scalable-object-delivery.md) | Content-addressed object cache tiers materialize only the repository data a client requests. |

## See also

- [[scion-changeset-derived-data]] — Scion's primary log record and replaceable query projections.
- [[sparse-virtualized-working-copy]] — the optional, demand-materialized client view.
- [[cloudflare-artifacts]] — a Git-compatible managed repository service for agent workspaces, useful as a contrasting design.
