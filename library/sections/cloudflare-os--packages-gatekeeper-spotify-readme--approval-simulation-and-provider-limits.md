---
title: Spotify approval simulation and provider limits
source: packages/gatekeeper-spotify/README.md
source_repo: cloudflare/cloudflare-os
source_commit: 24331ce64373e752bd3f57f8c542bd17c4a5bbe3
source_date: 2026-06-24
source_authors: [Yo'av Moshe]
ingested: 2026-08-24
ingested_by: scholar
topics: [capability-mediated-integrations, capability-security]
status: current
---

Spotify reads are logged and writes wait for human approval, with optimistic overlays for library and playlist edits but no simulation for playback commands.

Pending playlist and library mutations appear in later reads so a gadget can continue coherent work before approval. Playback is different: commands are gated but `getState()` always reports real device state. Non-owned, non-collaborative playlists may expose metadata while withholding track contents, causing `listTracks()` to return an empty list. Some third-party Spotify Connect endpoints may also be absent or misidentified, so transfers should be confirmed with a follow-up state read.

Source: [packages/gatekeeper-spotify/README.md](https://github.com/cloudflare/cloudflare-os/blob/24331ce64373e752bd3f57f8c542bd17c4a5bbe3/packages/gatekeeper-spotify/README.md) at commit `24331ce6`.
