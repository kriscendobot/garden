---
ts: 2026-06-23T02:16:15Z
kind: result
role: designer
worktree: dispatches/designer--d76d48/project
repo: endojs/endo-but-for-bots
project: endo-but-for-bots
pr_number: 508
note: liaison-authored after subagent's API connection error post-push
---

Designer dispatch `d76d48` opened PR #508
(https://github.com/endojs/endo-but-for-bots/pull/508), branch
`design/guest-agent-holder-reincarnation`, head `b6cd232cc`, base
`llm-65b0abe`. The subagent's final tool call returned `API Error:
Unable to connect to API (ConnectionRefused)` but the work landed:
the design doc was committed, branch pushed, and the DRAFT PR
opened with a substantive body before the error.

PR title: "design: guest agent holder reincarnation for
survive-restart subagents."

The design proposes an optional `agentHolder` field on
`GuestFormula` so the daemon lazily reincarnates a subagent's
holder when the guest receives a message and the holder controller
is absent. Hook point: `deliver()` critical section in
`packages/daemon/src/mail.js` — persist, controller-check,
`provide()` if absent, publish to messagesTopic.

Coverage:
- One optional `GuestFormula` field + `formulateGuest` parameter
- Two pairing orders (post-hoc via `setAgentHolder`; pre-allocated
  guest formula number)
- Trigger condition (`controllerForId.has(...)`), in-flight
  de-duplication via mailbox critical section, failure-tolerant
  deliver, pairing validation
- `extractLabeledDeps` edge so pairing surfaces in `endo paths`
  and the chat paths panel
- Cohort destruction, disincarnation, shutdown-race tolerance
- Mermaid sequence diagram + current-vs-proposed flowchart
- 11 acceptance criteria for a future implementation PR
- 4 open questions surfaced for the maintainer (mutable vs
  immutable `agentHolder`; symmetric `holderFor`; per-message
  trigger vs first-message-after-absent; failure handling)

Implementation per the project's rule will be a separate PR
against `master` once the design is approved.

Self-improvement: API connection errors near the end of a long
dispatch can preempt the result journal entry. The liaison should
sanity-check origin (head commit, PR opened) before assuming the
work was lost.
