---
title: §The-two-facet-control-pair canonical shape
source-slug: endo-but-for-bots--llm-designs-endoclaw-six-design-cluster
section-id: two-facet-control-pair-and-structural-confinement-and-help-method-and-composable-capabilities-and-cycle-196-parent
url: https://github.com/endojs/endo-but-for-bots/blob/master/designs/endoclaw-{network-fetch,notifications,proactive-messages,webhooks,voice,browser}.md
authors: [Kris Kowal (prompted)]
repo: endojs/endo-but-for-bots
path: designs/endoclaw-{network-fetch,notifications,proactive-messages,webhooks,voice,browser}.md
total-lines: 439 (69 + 55 + 74 + 79 + 69 + 93)
status: Not Started (all six; created and updated 2026-03-03; Parent: endoclaw)
ingest-cycle: 226
ingest-date: 2026-06-08
lane: designs
parent: endo-but-for-bots--llm-designs-endoclaw-six-design-cluster--two-facet-control-pair-and-structural-confinement-and-help-method-and-composable-capabilities-and-cycle-196-parent
---

Four of the six designs use §the-two-facet-pair:

```ts
interface Capability {
  // user-facing methods
  help(): string;
}

interface CapabilityControl {
  setLimit(...): void;
  revoke(): void;
  help(): string;
}
```

§Borrowable-pattern: §the-capability-facet-is-narrow (only the methods the user needs) + §the-control-facet-is-where-the-host-tunes-and-revokes. §Two-facets-with-two-different-holders: capability goes to the agent; control stays with the host.

§Three-named-properties-of-the-control-facet across the cluster:
1. §setLimit-style-method (`setMaxPerMinute`, `setMaxRequestsPerMinute`, `setMaxResponseBytes`, `setMaxPayloadBytes`, `setAllowedOrigins`).
2. §revoke()-method that §invalidates-the-capability-irreversibly.
3. §help()-method for §introspection.

§Borrowable-pattern: §every-capability-pair-has-revoke-and-help — these are §the-uniform-baseline-API across all capabilities. §A-host-can-always-revoke + §any-agent-can-call-help-to-learn-its-shape.
