The engine is already moving: stage 1 is `state: running` and the watcher has promoted `minion-town-deployment-doc` off `plan/` into the claim queue. My inbox is empty. Setup is complete — the deterministic orchestrate watcher now drives everything.

## Completion report: `orchestrate-minion-town-oauth-deploy`

**Set up the full two-stage orchestration for the minion.town OAuth deployment (Phases 2–6); the deterministic engine is already driving it** — stage 1 was promoted to `running` within a tick of being recorded. Both maintainer-input asks are posted, and both stale prior jobs are reconciled.

### The decomposition (why two stages)

The orchestrate engine expresses serial or parallel, not a DAG, so the plan's shape (Phase 2 first, then a 4-way fan-out) is encoded as:

- **`minion-town-oauth-stage1`** (serial, on-child-failure=halt, RUNNING): `minion-town-deployment-doc` → `minion-town-phase2-mcp-server` → `minion-town-oauth-fanout`. The doc child commits `DEPLOYMENT.md` (full draft embedded in its body: architecture, provider-portability boundary under `deploy/aws/`, AWS/Cognito inventory, the documented RFC 8707 audience deviation with client_id-allowlist verification, Caddy `conf.d/` file-ownership discipline, phase/state table, golden path) and closes superseded draft PR #2. Phase 2 fixes `mcp:`→`mcp/` scopes and the verifier, deploys `minion-mcp` + Caddy routes via SSM, and verifies PRM/401/token-200 — including creating a `client_credentials` test client (`minion/test-cc-client`), since Cognito grants custom scopes only through its OAuth endpoints, not password auth.
- **`minion-town-oauth-stage2`** (parallel, on-child-failure=continue): Phases 3 (Google IdP), 4 (policy + pre-token-gen V2 identity Lambda), 5 (GitHub OIDC thunk + 5-endpoint contract), 6 (oauth2-proxy web gate). Its four children are parked now under gate `orchestrated`, but the record is deliberately **not** posted yet — recording starts an orchestration immediately — so the stage-1 fan-out child posts it only after Phase 2 completes. The stage-1 record documents the manual resume command in case of a halt.

The orchestration spines are distinct from this job's base on purpose: the watcher writes its completion to `tada/<orch-base>`, which would collide with this report's own `tada/` entry.

Cross-child race hazards are mitigated in the bodies: Caddy config is split into per-phase-owned `conf.d/` files (Phase 6 owns `minion-town.caddy`, Phase 5 owns `github-idp.caddy`); Phases 3/5/6 all touch Cognito app clients, whose `update-user-pool-client` replaces whole config — each body mandates read-modify-write with read-back-and-redo.

### Maintainer inputs (Phases 3 & 5 — asked now, nothing stalls)

Two asks are in your inbox with exact console steps and `create-secret` commands: a **Google OAuth Web client** (redirect `https://minion-town.auth.us-west-1.amazoncognito.com/oauth2/idpresponse`) → `minion/google-idp-client`, and a **GitHub OAuth App** (same callback URL) → `minion/github-oauth-app`. Replies route to the phase children's inboxes. Each gated child polls secret+inbox ~90 min, does all non-gated work regardless, and on timeout parks a `--go-ahead` remainder job (`minion-town-phase{3,5}-completion`) instead of failing the orchestration.

### Reconciliation

- `synth-and-deploy-minion-town-aws` (go-ahead plan, CDK/App Runner assumption): removed from `plan/` with a supersession annotation landed at `jobs/tada/synth-and-deploy-minion-town-aws.md`. Nothing was blocked on it.
- `cognito-mcp-metadata-bridge`: already completed (in `tada/`); its draft PR #2 is the doc child's to comment-and-close, with the note that its pre-token-gen Lambda idea survives in Phase 4 while its aud-stamping goal is dead.

### Follow-ups

- The engine surfaces halts/failures to your inbox automatically; no babysitting needed.
- Deferred by design (recorded in DEPLOYMENT.md): static RFC 8414 doc, DCR/CIMD `/register`, SIWE thunk, `auth.minion.town` custom domain.
- The `src/` → endojs extraction is recorded in DEPLOYMENT.md as an explicit follow-on; no child deepens the coupling.
