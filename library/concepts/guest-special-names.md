---
id: guest-special-names
aliases: [specialNames, introducedSpecialNames, indelible guest names]
topics: [daemon, capability-security, persistence, agent-conventions]
status: draft
---

# Guest special names

Guest special names are daemon-provided, read-only names such as `@host` or
`@keypair` that resolve through the ordinary guest naming machinery but cannot be
removed or rebound by the guest. Persisting their formula identifiers with the
guest formula makes the same capabilities reappear on reincarnation; a proposed
`introducedSpecialNames` option generalizes this pattern to deployment-provided
capabilities.

## Sections that touch this concept

| Section | One-line summary |
|---|---|
| [`@keypair` as a special name](../sections/endo-but-for-bots--llm-designs-d256--per-agent-keypairs--keypair-as-a-special-name.md) | Shows a guest identity capability exposed through the same special-name record as other daemon powers. |
| [Form submission from `@host`](../sections/endo-but-for-bots--llm-designs-lal-fae-form-provisioning--three-named-problems-and-three-layer-lifecycle-and-three-option-analysis-for-guest-cannot-create-guests-and-inbox-as-durable-config-store--the-form-submission-from-host.md) | Contrasts mutable `introducedNames` used for explicit, user-authorized guest provisioning. |

## See also

- [[formula-graph]]
- [[four-ways-to-acquire-references]]
