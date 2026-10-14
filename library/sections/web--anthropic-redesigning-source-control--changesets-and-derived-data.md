---
title: Changesets and recursively derived repository data
source_kind: web
source_url: https://www.anthropic.com/engineering/redesigning-source-control
source_content_sha256: b3d054963c3f39d437e21031240970f89ddca379738402fa31c6e6c9f3562a44
source_authors: [Nick G., S.G., R.K., Dan C., Garrett H., Ben L., Colin M., Joe P.]
source_date: 2026-10-13
ingested: 2026-10-14
ingested_by: scholar
topics: [source-control-architecture, data-structures, content-addressed-storage]
status: current
---

Abstract: Scion's primary record is an append-only changeset containing first-parent-relative changed paths and content-addressed compressed blobs; blame, path history, commit-graph skip lists, copy detection, and search indexes are separate recursively computed derived data that may be eager or lazy.

A Scion changeset resembles a Git commit but records the files changed relative to its first parent instead of pointing to a complete tree. File contents are compressed in blob storage and referenced by content address. The server creates changesets, which become globally available without accepting packfiles, coordinating locks, or moving refs. A supported ref update is a separate compare-and-swap on one Spanner row.

The compact primary record cannot directly answer history-intensive questions. Scion therefore builds dedicated structures for blame and path history, skip lists for commit-graph traversal, and additional indexes for copy detection and path search. Each derived-data type is defined recursively from the corresponding values of a changeset's parents.

This split lets operators add new indexes independently, choose eager or deferred computation for each type, and revise server internals without changing clients. It also makes the immutable changeset log the authority while query-specific projections remain replaceable accelerators.

Source: [Redesigning source control at Anthropic](https://www.anthropic.com/engineering/redesigning-source-control#data-structures), retrieved 2026-10-14; content SHA-256 `b3d05496`.
