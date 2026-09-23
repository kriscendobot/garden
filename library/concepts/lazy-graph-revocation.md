---
id: lazy-graph-revocation
aliases: [lazy revocation, reachability revocation, reversible revocation, keepUsers]
topics: [collaborative-workspace-sharing, capability-security]
---

# Lazy graph revocation

Lazy graph revocation removes or disables the edges that support access, leaves downstream records and grants intact, and relies on live owner-rooted reachability computation to deny or downgrade users, allowing restoration by reconnecting a prior path.

## Sections that touch this concept

| Section | One-line summary |
|---|---|
| [effective roles over a permission graph](../sections/cloudflare-os--docs-sharing--effective-role-graph.md) | Supplies hypothetical graph changes for previewing revocation. |
| [lazy revocation and restoration](../sections/cloudflare-os--docs-sharing--lazy-revocation.md) | Preserves downstream records while edge reachability controls access. |
| [authorization and live-session termination](../sections/cloudflare-os--docs-sharing--authorization-and-session-termination.md) | Reauthorizes existing sessions after a graph change. |
| [Lazy revocation model and reversibility](../sections/cloudflare-os--packages-workshop-backend-src-sharing--lazy-revocation-model.md) | removeCollaborator and revokeShareLink sever or soft-flag without cascading; unreachable users are denied at open time. |

## See also

- [[permission-edge-graph]]
