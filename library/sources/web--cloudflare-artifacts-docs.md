---
source_kind: web
source_url: https://developers.cloudflare.com/artifacts/llms-full.txt
source_content_sha256: d81d8779a3e3a3b645c62b871ca8c06e35acfc66ccfde4986186904f06cb9996
source_authors: ["Cloudflare, Inc."]
source_date: 2026-08-25
retrieved: 2026-09-10
ingested: 2026-09-10
ingested_by: gardener
section_count: 5
status: current
notes: "Living vendor documentation reached from the Cloudflare Artifacts product page. The idempotency anchor covers the llms-full.txt rendering retrieved directly on 2026-09-10."
---

Cloudflare Artifacts is a managed, Git-compatible repository service for large populations of isolated agent workspaces. The documentation defines the repository and namespace model, Git and Worker interfaces, short-lived repo-scoped credentials, Worker-side mutation through isomorphic-git, lazy FUSE mounts through ArtifactFS, durability, limits, and billing.

| Section | Topics | Status |
|---------|--------|--------|
| [Product scope, repository unit, and durability](../sections/web--cloudflare-artifacts-docs--product-scope-repository-unit-and-durability.md) | agent-workspaces, cloudflare-workers-agent-hosting, content-addressed-storage | current |
| [Git compatibility and programmatic surfaces](../sections/web--cloudflare-artifacts-docs--git-compatibility-and-programmatic-surfaces.md) | cloudflare-workers-agent-hosting, content-addressed-storage, capability-security | current |
| [Agent isolation and scoped authority](../sections/web--cloudflare-artifacts-docs--agent-isolation-and-scoped-authority.md) | agent-workspaces, capability-security, cloudflare-workers-agent-hosting | current |
| [Worker-side mutation with isomorphic-git](../sections/web--cloudflare-artifacts-docs--worker-side-mutation-with-isomorphic-git.md) | cloudflare-workers-agent-hosting, agent-workspaces, content-addressed-storage | current |
| [Lazy mounts, limits, and lifecycle economics](../sections/web--cloudflare-artifacts-docs--lazy-mounts-limits-and-lifecycle-economics.md) | cloudflare-workers-agent-hosting, agent-workspaces | current |
