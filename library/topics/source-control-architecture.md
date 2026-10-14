# Topic: source-control-architecture

> Abstract: Architectures for storing, querying, distributing, reviewing, and landing repository changes at scales where a complete local Git clone and serialized merge queue become bottlenecks. Seeded from Anthropic's Scion account: always-online asymmetric clients and servers, append-only changesets, replaceable derived indexes, content-addressed cache tiers, optional sparse working copies, repository APIs, semantic approval policy, and post-merge validation. Distinct from `repository-governance`, which catalogs contribution rules, and from `content-addressed-storage`, which covers content hashing as a general persistence technique.

## Sections

| Section | Source | One-line abstract |
|---------|--------|-------------------|
| [overview](../sections/web--anthropic-redesigning-source-control--overview.md) | Anthropic source-control redesign | Anthropic presents Scion after AI-assisted development raised monorepo merge volume from about 2,500 to more than 30,000 changes per day. |
| [growing the monorepo](../sections/web--anthropic-redesigning-source-control--growing-the-monorepo.md) | Anthropic source-control redesign | Complete Git clones became impractical at nearly 100 GB of main history and roughly 25 million daily CI checkouts. |
| [agent-scale principles](../sections/web--anthropic-redesigning-source-control--agent-scale-principles.md) | Anthropic source-control redesign | Scion assumes online clients, asymmetric servers, repository APIs, horizontal scale, incremental refless commits, and optional sparse working copies. |
| [changesets and derived data](../sections/web--anthropic-redesigning-source-control--changesets-and-derived-data.md) | Anthropic source-control redesign | First-parent-relative changesets form the log; blame, path history, graph skips, copy detection, and search are replaceable derived data. |
| [scalable object delivery](../sections/web--anthropic-redesigning-source-control--scalable-object-delivery.md) | Anthropic source-control redesign | Immutable trees and blobs flow through node, regional, and authoritative cache tiers without packfile negotiation. |
| [engineering and operations lessons](../sections/web--anthropic-redesigning-source-control--engineering-and-operations-lessons.md) | Anthropic source-control redesign | Agents supplied implementation throughput while engineers retained system judgment, security policy, review calibration, and operational direction. |
| [ecosystem directions](../sections/web--anthropic-redesigning-source-control--ecosystem-directions.md) | Anthropic source-control redesign | Scion is narrow, but asymmetric Git servers, comprehensive RPCs, better negotiation, and composable sparse features may transfer. |

## See also

- [`agentic-sdlc`](agentic-sdlc.md) — the development lifecycle whose scale changes source-control requirements.
- [`content-addressed-storage`](content-addressed-storage.md) — the immutable-object substrate used for Scion's blobs and cacheability.
- [`repository-governance`](repository-governance.md) — repository contribution and policy documents rather than source-control implementation.
- [`testing`](testing.md) — validation mechanisms, including Scion's shift toward post-merge and pre-deploy automation.
