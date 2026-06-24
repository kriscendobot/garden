---
section: docker-image-with-external-TLS-and-reuse-of-Familiar-bundle-pipeline
source: endo-but-for-bots--llm-designs-daemon-docker-selfhost
topics: [daemon, agent-conventions]
status: current
title: The §four-requirements frame
parent: endo-but-for-bots--llm-designs-daemon-docker-selfhost--docker-image-with-external-TLS-and-reuse-of-Familiar-bundle-pipeline
---

The §What is the Problem Being Solved section names four
requirements for self-hosting:

1. **A container image** bundling daemon + worker + CLI with
   appropriate defaults for headless operation.
2. **State persistence** — the daemon's state directory must
   survive container restarts.
3. **Network exposure** — the gateway's HTTP/WebSocket endpoint
   must be reachable from outside the container, with TLS
   termination handled either by the daemon or a reverse proxy.
4. **Remote authentication** — the gateway currently rejects
   non-localhost connections; a self-hosted daemon must accept
   authenticated remote connections (gated through
   `gateway-bearer-token-auth`).

The four-axis decomposition. Each axis gets its own subsection
in the §Design section.
