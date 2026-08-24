---
title: Streaming edit-preview stream
source: packages/workshop-frontend/src/ChatInterface.tsx
source_kind: comment-fragment
source_repo: cloudflare/cloudflare-os
source_path: packages/workshop-frontend/src/ChatInterface.tsx
source_line_range: "149-214"
source_commit: 1ef6020a42fbabb6d27dd1063db3a075ba95c974
comment_subject: the frontend edit-preview event stream — start/delta/clear/reset, why finished previews outlive their streaming, and how each resolves against a durable row
source_authors: [Kenton Varda]
ingested: 2026-08-24
ingested_by: scholar
topics: [chat-ui, change-propagation, web-frontend]
status: current
---

Abstract: While an agent generates `writeFile`/`editFile` content, the Cloudflare OS frontend shows the edit appearing live through an edit-preview event stream fed synchronously from the chat subscription's stream events. An `EditPreviewEvent` is one of four kinds: `start` opens a preview of a named call (ending the previous call's delta stream, though that previous preview stays displayed until its durable row or `clear` resolves it); `delta` appends streamed text to the named call's preview; `clear` withdraws a preview whose call will produce no row (it may name any call of the response, not just the streaming one); and `reset` is the mop-up that drops all preview state when the turn ends or the stream is lost. Because tool calls execute only after the whole model response streams, several previews can finish streaming before any of them has a durable row, so a finished preview must keep displaying its final text until it resolves — which happens when the durable change row arrives (the ordinary end) or a `clear` withdraws it. `ChatLiveEditPreviews.subscribe` replays only the *currently streaming* preview (a start plus one delta), since already-finished previews are picked up from durable rows by a late joiner.

## The event kinds

`EditPreviewEvent` carries one event of the selected chat's edit-preview stream — the `writeFile`/`editFile` content the agent is still generating (mirroring `AiChatStreamEvent`'s `editPreviewStart` model on the wire):

- `start` opens a preview of the named call. It ends the previous call's delta stream, though *that* preview stays displayed until its own durable row or `clear` resolves it. It carries `toolCallId`, `workpieceId`, `filename`, and `textToReplace` (editFile's replaced text; absent for writeFile, whose streamed text replaces the whole file).
- `delta` appends streamed text to the named call's preview.
- `clear` withdraws a preview whose call will produce no row. It may name *any* call of the response, not just the streaming one.
- `reset` is the mop-up that drops all preview state (turn ended, stream lost).

The consumer additionally resolves each preview when its durable change row arrives (see the durable-and-live code-branch state section / `GadgetCodeInterface`), which is the ordinary end of a successful one.

## Why finished previews outlive their streaming

At most one preview is *streaming* at a time — a new `start` ends the previous call's delta stream — but a preview outlives its streaming. Tool calls execute only after the whole model response has streamed, so several previews can finish before any of their durable rows exists. The consumer must keep displaying each finished preview's final text — a call's edits would otherwise vanish until its row lands — until the preview resolves in one of two ways: the completed call's change row arrives via `AiChatSubscriber.changeApplied()` carrying the same final content (the ordinary end), or a `clear` withdraws it because no row will come. As with all provisional state, whatever remains is discarded when the agent stops running.

## Replay for mid-stream joiners

`ChatLiveEditPreviews.subscribe` replays the currently *streaming* preview (as a start plus one delta) so a consumer attaching mid-stream still shows it. Previews that already finished streaming are not replayable — a late joiner picks their content up from the durable rows instead. The retained `StreamingEditPreview` (toolCallId, workpieceId, filename, textToReplace, accumulated text) exists for subscribe-time replay only.

Source: [packages/workshop-frontend/src/ChatInterface.tsx](https://github.com/cloudflare/cloudflare-os/blob/1ef6020a42fbabb6d27dd1063db3a075ba95c974/packages/workshop-frontend/src/ChatInterface.tsx) at commit `1ef6020a`.
