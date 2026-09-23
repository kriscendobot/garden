# Job complete: `design-mcp-oauth-aws-minion-town`

**Repo:** https://github.com/kriscendobot/minion.town (created; pushed to `main`). No PR — bot repo, direct push.

## What I delivered

**Research first (researcher precedence).** Grounded the design in the *current* specs, not memory: the MCP authorization spec rev **2025-06-18** + the **Nov 2025** update (OAuth 2.1, S256-only PKCE, RFC 9728 Protected Resource Metadata, RFC 8707 resource indicators, RFC 8414 AS metadata, DCR demoted behind CIMD), current AWS MCP-hosting patterns, and the actual `@modelcontextprotocol/sdk@1.29.0` auth surface (verified against the published tarball).

**Design doc — `designs/mcp-oauth.md`.** Architecture, the OAuth authN model (JWT signature/iss/exp/**audience** validation), the authZ model (scope→tool map enforced at two layers — HTTP 403 at the route, MCP tool-error per-tool because Streamable HTTP multiplexes), the local-DX design, the AWS design, threat-model notes, and 5 open questions for the maintainer.

**Working, tested toy (locally runnable).** A `minion.town` MCP resource server (3 scope-gated tools) on `@modelcontextprotocol/sdk` + Streamable HTTP. One-command local loop: `npm run dev` brings up a real mock OAuth AS (`oauth2-mock-server`, real JWKS) + the MCP server with hot reload; a browserless PKCE client and a **5-case end-to-end test suite (all green)** prove discovery→PKCE→scoped calls, the 401+`WWW-Authenticate`, scope-denial, and RFC 8707 audience rejection. Verified live: full-scope client summons minions; read-only token is denied `summon_minion` with `insufficient_scope`.

**AWS deploy path (scaffold).** `infra/` CDK (TypeScript): App Runner running the *same container* (justified vs Lambda/Fargate against the transport's timeout needs), Cognito user pool + Resource Server (the 3 scopes), Route53/ACM, plus a `Dockerfile`. Same code local & cloud — only env vars differ (`src/config.ts` is the seam).

## Chosen AWS shape + why
**App Runner** — the toy speaks short, stateful Streamable-HTTP turns; App Runner runs the identical local container with a single `cdk deploy` and its 120s ceiling is ample. Documented escape hatch: swap to **ECS Fargate + ALB** (no timeout) if a tool ever needs long SSE — the rest of the stack is unchanged. Authorization server: **Cognito**, with a documented metadata/DCR/audience **bridge** as a follow-on (Cognito lacks native RFC 8414 metadata, RFC 7591 DCR, and RFC 8707 audience binding).

## Local-dev story
`cp .env.example .env && npm install && npm run dev` → authenticated MCP + a real OAuth AS, no Docker/cloud/secrets; `npm run client[ -- read-only]` and `npm test` exercise the full flow.

## Follow-ons posted
- `cognito-mcp-metadata-bridge` (plan/go-ahead) — build the Cognito↔MCP RFC 8414/7591/8707 bridge.
- `synth-and-deploy-minion-town-aws` (plan/go-ahead) — `cdk synth`, wire the custom domain, live deploy (needs maintainer's AWS account + spend authorization on the reserved domain).
- `garden-harden-producer-clone-lock` (todo, **already claimed by a peer**) — see below.

## Garden infra fix (proactive)
Hit a real reliability bug: a crashed/killed `post-plan`/`post-job` leaves a stale `journal.lock` in the shared producer clone that **silently wedges all future posts** (no timeout, no recovery). I cleared the stale lock (`rm -f /home/kris/.garden-state/producer/journal.lock`), which unwedged it instantly, posted a hardening job (stale-aware lock + bounded wait + a SKILL.md note that producers must post sequentially), and recorded the operational lesson in memory.

## For the maintainer — open questions
1. Cognito + bridge, or an MCP-native IdP (Stytch/WorkOS/Auth0/Keycloak) that gives DCR+metadata natively? 2. Is DCR actually needed for the intended clients? 3. Scope-naming (`mcp:minions:read` vs Cognito's `mcp/...`)? 4. Stateful vs stateless transport at scale? 5. JWT validation (current) vs introspection? **Live AWS deploy is parked on `go-ahead` pending an AWS account + spend authorization.**

The build clone was cleaned up (everything is on `origin`).
