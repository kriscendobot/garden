Versioned, portable templates for creating independent application instances from code and dependency requirements without copying live data, credentials, or ownership. Cloudflare OS Blueprints are the canonical corpus for this topic.

## Sections

| Section | Topics | Abstract |
|---|---|---|
| [Blueprint capture and properties](../sections/cloudflare-os--docs-blueprints--capture-and-properties.md) | reusable-app-blueprints, ai-generated-apps | A Blueprint copies gadget code and dependency shape without live data or credentials. |
| [binding requirements and annotations](../sections/cloudflare-os--docs-blueprints--binding-requirements.md) | reusable-app-blueprints, capability-mediated-integrations | Blueprint bindings preserve dependency shape while consumers supply their own resources. |
| [Blueprint storage and publication](../sections/cloudflare-os--docs-blueprints--storage-and-publication.md) | reusable-app-blueprints, cloudflare-workers-agent-hosting, persistence | Blueprint metadata propagates through Durable Objects and KV while code snapshots live in R2. |
| [portable gadget archive format](../sections/cloudflare-os--docs-blueprints--portable-gadget-format.md) | reusable-app-blueprints, ai-generated-apps | The bounded `.gadget` container moves application code between deployments. |
| [bundled formats and administrative curation](../sections/cloudflare-os--docs-blueprints--bundled-formats-and-curation.md) | reusable-app-blueprints, agent-workspaces | Administrators curate which Blueprints appear as standard application formats. |
| [Blueprint instantiation by users and agents](../sections/cloudflare-os--docs-blueprints--instantiation.md) | reusable-app-blueprints, ai-generated-apps, capability-mediated-integrations | Users and agents instantiate independent gadgets and resolve bindings against user-owned resources. |

## See also

- [ai-generated-apps](ai-generated-apps.md)
- [agent-workspaces](agent-workspaces.md)
- [capability-mediated-integrations](capability-mediated-integrations.md)
