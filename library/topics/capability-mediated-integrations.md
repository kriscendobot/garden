External-service integrations that replace ambient connector access with narrow, user-designated resource capabilities, including Gatekeeper APIs, account separation, authorization, audit, and deferred approval for side effects.

## Sections

| Section | Topics | Abstract |
|---|---|---|
| [Gatekeepers and deferred human approval](../sections/cloudflare-os--readme--gatekeepers-and-deferred-approval.md) | capability-mediated-integrations, capability-security, agent-workspaces | Gatekeepers mediate narrow external-service capabilities and defer human approval without stopping agent progress. |
| [capability-based introductions](../sections/cloudflare-os--readme--capability-based-introductions.md) | capability-mediated-integrations, capability-security | Agents and gadgets begin without external authority and gain resources through explicit introductions. |
| [binding requirements and annotations](../sections/cloudflare-os--docs-blueprints--binding-requirements.md) | reusable-app-blueprints, capability-mediated-integrations | Blueprint bindings preserve dependency shape while consumers supply their own resources. |
| [Blueprint instantiation by users and agents](../sections/cloudflare-os--docs-blueprints--instantiation.md) | reusable-app-blueprints, ai-generated-apps, capability-mediated-integrations | Users and agents instantiate independent gadgets and resolve bindings against user-owned resources. |
| [collaborator resource isolation](../sections/cloudflare-os--docs-sharing--collaborator-resource-isolation.md) | collaborative-workspace-sharing, capability-mediated-integrations | Shared gadgets keep model credentials and third-party accounts scoped to the collaborator who bound them. |
| [security invariant and observer model](../sections/cloudflare-os--docs-observers--security-invariant-and-observer-model.md) | collaborative-workspace-sharing, capability-mediated-integrations, capability-security | Gatekeepers verify observers against historical and future observations. |
| [observer records and verifiers](../sections/cloudflare-os--docs-observers--observer-records-and-verifiers.md) | collaborative-workspace-sharing, capability-mediated-integrations, capability-security | Vendor Gatekeepers interpret opaque verifiers minted by user accounts. |
| [configuration and re-verification on open](../sections/cloudflare-os--docs-observers--configuration-and-reverification-on-open.md) | collaborative-workspace-sharing, capability-mediated-integrations, capability-security | The overseer asks each in-scope Gatekeeper to verify the collaborator. |
| [forward exclusion and sharing-change teardown](../sections/cloudflare-os--docs-observers--forward-exclusion-and-sharing-change-teardown.md) | collaborative-workspace-sharing, capability-mediated-integrations, capability-security | Gatekeeper exclusions are reconciled against the live sharing graph. |
| [Gatekeeper observer strategies](../sections/cloudflare-os--docs-observers--gatekeeper-observer-strategies.md) | collaborative-workspace-sharing, capability-mediated-integrations, capability-security | Atomic and broad bindings use different vendor verification strategies. |
| [verified-email identity and incremental OAuth scopes](../sections/cloudflare-os--docs-oauth-signin--verified-email-identity-and-incremental-scopes.md) | authentication-gatekeepers, identity, capability-mediated-integrations, oauth-credentials | Broader provider capabilities require a later explicit connection. |
| [capability-shaped sign-in flow](../sections/cloudflare-os--docs-oauth-signin--capability-shaped-sign-in-flow.md) | authentication-gatekeepers, identity, capability-mediated-integrations | Gatekeeper callbacks complete login without a public attempt identifier. |
| [daily allowance and credit routing](../sections/cloudflare-os--docs-ai-gateway-billing--daily-allowance-and-credit-routing.md) | ai-usage-billing, agent-workspaces, capability-mediated-integrations | Billing authority remains in the user's Cloudflare connection. |
| [Cloudflare Gatekeeper billing connection](../sections/cloudflare-os--docs-ai-gateway-billing--cloudflare-gatekeeper-billing-connection.md) | ai-usage-billing, authentication-gatekeepers, capability-mediated-integrations | The user object stores no Cloudflare OAuth token. |
| [Binding edges and workpiece capabilities](../sections/cloudflare-os--plans-multi-gadget--binding-edges-and-workpiece-capabilities.md) | Cloudflare OS plans/multi-gadget.md | Binding names move onto per-gadget edges so several gadgets can name and annotate one resource differently. |
| [Named chat environments and spawner scope](../sections/cloudflare-os--plans-multi-gadget--named-chat-environments-and-spawner-scope.md) | Cloudflare OS plans/multi-gadget.md | Agents address gadgets and resources through validated names in frozen chat binding maps. |
| [Kernel and capability-security review](../sections/cloudflare-os--review--kernel-and-capability-security-review.md) | Cloudflare OS REVIEW.md | Review prioritizes kernel quality and capability-minting chokepoints before lower-risk surfaces. |

## See also

- [capability-security](capability-security.md)
- [agent-workspaces](agent-workspaces.md)
- [oauth-credentials](oauth-credentials.md)
