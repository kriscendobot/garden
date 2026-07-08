---
role: builder
---

# Deploy the SIWE OIDC thunk (AWS binding) — GO, maintainer decisions confirmed

**Repo (PRIVATE):** github.com/kriscendobot/minion.town — direct push to `main`, no PR. Isolated checkout: `scripts/jobs/ensure-project-worktree.sh <this-base> kriscendobot/minion.town main`. AWS CLI `~/.local/bin/aws` (install via `bash scripts/aws/install-aws-cli.sh` from the garden repo if absent), region us-west-1. Box access SSM only (`i-0380cd68b90020fad`). **Secrets only in Secrets Manager.** This **supersedes the parked `deploy-siwe-thunk-minion-town`** — do not also run that.

Design: `designs/siwe-onchain-authz.md` (read § 1–2, § 5–7). Portable core + tested toy already on `main` at `deploy/thunks/siwe/` (19/19 `npm test`). This job is the **AWS binding ONLY** — do not rework the core; the seam is `adapters/`. Mirror `deploy/aws/lambda/github-oidc-thunk/` + `deploy/aws/scripts/deploy-thunk.sh`.

## Scope
1. Lambda adapter (`deploy/thunks/siwe/adapters/lambda.js` or a `deploy/aws/lambda/siwe-oidc-thunk/` shim) — API Gateway HTTP API payload 2.0 (the account BLOCKS public Function URLs), esbuild-bundled ARM64 zip (viem+jose are real deps; NOT the zero-dep bare-file shape).
2. Single-use nonce/code store: one DynamoDB table with a TTL attribute + conditional-delete consume, behind `makeSingleUseStore`'s interface. Size cap / per-IP throttle at the API Gateway layer (design § 5 DoS).
3. Secrets: `minion/siwe-idp-signing-key` (RS256 PEM — generate + store), `minion/eth-rpc-url` (see decision), the Cognito OIDC client secret.
4. Caddy site `siwe-idp.minion.town` fronting the API (follow `conf.d/github-idp.caddy` + the SSM deploy recipe in DEPLOYMENT.md; add the Route53 A record → `13.56.17.18`).
5. Cognito OIDC IdP `SIWE` on pool `us-west-1_mDaTgjr1m` (attribute mapping per the email-less decision below); add `SIWE` to both app clients' `SupportedIdentityProviders` via read-modify-write (`update-user-pool-client` replaces whole config — preserve `COGNITO GitHub Google`).
6. Verify: discovery 200 byte-exact issuer; hosted-UI `authorize?identity_provider=SIWE` chains Cognito → the thunk wallet page; a full sign-in mints a Cognito token. **Confirm the live login page's "Continue with Ethereum" button now completes** (the current "login option is not available" defect is exactly this IdP being absent). Update DEPLOYMENT.md's phase table.

## Maintainer decisions (confirmed 2026-07-08, via liaison)
- **§6.1 chain:** Ethereum **mainnet** for identity.
- **§6.4 v1 scope:** EIP-1271 **IN**, ENS **OUT**.
- **§8 Q2 email-less identity:** use the **synthesized email `<address>@siwe.minion.town`** (do NOT relax the pool/gate email requirement) — consistent with the email-centric oauth2-proxy gate; the first-party policy keys on `iss`+`sub` regardless.
- **RPC (`minion/eth-rpc-url`):** no keyed RPC provided — **default to a public Ethereum mainnet RPC** (e.g. `https://ethereum-rpc.publicnode.com`) for v1; note in DEPLOYMENT.md that it should be swapped for a keyed/private RPC later (design § 5 RPC-as-oracle threat).
- **Context — open self-signup is coming** (separate design job): the site is moving to admit *all* authenticated users with first-party baseline authz. Deploy SIWE consistent with that — do NOT hardcode an allowlist gate for SIWE identities; a new wallet authenticates like any other federated identity.

Keep coupling loose; secrets only in Secrets Manager; don't lock out the maintainer.
