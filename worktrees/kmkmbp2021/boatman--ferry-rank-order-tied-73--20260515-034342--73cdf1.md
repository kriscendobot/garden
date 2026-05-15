---
hostname: kmkmbp2021
worktree: boatman--ferry-rank-order-tied-73--20260515-034342--73cdf1
path: /Users/kris/garden/dispatches/boatman--ferry-rank-order-tied-73--20260515-034342--73cdf1
repo: endojs/endo
branch: master
role: boatman
status: active
created_at: 2026-05-15T03:43:42Z
last_heartbeat: 2026-05-15T03:43:52Z
task: "First-time ferry of endojs/endo-but-for-bots#73 (compareRankRemotablesTied salvaged from endojs/endo#2871) to a new non-draft PR on endojs/endo with two-author attribution preserved (erights + kriskowal)"
prs:
  - repo: endojs/endo-but-for-bots
    pr: 73
    role: source
    title: "refactor(marshal): compareRankRemotablesTied for rank-cover ops"
  - repo: endojs/endo
    pr: null
    role: target
    title: null
---

Per-dispatch worktree triple for the first-time ferry of #73. **Multi-author** ferry (the first this session): commit 1 by Mark S. Miller (erights, the original author of the substance, who APPROVED the source-side mirror at 03:38Z 5 min before this dispatch), commit 2 by Kris Kowal (kriskowal@kriskowal.com, the follow-up). Both attributions preserved — no `--reset-author`.

The user did not ask about draft vs ready-for-review; the liaison defaulted to non-draft based on the erights approval (strong readiness signal) and the substantive nature of the change.

Identity authorization staged per the standing pattern (`identity_switch_authorized: true`). Strip the `(#73)` bot-internal source-PR-number suffix from commit 2's subject; drop the `/ bots#57` fragment from commit 1's body. PR body rewrite per `pr-formation` drops bot bookkeeping (the `🤖 Generated with [Claude Code]` trailer on the source PR body, the bot-internal `(fork's #57)` references, the test-plan checklists).
