---
section: docker-image-with-external-TLS-and-reuse-of-Familiar-bundle-pipeline
source: endo-but-for-bots--llm-designs-daemon-docker-selfhost
topics: [daemon, agent-conventions]
status: current
title: The §bundled-agents optional add-on
parent: endo-but-for-bots--llm-designs-daemon-docker-selfhost--docker-image-with-external-TLS-and-reuse-of-Familiar-bundle-pipeline
---

The §Bundled agents (optional) section names the *future
enhancement* that adds Lal/Fae bundles to the same image:

```dockerfile
COPY bundles/endo-lal.cjs ./bundles/
COPY bundles/endo-fae.cjs ./bundles/

ENV ENDO_LAL_PATH=/opt/endo/bundles/endo-lal.cjs
ENV ENDO_FAE_PATH=/opt/endo/bundles/endo-fae.cjs
```

The §optional-AI-agents-via-env-paths discipline: same image
serves users *with* or *without* AI agents; presence is
controlled by environment variables. The §parity-with-Familiar
benefit: *self-hosted users get the same out-of-the-box AI agent
experience as Familiar users*.

This depends on the (still-unindexed) `familiar-bundled-agents`
design.
