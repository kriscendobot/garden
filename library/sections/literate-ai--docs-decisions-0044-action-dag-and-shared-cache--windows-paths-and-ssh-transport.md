---
title: "ADR 0044: Windows long-path CAS and SSH action transport"
source: docs/decisions/0044-action-dag-and-shared-cache.md
source_repo: jordanhubbard/literate-ai
source_commit: 2820f8535116c5bc0056232d7251e178f02016d1
source_date: 2026-10-01
source_authors: [Jordan Hubbard]
ingested: 2026-10-11
ingested_by: scholar
topics: [agentic-sdlc, capability-security]
status: current
---

> Abstract: Windows CAS and source-cache I/O use extended-length paths without changing identities; SSH action workers receive requests on stdin with no forwarded credentials.

Windows CAS hardlink publication must support admitted destinations beyond MAX_PATH without relying on registry long-path policy, using extended-length drive or UNC paths consistently for publication, reads, metadata checks, and enumeration while keeping the configured root and content identities unchanged; publication stays atomic create-if-absent with no mutable-copy fallback (per [CreateHardLinkW](https://learn.microsoft.com/en-us/windows/win32/api/winbase/nf-winbase-createhardlinkw)). The same discipline covers source-cache metadata, memberships, bounded reads, and archive capture, whose members stay relative POSIX paths.

SSH action workers opt in with the action protocol and a private `action_command` argv naming a worker-owned receiver with its own CAS, workspace, and credentials. Requests and challenges travel on SSH stdin, never shell arguments; no credential environment is forwarded; POSIX quoting and encoded PowerShell preserve literal arguments; and both transports keep identical bounded-output, deadline, code-identity, and custody checks. Legacy SSH workers without the vector stay ineligible. On Windows controllers, environment lookup preserves case-insensitive names so `SYSTEMROOT` and `COMSPEC` reach children as runtime bindings, without forwarding additional ambient credentials.

Source: [docs/decisions/0044-action-dag-and-shared-cache.md](https://github.com/jordanhubbard/literate-ai/blob/2820f8535116c5bc0056232d7251e178f02016d1/docs/decisions/0044-action-dag-and-shared-cache.md) at commit 2820f853.
