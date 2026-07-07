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
