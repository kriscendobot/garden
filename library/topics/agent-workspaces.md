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
| [Workpiece namespace and gadget roots](../sections/cloudflare-os--plans-multi-gadget--workpiece-namespace-and-gadget-roots.md) | Cloudflare OS plans/multi-gadget.md | A workspace becomes a container of numbered workpieces with gadgets and Gatekeepers sharing one ID namespace. |
| [Binding edges and workpiece capabilities](../sections/cloudflare-os--plans-multi-gadget--binding-edges-and-workpiece-capabilities.md) | Cloudflare OS plans/multi-gadget.md | Binding names move onto per-gadget edges so several gadgets can name and annotate one resource differently. |
| [Chat-scoped provisional changes](../sections/cloudflare-os--plans-multi-gadget--chat-scoped-provisional-changes.md) | Cloudflare OS plans/multi-gadget.md | Chats can create and connect several gadgets while pending records remain private until accepted. |
| [Named chat environments and spawner scope](../sections/cloudflare-os--plans-multi-gadget--named-chat-environments-and-spawner-scope.md) | Cloudflare OS plans/multi-gadget.md | Agents address gadgets and resources through validated names in frozen chat binding maps. |
| [Migration decisions and provider routing](../sections/cloudflare-os--plans-pi-impl--migration-decisions-and-provider-routing.md) | Cloudflare OS plans/pi-impl.md | The pi migration fixes low-level loop selection, provider endpoints, credentials, and compatibility bounds. |
| [Message replay and tool adaptation](../sections/cloudflare-os--plans-pi-impl--message-replay-and-tool-adaptation.md) | Cloudflare OS plans/pi-impl.md | Existing chat records replay into pi message types while tools move from Zod to TypeBox. |
| [Awaited agent loop and persistence barrier](../sections/cloudflare-os--plans-pi-impl--awaited-agent-loop-and-persistence-barrier.md) | Cloudflare OS plans/pi-impl.md | An awaited event sink makes successful turn end the persistence barrier and drops failed partial output. |
| [Repository architecture and kernel bar](../sections/cloudflare-os--agents--repository-architecture-and-kernel-bar.md) | Cloudflare OS AGENTS.md | The monorepo map identifies the backend and shared API as the high-scrutiny kernel. |
| [Session API and Markdown boundary](../sections/cloudflare-os--packages-gatekeeper-confluence-readme--session-api-and-markdown-boundary.md) | capability-mediated-integrations, agent-workspaces | Resource-shaped sessions translate Confluence storage XHTML to and from agent-friendly Markdown. |
| [Deferred actions and simulation](../sections/cloudflare-os--packages-gatekeeper-confluence-readme--deferred-actions-and-simulation.md) | capability-mediated-integrations, agent-workspaces, capability-security | Pending side effects overlay simulated results until a human approves provider execution. |
| [Multi-site resource pickers](../sections/cloudflare-os--packages-gatekeeper-confluence-readme--multi-site-resource-pickers.md) | capability-mediated-integrations, agent-workspaces | Pasted URLs and pickers preserve site identity across a multi-site Atlassian account. |

## See also

- [ai-generated-apps](ai-generated-apps.md)
- [capability-mediated-integrations](capability-mediated-integrations.md)
- [cloudflare-workers-agent-hosting](cloudflare-workers-agent-hosting.md)
