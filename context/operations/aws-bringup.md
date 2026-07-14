# Bringing the garden up on AWS

A living record of standing up the garden's AWS footprint and extending it with
services — what exists, how it was decided, and the gotchas, so a future session
picks up without re-deriving. Reusable credential mechanics live in the
[`aws-administration`](../../skills/aws-administration/SKILL.md) skill; this page is
the narrative + resource inventory. Secrets are never here, only where they live.

## Account, identity, credentials

- **Account** `292378781985`, **region** `us-west-1` (nearest SF), **principal** IAM
  user `garden-fleet` (managed `AdministratorAccess`, deliberately off root; root
  used once via `aws login` OAuth only to mint it).
- **One access key**, hard-linked (not symlinked) across `~/.aws`, `~/garden/.aws`,
  `~/garden2/.aws` (one inode) so each container sees it; `.aws/credentials`
  gitignored. Fragility: a write-temp-then-rename rewrite (hand rotation) breaks the
  hard link — `relink-aws-creds.sh` is the fix.
- **CLI**: AWS CLI v2 user-local (`~/.local/aws-cli`, shim `~/.local/bin/aws`, no
  root). Installed on the host (2026-07-06) and again in-container (host `~/.local`
  is a different home than the container). Gotchas: `/tmp` is `noexec` — extract/run
  the installer under `$HOME`; `sudo` elevates to root in-container (used for `apt`,
  e.g. `dnsutils`).
- **Open follow-ups (maintainer, root-touching):** delete legacy root access keys;
  enable root MFA. Scope `garden-fleet` down from AdministratorAccess once a
  workload's permission surface is known.
- The **`aws-administration` skill** (fleet job `build-aws-administration-skill`)
  encodes install/rotate/verify; this doc stays the narrative.

## minion.town — the deployed web + service host

A single EC2 host fronted by Caddy serves `https://minion.town`, path-routing to a
local service, an S3 static bucket, and (later) Lambda. Decisions (2026-07-07,
maintainer): external registrar delegates DNS to Route53; **Caddy-on-host** ends TLS
(not ALB/CloudFront, for cost); **`t4g.medium`** (headroom for a garden fleet, not
just a web service). Lightsail was ruled out — not offered in `us-west-1`.

Resource inventory (us-west-1, tag `project=minion-town`):

| Resource | ID / value |
| --- | --- |
| EC2 instance | `i-0380cd68b90020fad` (`minion-town-garden`, t4g.medium, Ubuntu 24.04 ARM64 `ami-0b9023009667261d9`, 20 GB gp3, IMDSv2, us-west-1a) |
| Elastic IP | `13.56.17.18` (alloc `eipalloc-0117f8c4733f12795`, assoc `eipassoc-066fa00b60048d929`) |
| IAM role / instance profile | `garden-ec2-ssm` (`AmazonSSMManagedInstanceCore`) |
| Security group | `sg-0f2cf8d86744b7293` (`minion-town-web`; in 80/443 v4+v6; SSH closed) |
| VPC / subnets | default `vpc-0c46f09151a4f36ba`; `subnet-080cb735beab73b45` (1a), `subnet-006db3689a836ac19` (1c) |
| Route53 zone | `Z05121952LNOCCNVIXFAO` (`minion.town`); apex + `www` A → EIP, TTL 300 |
| S3 static bucket | `minion-town-static` (public static website; public-read `GetObject` only) |

- **DNS delegation:** registrar NS point at Route53 — `ns-1466.awsdns-55.org`,
  `ns-227.awsdns-28.com`, `ns-1582.awsdns-05.co.uk`, `ns-952.awsdns-55.net`.
  Registrar→`.town`-registry propagation took ~15 min (confirmed cache-free by
  querying a `.town` TLD server directly).
- **TLS:** Caddy auto-issues/renews Let's Encrypt (ACME account
  `endolinbot@users.noreply.github.com`). `https://minion.town` is **live** — valid
  cert, TLS 1.3; plain HTTP → 308 → HTTPS.
- **Routing today** (`/etc/caddy/Caddyfile`): `/static/*` → S3 website endpoint
  (`handle_path` strips the prefix, `header_up Host` set — S3 routes by Host);
  default `/` → placeholder. Verified end-to-end (`/static/` → `server: AmazonS3,
  via: Caddy`).
