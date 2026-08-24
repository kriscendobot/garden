---
title: Persistent hook binding and fresh-session delivery
source: packages/workshop-shared/src/gatekeeper.ts
source_kind: comment-fragment
source_repo: cloudflare/cloudflare-os
source_path: packages/workshop-shared/src/gatekeeper.ts
source_line_range: "959-1047, 1212-1283"
source_commit: 2c9d59098d852370f27882702dd39a159b3c12f5
comment_subject: persistent callback hooks are stored by the Overseer, enabled only after approval, and rebound to a fresh Gatekeeper session for every delivery
source_authors: [Kenton Varda, "Yo'av Moshe", Phillip Jones, Nathan Disidore]
ingested: 2026-08-24
ingested_by: scholar
topics: [capability-mediated-integrations, capability-security, cloudflare-workers-agent-hosting]
status: current
---

Persistent hooks split registration from delivery so a stored callback never outlives the Gatekeeper session and approval queue that authorize its use. `bindHook()` gives the Overseer the persistent callback plus a provider-owned controller, but the provider stores no active hook state until approval calls `enable()`. At each event it calls `HookInitiator.startHook()` to obtain a fresh callback and a fresh approval queue before authorizing the observation or submitting any resulting action.

## Binding and delayed enablement

A gadget supplies a persistent RPC stub created through the Workers runtime restore protocol. The Gatekeeper passes that stub to the Overseer rather than storing it itself because it is tied to the current session. The `HookController` captures persistable registration parameters in its Worker entrypoint properties. Human approval may happen later; if it never happens, `enable()` is never called and the provider should have created no external subscription state.

When enabled, the controller stores the `HookInitiator` and may also retain opaque workspace and gadget target metadata for display and navigation. That metadata is fixed routing context, not authority, identity, or a storage-scoping key. Re-enabling replaces the previous initiator. Disabling must permanently clean up all related provider state while remaining compatible with a later enable.

## Fresh delivery session

For every event, the provider calls `startHook()` before invoking the callback. The Overseer then creates a new Gatekeeper session and returns both the callback version bound to that session and its `ApprovalQueue`. The provider authorizes incoming data as an observation before delivery. If callback behavior or its return value causes effects, those effects enter the same action-submission path as an ordinary session call.

This rebinding pattern makes long-lived schedules and subscriptions survive Durable Object storage without preserving stale session authority. The persistent identity is restoration data; actual delivery authority is refreshed per invocation.

Source: [packages/workshop-shared/src/gatekeeper.ts](https://github.com/cloudflare/cloudflare-os/blob/2c9d59098d852370f27882702dd39a159b3c12f5/packages/workshop-shared/src/gatekeeper.ts) at commit `2c9d59098d` (lines 959-1047 and 1212-1283).
