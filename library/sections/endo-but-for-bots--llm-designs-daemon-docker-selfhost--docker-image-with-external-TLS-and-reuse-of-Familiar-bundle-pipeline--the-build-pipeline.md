---
section: docker-image-with-external-TLS-and-reuse-of-Familiar-bundle-pipeline
source: endo-but-for-bots--llm-designs-daemon-docker-selfhost
topics: [daemon, agent-conventions]
status: current
title: §The build pipeline
parent: endo-but-for-bots--llm-designs-daemon-docker-selfhost--docker-image-with-external-TLS-and-reuse-of-Familiar-bundle-pipeline
---

The §Build pipeline section names the §reuse-Familiar-bundle-
script discipline:

```bash
cd packages/familiar && yarn bundle
mkdir -p docker/bundles
cp bundles/*.cjs docker/bundles/
cp -r ../chat/dist docker/bundles/endo-chat
docker build -t endojs/daemon:latest docker/
```

The §three-step shape: run Familiar's bundler → copy bundles
into Docker build context → docker build. *No separate build
system*. The §no-separate-build-system discipline:

> *The Docker image reuses the Familiar's bundle pipeline. No
> separate build system. This ensures parity between the desktop
> and server deployments.*

The §single-source-of-truth-for-bundles. If the Familiar's
bundles work, the Docker image's bundles work. Bug fixes
propagate automatically.
