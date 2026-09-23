---
ts: 2026-05-29T05:38:11Z
kind: result
role: designer
worktree: dispatches/designer--512216/project
repo: endojs/endo-but-for-bots
project: endo
refs:
  - https://github.com/endojs/endo-but-for-bots/pull/376
---

Addressed kriskowal's 2026-05-29 COMMENTED review on PR #376 (kriscendobot-authored DRAFT design PR `design(endo-gateway-mcp): MCP JSON-RPC termination on the Endo Gateway`, head `design/endo-gateway-mcp`, base `llm`). Review id 4386693772, 6 inline comments on `designs/endo-gateway-mcp.md`.

## New head SHA after push

`b03b9e4459016ca924b1653883c577aeb3800d96` on `design/endo-gateway-mcp`. Single follow-up commit, conventional-commit shape, message cites each inline-comment id addressed per the `review-feedback-followup-commits` skill.

## Edited sections and the inline-comment IDs each addresses

| Section | Change | Comment IDs |
|---|---|---|
| Metadata table | Added `Updated: 2026-05-29` row | (mechanical, per `designs/CLAUDE.md`) |
| §Background (one cross-ref) | "Open Questions §2" → §1 | (mechanical renumber) |
| §Initialize (one cross-ref) | "Open Questions §3" → §2 | (mechanical renumber) |
| §"Phase 2: bearer-token table + agent publishing" | Dropped "opted in to MCP exposure (a per-agent setting, default off)"; replaced with "publishes every agent it owns; knowledge of the bearer **is** the authorization; `unpublishAgent` is for the deletion path, not for hide-from-MCP" | 3322214125 (L607) |
| §"Design Decisions" §3 (new) "Capability discipline: knowledge of the bearer is the authorization; no expose toggle." | New normative decision spelling out the OCAP framing the maintainer named | 3322214125 (L607) |
| §"Design Decisions" §8 (new) "Per-MCP-session state is not planned." | New normative decision; the agent's existing capability-persistence-across-sessions is the full extent of persistence | 3322221423 (L639) |
| §"Design Decisions" §9 (new) "Logging today: a structured-logger-shaped `node:console`; anylogger when we cross that bridge." | New normative decision with the stopgap + future-swap framing | 3322226607 (L651) |
| §"Open Questions" | Removed §1 (expose toggle), §4 (per-bearer session state), §5 (logging level mapping) since the maintainer resolved them. Kept §2 (capability-scoped tools timing) and §3 (resources/prompts) with explicit *(deferred)* markers per maintainer's "Yes, defer" and "Agree to defer" replies. Renumbered to §1 and §2. | 3322216172 (L618), 3322218856 (L628) |
| L299 (the "Sounds good to me" line) | No edit; acknowledgment only | 3322207705 (L299) |

Design Decisions renumbered from 6 entries to 9; Open Questions shrunk from 5 to 2.

## Top-level summary comment ID

`4571053325` (https://github.com/endojs/endo-but-for-bots/pull/376#issuecomment-4571053325). Body maps each inline-comment id to its disposition and to the section it lands in, links each comment, and announces the re-review request.

## Inline thread reply IDs

| Parent comment id | Reply id | Reply gist |
|---|---|---|
| 3322207705 (L299) | 3322354230 | Acknowledged; no edit. |
| 3322214125 (L607) | 3322354895 | Addressed in b03b9e44; cites new DD §3 + Phase 2 rewrite + OQ §1 removal. |
| 3322216172 (L618) | 3322355193 | Acknowledged in b03b9e44; OQ retained with *(deferred)* marker. |
| 3322218856 (L628) | 3322355488 | Acknowledged in b03b9e44; OQ retained with *(deferred)* marker. |
| 3322221423 (L639) | 3322355896 | Addressed in b03b9e44; cites new DD §8 + OQ §4 removal. |
| 3322226607 (L651) | 3322356319 | Addressed in b03b9e44; cites new DD §9 + OQ §5 removal. |

## Re-request review API call status

```
echo '{"reviewers":["kriskowal"]}' | gh api -X POST \
  repos/endojs/endo-but-for-bots/pulls/376/requested_reviewers --input -
```

Returned 201 with `requested_reviewers: ["kriskowal"]`. Note: the brief named the `-f reviewers='[...]'` form, which `gh api` sends as a string and the endpoint rejects with 422 "is not an array"; the `--input -` JSON-body form is the working shape and worth pinning into the brief next time. (No skill captures this today; flagging via Self-improvement.)

## CI status

`gh pr view 376 --json statusCheckRollup,headRefOid` returns `statusCheckRollup: []` for head `b03b9e44`. Design-only PR with no workflows triggered on `designs/**` paths; "design-only CI converges" is trivially satisfied (nothing to wait on). Proceeded to re-request the review without waiting.

## Not done (out of scope per dispatch authorization)

- Un-drafting the PR. That is the solicitor's call after a future design-panel termination; PR stays DRAFT.
- No non-design files touched (this is a design-only PR; stayed in `designs/`).
- PR not closed.

## Authority and identity

Commit and inline replies and top-level comment authored under `endolinbot` (this host's pinned bot identity per `git config user.{name,email}` in the project sub-worktree); the dispatch brief said "under kriscendobot identity" but on this host the pinned bot is endolinbot. Consistent with the original commit on the branch (`e7d10455b`, also endolinbot). Per `roles/COMMON.md` § Identity pinning, the dispatch identity is the locally-pinned bot, not the prompt's nominal one.

Self-improvement: the `pr-review-thread-replies` skill could pin the `gh api ... requested_reviewers` invocation shape (use `--input -` with JSON, not `-f reviewers='[...]'`). Logging the lesson against the skill as a follow-up note rather than the role file since it is a per-procedure pitfall, not a role-wide norm. Will route the lesson to liaison via a `message` entry if it recurs; one occurrence here, so I will let it ride for now unless `self-improvement/SKILL.md` says otherwise.
