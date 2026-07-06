---
title: Repository memory cell layout — local branches and remote sites
source: notes/memory-layout.md
source_repo: dialog-db/dialog-db
source_commit: 18c640a06797b62eb3c57f3aeedb016634a5da19
source_date: 2026-07-05
source_authors: [Irakli Gozalishvili]
ingested: 2026-07-06
ingested_by: scholar
topics: [change-propagation, local-first-sync]
status: current
---

> Abstract: Each repository, scoped to a subject DID, keeps its Git-like sync state in named memory cells. **Local branches** use two cells per branch: `branch/{name}/revision` (a `Cell<Revision>`, the local branch head — the latest committed tree plus metadata) and `branch/{name}/upstream` (a `Cell<Option<UpstreamState>>`, what this branch tracks, e.g. `UpstreamState::Remote { name, branch, tree }`). **Remote sites** use `remote/{name}/address` (a `Cell<RemoteAddress>` holding connection info wrapped as `RemoteAddress { address: SiteAddress, subject: Did }`) and `remote/{name}/branch/{branch}/revision` (a `Cell<Revision>`, the last-fetched revision for a remote branch — updated by fetch, not by pull). This mirror-of-Git-refs layout is what lets fetch, pull, and push each touch a precise, addressable slice of state.

## Local Branches

```
branch/{name}/revision          Cell<Revision>
branch/{name}/upstream          Cell<Option<UpstreamState>>
```

- **revision** -- the local branch head (latest committed tree + metadata)
- **upstream** -- what this branch tracks (`UpstreamState::Remote { name, branch, tree }`)

## Remote Sites

```
remote/{name}/address                     Cell<RemoteAddress>
remote/{name}/branch/{branch}/revision    Cell<Revision>
```

- **address** -- connection info wrapped in `RemoteAddress { address: SiteAddress, subject: Did }`
- **branch revision** -- last fetched revision for a remote branch (updated by fetch, not by pull)

Source: [notes/memory-layout.md](https://github.com/dialog-db/dialog-db/blob/18c640a06797b62eb3c57f3aeedb016634a5da19/notes/memory-layout.md) at commit `18c640a0`.
