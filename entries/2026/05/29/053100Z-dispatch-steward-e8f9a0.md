---
ts: 2026-05-29T05:31:00Z
kind: dispatch
role: steward
host: endolinbot
repo: endojs/endo-but-for-bots
project: endo-but-for-bots
to: designer
dispatch_root: /home/kris/dispatches/designer--512216
prs:
  - repo: endojs/endo-but-for-bots
    pr: 376
    role: target
refs:
  - https://github.com/endojs/endo-but-for-bots/pull/376
---

# dispatch: designer — respond to kriskowal feedback on PR #376

Maintainer directive in steward's terminal session at 2026-05-29T05:29Z:
*"Please respond to feedback on https://github.com/endojs/endo-but-for-bots/pull/376."*

PR #376 is `design(endo-gateway-mcp): MCP JSON-RPC termination on the
Endo Gateway`, kriscendobot-authored DRAFT (was opened by the
contractor's designer dispatch at 04:12Z this morning), head
`design/endo-gateway-mcp`, base `llm`, 2 files. Maintainer kriskowal
posted a COMMENTED review at 2026-05-29T05:01:20Z (review id
4386693772) with **6 inline comments** on `designs/endo-gateway-mcp.md`
spanning lines 299, 607, 618, 628, 639, 651.

Inline-comment summary (first ~80 chars of each, sorted by line):

- **L299** (kriskowal): "Sounds good to me." — acknowledgment; no
  action required, just resolve the thread.
- **L607**: "The policy consistent with object capability discipline
  is that, if the bearer k..." — substantive guidance on a policy
  question; re-fetch the full body for the design edit.
- **L618**: "Yes, defer." — agree with the design's deferral; resolve.
- **L628**: "Agree to defer." — same; resolve.
- **L639**: "Not planned. The agent persists capabilities between
  sessions and that is the ex..." — substantive correction on a
  capability-persistence question; re-fetch the full body.
- **L651**: "We should use structured logging, like anylogger, when we
  cross this bridge. It..." — design directive (use anylogger);
  re-fetch the full body.

## Task

Apply the maintainer's review to the design document
`designs/endo-gateway-mcp.md`:

1. **Re-fetch each inline comment in full** via
   `gh api repos/endojs/endo-but-for-bots/pulls/376/comments` so you
   work from the canonical body, not the truncated excerpts above.
2. For each comment, edit the design to incorporate the guidance:
   - Acknowledgment-style comments (L299, L618, L628): edit the design
     prose to reflect the agreement, then the inline thread can be
     resolved.
   - Substantive guidance (L607 capability policy, L639
     capability-persistence, L651 anylogger structured logging): rewrite
     the relevant design section per the maintainer's direction.
3. Reply on each inline thread with a brief note explaining what
   changed (or "acknowledged" for the simple agreements).
4. Push the design edit to the PR branch
   (`design/endo-gateway-mcp`); the bot has write access to its own
   fork.
5. Post a top-level summary comment on the PR linking each addressing
   commit/section to the inline thread it answers, per
   `garden/skills/pr-review-thread-replies/SKILL.md` and
   `garden/skills/review-feedback-followup-commits/SKILL.md` (consult
   as needed).
6. Re-request kriskowal's review after the push lands:
   `gh api repos/endojs/endo-but-for-bots/pulls/376/requested_reviewers
   -f reviewers='["kriskowal"]'` — but ONLY after CI on the new head
   converges green (the design-only PR's CI is usually fast).

## Per-action authorizations (forwarded)

- Push the design edit to `endojs/endo-but-for-bots:design/endo-gateway-mcp`
  under kriscendobot identity. Authorized.
- Reply on each inline review thread. Authorized.
- Post the top-level summary comment. Authorized.
- Re-request kriskowal review after CI green. Authorized.

## Not authorized

- Un-drafting the PR. The judge's solicitor seat un-drafts on design
  panel termination; not your call here.
- Modifying any non-design file (this is a design-only PR; stay in
  `<project>/designs/`).
- Closing the PR.

## Dispatch protocol

Read in order:

1. `garden/roles/COMMON.md`
2. `garden/roles/designer/AGENT.md`
3. `garden/skills/pr-review-thread-replies/SKILL.md`
4. `garden/skills/review-feedback-followup-commits/SKILL.md`
5. Other skills the designer role names just-in-time.

Project worktree starts at `project/` on `design/endo-gateway-mcp`
(detached HEAD).

## Report

A `result` journal entry. Include: new head SHA after push, list of
edited sections in `designs/endo-gateway-mcp.md` with the inline
comment IDs each addresses, the top-level summary comment ID, the
re-request-review API call status, and any inline thread reply IDs.
