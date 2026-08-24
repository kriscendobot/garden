---
source_kind: comment-fragment
source_repo: cloudflare/cloudflare-os
source_path: packages/workshop-shared/src/api.ts
source_line_range: "1663-3280"
source_commit: 1ef6020a42fbabb6d27dd1063db3a075ba95c974
comment_subject: the shared Overseer API contracts for the chat code branch — code-change submission as the sole edit path, chat code base epochs/pins/generations, accept and mainline merge, and the live edit-preview stream
source_authors: [Kenton Varda]
ingested: 2026-08-24
ingested_by: scholar
section_count: 4
status: current
---

`api.ts` is Cloudflare OS's shared RPC surface between frontend, backend, and gatekeepers. This digest partitions its chat-code-branch architecture (skipping the routine endpoint JSDoc) into four contracts: `submitCodeChange` as the only way to edit code, with server-side transform, atomic pin declarations, and OT-safe retry; `ChatCodeBase`, the metadata clients reconstruct chat content from, and its content-preserving vs destructive generation bumps; the accept / update-from-mainline / revert lifecycle (fast-forward-only accept that closes an epoch, 3-way mainline merge); and the `AiChatStreamEvent` live edit-preview wire contract. These are the authoritative shape behind the frontend flows in `ChatInterface.tsx` and the backend fold in `agent-compaction.ts`, and they carry the [[lazy-gadget-pinning]] and [[code-change-operational-transform]] concepts.

| Section | Topics | Status |
|---------|--------|--------|
| [Code-change submission as the sole edit path](../sections/cloudflare-os--packages-workshop-shared-src-api--code-change-submission-sole-edit-path.md) | collaborative-workspace-sharing, change-propagation, local-first-sync, persistence | current |
| [Chat code base — epochs, pins, and generations](../sections/cloudflare-os--packages-workshop-shared-src-api--chat-code-base-epochs-and-pins.md) | collaborative-workspace-sharing, persistence, change-propagation | current |
| [Accept, mainline merge, and revert](../sections/cloudflare-os--packages-workshop-shared-src-api--accept-mainline-merge-and-revert.md) | collaborative-workspace-sharing, change-propagation, persistence | current |
| [Live edit-preview stream contract](../sections/cloudflare-os--packages-workshop-shared-src-api--live-edit-preview-stream-contract.md) | chat-ui, change-propagation, collaborative-workspace-sharing | current |
