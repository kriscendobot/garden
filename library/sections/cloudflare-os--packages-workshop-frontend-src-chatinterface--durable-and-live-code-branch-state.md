---
title: Durable and live code-branch state
source: packages/workshop-frontend/src/ChatInterface.tsx
source_kind: comment-fragment
source_repo: cloudflare/cloudflare-os
source_path: packages/workshop-frontend/src/ChatInterface.tsx
source_line_range: "138-234, 4296-4362"
source_commit: 1ef6020a42fbabb6d27dd1063db3a075ba95c974
comment_subject: how the frontend derives a chat's code content from a durable snapshot (pins, epoch change, watermark) plus a synchronously-delivered live row stream
source_authors: [Kenton Varda]
ingested: 2026-08-24
ingested_by: scholar
topics: [chat-ui, change-propagation, local-first-sync, collaborative-workspace-sharing]
status: current
---

Abstract: The Cloudflare OS frontend builds a selected chat's code view from two paired pieces: a *durable* snapshot and a *live* row stream. `ChatCodeChanges` is the durable snapshot as one consistent object — the chat's current `ChatCodeBase` (pins, generation, epoch) together with the current epoch's non-reverted "changes" messages composed into one `epochChange`, plus `rowsThrough`, the current generation's revision the composed changes' watermarks reach. The two are always derived together, because pairing a stale epoch's changes with a fresh epoch's pins would transiently build nonsense. `ChatLiveChangeRows` is the live stream of accepted-but-not-yet-materialized change rows, delivered synchronously from the subscription callback *before* the materialization watermark that absorbs it can prune the buffer — an ordering that is load-bearing because the server broadcasts a row and the "changes" message that materializes it in the same step, so an asynchronously-fed consumer would routinely miss the final row of each batch. Rows below the watermark are already inside `epochChange`; only later rows still apply on top. `computeChatEpochChanges` is the function that composes the durable part, keying the epoch cutoff on the metadata's epoch so it stays consistent with the pin set the code view reads from the same metadata.

## The durable snapshot

`ChatCodeChanges` describes the chat's durable code-branch state as one consistent snapshot: the chat's current `ChatCodeBase` (pins, generation, epoch — `codeBase` absent when the chat has none yet, which reads as `{pins: [], generation: 0, revision: 0}`) together with the current epoch's non-reverted "changes" messages composed into one change (`epochChange`). The two are always derived together — the code view builds content as pin base trees + `epochChange` + live rows, and pairing a stale epoch's changes with a fresh epoch's pins (or vice versa) would transiently build nonsense.

`rowsThrough` is the current generation's revision the composed changes' watermarks reach: rows at or below it are already inside `epochChange`, and only later rows still apply on top. The snapshot is `undefined` while no chat is selected or its metadata/history hasn't loaded; `epochChange` is absent when the chat recorded no code changes this epoch. Because parent-owned state updates lag a chat switch by a render, a consumer must ignore a snapshot whose `chatId` doesn't match its selection.

## The live row stream

`ChatLiveChangeRows` is the selected chat's live (accepted but not yet materialized) change-row stream, delivered via `AiChatSubscriber.changeApplied()` and buffered per chat. `subscribe` replays the currently retained rows and then delivers each new row as it arrives — *synchronously from the subscription callback, before the materialization watermark that absorbs it can prune the buffer.*

That ordering is load-bearing: the server broadcasts a row and the "changes" message that materializes it in the same step (e.g. at the live-window size cap), so a consumer fed asynchronously would routinely miss the final row of each materialized batch. Rows a consumer subscribes too late to see are covered by the durable snapshot's watermark instead (`ChatCodeChanges.rowsThrough`). Replay can redeliver rows a consumer has already seen; consumers dedupe by stream position (the OT client does).

## Composing the durable part

`computeChatEpochChanges` composes the durable part: the current epoch's non-reverted "changes" messages folded into one change, plus the generation revision their watermarks reach. Only messages at or after the code base's `epoch` participate ("at" matters for a migrated chat, whose epoch points at its own `conversionBoundary` "changes" message), because accepting changes resets the code base and earlier epochs' changes are composed over pins that no longer exist. Keying the cutoff on the metadata's epoch rather than on loaded merge messages keeps this consistent with the pin set the code view reads from the same metadata.

The oldest loaded compaction boundary stands in for the pages before it — its `proposedChange` blob, unless a loaded revert reached across the boundary — and drops out once those pages load. The blob folds in at sequence `to - 1`, so an epoch past that excludes it like any other pre-epoch content. Revisions restart per generation, so only the current generation's watermarks position the live-row cursor (an older generation's rows were retired by its closing bump).

Source: [packages/workshop-frontend/src/ChatInterface.tsx](https://github.com/cloudflare/cloudflare-os/blob/1ef6020a42fbabb6d27dd1063db3a075ba95c974/packages/workshop-frontend/src/ChatInterface.tsx) at commit `1ef6020a`.
