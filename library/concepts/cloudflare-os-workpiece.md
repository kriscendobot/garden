---
id: cloudflare-os-workpiece
aliases: [workpiece, WorkpieceId, multi-gadget workspace, gadget binding edge]
topics: [agent-workspaces, capability-mediated-integrations, ai-generated-apps]
---

# Cloudflare OS workpiece

A workpiece is a numbered thing a user or agent works on inside one Cloudflare OS workspace. Gadgets and Gatekeepers initially share this ID namespace, while per-gadget named binding edges connect them and leave room for future mounted resource types with the same file and capability tools.

## Sections that touch this concept

| Section | One-line summary |
|---|---|
| [Workpiece namespace and gadget roots](../sections/cloudflare-os--plans-multi-gadget--workpiece-namespace-and-gadget-roots.md) | Defines the shared ID space and per-gadget document roots. |
| [Binding edges and workpiece capabilities](../sections/cloudflare-os--plans-multi-gadget--binding-edges-and-workpiece-capabilities.md) | Places names and blueprint annotations on edges between workpieces. |
| [Chat-scoped provisional changes](../sections/cloudflare-os--plans-multi-gadget--chat-scoped-provisional-changes.md) | Makes workpiece creation and binding provisional to a chat. |
| [Named chat environments and spawner scope](../sections/cloudflare-os--plans-multi-gadget--named-chat-environments-and-spawner-scope.md) | Resolves validated chat names to workpiece capabilities. |

## See also

- [[cloudflare-os-gadget]]
- [[cloudflare-os-gatekeeper]]
