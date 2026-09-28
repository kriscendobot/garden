---
tier: minion
model-burned: mentor
fallback-tier: 
dispatch: automatic
---
# Build: register SIWE as a recovery-bond provider on minion.town

**Repo:** github.com/kriscendobot/minion.town (base `main`). Open a DRAFT PR (manual-gauntlet regime; stop at draft).

Maintainer decision (kriskowal, PR #80 review https://github.com/kriscendobot/minion.town/pull/80#pullrequestreview-5344829305, 2026-09-28): ADAPT SIWE now; drop on-chain holdings and on-chain registry; do the wiring now because the recovery baseline is ready. Design: `designs/siwe-invitation-pivot.md` (§ 2, § 4, § 6 "Under ADAPT", § 8) + `designs/invitation-only-guest-onboarding.md` § 5.

Task: register the deployed `siwe-idp.minion.town` OIDC issuer (iss `https://siwe-idp.minion.town`, sub = EIP-55 checksummed address) as one more optional recovery-bond provider in the existing account/recovery layer (`src/auth/accounts.ts`, guest web router recovery routes, `deploy/aws/www/guest.{js,html}` "Add a recovery provider"). A SIWE bond is a recovery pointer only: no admission, no scopes, no `config/policy.json` entries, no allowlist, no on-chain reads for authorization. Checksum casing is significant. Add tests. Confirm the issuer is inert under the current scope-based path (no SIWE policy entries). If a live Cognito IdP binding or deploy step is needed and it isn't already in the repo, surface it in the PR body instead of doing it by hand.

<!-- garden-transient-elapsed: kind=signature through=0 values=1112 -->

<!-- garden-reaped: 1 -->
<!-- garden-plain-retry-not-before: 2026-09-28T22:23:05Z -->

---
claim:
  host: oros-studio-garden-ce242c49
  gardener: 1
  worker_kind: monk
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-09-28T22:31:27Z
