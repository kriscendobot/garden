---
tier: mentat
dispatch: manual
---
Perform a whole-project security review of the bot's own live deployment
[kriscendobot/minion.town](https://github.com/kriscendobot/minion.town) (live at
https://minion.town, AWS EC2 `i-0380cd68b90020fad`, us-west-1, SSM-only access).
This is a real live service (open self-signup, Stripe TEST-mode credits, real
OAuth-authenticated users) — review it, do not disrupt it: prefer static/code and
deploy-config review; if you need to probe the live service, stay read-only and
non-destructive, and never touch another user's account or data.

Start from `journal/projects/minion-town/README.md` for orientation (OAuth 2.1
resource server, Cognito-brokered, Caddy-fronted, oauth2-proxy web login gate,
DynamoDB account store keyed `iss`+`sub`, SSM-driven idempotent deploys, secrets
via Secrets Manager rendered to 0600 EnvironmentFiles — never through SSM text).
Set up an isolated worktree from `worktrees/kriscendobot-minion.town.git` and read
the repo's own `DEPLOYMENT.md` (operational source of truth) and `designs/`
corpus, especially `designs/mcp-oauth.md`, `unified-login-page.md`,
`siwe-onchain-authz.md`, `account-creation-open-signup.md`, and `stripe-credits.md`.

Cover at minimum:

- **Auth and session**: the Cognito/OAuth 2.1 flow, oauth2-proxy gate, client_id
  allowlist (the repo deliberately deviates from DCR/RFC 8707 `aud` — verify the
  substitute is sound), session/token handling, and the self-signup path.
- **Account/credential storage**: the DynamoDB account store, identity keying
  (`iss`+`sub`), and anywhere a secret could leak into logs, journal artifacts, or
  a build.
- **The guest/ocap containment boundary**: the daemon-guest MCP surface vs. the
  public pet-daemon split, and the CapTP/OCapN powers boundary — the garden
  already fixed one host-escape issue here (2026-08-27); check for the same class
  of defect elsewhere in the current surface, not just the patched instance.
- **Billing**: the Stripe TEST-mode credits integration — even in test mode, check
  for logic that would misbehave in live mode (no live keys are in play, but the
  code path should not assume test-mode forever).
- **AWS deployment surface**: IAM scope of `garden-fleet`, Secrets Manager usage,
  SSM script idempotency/injection risk, and the per-concern Caddy config under
  `deploy/aws/caddy/conf.d/`.
- **Provider-portability boundary**: confirm `src/`'s portable path still carries
  no AWS SDK imports (lazy-loaded adapters only), since a leak here is also a
  security-relevant coupling, not just an architecture one.

Write up findings with severity and concrete evidence (file/line, request/response
detail) in your completion report. This repo is watched (triager + CI) per the
project's "design delivery is PR review" convention — if a finding needs a code
fix, open it as a PR against `main` rather than pushing directly, so it draws
review; a pure investigative report needs no PR. Do not comment on or otherwise
touch any repo other than kriscendobot/minion.town.

<!-- garden-transient-elapsed: kind=signature through=0 values=148 -->

<!-- garden-reaped: 1 -->
