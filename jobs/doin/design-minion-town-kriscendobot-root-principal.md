---
role: designer
tier: mentor
fallback-tier: minion
arc: minion-town-mcp-ocapn
dispatch: automatic
---
**Role: designer.** Design a **non-interactive root MCP principal for kriscendobot** on minion.town, so the fleet can run the production Claude canary (https://github.com/kriscendobot/garden/issues/89 items 4–5) without a human completing GitHub web sign-in. Land it as a **design PR on https://github.com/kriscendobot/minion.town** for maintainer review. This is security-weighted: name every open question and do not implement anything.

**Why (maintainer decision, kriskowal, liaison muster 2026-10-07: "give the fleet a way in").**
- minion.town#165 (per-guest inbox responders) is merged and deployed at `d750b09b`.
- kriscendobot's Claude subscription credential is already present and active in production.
- The canary still needs a **root** MCP OAuth session for kriscendobot. Today that only comes from GitHub web login, which needs kriscendobot's password and MFA. The fleet holds only a gh API token.
- The one non-interactive principal, `minion-mcp-test-cc` (Cognito client credentials, then `/mcp`), is **not root**: its `tools/list` has no Claude tools, and the production responder index is absent.
- Evidence: the `kriscendobot-minion-town-pr165-deploy-validate-20261007-review5436814684` reports and orchestration `kriscendobot-minion-town-pr165-conduct-deploy-validate-5436814684` (halted).

**The design should cover:**
- The mechanism. Candidates: a scoped client-credentials grant bound to kriscendobot's root subject; a token minted once by the maintainer and held in SSM, with rotation; or a delegated, attenuated root capability.
- Scope and attenuation: exactly which root tools the canary needs, versus full root.
- Where the secret lives and who can read it, given the containment notes in the minion.town security review.
- Expiry, rotation, and revocation.
- Audit: every use must be attributable.
- Blast radius if a garden host is compromised.
- How the canary job consumes it.

Prefer the least-authority option that unblocks the canary. Build on existing Cognito and OAuth paths over a bespoke mechanism, and say why if you diverge.

**Done when** a design PR is open on kriscendobot/minion.town with an `## Open questions` section for the maintainer.

---
claim:
  host: endolin-garden2-5bcdff64
  gardener: 2
  worker_kind: monk
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-10-07T22:02:05Z
