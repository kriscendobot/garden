---
title: Workshop build-time authentication modes
source: packages/workshop-frontend/README.md
source_repo: cloudflare/cloudflare-os
source_commit: 046bcd7b76404934e2e87bb490b5a6ffb8fc226d
source_date: 2026-08-17
source_authors: [Brayden Wilmoth, Kenton Varda, Maximo Guk]
ingested: 2026-08-24
ingested_by: scholar
topics: [authentication-gatekeepers, cloudflare-workers-agent-hosting]
status: current
---

The Workshop frontend selects either local password authentication or Cloudflare Access identity at build time, removing password and signup surfaces when an upstream Access session owns authentication.

Password mode is the default and exposes login and `/signup`. Setting `VITE_CF_ACCESS_MODE=true` builds Access mode, in which those pages are disabled and the app calls `authenticateFromCfAccess()` on load after Cloudflare Access has already established identity. The backend must independently receive `CF_ACCESS_ISS` and `CF_ACCESS_AUD` so it can verify the Access JWT.

Source: [packages/workshop-frontend/README.md](https://github.com/cloudflare/cloudflare-os/blob/046bcd7b76404934e2e87bb490b5a6ffb8fc226d/packages/workshop-frontend/README.md) at commit `046bcd7b`.
