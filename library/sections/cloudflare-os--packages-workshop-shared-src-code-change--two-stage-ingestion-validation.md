---
title: Two-stage ingestion-validation trust boundary
source: packages/workshop-shared/src/code-change.ts
source_kind: comment-fragment
source_repo: cloudflare/cloudflare-os
source_path: packages/workshop-shared/src/code-change.ts
source_line_range: "25-47, 118-151, 451-604"
source_commit: 1ef6020a42fbabb6d27dd1063db3a075ba95c974
comment_subject: the ordered two-stage code-change validation — schema before transform, content after — the running size budget, and the surrogate rules that keep replicas byte-identical
source_authors: [Kenton Varda]
ingested: 2026-08-24
ingested_by: scholar
topics: [local-first-sync, change-propagation, endpoint-security]
status: current
---

Abstract: Cloudflare OS validates client code changes in two stages that must stay in order. `validateCodeChangeSchema` runs *before* any transform — transformation is structural and must only ever see well-formed changes — while `validateCodeChangeContent` runs *after* transforming the change to the server's current revision, because lengths and boundaries are only meaningful against the content the change will actually apply to. Both take a `CodeChange`, and that parameter type is a precondition (established by capnweb-validate's generated validator at the RPC edge and by the compiler for the in-process agent producer), so neither re-checks that a value is an object or a string; they check the invariants a TypeScript type cannot express — canonical gadget keys, path rules, size caps, integer section lengths, and the one variant rule the wire validator's first-match union misses. Validation's resource goal is deliberately modest: reject anything the caps rule out in at most one linear pass, enforced as a *running budget* so a hostile change is rejected before its sections are even walked. The size caps exist first for correctness (composed changes are stored and travel in RPC messages, both with hard size limits), not as a DoS defense. Stage 2's surrogate rules — every boundary on a code-point boundary, no lone surrogate inserted or `set` — are what keep replicas byte-identical, since changes travel as UTF-8 where a lone surrogate decodes as U+FFFD.

## The ordered trust boundary

Changes from clients are validated in two stages, and the stages must stay in this order:

- `validateCodeChangeSchema` runs *before* any transform — transformation is structural and must only ever see well-formed changes.
- `validateCodeChangeContent` runs *after* transforming the change to the server's current revision, because lengths and boundaries are only meaningful against the content the change will actually apply to.

Both stages take a `CodeChange`, and that parameter type is a precondition rather than a hope: the declared shape is established before they run, by capnweb-validate's generated validator at the RPC edge (`Overseer.submitCodeChange`) and by the compiler for the one in-process producer (the agent's `appendAgentCodeChange`, whose changes this module itself builds). So neither stage re-checks that a value is an object, an array, a pair, or a string; they check the invariants a TypeScript type cannot express.

## Stage 1: schema, with a running budget

`validateCodeChangeSchema` verifies canonical decimal gadget keys; non-empty entry lists with non-empty, duplicate-free paths; exactly one variant per `FileChange`; that every `edit` parses as a ChangeSet whose sections are non-negative integers each retaining, deleting, or inserting something (do-nothing padding rejected) and whose inserted line strings contain no `\n`; and the size caps (`MAX_FILE_TEXT_LENGTH` = 512 K code units per produced file, `MAX_FILE_PATH_LENGTH` = 1024 per path, `MAX_CODE_CHANGE_SIZE` = 2 MB overall). The cap is enforced as a running budget, not an after-the-fact sum: an edit's section count is pre-checked in O(1) and the budget re-checked as each section's cost accrues, so a hostile change is rejected before its sections are walked — and before `ChangeSet.fromJSON` materializes a second copy of an oversized edit.

The one-variant check is not the wire validator's to make: its union is first-match and allows extra properties, so `{set, remove}` would reach the module. It must not survive — `applyCodeChange` tests `set` before `edit` while `transformCodeChange` tests `edit` first, so a two-variant `FileChange` would be read differently by two replicas and diverge them. `ChangeSet.fromJSON` is also not strict enough alone (it accepts negative/non-integer section lengths, free padding that would evade the caps, and inserted "lines" containing `\n` that desynchronize line metadata), so the sections are checked first and `fromJSON` then rejects the remaining malformed shapes on budget-bounded input.

The resource-exhaustion goal is deliberately modest: reject the capped-out in one linear pass, no more. Change producers hold edit rights, and a user who can edit the workspace can do far worse than burn CPU; the isolate memory limit bounds the blast radius. The caps exist first for correctness — composed changes get stored and travel in RPC messages, both with hard size limits — not as a DoS defense.

## Stage 2: content, and byte-identical replicas

`validateCodeChangeContent` checks the change against the content it will actually apply to: each `edit` targets an existing file of exactly the change's before-length, every change boundary lands on a code-point boundary of that file, and no inserted or `set` text contains a lone UTF-16 surrogate. The surrogate rules are what keep replicas byte-identical: changes travel as UTF-8 (where a lone surrogate decodes as U+FFFD), so a mid-pair boundary or a lone surrogate would make remote replicas disagree with the sender. `remove` needs no content checks, being valid against any state.

## Translation

| `code-change.ts` term | Meaning |
|---|---|
| capnweb-validate | the generated RPC-edge validator that establishes a value's declared `CodeChange` shape before these stages run |
| lone surrogate | an unpaired UTF-16 surrogate half; decodes to U+FFFD under UTF-8, so it must never survive into stored content |
| running budget | the size cap enforced incrementally as costs accrue, rejecting an oversized change before fully walking it |

Source: [packages/workshop-shared/src/code-change.ts](https://github.com/cloudflare/cloudflare-os/blob/1ef6020a42fbabb6d27dd1063db3a075ba95c974/packages/workshop-shared/src/code-change.ts) at commit `1ef6020a`.
