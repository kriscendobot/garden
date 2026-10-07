The design is up as draft PR https://github.com/kriscendobot/minion.town/pull/167. Its only change is `designs/root-canary-principal.md`, and nothing has been implemented.

**What it proposes:** a new Cognito login client used only by the canary, `minion-mcp-root-canary`.
- **Setup:** the maintainer signs in once as kriscendobot through the existing GitHub login. A mint script stores the resulting long-lived refresh token in Secrets Manager under `minion/root-canary`, and only a dedicated reader role can read it.
- **Use:** each canary run turns the refresh token into a 15-minute access token. That token belongs to kriscendobot's own root account, so the canary tests the real root path. The only app code change is one audit log line.
- **The token's settings:** the client can only be used by signing in with GitHub, and refresh tokens are not rotated.

**Coverage of the brief:**
- **Scope:** a table of what the token can and cannot reach. It goes beyond what the canary needs in one way: it can also use the root account's ordinary tools (publish, evaluate, mail).
- **Expiry and revocation:** a re-mint reminder before the refresh token expires, and three ways to revoke, fastest first.
- **Audit:** every use traces from the garden job, through the AWS access log of the secret read, to a client id that differs from the human root's.
- **Compromised garden host:** spells out what an attacker could and could not do with the token.
- **Canary use:** the canary gets the token through a wrapper script, prefixes every name it creates with its run id, and cleans up after itself. If auth fails, it stops and reports auth unavailable rather than trying another credential.
- **Alternatives:**
  - Rejected: a client-credentials token tied to kriscendobot's root account, which Cognito can't produce. A second root account, or a plain password-holding Cognito user as root. Neither would hold kriscendobot's Claude credential. A stored GitHub browser session, which would carry authority over kriscendobot's whole GitHub account.
  - Deferred: a limited capability handed out by the root account. Today only the root may set up an inbox-watching agent, and no MCP tool exposes a handed-over capability.

**Open questions for the maintainer (eight).** The two that block the build:
- Who holds kriscendobot's GitHub password and MFA to do the one-time sign-in, and on which machine?
- Is a full-root token over MCP acceptable for the canary, or must the limited-capability version land first?

The other six cover:
- how long the refresh token should last
- which hosts may read the secret
- a separate spending cap so the canary can't use up kriscendobot's own share
- revoking access without restarting the server
- turning root itself into a held capability instead of an account check
- whether any other service accepts these tokens without checking the client id

**Follow-ups:** the panel review should start automatically from this PR. A builder job can follow once the maintainer answers the open questions.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/design-minion-town-kriscendobot-root-principal.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 52 tokens (2208920 cached reads)
- Output: 23651 tokens
- Cost: $1.774204
- Wall-clock: 324s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
