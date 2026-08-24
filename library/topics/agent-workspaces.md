Cloud-hosted work environments in which agents use organizational context, create artifacts and applications, and operate through governed integrations. This topic covers the workspace architecture and user experience rather than generic agent-loop frameworks.

## Sections

| Section | Topics | Abstract |
|---|---|---|
| [overview and workspace model](../sections/cloudflare-os--readme--overview-and-workspace-model.md) | agent-workspaces, ai-generated-apps | Cloudflare OS combines an agent chat, generated applications, and governed company integrations. |
| [gadgets as personal software sandboxes](../sections/cloudflare-os--readme--gadgets-personal-software-sandboxes.md) | ai-generated-apps, agent-workspaces, sandbox-platforms | A gadget is a private, modifiable application instance isolated from every other user copy. |
| [Gatekeepers and deferred human approval](../sections/cloudflare-os--readme--gatekeepers-and-deferred-approval.md) | capability-mediated-integrations, capability-security, agent-workspaces | Gatekeepers mediate narrow external-service capabilities and defer human approval without stopping agent progress. |
| [Workers runtime architecture](../sections/cloudflare-os--readme--workers-runtime-architecture.md) | cloudflare-workers-agent-hosting, agent-workspaces, sandbox-platforms | Workers primitives provide the kernel, process, driver, and workspace boundaries. |
| [agent-built collaborative applications](../sections/cloudflare-os--readme--agent-built-collaborative-apps.md) | ai-generated-apps, collaborative-workspace-sharing, agent-workspaces | Gadgets are generated, invoked, and collaboratively edited by agents through explicit APIs. |
| [bundled formats and administrative curation](../sections/cloudflare-os--docs-blueprints--bundled-formats-and-curation.md) | reusable-app-blueprints, agent-workspaces | Administrators curate which Blueprints appear as standard application formats. |
| [daily allowance and credit routing](../sections/cloudflare-os--docs-ai-gateway-billing--daily-allowance-and-credit-routing.md) | ai-usage-billing, agent-workspaces, capability-mediated-integrations | Public workspaces meter user-initiated agent turns. |
| [public multi-user deployment](../sections/cloudflare-os--docs-public-server--public-multi-user-deployment.md) | agent-workspaces, authentication-gatekeepers, ai-usage-billing, cloudflare-workers-agent-hosting | Public deployment combines federated login and metered AI usage. |

## See also

- [ai-generated-apps](ai-generated-apps.md)
- [capability-mediated-integrations](capability-mediated-integrations.md)
- [cloudflare-workers-agent-hosting](cloudflare-workers-agent-hosting.md)
