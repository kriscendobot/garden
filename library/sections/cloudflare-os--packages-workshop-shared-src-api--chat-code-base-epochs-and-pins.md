---
title: Chat code base — epochs, pins, and generations
source: packages/workshop-shared/src/api.ts
source_kind: comment-fragment
source_repo: cloudflare/cloudflare-os
source_path: packages/workshop-shared/src/api.ts
source_line_range: "2250-2360"
source_commit: 1ef6020a42fbabb6d27dd1063db3a075ba95c974
comment_subject: ChatCodeBase — how a client derives chat content from pins plus epoch changes, and the content-preserving vs destructive generation bumps
source_authors: [Kenton Varda]
ingested: 2026-08-24
ingested_by: scholar
topics: [collaborative-workspace-sharing, persistence, change-propagation]
status: current
---

Abstract: `ChatCodeBase` is the metadata a Cloudflare OS client needs to reconstruct a chat's uncommitted code content: a per-gadget pin set, a `generation` identifying the current change stream, an `epoch` sequence, and a `revision`. Clients derive content themselves — for each pin, fetch the base tree via `getCodeAtCommit(baseCommit)`, apply the current epoch's non-reverted "changes" messages in log order, then apply the not-yet-materialized changes delivered in revision order via `changeApplied()`. Accepting changes ends the epoch: the pin set resets to empty and the change stream restarts at revision 0 under a new generation. The generation bump comes in two classes with opposite handling. A *content-preserving* bump (a merge's epoch reset) changes the stream identity but carries content over — `prior` describes the closed stream so in-flight submissions transform onto the new generation and lose nothing. A *destructive* bump (a revert, draft discard, or turn abort erased already-applied changes) means content other clients transformed against is gone, so they must discard local state and rebuild. Pin additions and update-from-mainline do not bump — they only append changes.

## Deriving content

Clients derive the chat's content themselves: for each pin, fetch the base tree (`Overseer.getCodeAtCommit(baseCommit)`); apply the current epoch's non-reverted "changes" messages' changes in log order; then apply the changes not yet materialized into a message, delivered in revision order via `AiChatSubscriber.changeApplied()`. Accepting changes ends the epoch: the pin set resets to empty and the change stream restarts.

`ChatCodeBase.pins` holds one `ChatGadgetPinState` per permanent gadget whose code has been modified in the current epoch. `epoch` is the sequence number of the message that opened the current epoch — an `epochBoundary` merge message, or a migrated chat's `conversionBoundary` "changes" message — absent when the epoch runs from the start of the chat; only "changes" messages after this point contribute to current content. `revision` is the most recently accepted change of the current generation's stream (numbered from 1; 0 means none yet), a snapshot as of the metadata delivery — clients track the live position via `changeApplied()`.

## Lazy pins

A pin records that a gadget's code was modified for the first time in the chat's current epoch, fixing the commit its uncommitted changes apply on top of. A pin is established by that first modification — a `submitCodeChange` pin declaration, or the agent's first write, which pins at the then-current head — and lasts until the epoch ends or the declaring message is reverted.

## The two generation-bump classes

`generation` identifies the chat's current change stream; `submitCodeChange` validates against it, and it is bumped by every operation that invalidates the stream clients are rooted in:

- **Content-preserving** (a merge's epoch reset): the stream identity changes but the content carries over. `prior` describes the closed stream, and in-flight submissions are transformed onto the new generation. A client still processing `prior.generation` first applies its remaining `changeApplied()` deliveries — that stream is complete once seen through `prior.finalRevision` — then switches. Content is identical across the boundary for every gadget except those in `prior.discontinuousGadgets` (pinned but with no net change to commit while mainline moved past the pin), which must be rebuilt from head.
- **Destructive** (a revert, draft discard, or agent turn abort erased already-applied changes): content other clients may have transformed against is gone, so they must discard local state and rebuild. `prior` is absent, its closed stream being unusable anyway.

Pin additions and `updateChatFromMainline` do *not* bump — they only append changes.

Source: [packages/workshop-shared/src/api.ts](https://github.com/cloudflare/cloudflare-os/blob/1ef6020a42fbabb6d27dd1063db3a075ba95c974/packages/workshop-shared/src/api.ts) at commit `1ef6020a`.
