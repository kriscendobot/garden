---
id: cloudflare-os-blueprint
aliases: [Blueprint, Cloudflare OS Blueprint, .gadget archive]
topics: [reusable-app-blueprints, ai-generated-apps]
---

# Cloudflare OS Blueprint

A Blueprint is a versioned gadget-code snapshot plus binding requirements that can be published, exported, curated, and instantiated as an independent gadget without copying the source instance's data, history, or credentials.

## Sections that touch this concept

| Section | One-line summary |
|---|---|
| [Blueprint capture and properties](../sections/cloudflare-os--docs-blueprints--capture-and-properties.md) | Defines the versioned code snapshot and excluded instance state. |
| [binding requirements and annotations](../sections/cloudflare-os--docs-blueprints--binding-requirements.md) | Records dependency shape for later user assignment. |
| [Blueprint storage and publication](../sections/cloudflare-os--docs-blueprints--storage-and-publication.md) | Describes publication through Durable Objects, KV, and R2. |
| [portable gadget archive format](../sections/cloudflare-os--docs-blueprints--portable-gadget-format.md) | Defines the portable `.gadget` archive. |
| [bundled formats and administrative curation](../sections/cloudflare-os--docs-blueprints--bundled-formats-and-curation.md) | Separates Blueprint presentation from admin promotion. |
| [Blueprint instantiation by users and agents](../sections/cloudflare-os--docs-blueprints--instantiation.md) | Copies code into an independent gadget and assigns new bindings. |

## See also

- [[cloudflare-os-gadget]]
- [[cloudflare-os-gatekeeper]]
