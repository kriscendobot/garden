---
id: cloudflare-artifacts
aliases: [Cloudflare Artifacts, Artifacts, ArtifactFS]
topics: [cloudflare-workers-agent-hosting, agent-workspaces, content-addressed-storage, capability-security]
---

# cloudflare-artifacts

Cloudflare Artifacts is a managed Git-compatible repository service with namespace and per-repository isolation, Git-over-HTTPS, control-plane APIs, short-lived repository tokens, and Worker bindings. ArtifactFS is its separate FUSE-based lazy working-tree client for hosts that can mount filesystems.

## Sections that touch this concept

| Section | One-line summary |
|---|---|
| [web--cloudflare-artifacts-docs--product-scope-repository-unit-and-durability.md](../sections/web--cloudflare-artifacts-docs--product-scope-repository-unit-and-durability.md) | Artifacts makes an isolated, durably replicated Git repository the unit of agent work and lifecycle. |
| [web--cloudflare-artifacts-docs--git-compatibility-and-programmatic-surfaces.md](../sections/web--cloudflare-artifacts-docs--git-compatibility-and-programmatic-surfaces.md) | Git-over-HTTPS is the full repository data path; REST and the Worker binding expose different control and read subsets. |
| [web--cloudflare-artifacts-docs--agent-isolation-and-scoped-authority.md](../sections/web--cloudflare-artifacts-docs--agent-isolation-and-scoped-authority.md) | Per-session repositories and short-lived repo-scoped tokens separate agent work, review, and cleanup. |
| [web--cloudflare-artifacts-docs--worker-side-mutation-with-isomorphic-git.md](../sections/web--cloudflare-artifacts-docs--worker-side-mutation-with-isomorphic-git.md) | Workers edit an ephemeral filesystem through isomorphic-git, then commit and push durable state to Artifacts. |
| [web--cloudflare-artifacts-docs--lazy-mounts-limits-and-lifecycle-economics.md](../sections/web--cloudflare-artifacts-docs--lazy-mounts-limits-and-lifecycle-economics.md) | ArtifactFS lazily hydrates large working trees on FUSE hosts; beta limits and pricing bound retained repositories. |

## See also

- [[git-backed-gadget-code]] - another Cloudflare-hosted Git object model, implemented inside Cloudflare OS Durable Objects.
- [[object-capability]] - the authority discipline an Endo adapter must preserve above provider credentials.
