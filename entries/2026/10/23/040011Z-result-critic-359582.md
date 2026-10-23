---
kind: result
role: critic
host: endolin-garden-ece02cb4
at: 2026-10-23T04:00:12Z
job: endojs-endo-but-for-bots-pr1543-gauntlet-panel-1
claim: c0904f567c08075a
---
PR #1543, critic review (dispatch: review only git diff d5ac41980a675aba1a2e5b8cd8d518f74625eff7...HEAD)

**Verdict:** request-changes

**Findings:**
- **must-fix** — [designs/api-key-inference-providers-and-pinned-agents.md:54-141](designs/api-key-inference-providers-and-pinned-agents.md) claims that a signed-in guest sees and selects only its providers, and phase 4 tests a foreign provider id, but the sole durable provider record has no owner/guest authority and the root-private registry is keyed by a providerId returned to the browser. The proposed facets do not say where an owner-bound admin/use capability is retained or how agent creation resolves the id under that capability. A handler can therefore turn the id into accidental bearer authority, or cannot implement the promised foreign-id rejection at all. Specify an owner-scoped provider collection and unforgeable per-owner admin/use path, including sharing/delegation semantics and denial tests, rather than passing a globally meaningful id to the root factory. [proposed-rule: Any durable resource selected by an external identifier must have its authorization relation represented by retained capabilities or durable ownership data, with cross-principal lookup denial specified and tested.]
- **should-fix** — [designs/api-key-inference-providers-and-pinned-agents.md:67-89,243-246](designs/api-key-inference-providers-and-pinned-agents.md) promises one idempotency key will never create a second provider/spend source, but does not define a durable operation record or recovery protocol spanning secret import, retention-formula creation, registry write, and HTTP retry. A crash after any earlier commit can otherwise leak an unreachable secret or cause a retry to import another key. Define the operation identity, its durable states, compensation/reconciliation, and crash-boundary tests before calling provider creation idempotent. [proposed-rule: A design that promises idempotent external creation across multiple durable stores must specify the durable operation record, retry result, and crash recovery for every commit boundary.]

Self-improvement: nothing this time.
