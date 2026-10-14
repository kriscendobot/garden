---
id: scion-changeset-derived-data
aliases: [Scion changeset, Scion derived data, changeset log, derived repository index]
topics: [source-control-architecture, data-structures, content-addressed-storage]
---

# scion-changeset-derived-data

Scion separates an authoritative append-only changeset from replaceable query projections. A changeset records files changed relative to its first parent and content-addressed blob pointers; blame, path history, commit-graph skip lists, copy detection, and path search are recursively computed derived-data types that can be materialized eagerly or lazily.

## Sections that touch this concept

| Section | One-line summary |
|---|---|
| [changesets and derived data](../sections/web--anthropic-redesigning-source-control--changesets-and-derived-data.md) | The primary changeset log is distinct from recursively computed query projections. |
| [scalable object delivery](../sections/web--anthropic-redesigning-source-control--scalable-object-delivery.md) | Authoritative servers compute metadata projections on demand and cache immutable results. |

## See also

- [[scion-source-control]] — the complete source-control architecture.
- [[content-addressed-block-store]] — another immutable substrate whose higher-level indexes can be treated as projections.
