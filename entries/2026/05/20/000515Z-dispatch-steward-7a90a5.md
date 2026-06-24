---
ts: 2026-05-20T00:05:15Z
kind: dispatch
role: steward
to: gardener
dispatch_id: 7a90a5
dispatch_root: /home/kris/dispatches/gardener--7a90a5
project: garden
---

# Dispatch gardener 7a90a5 — reinforce 👀 reactji acknowledgment practice

Maintainer note 2026-05-20T00:07Z: "Might need the gardener to reinforce the practice of adding 👀 eyes reactji to acknowledge prompts."

Empirical evidence: in this engagement I acted on four @kriscendobot directives (PR #304#issuecomment-4493068464 consolidate, PR #301#issuecomment-4493151522 rebase, PR #303#issuecomment-4493154411 gauntlet, PR #305#issuecomment-4493197252 gamut) without acking any of them with 👀 first. The maintainer had to flag two of them as missed before I noticed. Reactji was backfilled at 00:07Z after the maintainer's reinforcement.

The `skills/reactji-acknowledgment/SKILL.md` skill exists and the steward's role file references it, but the per-cycle survey doesn't enforce the ack-on-pickup invariant. The reactji is supposed to land **immediately on pickup** so the maintainer can see at a glance which directives are owned and prevent re-issuance. Without the ack, the maintainer's only signal is the dispatch journal entry, which lives in a different surface and lags by minutes.

Audit and reinforce as you see fit. Possible angles:
- The steward's per-cycle survey could add a sub-step under *Dispatch* that names the reactji ack as the first action on any @-mention or directed comment picked up — currently the survey assumes the role-file's reactji-skill reference is enough.
- The reactji skill body could lead more strongly with the *when* (immediately on pickup, before dispatch, before any planning) rather than treating the timing as procedural footnote.
- The at-mention surveillance skill could include an "ack as you read" note: when the Monitor surfaces an @-mention, the steward's response to that Monitor event includes the reactji as the first reflex.
- A standing rule in roles/COMMON.md could promote reactji-ack from per-role discipline to global discipline (every role that picks up a directed comment acks before acting).

The empirical pattern (four prompts in 25 minutes, all acked late) suggests the failure mode is *not* skill-ignorance — the skill is documented — but *cadence-overrun*: when prompts arrive in fast bursts the steward jumps to dispatch before reacting to the directive itself. The reinforcement should land in the place that catches cadence-overrun, which is most likely the per-cycle survey rather than the skill body.

Choose the lightest-touch change that closes the hole. Commit and push to `main`.

Report: what you changed (path, summary), the empirical pattern you considered, and any related self-improvement (gardener-queue items you noticed but didn't address).
