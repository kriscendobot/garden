# Topic: source-control-architecture

> Abstract: Architectures for storing, querying, distributing, reviewing, and landing repository changes at scales where a complete local Git clone and serialized merge queue become bottlenecks. Seeded from Anthropic's Scion account: always-online asymmetric clients and servers, append-only changesets, replaceable derived indexes, content-addressed cache tiers, optional sparse working copies, repository APIs, semantic approval policy, and post-merge validation. Extended 2026-11-12 with OpenAI's Pando, the contrasting Git-compatible answer: a rebuilt server with per-ref causal consistency, reusable pushed packs served by `packfile-uri` from regional caches, and LSM-style pack compaction in place of repack/GC. Distinct from `repository-governance`, which catalogs contribution rules, and from `content-addressed-storage`, which covers content hashing as a general persistence technique.

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
| [Pando overview](../sections/web--openai-scaling-git--overview.md) | OpenAI Pando | Pando, OpenAI's Git-compatible monorepo backend, trades repository-wide ref consistency and per-client packs for scalable writes and line-rate reads. |
| [Why OpenAI needed a new source control system](../sections/web--openai-scaling-git--why-a-new-source-control-system.md) | OpenAI Pando | Codex-driven parallel pushes and fetches drove reliability below 90%; Pando scales writers per branch and readers by pack reuse. |
| [Git object storage primer](../sections/web--openai-scaling-git--git-object-storage-primer.md) | OpenAI Pando | Objects, refs, loose and packed storage, haves/wants, thin push packs, and what replication must guarantee. |
| [3PC and WAL Git service patterns](../sections/web--openai-scaling-git--existing-distributed-git-service-patterns.md) | OpenAI Pando | Quorum three-phase commit puts replica disks on the push path; a CAS-published shared manifest makes unrelated pushes contend. |
| [Pando causal consistency](../sections/web--openai-scaling-git--causal-consistency.md) | OpenAI Pando | Immutable pack blobs plus ref versions give per-ref serializability; multi-ref reads are not point-in-time. |
| [Pando scaling pushes](../sections/web--openai-scaling-git--scaling-pushes.md) | OpenAI Pando | Trunk-only advertisement keeps pushed packs reusable; one O(1) transaction writes the ref version and CASes the ref pointer. |
| [Pando line-rate fetch and clone](../sections/web--openai-scaling-git--line-rate-fetch-and-clone.md) | OpenAI Pando | Fetch planning selects stored packs in O(log Δ) and serves them by packfile-uri from the Express regional cache. |
| [Pando compaction](../sections/web--openai-scaling-git--compaction-and-time-to-first-byte.md) | OpenAI Pando | LSM-style L0 to L4 pack covers improve compression and act as a skip list; packs are never garbage-collected. |
| [Building and deploying Pando](../sections/web--openai-scaling-git--building-and-deploying-pando.md) | OpenAI Pando | Codex-built Rust in 10 weeks with conformance, deterministic simulation, and Lean/TLA+; migrated behind a write-through proxy. |
| [Pando contributions back to Git](../sections/web--openai-scaling-git--contributing-back-to-git.md) | OpenAI Pando | packfile-uri download fixes and tracing, parallel pack indexing, and explicit haves for --force-with-lease. |

## See also

- [`agentic-sdlc`](agentic-sdlc.md) — the development lifecycle whose scale changes source-control requirements.
- [`content-addressed-storage`](content-addressed-storage.md) — the immutable-object substrate used for Scion's blobs and cacheability.
- [`repository-governance`](repository-governance.md) — repository contribution and policy documents rather than source-control implementation.
- [`testing`](testing.md) — validation mechanisms, including Scion's shift toward post-merge and pre-deploy automation.
