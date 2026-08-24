Applications generated and modified by AI for individual users, including the isolation, API, portability, and ownership properties that make per-user software practical. This topic is distinct from general coding-agent harnesses and from the underlying cloud runtime.

## Sections

| Section | Topics | Abstract |
|---|---|---|
| [overview and workspace model](../sections/cloudflare-os--readme--overview-and-workspace-model.md) | agent-workspaces, ai-generated-apps | Cloudflare OS combines an agent chat, generated applications, and governed company integrations. |
| [gadgets as personal software sandboxes](../sections/cloudflare-os--readme--gadgets-personal-software-sandboxes.md) | ai-generated-apps, agent-workspaces, sandbox-platforms | A gadget is a private, modifiable application instance isolated from every other user copy. |
| [agent-built collaborative applications](../sections/cloudflare-os--readme--agent-built-collaborative-apps.md) | ai-generated-apps, collaborative-workspace-sharing, agent-workspaces | Gadgets are generated, invoked, and collaboratively edited by agents through explicit APIs. |
| [Blueprint capture and properties](../sections/cloudflare-os--docs-blueprints--capture-and-properties.md) | reusable-app-blueprints, ai-generated-apps | A Blueprint copies gadget code and dependency shape without live data or credentials. |
| [portable gadget archive format](../sections/cloudflare-os--docs-blueprints--portable-gadget-format.md) | reusable-app-blueprints, ai-generated-apps | The bounded `.gadget` container moves application code between deployments. |
| [Blueprint instantiation by users and agents](../sections/cloudflare-os--docs-blueprints--instantiation.md) | reusable-app-blueprints, ai-generated-apps, capability-mediated-integrations | Users and agents instantiate independent gadgets and resolve bindings against user-owned resources. |
| [Git object store and commit model](../sections/cloudflare-os--plans-git-storage--git-object-store-and-commit-model.md) | Cloudflare OS plans/git-storage.md | Gadget code moves from workspace-wide Yjs mainline into real Git commits stored as loose objects in each Overseer Durable Object. |
| [Commit-backed chat merge and migration](../sections/cloudflare-os--plans-git-storage--commit-backed-chat-merge-and-migration.md) | Cloudflare OS plans/git-storage.md | Chat branches merge into themselves before mainline advances, and historical Yjs state migrates into commit ancestry. |
| [Lazy per-gadget pinning and epochs](../sections/cloudflare-os--plans-git-storage--lazy-per-gadget-pinning-and-epochs.md) | Cloudflare OS plans/git-storage.md | Unedited gadgets track mainline live; only first modification establishes a commit pin for the chat epoch. |
| [Workpiece namespace and gadget roots](../sections/cloudflare-os--plans-multi-gadget--workpiece-namespace-and-gadget-roots.md) | Cloudflare OS plans/multi-gadget.md | A workspace becomes a container of numbered workpieces with gadgets and Gatekeepers sharing one ID namespace. |
| [Chat-scoped provisional changes](../sections/cloudflare-os--plans-multi-gadget--chat-scoped-provisional-changes.md) | Cloudflare OS plans/multi-gadget.md | Chats can create and connect several gadgets while pending records remain private until accepted. |

## See also

- [agent-workspaces](agent-workspaces.md)
- [reusable-app-blueprints](reusable-app-blueprints.md)
- [sandbox-platforms](sandbox-platforms.md)
