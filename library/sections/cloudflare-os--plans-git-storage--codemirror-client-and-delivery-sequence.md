---
title: CodeMirror client and delivery sequence
source: plans/git-storage.md
source_repo: cloudflare/cloudflare-os
source_commit: 1ef6020a42fbabb6d27dd1063db3a075ba95c974
source_date: 2026-08-21
source_authors: [Kenton Varda]
ingested: 2026-08-24
ingested_by: scholar
topics: [collaborative-workspace-sharing, testing, repository-governance]
status: current
---

The frontend migration replaces Monaco and Yjs with one OT client per chat and CodeMirror 6 views, preserving local editing, remote change application, diff presentation, and generation-aware event ordering.

The implementation sequence isolates the shared OT core and documented API first, then lands backend revision handling, legacy conversion, and finally the frontend editor and diff renderer. The plan explicitly relaxes intermediate green requirements while kernel interfaces are in motion, but restores backend tests before frontend work and requires the full build, test, and lint gate at completion. Watch-fors include UTF-16 boundaries, lone surrogates, empty-versus-missing files, reconnect-window continuity, delayed generation events, and two editor views sharing one client.

Source: [plans/git-storage.md](https://github.com/cloudflare/cloudflare-os/blob/1ef6020a42fbabb6d27dd1063db3a075ba95c974/plans/git-storage.md) at commit `1ef6020a`.
