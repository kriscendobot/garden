---
handed-off: apply-siwe-onchain-authz-maintainer-decisions
deliverable-complete: false
---
No maintainer reply arrived. Handing off honestly to the durable blocked successor.

## Completion report — `wire-siwe-onchain-authz-minion-town-followup`

**Outcome: honest handoff.** The core deliverable remains gated on maintainer input that has still not arrived. No responsible code work was possible, and I re-parked the remainder under a gate that stops the premature-promotion loop.

### What I found
- This followup is **purely the maintainer-gated remainder** — the predecessor (`wire-siwe-onchain-authz-minion-town`, commit `510cb4e`) already shipped every address-independent piece: the policy layer keys generically on `iss`+`sub` with intersection semantics (Tier 1 needs no code change), and `test/policy.test.ts` already covers the SIWE address-keyed shape (green), including the load-bearing EIP-55 checksum-casing guard.
- **The maintainer never answered.** Confirmed across the job inbox (empty), the journal message bus (only the outgoing questions from 2026-08-22, no reply), and the design doc (`designs/siwe-onchain-authz.md` § 6 records only the designer's *recommendations*, not decisions). `config/policy.json` in `kriscendobot/minion.town@main` still contains only Cognito identities — no SIWE identity, no allowlist addresses.
- **Root cause of this attempt's existence:** the job was auto-promoted by the **foreman** at `2026-09-16T14:19:14Z` (decisions.log `guard=promoted ... last=wire-siwe-onchain-authz-minion-town-followup`, gate `cleared=none`), purely because it was the top `--deferred` item with inflight below target=2 — **not** because the maintainer answered. A maintainer-gated job parked as `--deferred` is foreman-auto-promotable, so it gets pulled into a claimed no-op loop before the gate clears. This has now happened twice.

### What I did
- Messaged the maintainer with the crisp blocking decisions (Decision 3 tier choice; the Tier 1 allowlist addresses that must not be invented), then polled the inbox for 12 minutes — no reply.
- Did **not** fabricate any wallet address or touch `config/policy.json` (doing so would be a production authorization-security defect).
- **Posted a durable, foreman-immune successor:** `apply-siwe-onchain-authz-maintainer-decisions` — parked `--blocked` (blocked_on: `siwe-onchain-authz-maintainer-decision`), verified on `origin/journal2`. It carries full context and the exact blocking decisions, and being `--blocked` it will **not** be auto-promoted by the foreman; the liaison/maintainer promotes it manually once the answer arrives.
- Sent the maintainer a disposition note flagging the deferred→premature-promotion gate mismatch and suggesting a general "pending-maintainer-decision" gate so this class of job never lands on the foreman's deferred queue.

### Follow-ups
- **Maintainer action required:** answer Decision 3 + supply the Tier 1 allowlist addresses, then promote `apply-siwe-onchain-authz-maintainer-decisions`. Tier 1 is then minutes of work.
- **Garden defect worth fixing:** maintainer-gated jobs should not be parked `--deferred` (foreman-auto-promotable); consider a dedicated non-auto-promotable gate for "awaiting maintainer decision."

<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/wire-siwe-onchain-authz-minion-town-followup.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 54 tokens (1569380 cached reads)
- Output: 23259 tokens
- Cost: $2.011629
- Wall-clock: 1013s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
