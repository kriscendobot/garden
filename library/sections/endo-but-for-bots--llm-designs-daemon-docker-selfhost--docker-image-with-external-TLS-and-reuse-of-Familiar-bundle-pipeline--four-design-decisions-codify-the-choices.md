---
section: docker-image-with-external-TLS-and-reuse-of-Familiar-bundle-pipeline
source: endo-but-for-bots--llm-designs-daemon-docker-selfhost
topics: [daemon, agent-conventions]
status: current
title: §Four design decisions codify the choices
parent: endo-but-for-bots--llm-designs-daemon-docker-selfhost--docker-image-with-external-TLS-and-reuse-of-Familiar-bundle-pipeline
---

The §Design Decisions section names four:

1. **External TLS** — the load-bearing choice (above).
2. **Same bundles as Familiar** — *No separate build system.*
3. **Volume for state** — *Docker volumes are the standard
   persistence mechanism. Named volumes survive container
   recreation; bind mounts give users direct access for backup.*
4. **`0.0.0.0` binding** — the default-bind override.

The §codification-as-Design-Decisions discipline: each
non-obvious choice is *named* and *justified*. Future PRs that
want to deviate must explicitly argue against the recorded
rationale.
