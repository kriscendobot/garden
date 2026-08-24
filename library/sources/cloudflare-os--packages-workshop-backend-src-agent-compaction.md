---
source_kind: comment-fragment
source_repo: cloudflare/cloudflare-os
source_path: packages/workshop-backend/src/agent-compaction.ts
source_line_range: "1-462"
source_commit: 1ef6020a42fbabb6d27dd1063db3a075ba95c974
comment_subject: context compaction, the legacy code-log migration anchor, and the merge/revert fold that derives proposed changes and checkpoint state
source_authors: [Kenton Varda]
ingested: 2026-08-24
ingested_by: scholar
section_count: 2
status: current
---

`agent-compaction.ts` keeps a long chat within the model's context window by summarizing pre-boundary messages into a checkpoint while canonical history retains every message. This digest concentrates two of its load-bearing arguments and leaves the summarization plumbing (token budgeting, boundary selection, prompt building) as ordinary code: the git-storage migration's legacy code-log base-version anchor (why the *maximum* referenced version, not the first), and the single merge/revert fold that derives proposed changes, change statuses, and a checkpoint's carried-forward pins and epoch. Cross-references the chat-branch state modeled in `packages/workshop-shared/src/api.ts` and mirrored on the frontend in `ChatInterface.tsx`.

| Section | Topics | Status |
|---------|--------|--------|
| [Legacy code-log base-version anchor](../sections/cloudflare-os--packages-workshop-backend-src-agent-compaction--legacy-chat-base-version-anchor.md) | persistence, content-addressed-storage, collaborative-workspace-sharing | current |
| [Proposed-change fold and epoch boundaries](../sections/cloudflare-os--packages-workshop-backend-src-agent-compaction--proposed-change-fold-and-epoch-boundaries.md) | change-propagation, collaborative-workspace-sharing, context-engineering | current |
