---
title: Classifying a tool into read or action and deciding auto-approval
source: packages/mcp-shared/src/tools.ts
source_kind: comment-fragment
source_repo: cloudflare/cloudflare-os
source_path: packages/mcp-shared/src/tools.ts
source_line_range: "36-143"
source_commit: bd0aa2dcde02008bb6170341fe2c574fd3ace275
comment_subject: how classifyTool turns tool annotations into a read/action mode and an auto-approvable flag using strict boolean tests that fail closed
source_authors: [Dan Carter, Phillip Jones]
ingested: 2026-08-24
ingested_by: scholar
topics: [capability-mediated-integrations, capability-security]
status: current
---

`classifyTool` is the single place a server's self-description becomes a policy decision. It maps a tool plus its `ServerTrust` tier to a `mode` (`read` runs immediately and is recorded as an observation; `action` goes to the approval queue) and an `autoApprovable` flag. Every test is strict `=== true` / `=== false` rather than a truthiness check, so an unannotated tool fails all of them and comes out as an action that can never auto-apply. The classification decision is recorded on the tool (`classifiedBy`) rather than re-derived, so no downstream consumer can answer it differently from the classifier that made it.

## The read/action decision

`isDeclaredReadOnly` returns true only when `annotations.readOnlyHint === true`, matching the spec's own default of `false` so an absent annotation is not a read. `classifyTool` then sets `mode` to `read` when read-only and `action` otherwise, and records `classifiedBy` as `server-annotation` for a declared read or `default` for an action.

`readOnlyHint` is honoured on both tiers, which the file frames as a tradeoff rather than a free win: a tool the server mislabels runs with no approval where an unlabelled one would have been queued. Auto-applying a *write* is not accepted on those terms and additionally requires a vetted endpoint, so the deployment rather than the server casts the deciding vote.

## The auto-approval decision

`autoApprovable` is true only when the tool is *not* read-only, the trust tier is `vetted`, `annotations.destructiveHint === false`, and `annotations.idempotentHint === true`. All four strict tests must pass, so a byo endpoint or any missing annotation fails closed.

## Catalog fingerprinting to detect drift

`policyClaims` renders each tool's read/write plus its `destructiveHint` and `idempotentHint` as a tri-state fingerprint character (`1` / `0` / `-`), so a server starting or stopping a claim is visible even where both currently lead to the same decision. `catalogRevision` builds a stable fingerprint over each tool's name and every claim a grant was decided against (excluding descriptions, so copy edits do not fire the signal), used to detect that an endpoint changed under the connector. `actionKindFor` scopes a tool's approval-policy identity by a `scopeTag` so two connectors sharing a binding id cannot share pre-approvals.

Source: [packages/mcp-shared/src/tools.ts](https://github.com/cloudflare/cloudflare-os/blob/bd0aa2dcde02008bb6170341fe2c574fd3ace275/packages/mcp-shared/src/tools.ts) at commit `bd0aa2dcde` (lines 36-143).
