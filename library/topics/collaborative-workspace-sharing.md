Sharing stateful agent-built applications among users while preserving role restrictions, grant provenance, transitive revocation, per-user credentials, and live-session authorization. This topic covers collaboration semantics rather than reusable code-copy templates.

## Sections

| Section | Topics | Abstract |
|---|---|---|
| [agent-built collaborative applications](../sections/cloudflare-os--readme--agent-built-collaborative-apps.md) | ai-generated-apps, collaborative-workspace-sharing, agent-workspaces | Gadgets are generated, invoked, and collaboratively edited by agents through explicit APIs. |
| [collaborator roles and restricted capabilities](../sections/cloudflare-os--docs-sharing--collaborator-roles.md) | collaborative-workspace-sharing, capability-security | `open()` returns role-specific capabilities with default-deny maintenance for restricted users. |
| [share links and permission edges](../sections/cloudflare-os--docs-sharing--share-links-and-permission-edges.md) | collaborative-workspace-sharing, capability-security | Direct grants and bearer links become provenance-preserving permission edges. |
| [effective roles over a permission graph](../sections/cloudflare-os--docs-sharing--effective-role-graph.md) | collaborative-workspace-sharing, capability-security | Effective access is the greatest owner-rooted role supported by the grant graph. |
| [lazy revocation and restoration](../sections/cloudflare-os--docs-sharing--lazy-revocation.md) | collaborative-workspace-sharing, capability-security | Revocation severs support edges and recomputes reachability without cascading record deletion. |
| [collaborator resource isolation](../sections/cloudflare-os--docs-sharing--collaborator-resource-isolation.md) | collaborative-workspace-sharing, capability-mediated-integrations | Shared gadgets keep model credentials and third-party accounts scoped to the collaborator who bound them. |
| [authorization and live-session termination](../sections/cloudflare-os--docs-sharing--authorization-and-session-termination.md) | collaborative-workspace-sharing, capability-security, cloudflare-workers-agent-hosting | Durable Object restart forces open clients to reauthorize after access changes. |
| [security invariant and observer model](../sections/cloudflare-os--docs-observers--security-invariant-and-observer-model.md) | collaborative-workspace-sharing, capability-mediated-integrations, capability-security | Every non-owner is verified against the external data a gadget has read. |
| [observer records and verifiers](../sections/cloudflare-os--docs-observers--observer-records-and-verifiers.md) | collaborative-workspace-sharing, capability-mediated-integrations, capability-security | Observer records separate sharing intent from completed verification. |
| [configuration and re-verification on open](../sections/cloudflare-os--docs-observers--configuration-and-reverification-on-open.md) | collaborative-workspace-sharing, capability-mediated-integrations, capability-security | Collaborators select accounts once and are reverified on every open. |
| [forward exclusion and sharing-change teardown](../sections/cloudflare-os--docs-observers--forward-exclusion-and-sharing-change-teardown.md) | collaborative-workspace-sharing, capability-mediated-integrations, capability-security | A read is blocked while any excluded observer remains authorized. |
| [Gatekeeper observer strategies](../sections/cloudflare-os--docs-observers--gatekeeper-observer-strategies.md) | collaborative-workspace-sharing, capability-mediated-integrations, capability-security | Resource types choose an observer policy according to their ACL shape. |
| [Commit-backed chat merge and migration](../sections/cloudflare-os--plans-git-storage--commit-backed-chat-merge-and-migration.md) | Cloudflare OS plans/git-storage.md | Chat branches merge into themselves before mainline advances, and historical Yjs state migrates into commit ancestry. |
| [Lazy per-gadget pinning and epochs](../sections/cloudflare-os--plans-git-storage--lazy-per-gadget-pinning-and-epochs.md) | Cloudflare OS plans/git-storage.md | Unedited gadgets track mainline live; only first modification establishes a commit pin for the chat epoch. |
| [Deterministic Yjs seeds and reserved client IDs](../sections/cloudflare-os--plans-git-storage--deterministic-yjs-seeds-and-reserved-client-ids.md) | Cloudflare OS plans/git-storage.md | Per-gadget seeds use reserved deterministic client IDs and hashes while live authors are excluded from the reserved band. |
| [Operational-transform change model](../sections/cloudflare-os--plans-git-storage--operational-transform-change-model.md) | Cloudflare OS plans/git-storage.md | A file-change algebra and Durable Object revision stream replace Yjs chat updates with operational transformation. |
| [Revision epochs, stragglers, and materialization](../sections/cloudflare-os--plans-git-storage--revision-epochs-stragglers-and-materialization.md) | Cloudflare OS plans/git-storage.md | Revision windows materialize compactly while eligible in-flight changes bridge merge boundaries against recorded commits. |
| [CodeMirror client and delivery sequence](../sections/cloudflare-os--plans-git-storage--codemirror-client-and-delivery-sequence.md) | Cloudflare OS plans/git-storage.md | One OT client per chat feeds CodeMirror views through a kernel-first delivery sequence and explicit full gate. |
| [Chat-scoped provisional changes](../sections/cloudflare-os--plans-multi-gadget--chat-scoped-provisional-changes.md) | Cloudflare OS plans/multi-gadget.md | Chats can create and connect several gadgets while pending records remain private until accepted. |

## See also

- [reusable-app-blueprints](reusable-app-blueprints.md)
- [capability-security](capability-security.md)
- [agent-workspaces](agent-workspaces.md)
