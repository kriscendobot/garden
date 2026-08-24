---
title: Spotify OAuth and development-mode requirements
source: packages/gatekeeper-spotify/README.md
source_repo: cloudflare/cloudflare-os
source_commit: 24331ce64373e752bd3f57f8c542bd17c4a5bbe3
source_date: 2026-06-24
source_authors: [Yo'av Moshe]
ingested: 2026-08-24
ingested_by: scholar
topics: [oauth-credentials, cloudflare-workers-agent-hosting]
status: current
---

Spotify development apps require an exact loopback-IP OAuth redirect, explicit user enrollment, and Premium accounts for playback writes, making local origin choice and provider-side enrollment part of the connector's effective configuration.

The app redirect is `http://127.0.0.1:8787/gatekeeper/spotify/oauth` for the default local setup. New Spotify apps reject `localhost`, so `BASE_URL`, the registered redirect, and the Workshop origin must all use `127.0.0.1`; production uses the deployment host over HTTPS. `CLIENT_ID` and `CLIENT_SECRET` live in the package's ignored `.env` file.

A new app remains in development mode until the intended Spotify account is added under User Management. Authorization otherwise fails even with valid credentials. Playback commands additionally require Spotify Premium and return 403 for free accounts.

Source: [packages/gatekeeper-spotify/README.md](https://github.com/cloudflare/cloudflare-os/blob/24331ce64373e752bd3f57f8c542bd17c4a5bbe3/packages/gatekeeper-spotify/README.md) at commit `24331ce6`.
