---
id: pando-git-backend
aliases: [Pando, OpenAI Pando, Express pack cache, ref version, packfile cover, L0 packfile, causal consistency for Git refs, per-ref serializability, trunk-only ref advertisement, pack reuse]
topics: [source-control-architecture]
---

# pando-git-backend

Pando is OpenAI's Git-protocol-compatible server backend for an agent-heavy monorepo. It keeps the Git client and wire protocol and rebuilds the server: each push is validated in one pass and stored as an immutable pack blob; each branch move records a **ref version** (tip, pack, pack dependencies) in a scalable metadata store with a CAS-guarded ref pointer as the only contended key; pushes to new branches see only trunk advertised so their packs stay reusable; fetches are planned as **selection of stored packs** over ref versions and served exclusively by `packfile-uri` from a regional cache (Express); and LSM-style compaction groups packs into geometrically sized **covers** (L0 to L4) that improve compression and act as a skip list, with no pack ever garbage-collected. The consistency model is per-ref serializable and causally consistent, not repository-wide point-in-time.

## Sections that touch this concept

| Section | One-line summary |
|---|---|
| [overview](../sections/web--openai-scaling-git--overview.md) | Pando's two goals (scalable writes, line-rate reads) and headline results. |
| [causal consistency](../sections/web--openai-scaling-git--causal-consistency.md) | Ref versions, per-ref serializability, and the trade against repository-wide consistency. |
| [scaling pushes](../sections/web--openai-scaling-git--scaling-pushes.md) | Trunk-only advertisement, reusable packs, and the O(1) ref-version transaction. |
| [line-rate fetch and clone](../sections/web--openai-scaling-git--line-rate-fetch-and-clone.md) | Pack selection in O(log Δ), `packfile-uri`, and the Express regional cache. |
| [compaction](../sections/web--openai-scaling-git--compaction-and-time-to-first-byte.md) | LSM-style L0 to L4 covers as compression and skip list; no GC. |

## See also

- [[scion-source-control]]: Anthropic's contrasting answer to the same agent-scale pressure, abandoning Git's client and packfile negotiation for content-addressed object RPCs.
- [[git-packfile-uri]]: the Git protocol feature Pando uses for every fetch response.
- [[journal-ref-rmw-cas]]: CAS on a single shared git ref, the WAL-style coordination Pando is designed to avoid.
