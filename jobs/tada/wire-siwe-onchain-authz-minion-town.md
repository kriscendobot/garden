---
handed-off: wire-siwe-onchain-authz-minion-town-followup
deliverable-complete: false
---
The successor is durably on `origin/journal2`. Handing off honestly.

---

## Completion report — `wire-siwe-onchain-authz-minion-town`

**Outcome: honest handoff.** The core deliverable is gated on maintainer input that never arrived; I delivered the entire address-independent portion and posted a parked successor that owns the maintainer-gated remainder.

### What I did
- **Read the design** (`designs/siwe-onchain-authz.md` § 3 tier model + policy-layer placement, § 6 decisions 1 & 3) and both predecessor job reports. Confirmed the deployed thunk issuer is live at `https://siwe-idp.minion.town` (mainnet, EIP-1271 in, ENS out; `sub` = EIP-55 checksummed address).
- **Analyzed the policy layer** (`src/auth/policy.ts`, `config/policy.json`, `src/auth/scopes.ts`). Key finding: the layer already keys generically on `iss`+`sub` with intersection semantics, so **Tier 1 requires no code change** — only allowlist entries.
- **Delivered + pushed** address-independent Tier 1 test coverage.

### What changed (pushed to `kriscendobot/minion.town` `main`, commit `510cb4e`)
- `test/policy.test.ts`: new `describe` block covering a SIWE address-keyed identity — recognition, scope grant + guest-facet capability, intersection semantics on an address identity, `iss`+`sub` keying, and a guard that **checksum casing is load-bearing** (a lowercased `sub` is a distinct, unknown identity, so a mis-cased allowlist entry can never silently fail to match). Suite 14 → 19 tests, all green (`vitest run test/policy.test.ts`).

### Why it's a handoff, not a completion
Two genuine preconditions were unmet and cannot be satisfied by a builder:
1. **Decision 3 (tier)** was never recorded (`cleared=none`); Tier 2 is explicitly "if chosen" and was not chosen.
2. **The Tier 1 address allowlist** was absent from the job body, inbox, and journal. Fabricating Ethereum addresses into a production authorization policy would be a security defect, so `config/policy.json` was correctly left untouched.

I messaged the maintainer (`20260822T055203Z-ae527d`) requesting both, then polled for ~55 min with no reply; the job was reaped once and re-blocking would only loop.

### Handoff / follow-ups
- Parked successor **`wire-siwe-onchain-authz-minion-town-followup`** (durably on `origin/journal2` `jobs/plan/`, gate=deferred) owns all remaining work: add the maintainer's SIWE identities to `config/policy.json` once the allowlist arrives, and build Tier 2 (+ registry contract) only if the maintainer chooses it. It carries full context and the exact blocking questions, so it can be promoted and finished in minutes once the maintainer answers.

<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/wire-siwe-onchain-authz-minion-town.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 4 on 1 host(s) (2 unmetered)
- Input: 56 tokens (2138142 cached reads)
- Output: 27458 tokens
- Cost: $3.320956 (2 engagement(s) unpriced)
- Wall-clock: 719s
- Model(s): claude-opus-4-8 ×2

<!-- garden-usage-end -->
