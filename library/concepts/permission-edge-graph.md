---
id: permission-edge-graph
aliases: [permission graph, permission edge, effective role graph, share-link node]
topics: [collaborative-workspace-sharing, capability-security]
---

# Permission edge graph

Cloudflare OS records direct grants and share-link redemptions as provenance-carrying edges, then computes each collaborator's effective role as the greatest owner-rooted authority supported by those edges.

## Sections that touch this concept

| Section | One-line summary |
|---|---|
| [share links and permission edges](../sections/cloudflare-os--docs-sharing--share-links-and-permission-edges.md) | Represents direct grants and share links as explicit provenance edges. |
| [effective roles over a permission graph](../sections/cloudflare-os--docs-sharing--effective-role-graph.md) | Computes the greatest owner-rooted role by fixed-point propagation. |
| [lazy revocation and restoration](../sections/cloudflare-os--docs-sharing--lazy-revocation.md) | Uses the graph to determine downstream effects of severed support. |
| [Lazy revocation model and reversibility](../sections/cloudflare-os--packages-workshop-backend-src-sharing--lazy-revocation-model.md) | Edges are severed, never cascaded or deleted, so revocation is reversible by re-adding the collaborator. |
| [Share-key redemption and link/alias edges](../sections/cloudflare-os--packages-workshop-backend-src-sharing--share-key-redemption.md) | A shareKey edge names the link, not the key, so a link's keys and copies collapse to one grant. |
| [Effective roles by fixed-point graph traversal](../sections/cloudflare-os--packages-workshop-backend-src-sharing--effective-role-fixed-point.md) | Effective role is min(edge role, sharer role) maximized over owner-rooted paths by a monotone fixed point. |

## See also

- [[lazy-graph-revocation]]
- [[principle-of-least-authority]]
