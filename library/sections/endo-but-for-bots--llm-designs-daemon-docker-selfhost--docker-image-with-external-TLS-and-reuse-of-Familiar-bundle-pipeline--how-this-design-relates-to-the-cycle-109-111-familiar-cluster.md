---
section: docker-image-with-external-TLS-and-reuse-of-Familiar-bundle-pipeline
source: endo-but-for-bots--llm-designs-daemon-docker-selfhost
topics: [daemon, agent-conventions]
status: current
title: How this design relates to the cycle 109/111 Familiar cluster
parent: endo-but-for-bots--llm-designs-daemon-docker-selfhost--docker-image-with-external-TLS-and-reuse-of-Familiar-bundle-pipeline
---

Cycle 109's `familiar-electron-shell` (the Electron desktop
shell) and cycle 111's `familiar-gateway-migration` (the
gateway moved from Chat-Vite-plugin into the daemon) are the
*Familiar* side of the deployment story. This cycle is the
*server* side:

| Cycle | Side | Audience |
|-------|------|----------|
| 109 | Familiar (Electron) | Desktop user |
| 111 | Gateway-in-daemon | Both |
| 113 | Familiar daemon bundling | Desktop user |
| 114 | Familiar unified weblet server | Desktop user |
| 139 (this) | Docker self-host | Server / VPS user |

The §gateway-in-daemon (cycle 111) was the *prerequisite* for
this design — *the gateway must own this concern* because *if it
remains in Chat, then every application that wants to connect
to the daemon from a browser must either depend on Chat or
reimplement the gateway*. With the gateway in the daemon, this
cycle's Docker image just *runs the daemon and gets the gateway
for free*.
