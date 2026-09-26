The SIWE OIDC thunk is deployed, wired, and verified live. Final report:

---

## Deploy the SIWE OIDC thunk (AWS binding) — complete

**Repo:** `kriscendobot/minion.town` `main` @ `2570cce` (direct push, 3 commits, bot identity `endolinbot`; cleanly rebased over a concurrent open-signup design commit, no conflict). Supersedes parked `deploy-siwe-thunk-minion-town` (that was not run).

### What I built (the AWS binding; the portable core was not reworked)
- **`adapters/lambda.js`** — API Gateway HTTP API payload-2.0 adapter (Function URLs are blocked account-wide), esbuild-bundled ARM64 zip (viem + jose bundled, `@aws-sdk/*` external).
- **`adapters/dynamodb-store.js`** — one DynamoDB table (`minion-siwe-thunk-store`, on-demand, TTL on `expires`) backs both single-use stores; consume is an atomic `DeleteItem ReturnValues=ALL_OLD` (correct across concurrently-warm containers).
- **Core seam:** the core's store interface is *synchronous* and `issueChallenge` is sync (the toy's `assert.throws`/sync calls depend on it), so I did **not** make the core async. The adapter bridges to async DynamoDB with a preload/drain buffer (consume from DynamoDB before the core reads, flush the core's writes after, both awaited in-invocation so nothing is lost to a frozen container). The only core change is a **2-line additive store-injection point** in `makeOpenId` — **19/19 toy tests stay green** (verified before and after).
- **Email-less identity:** `/userinfo` synthesizes `<address>@siwe.minion.town` (`email_verified:false`) in the adapter; pool/gate email requirement **not** relaxed; authz keys on `iss`+`sub`; no allowlist gate for SIWE.
- **Deploy scripts:** `deploy-siwe-thunk.sh` (table + 3 secrets + IAM role + bundle + Lambda + HTTP API + stage throttle) and `deploy-cognito-siwe-idp.sh`; plus `conf.d/siwe-idp.caddy` and the Route53 A record.

### What changed in AWS (live)
- Lambda `minion-siwe-idp-thunk` + HTTP API `6h9qv3xunb` (fronted by Caddy `siwe-idp.minion.town`, Route53 A → `13.56.17.18`, Let's Encrypt cert issued). `$default` stage throttle rate 50/s burst 100 (DoS bound, design § 5).
- DynamoDB `minion-siwe-thunk-store`; secrets `minion/siwe-idp-signing-key`, `minion/siwe-cognito-client`, `minion/eth-rpc-url` (public mainnet RPC default). All secrets in Secrets Manager only, injected as Lambda env at deploy; the Lambda reads none at runtime (role = DynamoDB Put/Delete + logs).
- Cognito OIDC IdP `SIWE` on pool `us-west-1_mDaTgjr1m`; both clients now list `COGNITO GitHub Google SIWE` (GitHub/Google preserved via read-modify-write). Mainnet, EIP-1271 in / ENS out.

### Verified (real execution, evidence)
- **Discovery** `https://siwe-idp.minion.town/.well-known/openid-configuration` → 200, `issuer` **byte-exact** `https://siwe-idp.minion.town`; JWKS one RS256 key.
- **Full headless EOA sign-in through the domain** (challenge→sign→verify→token→userinfo): id_token JWKS-verifies (`sub` = checksummed address, `wallet_type=eoa`, `chain_id=1`); `/userinfo` carries the synthesized email. **Nonce replay rejected and code reuse rejected** — proving DynamoDB atomic single-use across separate invocations (the property in-memory couldn't give).
- **Cognito hosted-UI** `?identity_provider=SIWE` → 302 → SIWE thunk → renders the wallet page ("Sign in with Ethereum — minion.town").
- **Login-page button chain** (curl-traced end to end): the page renders `value="SIWE"` / "Continue with Ethereum"; `/oauth2/start?identity_provider=SIWE` → Cognito with `identity_provider=SIWE` → SIWE thunk wallet page. The "login option is not available" defect (missing IdP) is resolved.

### Not verified / caveats (honest)
- **No actual in-browser click of the button.** No browser tool is available in this environment; I traced the exact HTTP redirect chain the button fires and fetched the rendered wallet-page HTML it lands on, and drove a full headless EOA sign-in — but I did not drive a MetaMask popup / rendered-DOM browser session. The structural defect (IdP absent) is fixed and the chain reaches the wallet page.
- **EIP-1271** code path was proven in the toy against a mock chain (tests 17–19); a mainnet RPC is configured, but I did not exercise a live contract-wallet sign-in (needs a deployed Safe/4337 wallet).
- **RPC** is the public default `https://ethereum-rpc.publicnode.com`; DEPLOYMENT.md notes it should be swapped for a keyed/private RPC (RPC-as-oracle threat, design § 5).

### Follow-ups
- Swap `minion/eth-rpc-url` for a keyed/private RPC before relying on EIP-1271 at scale.
- True per-IP throttling (WAF rate rule) if the challenge endpoint sees abuse; current cap is global.
- The separate authz-tier wiring (design § 7 job 2) remains a distinct job; this was the IdP binding only.

DEPLOYMENT.md updated: Phase 8 row + section, Caddy ownership, Secrets, Phase 7 SIWE note (self-healed), golden-path item 6.

Self-improvement: nothing this time.
