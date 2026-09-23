---
source_kind: comment-fragment
source_repo: cloudflare/cloudflare-os
source_path: packages/workshop-frontend/src/ChatInterface.tsx
source_line_range: "138-4362"
source_commit: 1ef6020a42fbabb6d27dd1063db3a075ba95c974
comment_subject: the frontend's chat code-branch model — durable snapshot plus synchronous live row stream, and the streaming edit-preview event protocol
source_authors: [Kenton Varda]
ingested: 2026-08-24
ingested_by: scholar
section_count: 2
status: current
---

`ChatInterface.tsx` is Cloudflare OS's chat UI. This digest concentrates two of its client-side data-flow contracts out of an 8000-line component and skips its rendering: how the code view is derived from a *durable* snapshot (pins, composed epoch change, watermark) paired with a *live* accepted-but-unmaterialized row stream delivered synchronously so no final-of-batch row is missed; and the streaming edit-preview event protocol (start/delta/clear/reset) that shows an agent's `writeFile`/`editFile` content appearing live, with finished previews outliving their streaming until a durable row resolves them. These are the client mirror of the server contracts in `packages/workshop-shared/src/api.ts` (`ChatCodeBase`, `AiChatStreamEvent`).

| Section | Topics | Status |
|---------|--------|--------|
| [Durable and live code-branch state](../sections/cloudflare-os--packages-workshop-frontend-src-chatinterface--durable-and-live-code-branch-state.md) | chat-ui, change-propagation, local-first-sync, collaborative-workspace-sharing | current |
| [Streaming edit-preview stream](../sections/cloudflare-os--packages-workshop-frontend-src-chatinterface--streaming-edit-preview-stream.md) | chat-ui, change-propagation, web-frontend | current |
