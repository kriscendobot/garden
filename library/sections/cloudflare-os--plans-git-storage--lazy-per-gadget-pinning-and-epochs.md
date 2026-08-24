---
title: Lazy per-gadget pinning and epochs
source: plans/git-storage.md
source_repo: cloudflare/cloudflare-os
source_commit: 1ef6020a42fbabb6d27dd1063db3a075ba95c974
source_date: 2026-08-21
source_authors: [Kenton Varda]
ingested: 2026-08-24
ingested_by: scholar
topics: [persistence, collaborative-workspace-sharing, ai-generated-apps]
status: current
---

Part 2 replaces eager chat-wide code snapshots with lazy, independent pins: an unedited gadget tracks mainline live, and only its first modification establishes a commit base for the current chat epoch.

Reads do not pin. They record the observed commit, and replay elides a prior read if that file changed before the next turn, forcing the agent to reread. Accept always includes all drafts, commits all affected gadgets, clears every pin, discards the chat document, and starts a new generation. Merge and revert bump the generation so stale clients reject and rebuild rather than silently applying edits to a discarded base. Pin declarations are written into the chat log, allowing closed epochs to reconstruct deterministically from immutable commits.

Source: [plans/git-storage.md](https://github.com/cloudflare/cloudflare-os/blob/1ef6020a42fbabb6d27dd1063db3a075ba95c974/plans/git-storage.md) at commit `1ef6020a`.
