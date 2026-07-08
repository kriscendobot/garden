---
role: builder
---

Build the Docker self-hosting image for the Endo daemon per the `daemon-docker-selfhost` design (M3 exit-criterion pillar: "self-host a daemon with our Docker image and remote control it") in endojs/endo-but-for-bots on base `llm`: deliver the Dockerfile bundling the daemon/worker/CLI bundles, the `docker-entrypoint.sh` (state init + foreground daemon), the `/data/endo` state volume, `0.0.0.0:8920` gateway exposure, and the `ENDO_GATEWAY_REMOTE=true` remote-auth wiring against the already-complete `gateway-bearer-token-auth`. Run the builder pre-flight duplicate check first and skip-and-surface if an equivalent PR already exists.

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 6
  claimed_at: 2026-07-08T05:46:06Z
