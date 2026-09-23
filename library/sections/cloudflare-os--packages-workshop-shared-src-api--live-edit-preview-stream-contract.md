---
title: Live edit-preview stream contract
source: packages/workshop-shared/src/api.ts
source_kind: comment-fragment
source_repo: cloudflare/cloudflare-os
source_path: packages/workshop-shared/src/api.ts
source_line_range: "3183-3280"
source_commit: 1ef6020a42fbabb6d27dd1063db3a075ba95c974
comment_subject: the AiChatStreamEvent wire contract for live edit previews — editPreviewStart carries no base content, at most one streams at a time, and each resolves against a durable change row
source_authors: [Kenton Varda]
ingested: 2026-08-24
ingested_by: scholar
topics: [chat-ui, change-propagation, collaborative-workspace-sharing]
status: current
---

Abstract: `AiChatStreamEvent` is the shared wire type for a Cloudflare OS agent turn's live events, and the `editPreview*` variants are the producer contract behind the frontend's live edit preview. `editPreviewStart` opens a live preview of a `writeFile`/`editFile` call whose content the model is still generating — the streamed value (delivered by `editPreviewDelta`) progressively replaces a span of the target file so the user watches the edit appear. The event carries *no base content*: the client locates the span in its own copy of the file — the chat's content, or the committed head for a gadget the chat doesn't cover — which mirrors the content the agent computes its edit against (both are the same change stream). The preview is display-only provisional state, never entering the client's own change tracking. At most one preview streams at a time (a new `editPreviewStart` ends the previous call's delta stream), but a preview outlives its streaming because tool calls execute only after the whole response streams; the client keeps displaying each finished preview's final text until it resolves — the completed call's change row arrives via `changeApplied()` carrying the same final content (the ordinary end), or an `editPreviewClear` withdraws it. Other stream events (`compacting`/`compacted`, `textDelta`, `reasoningDelta`, `toolCallStarted`/`toolCallFinished`, `toolCodeDelta`, `setActiveFile`, `toolCallTarget`) carry the rest of the turn's lifecycle.

## editPreviewStart carries no base content

`editPreviewStart` opens a live preview of a `writeFile`/`editFile` call whose content the model is still generating: the streamed value (delivered by `editPreviewDelta` events) progressively replaces a span of the target file, so the user watches the edit appear as it is written. It is emitted once the call's input has streamed far enough to identify the target — which happens when the content/replacement field begins, since it is the input's final field.

The event carries no base content: the client locates the span in its own copy of the file (the chat's content, or the committed head for a gadget the chat doesn't cover), which mirrors the content the agent computes its edit against — both are the same change stream. The preview is display-only provisional state, never entering the client's own change tracking. For `editFile` the event carries `textToReplace`, the exact text being replaced, which the client finds a unique match for in the file (skipping the preview if there isn't exactly one — the call itself will then fail); absent for `writeFile`, whose streamed content replaces the whole file.

## One streams; several finished previews persist

At most one preview is *streaming* at a time (a new `editPreviewStart` ends the previous call's delta stream), but a preview outlives its streaming: tool calls execute only after the whole model response has streamed, so several previews can finish before any of their durable rows exists. The client must keep displaying each finished preview's final text — a call's edits would otherwise vanish until its row lands — until it resolves in one of two ways: the completed call's change row arrives via `AiChatSubscriber.changeApplied()` carrying the same final content (the ordinary end), or an `editPreviewClear` withdraws it because no row will come. Since rows arrive in call order, per-file previews resolve oldest-first. As with all provisional state, the client discards whatever remains when the agent stops running.

## The rest of the turn's stream events

`AiChatStreamEvent` also covers: `compacting`/`compacted` (context summarization, the latter carrying `nothingToCompact`); `textDelta` and `reasoningDelta`; `toolCallStarted`/`toolCallFinished` (a provisional UI lifecycle event); `toolCodeDelta` (the `executeCode` tool streams its code, where `writeFile`/`editFile` use `editPreview*` and other tools' inputs are not streamed); and `setActiveFile`/`toolCallTarget` (the file an edit call is streaming into, before the finalized tool call arrives).

Source: [packages/workshop-shared/src/api.ts](https://github.com/cloudflare/cloudflare-os/blob/1ef6020a42fbabb6d27dd1063db3a075ba95c974/packages/workshop-shared/src/api.ts) at commit `1ef6020a`.