- **Access:** SSM only, no SSH — `aws ssm start-session --target
  i-0380cd68b90020fad --region us-west-1`.
- **Operate Caddy / any box file** via SSM: `aws ssm send-command`
  (`AWS-RunShellScript`) → base64-decode into the target path → `caddy validate`
  (gates the reload) → `systemctl reload caddy`.
- **Cost:** ~$26/mo at rest (t4g.medium ~$24 + 20 GB gp3 ~$1.60 + zone $0.50; EIP
  free while associated; S3/Lambda negligible).

## minion.town OAuth (MCP resource server + web login gate)

Model: third-party authN (Google/GitHub, later SIWE) federated through **one Cognito
broker**; **first-party authZ** owned by minion.town (a local identity→permissions
policy). Reuses the existing MCP server in `kriscendobot/minion.town`. Full plan:
`.claude/plans/functional-juggling-metcalfe.md`.

Phase 1 — Cognito broker (done, us-west-1):

| Resource | ID / value |
| --- | --- |
| User pool | `us-west-1_mDaTgjr1m` (Essentials, self-signup off, deletion-protected) |
| Issuer | `https://cognito-idp.us-west-1.amazonaws.com/us-west-1_mDaTgjr1m` |
| Resource server / scopes | `mcp` → `mcp/tools`, `mcp/minions:read`, `mcp/minions:write` |
| Hosted-UI domain | `minion-town.auth.us-west-1.amazoncognito.com` (ACTIVE) |
| MCP public client (PKCE) | `1uesun672b9a0lidth983v0vc9` |
| Web-gate confidential client | `1ado9v94gl9lpufejiekpehnli` (secret → Secrets Manager `minion/web-gate-client`) |
| Break-glass admin | `breakglass@minion.town` (sub `e9a9096e-70d1-7080-33b2-827cf49ec38e`; creds → `minion/breakglass-user`) |

- Verified OIDC discovery + JWKS 200. Provisioned via `aws` CLI.
- **Audience correction (Cognito limitation, AWS docs):** the pre-token trigger
  cannot set an arbitrary `aud` — it "must match the app client ID," so strict
  RFC 8707 audience=resourceURL is unachievable. The MCP verifier instead validates
  **`client_id` ∈ {`1uesun672b9a0lidth983v0vc9`} + `iss` + `mcp/*` scopes**. The
  pre-token Lambda consequently moves to Phase 4 (identity enrichment, not audience).

**Architecture directive (maintainer):** minion.town is a **deployment +
configuration layer**, not a code home — the garden and the Endo MCP server code
live in their own open repos; minion.town holds only config + deployment. Keep
coupling **loose / provider-portable** (the AWS binding stays separable so the same
components can later target CloudFlare, Netlify, others).

**Fleet handoff (2026-07-07):** `kriscendobot/minion.town` set **private** (was
public). Orchestrator job `orchestrate-minion-town-oauth-deploy` (`role: orchestrator`,
`model: fable`) posted and claimed; it drives Phases 2–6 (MCP server on the box,
Google + GitHub federation, first-party authz, web login gate), fanning independent
phases out as parallel children, and reconciles the superseded parked jobs
(`synth-and-deploy-minion-town-aws`, `cognito-mcp-metadata-bridge`). It will request
a Google OAuth client and a GitHub OAuth App from the maintainer (secrets → Secrets
Manager).

### minion.town billing — Stripe credits (maintainer setup, TEST mode)

Design + tested toy: `designs/stripe-credits.md` + `src/billing/` in
`kriscendobot/minion.town`. Model: any authenticated user buys credits at **1¢ per
credit** (config `CREDIT_UNIT_CENTS`); credits accrue to the `credits` field on the
`minion-town-accounts` DynamoDB row; purchase via Stripe Checkout; a
**signature-verified** webhook credits **exactly-once** (marker table
`minion-town-billing-events` + a single `TransactWriteItems`). Obtaining credits only
— spending/metering is a later phase (debit seam shaped, not built).

**Maintainer setup — from an existing Stripe account, TEST mode only:**
1. Stripe Dashboard → toggle **Test mode**.
2. Developers → API keys → copy `sk_test_…` (secret) + `pk_test_…` (publishable).
3. Developers → Webhooks → **Add endpoint**: URL `https://minion.town/billing/webhook`;
   events `checkout.session.completed` + `checkout.session.async_payment_succeeded`;
   reveal + copy its **signing secret** `whsec_…`. (Stripe doesn't verify reachability
   at creation, so the endpoint may be added before the deploy exists.)
