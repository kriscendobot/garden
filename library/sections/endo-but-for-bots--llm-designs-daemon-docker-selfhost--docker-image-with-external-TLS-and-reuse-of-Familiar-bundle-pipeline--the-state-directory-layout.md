---
section: docker-image-with-external-TLS-and-reuse-of-Familiar-bundle-pipeline
source: endo-but-for-bots--llm-designs-daemon-docker-selfhost
topics: [daemon, agent-conventions]
status: current
title: The §state-directory layout
parent: endo-but-for-bots--llm-designs-daemon-docker-selfhost--docker-image-with-external-TLS-and-reuse-of-Familiar-bundle-pipeline
---

The §State persistence section names the three subdirectories:

- **`state/`** — formula store (formula graphs, pet names,
  message logs)
- **`keys/`** — agent keypairs (256-bit identifiers; cycle 60's
  daemon-256-bit-identifiers)
- **`worker/`** — worker process logs

The §single-volume-three-subdirectories discipline lets one
mount handle the persistence. Users can `docker exec` into the
container to inspect; or use `docker cp` to backup; or bind-
mount the host directory for direct access.
