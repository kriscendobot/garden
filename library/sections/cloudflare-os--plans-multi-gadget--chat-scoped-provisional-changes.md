---
title: Chat-scoped provisional changes
source: plans/multi-gadget.md
source_repo: cloudflare/cloudflare-os
source_commit: e8132b07f2c4fe79d3c9a75e4e3f0b3c932f8d33
source_date: 2026-07-29
source_authors: [Kenton Varda]
ingested: 2026-08-24
ingested_by: scholar
topics: [agent-workspaces, collaborative-workspace-sharing, ai-generated-apps]
status: current
---

Chats stay workspace-scoped and may create, edit, or connect several gadgets atomically; new gadgets and binding edges remain provisional to the originating chat until the user accepts its changes.

Pending records are real enough to reserve IDs and names and to support previews, but other chats, blueprints, mainline loaders, and use-role sharing ignore them for reads. Change messages stamp pending creations and edges with a sequence, enabling merge to promote them and revert to delete them. Replay re-adopts logged work after a crash, while reconciliation removes unlogged orphans. Removals remain immediate in the first version because provisional deletion would require tombstones.

Source: [plans/multi-gadget.md](https://github.com/cloudflare/cloudflare-os/blob/e8132b07f2c4fe79d3c9a75e4e3f0b3c932f8d33/plans/multi-gadget.md) at commit `e8132b07`.
