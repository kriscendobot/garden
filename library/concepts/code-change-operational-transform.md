---
id: code-change-operational-transform
aliases: [CodeChange, code change, code-change stream, submitCodeChange, transformCodeChange, revisioned change stream, editFile OT, ChatCodeChanges, change materialization watermark, code-change validation]
topics: [local-first-sync, change-propagation]
---

# code-change-operational-transform

Cloudflare OS represents a chat's uncommitted code as an operational-transform stream of base-free `CodeChange`s layered over git-backed committed code. Each change is expressed against a revision, carries no base content, and the server serializes concurrent changes into one revisioned stream per chat, resolving overlaps by a fixed server-order priority convention (the earlier-ordered change's inserts win at equal positions, exactly `@codemirror/state` ChangeSet's transform law). `submitCodeChange` is the sole edit path; retries are idempotent by client session and seq because OT, unlike a CRDT, cannot tolerate double-application. Client code changes cross a trust boundary through two ordered validation stages — schema before any transform, content after transforming to the server's current revision — whose surrogate and boundary rules keep replicas byte-identical.

## Sections that touch this concept

| Section | One-line summary |
|---|---|
| [Operational-transform code-change representation](../sections/cloudflare-os--packages-workshop-shared-src-code-change--operational-transform-representation.md) | Base-free revisioned changes, the wire types, and why per-gadget files are lists not objects. |
| [Concurrent transform and the priority convention](../sections/cloudflare-os--packages-workshop-shared-src-code-change--concurrent-transform-priority-convention.md) | The server-order priority pairing, the ChangeSet transform law, and per-path edit/set/remove rules. |
| [Two-stage ingestion-validation trust boundary](../sections/cloudflare-os--packages-workshop-shared-src-code-change--two-stage-ingestion-validation.md) | Schema-before-transform / content-after ordering, the running size budget, and byte-identical-replica surrogate rules. |
| [Code-change submission as the sole edit path](../sections/cloudflare-os--packages-workshop-shared-src-api--code-change-submission-sole-edit-path.md) | submitCodeChange: server transform over accepted changes, atomic pins, and OT-safe retry by session and seq. |
| [Durable and live code-branch state](../sections/cloudflare-os--packages-workshop-frontend-src-chatinterface--durable-and-live-code-branch-state.md) | The client's durable snapshot plus synchronous live row stream, deduped by stream position. |

## See also

- [[lazy-gadget-pinning]] — the pin/epoch/generation model this change stream applies on top of.
- [[git-backed-gadget-code]] — the committed-code substrate each change composes against.
- [[cask-operational-transform]] — a sibling OT primitive in the unrelated CASK project (Keep/Skip/Inject over content-addressed arrays), a useful contrast in how a different system frames the same problem.