4. Store all three in Secrets Manager `minion/stripe` (create first time, else
   `put-secret-value` to update):

   ```sh
   aws secretsmanager put-secret-value --secret-id minion/stripe --region us-west-1 \
     --secret-string '{"secret_key":"sk_test_…","publishable_key":"pk_test_…","webhook_secret":"whsec_…"}'
   ```

   The build **refuses live keys** (`sk_live_`/`pk_live_`). All three fields are
   required — an empty `webhook_secret` blocks the deploy (it is the signature-
   verification boundary; without it, webhooks can't be trusted to credit accounts).

**Then** promote the parked builder job `deploy-stripe-credits-minion-town` (the box
binding: billing routes, the events table, attribute-scoped IAM, Caddy `/billing/*`,
the "Buy credits" control), which verifies the live test-mode loop end-to-end
(test card `4242…`).

## Turnkey garden host — private AMI + launch template

A one-click EC2 garden host with Docker, a reviewed garden checkout, and the
container image already built — with **no** Claude/GitHub/user secret in the AMI,
launch template, repository, or user-data. Design:
[`designs/turnkey-garden-host.md`](../../designs/turnkey-garden-host.md); operator
runbook: [turnkey-host.md](turnkey-host.md); pipeline: `scripts/aws/turnkey/`.
First release baked + smoke-tested end-to-end 2026-07-14.

Resource inventory (us-west-1, tag `project=garden-turnkey`):

| Resource | ID / value |
| --- | --- |
| AMI (private, ARM64) | `ami-0fbfe0b799310072d` (`garden-turnkey-edcab025d554-20260714T184036Z`) |
| Backing snapshot | `snap-0285a9fd494ba6e6c` (50 GiB, encrypted) |
| Launch template | `lt-0640cc0640c5e2244` (`garden-turnkey`, v1 default) |
| IAM role + instance profile | `garden-turnkey-ssm` (`AmazonSSMManagedInstanceCore` only) |
| Security group (launch) | `sg-0779a404a970ce42b` (`garden-turnkey`; **no inbound**, egress default) |
| Security group (smoke test) | `sg-01a9c9fa35a51fc64` (`garden-turnkey-test`) |
| Base AMI (pinned) | `ami-0b9023009667261d9` (Canonical `ubuntu-noble-24.04-arm64-server-20260626`) |
| Source commit baked | `edcab025d554…` on `main2` |

- **Immutable AMI tags:** `garden:source-commit`, `garden:base-ami`,
  `garden:architecture=arm64`, `garden:build-timestamp`. A rebuild is a new AMI +
  new launch-template version, never an in-place patch.
- **Hardening (verified):** launch template requires IMDSv2 (`HttpTokens=required`),
  encrypted gp3 root, no user-data, no key pair; SG has zero inbound rules; role
  carries only the SSM managed policy (no inline secret grant).
- **Access:** SSM only — `aws ssm start-session --target <id>`, or `ssh` over
  `AWS-StartSSHSession`. Port 22 is closed to the internet; the device-auth login
  runs interactively over that SSM-tunnelled CLI (no secret handoff).
- **Smoke result (2026-07-14, on a throwaway `t4g.medium` in the test SG, then
  terminated):** SSM reachable; `./garden create` starts the container from the
  **prebuilt** `garden-ubuntu` image; **no** pre-existing Claude/GitHub auth. PASS.
- **Cost:** the bake ran a `m7g.xlarge` builder (~25 min, cents) + a brief
  `t4g.medium` smoke instance; both terminated. Ongoing: only the AMI's snapshot,
  billed on actual used blocks (~10–15 GiB, not the 50 GiB volume) ≈ $0.50–0.75/mo
  while the AMI is retained. No instance runs unless launched. Teardown:
  `scripts/aws/turnkey/teardown.sh [--ami <id>|--all]`.
- **Known follow-up:** the shared `Dockerfile` fetches an amd64 Ollama ROCm bundle
  unconditionally; on Graviton it is inert dead weight (no AMD GPU). Arch-guard it
  to shrink the turnkey bake (tracked in the design's § Implementation).
