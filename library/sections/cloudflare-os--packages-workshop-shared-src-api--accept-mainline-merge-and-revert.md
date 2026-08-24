---
title: Accept, mainline merge, and revert
source: packages/workshop-shared/src/api.ts
source_kind: comment-fragment
source_repo: cloudflare/cloudflare-os
source_path: packages/workshop-shared/src/api.ts
source_line_range: "1950-2031"
source_commit: 1ef6020a42fbabb6d27dd1063db3a075ba95c974
comment_subject: mergeChanges (fast-forward-only accept that closes an epoch), updateChatFromMainline (3-way merge of moved mainline into a chat), and the destructive revert/discard operations
source_authors: [Kenton Varda]
ingested: 2026-08-24
ingested_by: scholar
topics: [collaborative-workspace-sharing, change-propagation, persistence]
status: current
---

Abstract: Cloudflare OS closes and reconciles a chat's code branch with three Overseer operations. `mergeChanges` (accept) merges *everything* the chat proposes into mainline and is only ever a fast-forward: every gadget touched must have its chat pin equal to the gadget's current head, else nothing merges and a "stale" outcome is returned (call `updateChatFromMainline`, resolve conflicts, retry). A successful merge closes the chat's current epoch — all merged content lives in commits, the code base resets to empty, the change stream restarts at revision 0 under a new generation, and the merge message records `epochBoundary` — while the content-preserving generation bump lets in-flight submissions transform onto the new generation and lose nothing. `updateChatFromMainline` merges mainline commits that landed after the chat's pins into the chat's uncommitted state: only pinned gadgets participate, each computed as a 3-way text merge (base = last merged commit, ours = head, theirs = the chat's current files) applied as an ordinary broadcast change and recorded in a "changes" message carrying `mainlineMerge`. Conflicting hunks are left inline as 3-way markers. `revertChanges`, `discardChatDraftChanges`, and (contrastingly) `finalizeChatDraft` govern erasing versus merely materializing proposed changes; erasing already-applied changes bumps the generation destructively.

## Accept: fast-forward-only, epoch-closing

`mergeChanges` merges *everything* the chat proposes into mainline — changes not yet materialized into a "changes" message are swept in first, and there is no way to accept only a subset. Accepting is only ever a fast-forward: every gadget touched by the merged changes must have its chat pin equal to the gadget's current head commit. If mainline has advanced past any pin, nothing at all is merged and the call returns a "stale" outcome (an expected result, not an exception): call `updateChatFromMainline`, resolve any conflicts, and retry.

A successful merge closes the chat's current **epoch**: all merged content now lives in commits, so the code base resets to empty (every pin dropped, the change stream restarts at revision 0 under a new generation, and the merge message records `epochBoundary`). Subsequent edits re-pin lazily against the new heads. The generation bump is content-preserving: `ChatCodeBase.prior` describes the closed stream, and in-flight submissions rooted in it are transformed onto the new generation rather than discarded, so a client typing through someone's accept loses nothing.

## Update-from-mainline: 3-way merge of moved mainline

`updateChatFromMainline` merges mainline commits that landed after this chat's pins into the chat's uncommitted state. Only *pinned* gadgets participate — an unpinned gadget's code was never modified in this chat, so it tracks mainline head live and there is nothing to merge into. For each pinned gadget whose `mergedCommit` is behind the gadget's current head, the server computes a 3-way text merge (base = the last merged commit, ours = the head, theirs = the chat's current files) and applies the result as an ordinary change — broadcast via `changeApplied()`, so concurrent editors transform against it like any other remote change — recorded in a "changes" message carrying `mainlineMerge`, advancing the pin to head. Conflicting hunks are left inline as 3-way conflict markers, each affected path qualified by its gadget's binding name (`GADGET_NAME/path`) and returned in sorted order. An empty `conflictPaths` means every file merged cleanly (or there was nothing to merge). Whenever any pin advances, a `mainlineMerge` "changes" message is recorded even when the content already matched mainline, so the chat log always accounts for the advancement.

## Revert, discard, and materialize

`revertChanges(chatId, revertFrom)` reverts proposed changes from a given sequence. It throws if the range covers a still-proposed mainline merge, or erases the chat's conversion boundary while keeping an earlier still-proposed batch (a full revert, `revertFrom` 0, always satisfies this). Pins declared by reverted messages are removed (a pin survives a revert iff its declaring message survives), and changes not yet materialized are erased along with the reverted range. Erasing already-applied changes invalidates every client's local state, so the generation is bumped *destructively*.

`discardChatDraftChanges` discards changes not yet materialized into a durable message, removing pins those changes established and bumping the generation destructively, exactly as with revert. `finalizeChatDraft` merely materializes the not-yet-covered changes into one durable "changes" message without merging into mainline — it invalidates nothing, because the message's `watermark` tells clients which changes it absorbed. Materialization also happens automatically: at agent turn start, at accept, and when un-materialized changes grow past a size/age threshold.

Source: [packages/workshop-shared/src/api.ts](https://github.com/cloudflare/cloudflare-os/blob/1ef6020a42fbabb6d27dd1063db3a075ba95c974/packages/workshop-shared/src/api.ts) at commit `1ef6020a`.
