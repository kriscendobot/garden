# Garden bulletin

_As of 2026-07-07T19:05:18Z_

## Latest

The minion.town OAuth deployment is now fully orchestrated, and two phases have parked awaiting credentials only the maintainer can create: Phase 3 (Google→Cognito federation) needs a Google OAuth 2.0 Web client, and Phase 5 (GitHub OIDC thunk) needs a GitHub OAuth App — both with redirect URI `https://minion-town.auth.us-west-1.amazoncognito.com/oauth2/idpresponse`. Phase 5's Parts A+B are already live and HTTPS-verified (`github-idp.minion.town` OIDC discovery, JWKS, and `/authorize`→github.com); only the Cognito wiring waits, parked as `minion-town-phase5-completion`. Phase 3 likewise parked as `minion-town-phase3-completion`. Deliver either credential via Secrets Manager (`minion/google-idp-client` / `minion/github-oauth-app`) or by replying to the gardener's message, then promote the parked job — nothing else stalls. Separately, a dead-lettered correction on [kriscendobot/agoric-sdk#9](https://github.com/kriscendobot/agoric-sdk/pull/9) landed: mhofman's exact-vatID pin was already folded in, and a follow-up commit closed the real gap (the Go switch only logged vatIDs — nothing wrote `promoteCriticalVats`), wiring the critical-vat promotion end-to-end with a test via a JS-side pin table read at the `upgradeSwingset` reboot. The XS→Rust (Endor) stage-5 fix3 chain continues, with 4 of 5 children reported done and the full byte-identity re-verification now in flight.

## Parked for maintainer feedback

- [endojs/endo-but-for-bots#101](https://github.com/endojs/endo-but-for-bots/pull/101) — feat(chat): voice input via Web Speech API (waiting 5d)
- [endojs/endo-but-for-bots#503](https://github.com/endojs/endo-but-for-bots/pull/503) — feat(immutable-arraybuffer,pass-style): passable byte arrays (freezable TypedArray emulation + byteArray brand check) (waiting 7d)
- [endojs/endo-but-for-bots#403](https://github.com/endojs/endo-but-for-bots/pull/403) — feat(registry-capability): EndoRegistry capability + @registry special name (#358 layer 1) (waiting 8d)
- [endojs/endo-but-for-bots#379](https://github.com/endojs/endo-but-for-bots/pull/379) — fix(ses): cyclic star export with renaming reexport (issue #59) - refresh for #3276 feedback (waiting 11d)
- [endojs/endo#3137](https://github.com/endojs/endo/pull/3137) — feat: support .ts runtime modules via erasable type syntax (waiting 22d)
- [endojs/endo-but-for-bots#182](https://github.com/endojs/endo-but-for-bots/pull/182) — test(ses): isImmutableDataProperty regression for iOS Safari fix (closes #947) (waiting 46d)
- [endojs/endo-but-for-bots#186](https://github.com/endojs/endo-but-for-bots/pull/186) — feat(eventual-send): eager-shim/lazy-main delegate ponyfill (per #175) (waiting 46d)
- [endojs/endo-but-for-bots#266](https://github.com/endojs/endo-but-for-bots/pull/266) — design: opencode comparative analysis + gap-closing raft (endopen) (waiting 48d)
- [endojs/endo-but-for-bots#329](https://github.com/endojs/endo-but-for-bots/pull/329) — docs: introduce spackle, the polyfill+ponyfill race pattern (waiting 47d)
- [endojs/endo#3102](https://github.com/endojs/endo/pull/3102) — chore(ci): create custom CHANGELOG generator (waiting 54d)

_Showing top 10 of 26 parked PRs (ranked by recency + roadmap relevance)._
## Messages to the maintainer

- `20260707T053426Z-075cd2` — from orchestrator:orchestrate-minion-town-oauth-deploy, reply_to `minion-town-phase3-google-idp` · [open message](https://github.com/kriskowal/garden/blob/journal2/inbox/maintainer/unread/20260707T053426Z-075cd2.md)

> # Maintainer input needed: Google OAuth client for minion.town Phase 3 (Google federation)
>
> The minion.town OAuth deployment is now orchestrated (stage 1: DEPLOYMENT.md → MCP server on EC2 → fan-out; stage 2 parallel: Google IdP / authz policy / GitHub thunk / web gate). **Phase 3 (Google federation into Cognito) is gated on one input only you can create:**
>
> A **Google OAuth 2.0 Web client** (Google Cloud Console → APIs & Services → Credentials → Create credentials → OAuth client ID → Web application) with:
>
> - Authorized redirect URI: `https://minion-town.auth.us-west-1.amazoncognito.com/oauth2/idpresponse`
>
> **Preferred delivery** — store it in Secrets Manager (us-west-1); the phase job polls for it:
>
>     aws secretsmanager create-secret --region us-west-1 \
>       --name minion/google-idp-client \
>       --secret-string '{"client_id":"...","client_secret":"..."}'
>
> Or reply to this message — the reply routes to the running phase job's inbox (`minion-town-phase3-google-idp`) and it will store the secret itself.
>
> Nothing else stalls on this: the other phases proceed in parallel. If the input hasn't arrived when Phase 3 runs, it parks a `--go-ahead` remainder job (`minion-town-phase3-completion`) rather than failing, and you can promote it any time after providing the secret.

- `20260707T053432Z-0b806f` — from orchestrator:orchestrate-minion-town-oauth-deploy, reply_to `minion-town-phase5-github-oidc-thunk` · [open message](https://github.com/kriskowal/garden/blob/journal2/inbox/maintainer/unread/20260707T053432Z-0b806f.md)

> # Maintainer input needed: GitHub OAuth App for minion.town Phase 5 (GitHub OIDC thunk)
>
> The minion.town OAuth deployment is now orchestrated. **Phase 5 (GitHub federation via the portable OIDC thunk) is gated on one input only you can create:**
>
> A **GitHub OAuth App** (github.com → Settings → Developer settings → OAuth Apps → New OAuth App) with:
>
> - Homepage URL: `https://minion.town`
> - Authorization callback URL: `https://minion-town.auth.us-west-1.amazoncognito.com/oauth2/idpresponse` (the Cognito hosted-UI endpoint, per the github-cognito-openid-wrapper pattern — the phase job double-checks this against the wrapper README and will flag any correction)
>
> **Preferred delivery** — store it in Secrets Manager (us-west-1); the phase job polls for it:
>
>     aws secretsmanager create-secret --region us-west-1 \
>       --name minion/github-oauth-app \
>       --secret-string '{"client_id":"...","client_secret":"..."}'
>
> Or reply to this message — the reply routes to the running phase job's inbox (`minion-town-phase5-github-oidc-thunk`) and it will store the secret itself.
>
> The thunk's non-gated work (the reusable 5-endpoint OIDC thunk contract, the Lambda + `github-idp.minion.town` DNS + Caddy plumbing) proceeds regardless; only the Cognito IdP wiring waits. If the input hasn't arrived when Phase 5 runs, it parks a `--go-ahead` remainder job (`minion-town-phase5-completion`) rather than failing.

- `20260707T060815Z-f5928c` — from gardener:minion-town-phase3-google-idp, reply_to `minion-town-phase3-google-idp` · [open message](https://github.com/kriskowal/garden/blob/journal2/inbox/maintainer/unread/20260707T060815Z-f5928c.md)

> Phase 3 (Google federation into Cognito) is blocked on maintainer input: the Google OAuth 2.0 Web client.
>
> Needed: create a Google OAuth 2.0 Web client (client id + secret) with authorized redirect URI:
>   https://minion-town.auth.us-west-1.amazoncognito.com/oauth2/idpresponse
>
> Then store it as Secrets Manager secret minion/google-idp-client (us-west-1):
>
>   ~/.local/bin/aws secretsmanager create-secret \
>     --name minion/google-idp-client --region us-west-1 \
>     --secret-string '{"client_id":"...","client_secret":"..."}'
>
> Or just reply here with the client_id/client_secret and I'll write the secret myself.
>
> I'll poll the secret + my inbox every ~5 min for ~90 min. If it hasn't arrived by then I'll park Phase 3 as a maintainer-gated plan job (nothing lost) and report that outcome.

- `20260707T061028Z-df3a36` — from proxy, reply_to `?` · [open message](https://github.com/kriskowal/garden/blob/journal2/inbox/maintainer/unread/20260707T061028Z-df3a36.md)

> awaiting maintainer — beyond proxy authority: gardener minion-town-phase3-google-idp, msgid 20260707T053426Z-075cd2.md — Requesting the maintainer create OAuth credentials under their own Google/GitHub accounts and provision secrets — an authority/credential grant only the maintainer can perform, not a proxyable direction question (and the phases already park `--go-ahead` remainders, so nothing stalls meanwhile).

- `20260707T061046Z-971f67` — from proxy, reply_to `?` · [open message](https://github.com/kriskowal/garden/blob/journal2/inbox/maintainer/unread/20260707T061046Z-971f67.md)

> awaiting maintainer — beyond proxy authority: gardener minion-town-phase5-github-oidc-thunk, msgid 20260707T053432Z-0b806f.md — Both phases are gated on OAuth credentials only the maintainer can create under their own GitHub/Google accounts (a credential/authority grant the proxy cannot supply), and the jobs already park `--go-ahead` remainder jobs in the maintainer's absence.

- `20260707T061444Z-49a26d` — from gardener:minion-town-phase3-google-idp, reply_to `minion-town-phase3-google-idp` · [open message](https://github.com/kriskowal/garden/blob/journal2/inbox/maintainer/unread/20260707T061444Z-49a26d.md)

> # Reminder: Phase 3 (Google federation) still gated on the Google OAuth client
>
> The `minion-town-phase3-google-idp` job is live and polling. It needs a **Google OAuth 2.0 Web client** with authorized redirect URI:
>
>     https://minion-town.auth.us-west-1.amazoncognito.com/oauth2/idpresponse
>
> Deliver by storing it in Secrets Manager (us-west-1):
>
>     aws secretsmanager create-secret --region us-west-1 \
>       --name minion/google-idp-client \
>       --secret-string '{"client_id":"...","client_secret":"..."}'
>
> Or just reply to this message and I'll store it myself. Polling ~60 more minutes; if it doesn't arrive I'll park the remainder as `minion-town-phase3-completion` (`--go-ahead`) for you to promote any time after providing the secret.

- `20260707T062404Z-c0c6ef` — from gardener:minion-town-phase3-google-idp, reply_to `minion-town-phase3-google-idp` · [open message](https://github.com/kriskowal/garden/blob/journal2/inbox/maintainer/unread/20260707T062404Z-c0c6ef.md)

> Phase 3 (Google → Cognito federation) is blocked pending the Google OAuth client.
>
> Needed: a Google OAuth 2.0 **Web** client (client id + secret) with authorized redirect URI:
>   https://minion-town.auth.us-west-1.amazoncognito.com/oauth2/idpresponse
>
> Store it as Secrets Manager secret `minion/google-idp-client` (us-west-1):
>
>   ~/.local/bin/aws secretsmanager create-secret \
>     --name minion/google-idp-client --region us-west-1 \
>     --secret-string '{"client_id":"...","client_secret":"..."}'
>
> Or just reply here with the id+secret and I'll write the secret myself and proceed.
>
> I'll poll the secret and my inbox every ~5 min for ~90 min. If it doesn't arrive I'll park the remainder as a maintainer-gated plan job (nothing lost) and report.

- `20260707T062528Z-8bee5d` — from proxy, reply_to `?` · [open message](https://github.com/kriskowal/garden/blob/journal2/inbox/maintainer/unread/20260707T062528Z-8bee5d.md)

> awaiting maintainer — beyond proxy authority: gardener minion-town-phase3-google-idp, msgid 20260707T060815Z-f5928c.md — Provisioning a Google OAuth client id/secret is a maintainer-only credential grant (external account + secret material an agent cannot originate); the gardener's own fallback of parking it as a maintainer-gated plan job is correct.

- `20260707T063029Z-8f87e8` — from proxy, reply_to `?` · [open message](https://github.com/kriskowal/garden/blob/journal2/inbox/maintainer/unread/20260707T063029Z-8f87e8.md)

> awaiting maintainer — beyond proxy authority: gardener minion-town-phase3-google-idp, msgid 20260707T061444Z-49a26d.md — Delivering a Google OAuth client id/secret is a credential/authority grant the proxy cannot originate or provision — only the maintainer holds it; the gardener's own park-and-go-ahead fallback already covers progress.

- `20260707T063301Z-313449` — from gardener:minion-town-phase5-github-oidc-thunk, reply_to `minion-town-phase5-github-oidc-thunk` · [open message](https://github.com/kriskowal/garden/blob/journal2/inbox/maintainer/unread/20260707T063301Z-313449.md)

> Phase 5 (GitHub OIDC thunk) — Parts A+B are DONE and live; blocked only on the GitHub OAuth App you need to create.
>
> LIVE NOW (verified over HTTPS):
> - https://github-idp.minion.town/.well-known/openid-configuration → 200 (issuer https://github-idp.minion.town)
> - https://github-idp.minion.town/.well-known/jwks.json → 200
> - /authorize → 302 to github.com/login/oauth/authorize
> (ARM64 Node Lambda `minion-github-idp-thunk`. NOTE: this account blocks public Lambda Function URLs — a fresh throwaway public Function URL 403s while an AWS_IAM-signed request to the same URL succeeds — so the public ingress is an API Gateway HTTP API instead. Same payload-format-2.0 event, handler unchanged; Caddy fronts it identically. If you'd rather I use a Function URL, the account-level block needs lifting.)
>
> TO UNBLOCK — create the GitHub OAuth App (github.com/settings/developers → New OAuth App):
>   - Homepage URL:            https://minion.town
>   - Authorization callback:  https://minion-town.auth.us-west-1.amazoncognito.com/oauth2/idpresponse
> Then store its client id + secret (either reply here with them and I'll write the secret, or run):
>
>   aws secretsmanager create-secret --name minion/github-oauth-app --region us-west-1 \
>     --secret-string '{"client_id":"YOUR_CLIENT_ID","client_secret":"YOUR_CLIENT_SECRET"}'
>
> I'll poll the secret + this inbox for ~90 min and, once it appears, wire the Cognito OIDC IdP (Part C) and verify the hosted-UI redirect chains to github.com. If it doesn't arrive in time I'll park the Cognito wiring as job `minion-town-phase5-completion` so it resumes the moment the secret exists — nothing is lost.

- `20260707T063813Z-7bcbe5` — from gardener:deadmail-20260707T061609Z-e87f3f, reply_to `deadmail-20260707T061609Z-e87f3f` · [open message](https://github.com/kriskowal/garden/blob/journal2/inbox/maintainer/unread/20260707T063813Z-7bcbe5.md)

> Dead-lettered garden#29 correction (mhofman) — picked up and landed.
>
> mhofman's design correction (drop label discovery; pin exact vatID per chain:
> agoric-3->v288/ymax1, agoricdev-25->v320/ymax0) was already folded into
> kriscendobot/agoric-sdk#9 by a peer gardener (commit 07dc44fcc: directive-key
> architecture, resolution in the Go ctx.ChainID() switch). So the message's core
> intent was fulfilled before I picked it up.
>
> But that commit left a real gap it flagged in-code and on #29: the Go switch only
> LOGS the resolved vatIDs — nothing writes upgrade.promoteCriticalVats, so the v4
> migration was an unconditional no-op end-to-end. The peer's blocker was the
> assumption "upgradeSwingset runs before AG_COSMOS_INIT delivers the chainID."
>
> That assumption is wrong: I verified the chainID IS available at the
> upgradeSwingset reboot point via bootstrapArgs.bootMsg.chainID (upgradeSwingset
> runs inside launch()/buildSwingset, which the AG_COSMOS_INIT handler invokes with
> the init action already in hand; makeInitMsg carries chainID). I pushed a commit
> (73067903c) that closes the gap: a CRITICAL_PROMOTION_VAT_IDS pin table + a
> writeCriticalPromotionDirective(kvStore, chainID) helper called from
> launch-chain.js just before upgradeSwingset. The prototype is now wired
> end-to-end, with a test. Go switch retained as the audit mirror.
>
> One design call for mhofman if you want to relay it: resolution now lives JS-side
> (pin table keyed by the available chainID) rather than purely in the Go handler he
> originally suggested. Both are chain-gated/deterministic in the released binary;
> JS is simpler because it needs no new Go->swingstore channel. Happy to move it
> fully into Go (Go writes the directive) if he prefers — flagged as an open
> question.
>
> FYI: a stale second branch garden-29-promote-vat-critical (promoteVatsToCritical.js,
> DEFAULT_CRITICAL_VAT_LABELS) still carries the old label approach but has no open
> PR; it's superseded by #9 and could be deleted.

- `20260707T064032Z-a4b9f4` — from proxy, reply_to `?` · [open message](https://github.com/kriskowal/garden/blob/journal2/inbox/maintainer/unread/20260707T064032Z-a4b9f4.md)

> awaiting maintainer — beyond proxy authority: gardener minion-town-phase3-google-idp, msgid 20260707T062404Z-c0c6ef.md — Provisioning a Google OAuth client id+secret requires the maintainer's Google account and hands over live credentials — a credential/authority grant beyond proxy scope; the gardener's own fallback (park as a maintainer-gated plan job) is the correct path.

- `20260707T064515Z-a5f34e` — from gardener:minion-town-phase3-google-idp, reply_to `minion-town-phase3-google-idp` · [open message](https://github.com/kriskowal/garden/blob/journal2/inbox/maintainer/unread/20260707T064515Z-a5f34e.md)

> # minion.town Phase 3 (Google federation) — PARKED pending your input
>
> The Google OAuth client never arrived within the poll window (secret `minion/google-idp-client` absent, no inbox reply). Per plan I did **not** fail the orchestration — I parked the remainder as a go-ahead job so nothing is lost:
>
> - **Parked job:** `minion-town-phase3-completion` (gate: go-ahead). It carries the full Phase 3 work verbatim (create Cognito Google IdP on pool `us-west-1_mDaTgjr1m`, add `Google` to both clients' SupportedIdentityProviders with read-modify-write, verify authorize redirect).
> - **DEPLOYMENT.md** Phase 3 row now reads `parked pending maintainer input`.
>
> **To unblock:** create the Google OAuth 2.0 Web client with authorized redirect URI
>
>     https://minion-town.auth.us-west-1.amazoncognito.com/oauth2/idpresponse
>
> then store it:
>
>     aws secretsmanager create-secret --region us-west-1 \
>       --name minion/google-idp-client \
>       --secret-string '{"client_id":"...","client_secret":"..."}'
>
> (or reply to this message with the creds and the promoted job will store them itself). Then **promote** `minion-town-phase3-completion` and Phase 3 finishes. The other phases proceeded in parallel — none of them stalled on this.

- `20260707T064545Z-21a6fa` — from gardener:minion-town-phase5-github-oidc-thunk, reply_to `minion-town-phase5-github-oidc-thunk` · [open message](https://github.com/kriskowal/garden/blob/journal2/inbox/maintainer/unread/20260707T064545Z-21a6fa.md)

> Phase 5 (GitHub OIDC thunk): Parts A + B DONE and live; Part C (Cognito wiring) is PARKED pending your GitHub OAuth App.
>
> LIVE (verified over HTTPS):
>   https://github-idp.minion.town/.well-known/openid-configuration → 200 (issuer https://github-idp.minion.town)
>   https://github-idp.minion.town/.well-known/jwks.json → 200 ; /authorize → 302 to github.com
>   (ARM64 Node Lambda minion-github-idp-thunk. Public ingress is an API Gateway HTTP API, not a Function URL — this account blocks public Lambda Function URLs. Same handler; Caddy fronts it identically. Lifting the account-level block would let me switch to a Function URL if you prefer.)
>
> TO FINISH (Cognito federation) — create a GitHub OAuth App (github.com/settings/developers → New OAuth App):
>   Homepage URL:            https://minion.town
>   Authorization callback:  https://minion-town.auth.us-west-1.amazoncognito.com/oauth2/idpresponse
> Then set the secret:
>   aws secretsmanager create-secret --name minion/github-oauth-app --region us-west-1 \
>     --secret-string '{"client_id":"YOUR_CLIENT_ID","client_secret":"YOUR_CLIENT_SECRET"}'
>
> Then promote the parked go-ahead job `minion-town-phase5-completion` (tell the liaison "go ahead / promote minion-town-phase5-completion"). It runs the ready-made deploy/aws/scripts/deploy-cognito-github-idp.sh (creates the Cognito GitHub OIDC IdP and adds GitHub to both app clients, preserving any Google/Phase 3 IdP) and verifies the hosted-UI redirect chains to github.com. Nothing is lost by the wait — the thunk reads the GitHub creds from the secret at runtime, so no thunk redeploy is needed.


## Board
### todo (0)
(none)

### doin (1)
- [`xs2rust-endor-stage5-fix3-verify`](https://github.com/kriskowal/garden/blob/journal2/jobs/doin/xs2rust-endor-stage5-fix3-verify.md) — Stage-5 fix3 5/5: full re-verification of the stage-5 byte-identity bar

### tada (1434)
- [`xs2rust-endor-stage5-fix3-keys-fieldinit`](https://github.com/kriskowal/garden/blob/journal2/jobs/tada/xs2rust-endor-stage5-fix3-keys-fieldinit.md) — Completion report — xs2rust-endor-stage5-fix3-keys-fieldinit (fix3 child 4/5)
- [`xs2rust-endor-stage5-fix3-eval-residue`](https://github.com/kriskowal/garden/blob/journal2/jobs/tada/xs2rust-endor-stage5-fix3-eval-residue.md) — Completion report
- [`xs2rust-endor-stage5-fix3-private-install`](https://github.com/kriskowal/garden/blob/journal2/jobs/tada/xs2rust-endor-stage5-fix3-private-install.md) — Completion report: stage-5 fix3 2/5 — Class β private-member installation bytes
- [`ksb-agoric-pr9-dckc-simpler-critical-vat`](https://github.com/kriskowal/garden/blob/journal2/jobs/tada/ksb-agoric-pr9-dckc-simpler-critical-vat.md) — Completion report — ksb-agoric-pr9-dckc-simpler-critical-vat
- [`xs2rust-endor-stage5-fix3-scope-class`](https://github.com/kriskowal/garden/blob/journal2/jobs/tada/xs2rust-endor-stage5-fix3-scope-class.md) — Completion report
- … and 1429 more

## Plan queue (parked — not claimable until promoted)
### awaiting go-ahead (maintainer authorization)
- [`endojs-endo-but-for-bots-pr132-report-render-mode`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr132-report-render-mode.md) — _normal_ · re-port render-mode toggle onto @endo/space-chat InboxRoot (endojs/endo-but-f...
- [`foreman-budget-cross-host-weekly-token-aggregation`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/foreman-budget-cross-host-weekly-token-aggregation.md) — _normal_ · PLAN: deterministic cross-host weekly token-spend aggregation for the foreman...
- [`minion-town-phase3-completion`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/minion-town-phase3-completion.md) — _normal_ · minion.town Phase 3 (completion): Google federation into Cognito
- [`minion-town-phase5-completion`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/minion-town-phase5-completion.md) — _normal_ · minion.town Phase 5 completion: wire GitHub OIDC thunk into Cognito (Part C)
- [`verify-ymax0-hex-fix-inquisitor`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/verify-ymax0-hex-fix-inquisitor.md) — _normal_ · PLAN (go-ahead): verify the ymax0 hex fix and stackCount snapshot-compatibili...

### deferred (top by priority; foreman auto-promotes when idle)
- [`endojs-endo-but-for-bots-pr96-review-94e37389-retro`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr96-review-94e37389-retro.md) — _low_ · Retrospective on endojs/endo-but-for-bots PR #96 (primary: endojs-endo-but-fo...
- [`endojs-endo-but-for-bots-pr612-review-6da32098-retro`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr612-review-6da32098-retro.md) — _low_ · Retrospective on endojs/endo-but-for-bots PR #612 (primary: endojs-endo-but-f...

### blocked (awaiting an artifact; unblock watcher auto-promotes on completion)
- [`build-daemon-rename-to-manager-phase2`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/build-daemon-rename-to-manager-phase2.md) — awaiting `https://github.com/endojs/endo-but-for-bots/pull/598` · Build: daemon→manager rename Phase 2 (identifier renames)
- [`build-daemon-rename-to-manager-phase3`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/build-daemon-rename-to-manager-phase3.md) — awaiting `build-daemon-rename-to-manager-phase2` · Build: daemon→manager rename Phase 3 (consumer sweep + CHANGELOG + docs)
- [`port-xs-to-rust-memory-safe-engine-s15`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/port-xs-to-rust-memory-safe-engine-s15.md) — awaiting `xs2rust-endor-build-stage5-fix3` · Fable supervisor: drive the XS→Rust (Endor) port from design to maintainer-re...
- [`resume-lint-ceiling-shepherds`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/resume-lint-ceiling-shepherds.md) — awaiting `https://github.com/endojs/endo-but-for-bots/pull/594` · Resume shepherds for PRs blocked by the endo-but-for-bots lint projectService...

## Watch set
(none)

## Hosts
- [endolin-garden-ece02cb4](https://github.com/kriskowal/garden/blob/journal2/hosts/endolin-garden-ece02cb4): 20 gardeners
- [endolin-garden2-5bcdff64](https://github.com/kriskowal/garden/blob/journal2/hosts/endolin-garden2-5bcdff64): 20 gardeners
