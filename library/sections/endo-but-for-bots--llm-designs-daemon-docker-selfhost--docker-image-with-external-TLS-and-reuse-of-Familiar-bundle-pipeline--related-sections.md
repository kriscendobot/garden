---
section: docker-image-with-external-TLS-and-reuse-of-Familiar-bundle-pipeline
source: endo-but-for-bots--llm-designs-daemon-docker-selfhost
topics: [daemon, agent-conventions]
status: current
title: Related sections
parent: endo-but-for-bots--llm-designs-daemon-docker-selfhost--docker-image-with-external-TLS-and-reuse-of-Familiar-bundle-pipeline
---

- cycle 109
  [[endo-but-for-bots--llm-designs-familiar-electron-shell--electron-shell-with-daemon-outlives-app-and-localhttp-protocol]]
  — the Familiar shell whose §daemon-outlives-the-Familiar
  discipline produces the *daemon as long-lived service*
  shape this design relies on for the server case.
- cycle 111
  [[endo-but-for-bots--llm-designs-familiar-gateway-migration--gateway-moved-from-chat-vite-plugin-into-daemon]]
  — the *gateway-in-daemon* migration that's a prerequisite for
  this design (daemon now owns the HTTP/WebSocket endpoint).
- cycle 113
  [[endo-but-for-bots--llm-designs-familiar-daemon-bundling--esbuild-single-file-bundle-with-side-effect-mitigations]]
  — the *Familiar bundle pipeline* this design §reuses; same
  CJS bundles ship in both Electron and Docker.
- cycle 60 (§d256-per-agent-keypairs)
  [[endo-but-for-bots--llm-designs-d256--per-agent-keypairs]]
  — the 256-bit identifier substrate whose `keys/` subdirectory
  this design's §state-directory layout includes.
