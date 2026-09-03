# Project: minion-town

The bot's own MCP-server deployment: [kriscendobot/minion.town](https://github.com/kriscendobot/minion.town), live at <https://minion.town> on AWS (EC2 `i-0380cd68b90020fad`, us-west-1, SSM-only access). An OAuth 2.1 resource server (Cognito-brokered) fronted by Caddy, with a web login gate (oauth2-proxy), open self-signup (DynamoDB account store keyed `iss`+`sub`), and Stripe TEST-mode credits. The repo's `DEPLOYMENT.md` is the operational source of truth; `designs/` holds the design corpus.

## Rules of engagement

- **Design delivery is now PR review (maintainer directive, kriskowal 2026-07-10).** New design docs land as **pull requests** against `main` on kriscendobot/minion.town — the fork is watched (triager + CI), so a design PR draws review — not as direct commits. Builds and config may still land as direct commits to `main` (`git push origin HEAD:main`) where a change doesn't want pre-deploy review (reference: PR #3, an oauth2-proxy config fix). Designs already on `main` from before this directive (`stripe-credits`, `account-creation-open-signup`, `mcp-endo-guest`) stay as-is; the directive is forward-looking.
- **Design docs match the repo's own conventions, not the garden's frontmatter.** Shape: `# Design: <title>` then a bold `**Status:** / **Mandate:** / **Grounded against:** / **Companion:**` header block, numbered sections, mermaid diagrams. Design-only commits say "spec only, no live change" in the subject.
- **Deploys are SSM-driven and idempotent** (`deploy/aws/scripts/*`): build on a garden host, tarball to the private artifacts bucket, presigned GET, `ssm_run` onto the box. Secrets live only in Secrets Manager, rendered to 0600 EnvironmentFiles via presigned S3, never through SSM text. Caddy config is per-concern files under `deploy/aws/caddy/conf.d/`, one owner each.
- **Maintainer architecture directive:** minion.town is a deployment + configuration layer, not a code home. Server code that grows here (billing, guest control) is shaped for later transplant; the Endo direction is to grow `@endo/gateway` + `@endo/mcp` organically with this AWS deployment (kriskowal, closing endojs/endo-but-for-bots#134, 2026-07-09). Endo-side changes target `endojs/endo-but-for-bots` @ `llm`.
- **Provider portability boundary:** `src/` carries no AWS SDK imports on the portable path; AWS adapters load lazily by config (`ACCOUNT_STORE=dynamodb`). The same code runs locally against a mock AS.

## Identity and credentials

- The repo is owned by the bot (`kriscendobot`); commits carry the bot identity. No ferry or identity switch is involved.
- AWS: account `292378781985`, region us-west-1, fleet IAM user `garden-fleet`; the box also runs the garden fleet, so additions stay memory-capped.
- OAuth spine: Cognito pool `us-west-1_mDaTgjr1m`; identities are keyed `iss`+`sub` everywhere (policy, account store, billing, and the designed per-user Endo guests).

## Design corpus (in-repo)

`designs/mcp-oauth.md` (resource-server architecture and the Cognito deviations: no DCR, client_id-allowlist instead of RFC 8707 `aud`), `unified-login-page.md`, `siwe-onchain-authz.md`, `account-creation-open-signup.md`, `stripe-credits.md`, `mcp-endo-guest.md` (the gated Claude-then-Endo-guest chain, 2026-07-09).

## Roadmap

Minion Town has no in-repo numbered-milestone ledger; its Endo-touching work grows `@endo/gateway` / `@endo/mcp` **organically as part of the same endo direction** (maintainer directive closing endojs/endo-but-for-bots#134, 2026-07-09), so it is sequenced inside the **endo milestone ledger** (`designs/README.md` on `endojs/endo-but-for-bots@llm`, M1–M11).

- **Client-side bridge, endo M3 top priority (carved 2026-09-03).** [`git-remote-capability`](https://github.com/kriscendobot/minion.town/pull/41) (the capability-addressed git remote — `git push` an artifact straight into an Endo directory, no MCP-tool-call byte marshaling) is one of the two client-side-bridge capabilities carved to the **head of the first unfinished endo milestone, M3**. Its endo-side follow-on is the M3 git trio (`daemon-git-capability`, `daemon-git-remotes`, `daemon-git-next-steps`) + the `daemon-agent-tools` `makeGitRemoteTool` push tier, with Rust smart-HTTP backing `endor-git-bindings` (M11). The other half is the confined in-guest agent `@endo/claude` (endo-but-for-bots#1015 + child-guest provisioning #1102). See the endo ledger and the carve PR endojs/endo-but-for-bots#1127. Journal record: [`../../plan/designs/minion-town/git-remote-capability.md`](../../plan/designs/minion-town/git-remote-capability.md).

## Topic notes

- [ocap-mailbox-relative-routing](ocap-mailbox-relative-routing.md) — Mark Miller's [[relative-routing]] applied to the ocap-mailbox adapter: an email-backed synthetic guest and an in-daemon OCapN-over-Noise session are two *routes* (connection hints) to the same peer, not rival designs; short-circuit to the nearest reliable path (added 2026-08-14 by scholar-relative-routing-miller; grounds against PR #37).
