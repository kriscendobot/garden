The job is fully complete. The prior attempt's committed and pushed work fully satisfies the deliverable, and I've verified it end-to-end.

## Completion report — `design-siwe-pivot-to-invitation-onboarding`

**Outcome: complete.** This is an evaluate-then-recommend design job. A prior attempt's committed work survived and fully satisfies the definition of done; I re-derived the state, verified every artifact, and found nothing left to redo.

### What was delivered (all durable on `kriscendobot/minion.town`)
- **`designs/siwe-invitation-pivot.md`** (209 lines, commit `770e086` on branch `design/siwe-invitation-pivot`, pushed to origin) — a full written recommendation, grounded against the SIWE design's § 3 and the invitation design's § 1/§ 5/§ 6 (both read, not reasoned from the job body).
- **Supersession banner** added atop `designs/siwe-onchain-authz.md` marking § 3 and the tier decisions superseded pending review.
- **Review PR #80** (open, draft, base `main`, mergeable, carries the `<!-- garden-job: design-siwe-pivot-to-invitation-onboarding -->` marker) — correctly presented as a review PR rather than landed bare, because the design carries an `## Open questions` section on an authorization boundary (the CLAUDE.md carve-out).

### The recommendation
**ADAPT-BUT-DEFER.** SIWE pivots along the same axis OAuth did: from an *authorization authority* (address → on-chain tiers → `mcp/*` scopes) to an *optional recovery-bond authenticator* (an `iss+sub` bonded to an existing guest account; adds no tools, widens no facet).
- **Tiers 1–3 do not ship** — superseded, not deferred. Scope-based admission is retired by invitation-only onboarding, so the "which tier" and "supply the allowlist" questions the deploy/wire jobs blocked on **dissolve**; no allowlist is written.
- **The deployed `siwe-idp.minion.town` issuer survives unchanged**, reused as one `OAuthIdentity` recovery provider (§ 5), held inert (default-deny, no policy entries) until #56's recovery layer lands. The parked `wire-siwe-onchain-authz-minion-town-followup` should be withdrawn (its work no longer exists), replaced post-#56 by a small `bond-siwe-recovery-provider` job.
- **CLOSE fallback fully specified**: if a wallet recovery bond is judged unwanted, decommission the issuer (remove Cognito IdP binding, tear down Lambda/API-Gateway/Caddy route, delete secrets), retaining the local toy + designs as a dormant capability. Leaving a live IdP with zero consumers is the one outcome the design flags to avoid.

### Verification performed
Confirmed PR #80 open with correct marker/base/head, both files present in the diff, the supersession banner in place, and no prior `tada/` report (this was a genuine re-run). No garden-repo changes were needed; the deliverable lives entirely in the minion.town PR.

### Follow-ups (for the maintainer, in PR #80 § 8)
The three open questions surfaced for review — chiefly *is an Ethereum-wallet recovery bond wanted at all?* (the ADAPT-vs-CLOSE fork) — are the maintainer decisions the review PR exists to collect. No further job is needed until #56 lands.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/design-siwe-pivot-to-invitation-onboarding.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 2 on 1 host(s)
- Input: 76 tokens (2440695 cached reads)
- Output: 31645 tokens
- Cost: $3.2089684999999997
- Wall-clock: 519s
- Model(s): claude-opus-4-8 ×2

<!-- garden-usage-end -->
