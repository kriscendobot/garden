---
title: Approval, simulation, rejection, and revert
source: packages/workshop-shared/src/gatekeeper.ts
source_kind: comment-fragment
source_repo: cloudflare/cloudflare-os
source_path: packages/workshop-shared/src/gatekeeper.ts
source_line_range: "691-853, 928-958, 1110-1210"
source_commit: 2c9d59098d852370f27882702dd39a159b3c12f5
comment_subject: every side effect crosses the asynchronous approval queue, with optional simulation, explicit rejection cleanup, and best-effort revert
source_authors: [Kenton Varda, "Yo'av Moshe", Phillip Jones, Nathan Disidore]
ingested: 2026-08-24
ingested_by: scholar
topics: [capability-mediated-integrations, capability-security]
status: current
---

Every Gatekeeper session routes reads through synchronous observation authorization and side effects through an asynchronous approval queue. A Gatekeeper may simulate pending changes so the agent can continue against a coherent provisional world, but must never perform the real effect until `applyAction()` arrives. Rejection cleans retained state, and applied actions may expose a best-effort `revertAction()` path with explicit retry and restart signals.

## Submission is mandatory

The Gatekeeper assigns each proposed side effect a sequential local action ID and retains the details in its own storage. `submitAction()` returns quickly even when a person will decide hours or days later. Auto-approval changes who decides and how quickly; it never permits bypassing submission. The Overseer later returns the ID through exactly one of the apply or reject callbacks.

An `ActionDescription` must contain enough human-readable detail for review and audit. A stable `actionKind.tag` supports policy matching while its label is display text. Auto-approval requires both an opted-in kind and the Gatekeeper author's per-action `autoApprovable` verdict. Missing metadata fails toward manual approval. The protocol treats that boolean as an interim policy hint, not a complete risk model.

## Simulation and agent suspension

Simulation lets the session answer later reads as if queued edits already happened, which supports dependent work without applying effects. When a Gatekeeper cannot simulate safely, `awaitDecision` advises the agent harness to suspend the turn. Otherwise the agent would read stale external state and may retry or undo its own pending action. The hint changes conversational control flow but not the approval security boundary.

## Reject and revert

`rejectAction()` removes pending storage. It may request a gadget restart when simulated state cannot be rolled back cleanly. `revertAction()` addresses an action already applied. High-quality Gatekeepers should implement it, but the result can instead explain manual steps, identify stacked changes that must move first, say whether retry may later succeed, and request the same restart treatment. The UI uses `implementsRevert` to avoid promising an automatic undo that the Gatekeeper does not provide.

Source: [packages/workshop-shared/src/gatekeeper.ts](https://github.com/cloudflare/cloudflare-os/blob/2c9d59098d852370f27882702dd39a159b3c12f5/packages/workshop-shared/src/gatekeeper.ts) at commit `2c9d59098d` (lines 691-853, 928-958, and 1110-1210).
