---
title: Spotify account and playlist resource granularities
source: packages/gatekeeper-spotify/README.md
source_repo: cloudflare/cloudflare-os
source_commit: 24331ce64373e752bd3f57f8c542bd17c4a5bbe3
source_date: 2026-06-24
source_authors: [Yo'av Moshe]
ingested: 2026-08-24
ingested_by: scholar
topics: [capability-mediated-integrations, cloudflare-workers-agent-hosting]
status: current
---

The Spotify Gatekeeper exposes either a whole Spotify account or one playlist as a resource capability, while deliberately excluding Spotify from the Workshop's authentication-provider set.

An account grant covers profile access, catalog search, saved tracks and albums, top and recently played items, follows, playlists, and playback control through `getPlayer()`. A playlist grant narrows authority to reading, editing, following, or unfollowing one playlist. The connector sets `providesAuth: false`, so connecting Spotify never creates a "Continue with Spotify" sign-in path.

The implementation targets Spotify's post-February-2026 development-mode API. Library writes use `/me/library`, playlist contents use `/playlists/{id}/items`, and removed fields such as track popularity are represented as `null`.

Source: [packages/gatekeeper-spotify/README.md](https://github.com/cloudflare/cloudflare-os/blob/24331ce64373e752bd3f57f8c542bd17c4a5bbe3/packages/gatekeeper-spotify/README.md) at commit `24331ce6`.
