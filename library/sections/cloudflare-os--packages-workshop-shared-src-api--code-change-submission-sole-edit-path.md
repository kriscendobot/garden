---
title: Code-change submission as the sole edit path
source: packages/workshop-shared/src/api.ts
source_kind: comment-fragment
source_repo: cloudflare/cloudflare-os
source_path: packages/workshop-shared/src/api.ts
source_line_range: "1663-1737"
source_commit: 1ef6020a42fbabb6d27dd1063db3a075ba95c974
comment_subject: submitCodeChange as the only way to edit code — server transform over accepted changes, atomic pin declarations, and OT-safe retry by client session and seq
source_authors: [Kenton Varda]
ingested: 2026-08-24
ingested_by: scholar
topics: [collaborative-workspace-sharing, change-propagation, local-first-sync, persistence]
status: current
---

Abstract: In Cloudflare OS, `Overseer.submitCodeChange` is the only way to edit code: committed code cannot be written directly — gadget heads advance only when a chat's changes are accepted. A submission's `change` is expressed against the chat's content as of `(generation, revision)`; the server transforms it over any changes accepted since, validates it, appends it to the chat's single revisioned stream, broadcasts it via `AiChatSubscriber.changeApplied()`, and returns where it landed. `submission.pins` carries one declaration per permanent gadget the change touches that is not yet pinned, each naming the head commit the client derives from; the server checks the declared base is the gadget's current head (or a parent, tolerating one concurrent merge) and establishes the pin atomically with the change. Retries are OT-safe by construction: `clientId` names the editing session and `seq` numbers its submissions, the server remembers each session's last accepted seq and where it landed, and a retry of that seq returns the recorded result rather than applying it twice — so a transport failure must be retried with the *same* seq and identical payload (OT, unlike a CRDT, does not tolerate double-application). Reads use `getCodeAtCommit` (immutable, client-cacheable by commit id) to fetch pin base content.

## The only edit path

Committed code cannot be written directly; gadget heads only advance when a chat's changes are accepted (via `mergeChanges`). `submission.change` is expressed against the chat's content as of `(submission.generation, submission.revision)` — the submitter has applied every accepted change of that generation's stream up to and including that revision. The server transforms the change over any changes accepted since, validates it, appends it to the stream, and broadcasts it; the returned `(generation, revision)` is where it landed.

## Atomic pin declarations

`submission.pins` must carry one declaration per *permanent* gadget the change touches that is not yet pinned in the chat, each naming the head commit the client's content derives from. The server checks that each declared base is the gadget's current head, or a parent of it (tolerating a race with one concurrent merge), and establishes the pin atomically with the change. A declaration identical to the existing pin is accepted idempotently; one naming a different `baseCommit` (a race between two first editors) throws. A gadget still *pending* in this chat has no head commit to pin, so its changes carry no declaration and build content up from nothing.

## OT-safe retry

`submission.clientId` names the client's editing session and `submission.seq` numbers its submissions from 1. The server remembers each session's last accepted seq and where it landed — independently of the changes themselves, so recognition survives materialization, epoch resets, and destructive generation bumps — and answers a retry of that seq with the recorded result instead of applying it twice.

A transport failure must therefore be retried with the *same* seq and an identical payload, never renumbered or re-composed: operational transform, unlike a CRDT, does not tolerate double-application. A same-seq submission whose content differs is a client bug and is rejected. A seq one past the last accepted (or 1 from a new session) is the next change; anything else is rejected — discard local edits and rebuild under a fresh `clientId`. Only the last submission is remembered, so keep at most one in flight. While an agent turn is active the call throws a retryable error (keep the queued change and resubmit after the turn ends).

## Cross-generation transform and unrecoverable rejections

A submission still rooted in the *previous* generation, when that generation was closed by a merge (a content-preserving bump), is transformed across the boundary and lands in the current generation, so typing straight through someone's accept is seamless. Such a submission's pin declarations are ignored (they describe pre-merge heads; the server derives the new pins itself), and it is rejected if it touches a gadget in `ChatCodeBase.prior.discontinuousGadgets` or one re-pinned at a different base. Every other rejection means the client's local state is unusable — a destructive generation bump (revert, draft discard, turn abort), a revision older than the server's retained transform window, or an invalid change — and the client must discard local edits and rebuild from fresh metadata.

Source: [packages/workshop-shared/src/api.ts](https://github.com/cloudflare/cloudflare-os/blob/1ef6020a42fbabb6d27dd1063db3a075ba95c974/packages/workshop-shared/src/api.ts) at commit `1ef6020a`.
