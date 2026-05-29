---
ts: 2026-05-29T13:23:00Z
kind: dispatch
role: steward
host: endolinbot
repo: endojs/endo-but-for-bots
project: endo-but-for-bots
to: judge
dispatch_root: /home/kris/dispatches/judge--8418fa
prs:
  - repo: endojs/endo-but-for-bots
    pr: 376
    role: target
refs:
  - https://github.com/endojs/endo-but-for-bots/pull/376
  - entries/2026/05/29/053900Z-result-steward-a0b1c2.md
  - entries/2026/05/29/063630Z-result-steward-f5a6b7.md
---

# dispatch: judge — design panel + un-draft on #376 (maintainer APPROVED)

Maintainer kriskowal submitted an APPROVED review on PR #376 at
2026-05-29T13:21:32Z (review body empty; the approval is the signal).
This is the green light to terminate the design panel and un-draft the
PR for conductor merge.

## Context

PR #376 (`design(endo-gateway-mcp): MCP JSON-RPC termination on the Endo
Gateway`) is a design-only PR (touches `designs/endo-gateway-mcp.md`
plus the designs/README.md totals). The full chain so far:

- Contractor opened DRAFT 04:12Z
- Maintainer's first review (COMMENTED, 6 inline comments) 05:01Z
- Designer dispatch addressed all 6 — pushed b03b9e44 05:38Z
- PR went CONFLICTING after designer push
- Weaver rebased onto `origin/llm` advance — pushed d32c8deb3 06:35Z
- Maintainer re-reviewed and APPROVED 13:21Z

The PR is currently:
- State: OPEN, DRAFT
- Head: `design/endo-gateway-mcp@d32c8deb3` (post-rebase head)
- Base: `llm`
- Mergeable: MERGEABLE
- Review decision: APPROVED (kriskowal)

## Task

Operate as the solicitor seat (design-panel judge) per
`roles/solicitor/AGENT.md` (or `roles/judge/AGENT.md` redirect):

1. Verify the design panel verdict. The maintainer APPROVAL is the
   strongest signal; a formal panel pass is optional. If the
   solicitor's panel composition rule says skip-the-panel-when-
   maintainer-approved, do so. Otherwise run a quick panel (the design
   is small and well-scoped).
2. Un-draft PR #376: `gh pr ready 376 --repo endojs/endo-but-for-bots`.
3. Verify the un-draft landed (PR state becomes non-draft).
4. Do *not* merge — the conductor handles merge as a separate
   dispatch (steward will follow up).

## Per-action authorizations (forwarded)

- Un-drafting PR #376. Authorized.
- Posting any panel-summary comment on PR #376 if the role file calls
  for one. Authorized.
- Reading PR diff and design document. Authorized.

## Not authorized

- Merging PR #376 (conductor's job).
- Modifying the design document (any further design changes would be
  a separate designer dispatch).
- Re-requesting maintainer review (they've already approved).

## Dispatch protocol

Read in order:

1. `/home/kris/dispatches/judge--8418fa/garden/roles/COMMON.md`
2. `/home/kris/dispatches/judge--8418fa/garden/roles/solicitor/AGENT.md`
   (the post-2026-05-21 split; `roles/judge/AGENT.md` is the redirect).
3. Skills the solicitor names just-in-time.

Project worktree starts at `project/` on `design/endo-gateway-mcp`
(detached HEAD at `b03b9e445`). Note: the worktree may be at the
earlier head; the actual PR head is `d32c8deb3` after the weaver
rebase. The judge's panel work is at the PR level (not local commits),
so this is fine.

## Report

A `result` journal entry. Include: panel verdict (if a panel ran),
un-draft confirmation (new isDraft=false), any panel-summary comment
IDs.
