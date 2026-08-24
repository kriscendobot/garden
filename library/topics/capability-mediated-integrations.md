External-service integrations that replace ambient connector access with narrow, user-designated resource capabilities, including Gatekeeper APIs, account separation, authorization, audit, and deferred approval for side effects.

## Sections

| Section | Topics | Abstract |
|---|---|---|
| [Gatekeepers and deferred human approval](../sections/cloudflare-os--readme--gatekeepers-and-deferred-approval.md) | capability-mediated-integrations, capability-security, agent-workspaces | Gatekeepers mediate narrow external-service capabilities and defer human approval without stopping agent progress. |
| [capability-based introductions](../sections/cloudflare-os--readme--capability-based-introductions.md) | capability-mediated-integrations, capability-security | Agents and gadgets begin without external authority and gain resources through explicit introductions. |
| [binding requirements and annotations](../sections/cloudflare-os--docs-blueprints--binding-requirements.md) | reusable-app-blueprints, capability-mediated-integrations | Blueprint bindings preserve dependency shape while consumers supply their own resources. |
| [Blueprint instantiation by users and agents](../sections/cloudflare-os--docs-blueprints--instantiation.md) | reusable-app-blueprints, ai-generated-apps, capability-mediated-integrations | Users and agents instantiate independent gadgets and resolve bindings against user-owned resources. |
| [collaborator resource isolation](../sections/cloudflare-os--docs-sharing--collaborator-resource-isolation.md) | collaborative-workspace-sharing, capability-mediated-integrations | Shared gadgets keep model credentials and third-party accounts scoped to the collaborator who bound them. |

## See also

- [capability-security](capability-security.md)
- [agent-workspaces](agent-workspaces.md)
- [oauth-credentials](oauth-credentials.md)
