---
gate: go-ahead
priority: normal
posted_by: designer
posted_at: 2026-07-07T22:57:26Z
---

---
role: builder
---

# Deploy the SIWE OIDC thunk (mirroring the GitHub thunk's AWS path)

**Repo (PRIVATE):** github.com/kriscendobot/minion.town — direct push to `main`, no PR. Work in an isolated per-job checkout (`scripts/jobs/ensure-project-worktree.sh <this-base> kriscendobot/minion.town main`). AWS CLI `~/.local/bin/aws`, region us-west-1. **Secrets only in Secrets Manager.**

Design: `designs/siwe-onchain-authz.md` (read § 1–2, § 5–7 first). Portable core + tested local toy already on `main` at `deploy/thunks/siwe/` (19/19 `npm test`). This job is the AWS binding ONLY — do not rework the core; the seam is `adapters/`.

Scope, mirroring `deploy/aws/lambda/github-oidc-thunk/` + `deploy/aws/scripts/deploy-thunk.sh`:
1. Lambda adapter (`deploy/thunks/siwe/adapters/lambda.js` or a `deploy/aws/lambda/siwe-oidc-thunk/` shim) — API Gateway HTTP API payload 2.0 (the account BLOCKS public Function URLs), esbuild-bundled ARM64 zip (viem+jose are real deps; NOT the zero-dep bare-file shape).
2. Single-use nonce/code store: one DynamoDB table with TTL attribute and conditional-delete consume, swapped in behind `makeSingleUseStore`'s interface. Add a size cap / per-IP throttle at the API Gateway layer (design § 5 DoS note).
3. Secrets: `minion/siwe-idp-signing-key` (RS256 PEM, generate + store), `minion/eth-rpc-url` (maintainer-provided keyed RPC — only needed if EIP-1271 is in per the maintainer's § 6.4 decision), Cognito OIDC client secret.
4. Caddy site `siwe-idp.minion.town` fronting the API (follow `conf.d/github-idp.caddy` + the SSM deploy recipe in DEPLOYMENT.md).
5. Cognito OIDC IdP `SIWE` on pool `us-west-1_mDaTgjr1m`, attribute mapping `sub → username`; resolve the email-less-identity wrinkle per the maintainer's answer to design § 8 Q2 (synthesized `<address>@siwe.minion.town` vs relaxed pool/gate) — do not guess; the answer should be in this job's body or inbox at promotion time.
6. Verify per the golden-path shape: discovery 200 byte-exact issuer; hosted-UI authorize chains Cognito → thunk wallet page; a full sign-in mints a Cognito token; update DEPLOYMENT.md's phase table.

PRECONDITION: the maintainer has answered design § 6 decisions 1 (chain) and 4 (EIP-1271/ENS v1 scope); this job is parked --go-ahead for exactly that reason.
