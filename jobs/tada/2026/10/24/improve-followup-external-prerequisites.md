**Completion report: improve-followup-external-prerequisites**

**Root cause.** The blocked #1545 exo-dynamodb report from 2026-10-24T05:51:51Z had this follow-up item: "Before taking the draft out of draft, run the DynamoDB Local and isolated-IAM tests on a host that has Docker and AWS access." The words "run the" matched the `(…|run) (a|an|the|another)` prose pattern in `followups_prescribe_fleet_work`. The gate read the item as work for the fleet, refused to auto-escalate it, and blocked the finished job, so the reaper reran the agent.

**Fix (main2 `879c67ebef0`):**
- **New helper in `scripts/jobs/common.sh`:** `followup_item_needs_external_access <item>` matches one follow-up item that depends on access or credentials the fleet doesn't have. It catches two phrasings:
  - "on/from/in/with a host/machine/runner/environment/account that has/with … Docker/AWS/credentials/secrets/access/GPU/hardware"
  - "requires/needs/gated on Docker / (real) AWS access, credentials or account / maintainer, cloud or prod credentials / interactive login / MFA"

  It is narrow on purpose: an item that also names a fleet role or job (conductor, shepherd, fixer, weaver, builder, designer, gauntlet, panel, job) does not match.
- **Change to `followups_prescribe_fleet_work`:** the section is now split into list items, and matching items are dropped before the prose fleet-work patterns run. The check for a leading orchestrator verb still applies to every item, so "Rebase on a host with Docker" still blocks. With no fleet work left, the gate's existing auto-escalation sends the section to the maintainer inbox (coalesced, `reply_to=<base>`, checked on a fresh board read), and the completion is kept.
- **Gate header comment:** `scripts/jobs/assert-followup-posted.sh` now documents the new case.
- **New regression test (d5) in `scripts/jobs/test/followup-posted-gate-test.sh`:**
  - The exact incident section passes and lands in the inbox.
  - "A fresh shepherd job is warranted on a host that has Docker and AWS access" still blocks.

**Verification.**
- `followup-posted-gate-test.sh` passes, including the new d5 case and the existing d4 test that prescribed fleet work still blocks.
- `design-build-handoff-test.sh` passes.
- shellcheck reports nothing new; the three findings it does report are already on origin/main2.

**Follow-ups:** none. The fix takes effect on each host at its next deploy.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/improve-followup-external-prerequisites.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 48 tokens (1696011 cached reads)
- Output: 11363 tokens
- Cost: $1.1845742
- Wall-clock: 257s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
