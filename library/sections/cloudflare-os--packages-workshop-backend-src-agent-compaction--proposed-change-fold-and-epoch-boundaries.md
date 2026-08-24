---
title: Proposed-change fold and epoch boundaries
source: packages/workshop-backend/src/agent-compaction.ts
source_kind: comment-fragment
source_repo: cloudflare/cloudflare-os
source_path: packages/workshop-backend/src/agent-compaction.ts
source_line_range: "88-158, 406-462"
source_commit: 1ef6020a42fbabb6d27dd1063db3a075ba95c974
comment_subject: the single merge/revert fold rule that derives proposed changes, change statuses, and a compaction checkpoint's carried-forward pins and epoch
source_authors: [Kenton Varda]
ingested: 2026-08-24
ingested_by: scholar
topics: [change-propagation, collaborative-workspace-sharing, context-engineering]
status: current
---

Abstract: Context compaction summarizes a chat's older messages into a checkpoint so agent replay can start at a boundary while canonical history keeps every message. The checkpoint must fold the pre-boundary code state so replay need not reload the compacted messages, and it does so with one merge/revert rule reused everywhere. `foldProposedChanges` walks the log oldest-first: a "changes" message pushes a proposed batch (addressed by chat sequence), a `merge` accepts through `mergeThrough` inclusively by shifting the accepted head off the front, and a `revert` discards from `revertFrom` onward off the back — the single rule both the proposed-changes view and a new checkpoint derive from. `chatChangeStatuses` marks each message merged or reverted under the same log-order semantics (earliest marking wins). `buildCompactionState` folds pins and the epoch over the compacted span: an `epochBoundary` merge or a migrated chat's `conversionBoundary` "changes" message clears the pins and resets the epoch, and a surviving batch's declarations accumulate. An empty conversion boundary proposes nothing, so a read-only migrated chat shows no phantom proposed changes.

## The fold

`foldProposedChanges(messages, seed)` returns the batches still proposed, oldest first, where `seed` carries batches proposed before the log begins (as a checkpoint records):

- a `"changes"` message pushes `{sequence, change}` — unless it is an *empty* conversion boundary (`conversionBoundary` set, `change` undefined), which proposes nothing so a read-only migrated chat does not show proposed changes;
- a `"merge"` accepts through `mergeThrough` inclusively, shifting every batch with `sequence <= mergeThrough` off the front;
- a `"revert"` discards from `revertFrom` onward, popping every batch with `sequence >= revertFrom` off the back.

Accepted batches are simply dropped: every accepted batch's content lives in commits from its epoch-closing merge on, so nothing replays it.

## Statuses under the same semantics

`chatChangeStatuses` produces a `sequence -> "merged" | "reverted"` map with semantics that mirror the fold: processing is strictly in log order, so a marking message affects only messages recorded *before* it; a merge marks through `mergeThrough` inclusively; a revert marks from `revertFrom` up to (not including) the revert message itself; and the earliest marking wins. A `"changes"` message left unmarked is still proposed; non-`"changes"` messages in a range are marked too, so replay can elide tool reads whose content was later reverted.

## Pins and epoch in the checkpoint

`buildCompactionState` folds the state before the boundary into a new checkpoint. Pins active at the boundary and the epoch they lie in are seeded from the previous checkpoint and folded over the compacted span: an `epochBoundary` merge or a migrated chat's `conversionBoundary` "changes" message clears the pins and resets the epoch, and a surviving "changes" message's pin declarations accumulate. Statuses are computed over the compacted span alone, which is sound because `rollbackChatCompaction` guarantees no revert in the retained tail reaches below the boundary.

Proposed changes stay addressable by sequence until a merge accepts them or a revert drops them; the checkpoint carries their composition (`proposedChange`) so replay needn't load the compacted messages. Composition is bounded by content size, not edit count, so it cannot grow with history the way merged CRDT updates could.

Source: [packages/workshop-backend/src/agent-compaction.ts](https://github.com/cloudflare/cloudflare-os/blob/1ef6020a42fbabb6d27dd1063db3a075ba95c974/packages/workshop-backend/src/agent-compaction.ts) at commit `1ef6020a`.
