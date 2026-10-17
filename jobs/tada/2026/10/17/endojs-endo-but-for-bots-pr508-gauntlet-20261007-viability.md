## Viability report: endojs/endo-but-for-bots PR #508. Result: overtaken

PR #508 ("design: guest agent holder reincarnation for survive-restart subagents") is still open and is not a draft. Its base is `llm-65b0abe` and its head is `e366054a`. It only touches design files: `designs/guest-agent-holder-reincarnation.md` and `designs/README.md`. Its last activity was the panel's round-1 "must-fix" verdict on 2026-09-27. Nothing has happened on it since.

**Deciding question:** Is a mailbox-delivery wake hook that reincarnates a guest's agent-side responder still missing from the daemon? That gap is what the PR's `GuestFormula.agentHolder` field and the hook in `mail.js` `deliver()` would fill.

**Evidence:** No, it is no longer missing. A different design has been built and merged.
- PR #1306 merged on 2026-09-18 (commit `9e16e50b`): "caller-elected pins, networks, and names for new agents". Every `GuestFormula` on `llm` now has `guestPins` and `hostPins`.
- On `llm`, `packages/daemon/src/mail.js` now has `reincarnateMailboxPins`. It re-provides the pinned values on every mailbox delivery, around line 875, before the message is published. That is the same wake-on-mail behavior #508 proposes, built more generally on pins.
- `designs/daemon-guest-bot-incarnation.md` on `llm` is marked **Implemented** (updated 2026-09-27). It says that with pins in place there is "no need for a `GuestFormula.bot` edge … or a second mailbox wake hook". #508's `agentHolder` edge is exactly that kind of guest-specific edge and second hook.
- `GuestFormula` on `llm` has no `agentHolder` field. The motivating problem, a durable guest whose holder dies on restart, is now solved by storing the responder in the guest's pin directory.

Option: close as superseded

I spent no clean, panel, fix, CI-wait or un-draft budget. A background project checkout I started did not finish within its time limit, so it will just lapse. I relied on read-only API reads instead, and nothing was changed or pushed.

<!-- gauntlet-stage-result: viability=overtaken -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr508-gauntlet-20261007-viability.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 20 tokens (479552 cached reads)
- Output: 3621 tokens
- Cost: $0.5362823999999999
- Wall-clock: 195s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
