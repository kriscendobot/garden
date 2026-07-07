---
role: builder
---
<!-- garden-promoted-from-plan: gate=orchestrated priority=normal at=2026-07-07T06:07:30Z -->

# minion.town Phase 4: first-party authorization policy + identity-enriching pre-token Lambda

**Repo (PRIVATE):** github.com/kriscendobot/minion.town — bot repo, **direct push to `main`, no PR**. `gh` is authenticated as `kriscendobot` (admin). **Read `DEPLOYMENT.md` at the repo root FIRST** (architecture, AWS inventory, secret names, audience deviation, Caddy discipline). Phase 2 is done: the MCP server runs on the box as systemd `minion-mcp` at `/opt/minion-town`, deployed via the `deploy/aws/scripts/` recipe — reuse it, don't invent a second deploy path.

Isolated checkout:

    /home/kris/garden2/scripts/jobs/ensure-project-worktree.sh minion-town-phase4-authz-policy kriscendobot/minion.town main

AWS CLI `~/.local/bin/aws`; box access **SSM only** (`i-0380cd68b90020fad`, us-west-1). Keep the box light. **Secrets only in Secrets Manager.**

## Part A — policy (portable app layer)

- `config/policy.json`: maps **identities keyed on `iss`+`sub`** (plus a human-readable email/note per entry) to the scopes they are granted. Include entries for the maintainer-facing identities known so far (the break-glass user; the test clients from Phase 2's § Secrets) — grant the read-only test identity only `mcp/tools` + `mcp/minions:read`.
- `src/auth/policy.ts`: load the policy; the server computes a caller's **allowed tools = intersection(policy-granted scopes for this iss+sub, token scopes)**. A tool call outside that set is denied with the OAuth `insufficient_scope` error shape (403). Unknown identity → baseline deny (only what the policy's default entry, if any, grants). No AWS SDK imports in `src/`; the policy path comes from config/env.
- Unit tests for the intersection and the deny path; `npm test` green.

## Part B — pre-token-generation V2 identity Lambda (`deploy/aws/lambda/pre-token-gen/`)

Build the Lambda that enriches the **access token** with human identity claims — email and upstream provider — so the policy (and audit) can key on who the human is even through federated logins. This is for **identity, NOT for `aud`** (Cognito cannot stamp a resource-URL audience; see DEPLOYMENT.md § audience deviation). Prior art: `infra/lambda/token-customizer.js` from the superseded CDK era — its V2_0 event shape is reusable, its aud-stamping goal is dead.

- Plain Node Lambda (ARM64), no framework. Create an execution role (basic logs only), `aws lambda create-function`, then attach to pool `us-west-1_mDaTgjr1m` with `aws cognito-idp update-user-pool --lambda-config 'PreTokenGenerationConfig={LambdaVersion=V2_0,LambdaArn=...}'` (the pool is already on the Essentials tier, which V2_0 requires) plus the `lambda add-permission` for cognito-idp. **Careful: `update-user-pool` replaces the whole config — read the current pool config first and preserve every existing setting.**
- Client-credentials tokens never pass through user triggers; the policy must therefore key test clients by their `sub` (= client id) directly.

## Part C — deploy + verify

- Deploy the updated server + `config/policy.json` to the box via the Phase 2 deploy script; restart `minion-mcp`.
- **Verify live:** a token for the read-only identity (the restricted test client; create it as `minion/test-cc-readonly` with only `mcp/tools` + `mcp/minions:read` scopes if Phase 2 didn't) can call `minion_status`/`list_minions` but is denied `summon_minion` with `insufficient_scope`; the full-scope test client still gets `summon_minion` 200. For the Lambda: a hosted-UI user token (or the Lambda's CloudWatch log from a test invoke with a V2_0 sample event) shows the enrichment claims.

## Definition of done

Policy + policy.ts + Lambda source pushed to `main`; Lambda attached to the pool; box redeployed; the deny/allow verification evidence is in your report. Update only your row in DEPLOYMENT.md § Phase plan and add new secret names to § Secrets. Note for coordination: Phases 5 and 6 may be running concurrently — you don't touch Caddy config, and they don't touch the pool's Lambda config or `src/`; if you push to `main` and are rejected, rebase and retry.
