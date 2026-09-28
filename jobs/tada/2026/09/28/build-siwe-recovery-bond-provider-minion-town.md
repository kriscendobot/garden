All verification passes. The prior attempt completed the deliverable and pushed it; the session died before signaling completion. The work is genuinely complete — no redo needed.

## Completion report

**Job:** Build — register SIWE as a recovery-bond provider on minion.town.

**State re-derived:** DRAFT PR **#133** (`build/siwe-recovery-bond-provider` → `main-c6788df`, which currently equals `origin/main` at `c6788df`) already exists, carrying the durable `<!-- garden-job: build-siwe-recovery-bond-provider-minion-town -->` marker. Single commit `964554e` is pushed and on the PR. This attempt adopted it rather than opening a duplicate.

**Verified in a fresh isolated project worktree at the PR head:**
- `npm run typecheck` — clean.
- `test/siwe-recovery.test.ts` — 7/7 pass (Keccak-256 digests, EIP-55 vectors, non-canonical casing refusal, provider issuer/name/subject rules, policy inertness).
- `test/web/guest-web-http.test.ts` — 9/9 pass (SIWE bond+recover on `(https://siwe-idp.minion.town, EIP-55 address)`; lowercase/uppercase/wrong-checksum/empty subjects fail closed with nothing filed; no cross-recovery between SIWE and pool keys; bearer+gate secret still required; other providers and unregistered-SIWE stay on the pool key).
- `deploy/aws/lambda/pre-token-gen/self-test.js` — all assertions pass (`idp_sub` on ID token only, casing preserved, absent for native users).

**What the delivered PR does (matches spec):**
- Registers the deployed `siwe-idp.minion.town` OIDC issuer (`iss https://siwe-idp.minion.town`, `sub` = EIP-55 checksummed address, byte-exact) as one more optional recovery-bond provider in the existing guest recovery layer (`src/web/guest-web-router.ts` `recoveryProviders` registry, `src/auth/siwe-recovery.ts`, `src/auth/eip55.ts`, `deploy/aws/www/guest.html` "Add a recovery provider" links).
- SIWE bond is a recovery pointer only: no admission, no scopes, no `config/policy.json` entries, no allowlist, no on-chain reads. Inertness is asserted by a test (`(siwe-idp, address)` → no scopes; no SIWE issuer entries in policy).
- Checksum casing is significant; non-canonical casings fail closed with 401, no fallback to the pool subject.
- `SIWE_RECOVERY_ISSUER` config allows unregistering SIWE (then it reverts to today's pool-subject behavior).

**Surfaced to the maintainer in the PR body (not done by hand, per spec):**
- Deploy ordering (pre-token-gen Lambda → oauth2-proxy → Caddy+app) and live-only checks (Cognito `identities[0].userId` casing, header-spoofing strip, linked-identity ordering).
- A scope-path finding: a *Cognito-federated* SIWE login is still auto-provisioned as `guest` under `ACCOUNT_AUTOPROVISION=on` (pre-existing behavior, unchanged here); two options offered for a maintainer decision.

**Follow-ups:** none on my side. The build correctly stops at an open DRAFT PR under the manual-gauntlet regime; promotion to review awaits an explicit **run the gauntlet #133**. The maintainer-decision items above live in the PR body.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/build-siwe-recovery-bond-provider-minion-town.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 2 on 1 host(s)
- Input: 122 tokens (5414614 cached reads)
- Output: 43141 tokens
- Cost: $3.459360900000001
- Wall-clock: 1322s
- Model(s): claude-opus-5-5 ×1, claude-opus-4-8 ×1

<!-- garden-usage-end -->
