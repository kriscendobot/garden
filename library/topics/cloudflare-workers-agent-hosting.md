Hosting agent workspaces and generated applications on Cloudflare Workers primitives, especially Durable Objects, Dynamic Workers, Facets, Workers KV, R2, bindings, and the open-source `workerd` runtime.

## Sections

| Section | Topics | Abstract |
|---|---|---|
| [Workers runtime architecture](../sections/cloudflare-os--readme--workers-runtime-architecture.md) | cloudflare-workers-agent-hosting, agent-workspaces, sandbox-platforms | Durable Objects, Dynamic Workers, Facets, and bindings host the workspace and its applications. |
| [Blueprint storage and publication](../sections/cloudflare-os--docs-blueprints--storage-and-publication.md) | reusable-app-blueprints, cloudflare-workers-agent-hosting, persistence | Blueprint metadata propagates through Durable Objects and KV while code snapshots live in R2. |
| [authorization and live-session termination](../sections/cloudflare-os--docs-sharing--authorization-and-session-termination.md) | collaborative-workspace-sharing, capability-security, cloudflare-workers-agent-hosting | Durable Object restart forces open clients to reauthorize after access changes. |

## See also

- [agent-workspaces](agent-workspaces.md)
- [sandbox-platforms](sandbox-platforms.md)
- [persistence](persistence.md)
