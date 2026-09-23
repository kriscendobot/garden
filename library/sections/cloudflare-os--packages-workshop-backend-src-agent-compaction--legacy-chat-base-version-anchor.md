---
title: Legacy code-log base-version anchor
source: packages/workshop-backend/src/agent-compaction.ts
source_kind: comment-fragment
source_repo: cloudflare/cloudflare-os
source_path: packages/workshop-backend/src/agent-compaction.ts
source_line_range: "160-198"
source_commit: 1ef6020a42fbabb6d27dd1063db3a075ba95c974
comment_subject: why the git-storage migration anchors a legacy chat's Yjs doc base at the maximum referenced code-log version, not the first
source_authors: [Kenton Varda]
ingested: 2026-08-24
ingested_by: scholar
topics: [persistence, content-addressed-storage, collaborative-workspace-sharing]
status: current
---

Abstract: When Cloudflare OS migrated its gadget storage from a Yjs-CRDT code log to Git commits, each legacy chat's Yjs document base had to be anchored to a single code-log version. `legacyChatBaseVersion` takes the *maximum* over every version the chat's history references — the compaction checkpoint's stamp, `observedCodeVersion` on tool calls and "changes" messages, and legacy merge messages' `version` — because a Yjs update applies cleanly to any doc state that *includes* the state it was built against, so the max is the smallest base that can represent them all. Anchoring lower silently loses content: a user draft materialized while mainline was ahead of the agent's version-lock latch references Yjs items a lower-anchored doc lacks, which Yjs parks as pending structs and the edits vanish from the flattened files. This is migration-internal; nothing else reads the read-only legacy log.

## The rule

The code-log version a legacy (pre-git-storage) chat's Yjs doc base is anchored to is the maximum over every version the chat's history references:

- the active compaction checkpoint's stamp (`checkpoint.observedCodeVersion`);
- `observedCodeVersion` on the chat's tool calls and on its "changes" messages;
- legacy merge messages' `version`.

A chat that references no version reads the legacy log's tip (`"current"`), which is stable now that the log is read-only.

## Why the maximum, not the first stamp

The first stamp is the agent's own version-lock latch, and anchoring there is wrong. A Yjs update applies cleanly to any doc state that includes the state it was built against, and every update in the log was built against the doc at *some* referenced version, so the maximum is the smallest base that can represent all of them.

Anchoring lower silently loses content. A user draft materialized while mainline was ahead of the agent's latch carries a stamp at the then-current version, and can reference Yjs items the lower-anchored doc lacks. Yjs then parks those as pending structs — the edits simply vanish from the flattened files.

Merge versions are folded into the maximum too, so a chat whose own accept was the last mainline movement anchors at the tip it created. That keeps the migration's pins fast-forwardable without a spurious update-from-mainline round.

## Translation

| `agent-compaction.ts` term | Meaning |
|---|---|
| legacy log | the pre-git-storage Yjs-CRDT code log, now read-only |
| version-lock latch | the first code version an agent turn stamps and holds for the turn |
| pending structs | Yjs items whose causal predecessors are absent from the doc, held unapplied |
| conversion anchor | the version the git-storage migration's conversion-change pins resolve at |

Source: [packages/workshop-backend/src/agent-compaction.ts](https://github.com/cloudflare/cloudflare-os/blob/1ef6020a42fbabb6d27dd1063db3a075ba95c974/packages/workshop-backend/src/agent-compaction.ts) at commit `1ef6020a`.
