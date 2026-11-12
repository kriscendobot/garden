---
id: git-packfile-uri
aliases: [packfile-uri, packfile URIs, explicit haves, offloaded packfiles, haves and wants, pack negotiation, thin pack, ref advertisement]
topics: [source-control-architecture, networking]
---

# git-packfile-uri

`packfile-uri` is a Git protocol v2 fetch capability that lets a server answer a fetch with an inline pack plus URIs of additional packs the client downloads separately, instead of the single inline pack the protocol otherwise allows. It is what makes **server-side pack reuse** practical: a server can hand out prebuilt, cacheable packs (from a CDN or regional cache) rather than computing a per-client pack from the haves/wants set difference. OpenAI's Pando uses it exclusively (empty inline pack, all objects by URI) and contributed client fixes upstream (concurrent and resumed downloads, interrupted-transfer cleanup, validation of reused packs, tracing and byte counts), plus parallel pack download/indexing and **explicit haves** (advertising a branch tip separately from the history a pushing client may omit, so `--force-with-lease` and trunk-relative packs coexist) in OpenAI's Git build.

## Sections that touch this concept

| Section | One-line summary |
|---|---|
| [line-rate fetch and clone](../sections/web--openai-scaling-git--line-rate-fetch-and-clone.md) | Pando sends an empty inline pack and serves every object by `packfile-uri` from Express. |
| [contributing back to Git](../sections/web--openai-scaling-git--contributing-back-to-git.md) | Client fixes for pack download/indexing, tracing, parallel indexing, and explicit haves. |
| [Git object storage primer](../sections/web--openai-scaling-git--git-object-storage-primer.md) | Haves, wants, reachability, and why a pushed pack can be thin. |

## See also

- [[pando-git-backend]]: the server design built around this feature.
- [[scion-source-control]]: replaces packfile negotiation altogether with per-object cacheable requests.
