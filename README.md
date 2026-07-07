# Garden bulletin

_As of 2026-07-07T06:14:55Z_

## Latest

The minion.town OAuth deployment moved from design into an orchestrated rollout: stage 1 (DEPLOYMENT.md → MCP server on EC2 → fan-out) completed, and phases 3–6 (Google IdP, authorization policy, GitHub OIDC thunk, web login gate) are now running in parallel. Two of them are stalled on inputs only you can create and would like your attention: **Phase 3** needs a Google OAuth 2.0 Web client and **Phase 5** needs a GitHub OAuth App, each with the Cognito redirect URI `https://minion-town.auth.us-west-1.amazoncognito.com/oauth2/idpresponse`. Deliver either by dropping the credentials into Secrets Manager (`minion/google-idp-client`, `minion/github-oauth-app`, us-west-1) or by replying to the relevant maintainer message; nothing hard-fails in the meantime — each phase parks a `--go-ahead` remainder you can promote once the secret lands, and the non-gated plumbing proceeds regardless. Separately, @kriscendobot tried to drive the garden through issue [kriskowal/garden#29](https://github.com/kriskowal/garden/issues/29) but isn't on the maintainer allowlist, so the interaction was dropped; add them with `add-maintainer.sh` and ask them to re-post if it still matters.

## Parked for maintainer feedback

- [endojs/endo-but-for-bots#101](https://github.com/endojs/endo-but-for-bots/pull/101) — feat(chat): voice input via Web Speech API (waiting 4d)
- [endojs/endo-but-for-bots#503](https://github.com/endojs/endo-but-for-bots/pull/503) — feat(immutable-arraybuffer,pass-style): passable byte arrays (freezable TypedArray emulation + byteArray brand check) (waiting 7d)
- [endojs/endo-but-for-bots#403](https://github.com/endojs/endo-but-for-bots/pull/403) — feat(registry-capability): EndoRegistry capability + @registry special name (#358 layer 1) (waiting 7d)
- [endojs/endo-but-for-bots#379](https://github.com/endojs/endo-but-for-bots/pull/379) — fix(ses): cyclic star export with renaming reexport (issue #59) - refresh for #3276 feedback (waiting 11d)
- [endojs/endo#3137](https://github.com/endojs/endo/pull/3137) — feat: support .ts runtime modules via erasable type syntax (waiting 21d)
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

- `20260707T060118Z-7827d8` — from issue-inbox-watcher, reply_to `?` · [open message](https://github.com/kriskowal/garden/blob/journal2/inbox/maintainer/unread/20260707T060118Z-7827d8.md)

> kind: access-request
>
> @kriscendobot interacted with the garden's issue inbox on kriskowal/garden #29 but is NOT on
> the maintainer allowlist, so the interaction was DROPPED (dispatched
> nothing). If this is a collaborator you want to let drive the garden by
> issue, add them:
>
>     scripts/jobs/add-maintainer.sh kriscendobot
>
> After that, FUTURE issues/comments from @kriscendobot will dispatch — but THIS one
> was already dropped, so ask them to re-post it (or re-post it yourself)
> if it still matters.
>
> Interaction: https://github.com/kriskowal/garden/issues/29#issuecomment-4900643943
>
> You are shown this ONCE per individual. Reply or archive to dismiss it.

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


## Board
### todo (0)
(none)

### doin (7)
- [`deadmail-issue-comment-4900696368`](https://github.com/kriskowal/garden/blob/journal2/jobs/doin/deadmail-issue-comment-4900696368.md) — Dead-lettered message — pick up its intent
- [`mention-kriskowal-garden-29-00a2b5cb`](https://github.com/kriskowal/garden/blob/journal2/jobs/doin/mention-kriskowal-garden-29-00a2b5cb.md) — attention directive from @-mention on kriskowal/garden #29
- [`minion-town-phase3-google-idp`](https://github.com/kriskowal/garden/blob/journal2/jobs/doin/minion-town-phase3-google-idp.md) — minion.town Phase 3: Google federation into Cognito (maintainer-input gated)
- [`minion-town-phase4-authz-policy`](https://github.com/kriskowal/garden/blob/journal2/jobs/doin/minion-town-phase4-authz-policy.md) — minion.town Phase 4: first-party authorization policy + identity-enriching pr...
- [`minion-town-phase5-github-oidc-thunk`](https://github.com/kriskowal/garden/blob/journal2/jobs/doin/minion-town-phase5-github-oidc-thunk.md) — minion.town Phase 5: GitHub OIDC thunk (portable wrapper + Lambda + Cognito O...
- [`minion-town-phase6-web-gate`](https://github.com/kriskowal/garden/blob/journal2/jobs/doin/minion-town-phase6-web-gate.md) — minion.town Phase 6: web login gate (oauth2-proxy behind Caddy forward_auth)
- [`xs2rust-endor-stage5-coder-decl`](https://github.com/kriskowal/garden/blob/journal2/jobs/doin/xs2rust-endor-stage5-coder-decl.md) — Stage-5 child 6/7: coder — functions, classes, control flow, generators/async...

### tada (1392)
- [`minion-town-oauth-stage1`](https://github.com/kriskowal/garden/blob/journal2/jobs/tada/minion-town-oauth-stage1.md) — orchestration minion-town-oauth-stage1 — complete
- [`minion-town-oauth-fanout`](https://github.com/kriskowal/garden/blob/journal2/jobs/tada/minion-town-oauth-fanout.md) — Completion report
- [`minion-town-phase2-mcp-server`](https://github.com/kriskowal/garden/blob/journal2/jobs/tada/minion-town-phase2-mcp-server.md) — Completion report — minion-town-phase2-mcp-server
- [`mention-kriskowal-garden-29-d1daaa55`](https://github.com/kriskowal/garden/blob/journal2/jobs/tada/mention-kriskowal-garden-29-d1daaa55.md) — Completion report
- [`deadmail-issue-comment-4900532627`](https://github.com/kriskowal/garden/blob/journal2/jobs/tada/deadmail-issue-comment-4900532627.md) — Completion report
- … and 1387 more

## Plan queue (parked — not claimable until promoted)
### awaiting go-ahead (maintainer authorization)
- [`endojs-endo-but-for-bots-pr132-report-render-mode`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr132-report-render-mode.md) — _normal_ · re-port render-mode toggle onto @endo/space-chat InboxRoot (endojs/endo-but-f...
- [`foreman-budget-cross-host-weekly-token-aggregation`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/foreman-budget-cross-host-weekly-token-aggregation.md) — _normal_ · PLAN: deterministic cross-host weekly token-spend aggregation for the foreman...
- [`verify-ymax0-hex-fix-inquisitor`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/verify-ymax0-hex-fix-inquisitor.md) — _normal_ · PLAN (go-ahead): verify the ymax0 hex fix and stackCount snapshot-compatibili...

### deferred (top by priority; foreman auto-promotes when idle)
- [`endojs-endo-but-for-bots-pr96-review-94e37389-retro`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr96-review-94e37389-retro.md) — _low_ · Retrospective on endojs/endo-but-for-bots PR #96 (primary: endojs-endo-but-fo...
- [`endojs-endo-but-for-bots-pr612-review-6da32098-retro`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr612-review-6da32098-retro.md) — _low_ · Retrospective on endojs/endo-but-for-bots PR #612 (primary: endojs-endo-but-f...

### blocked (awaiting an artifact; unblock watcher auto-promotes on completion)
- [`build-daemon-rename-to-manager-phase2`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/build-daemon-rename-to-manager-phase2.md) — awaiting `https://github.com/endojs/endo-but-for-bots/pull/598` · Build: daemon→manager rename Phase 2 (identifier renames)
- [`build-daemon-rename-to-manager-phase3`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/build-daemon-rename-to-manager-phase3.md) — awaiting `build-daemon-rename-to-manager-phase2` · Build: daemon→manager rename Phase 3 (consumer sweep + CHANGELOG + docs)
- [`port-xs-to-rust-memory-safe-engine-s12`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/port-xs-to-rust-memory-safe-engine-s12.md) — awaiting `xs2rust-endor-build-stage5` · Fable supervisor: drive the XS→Rust (Endor) port from design to maintainer-re...
- [`resume-lint-ceiling-shepherds`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/resume-lint-ceiling-shepherds.md) — awaiting `https://github.com/endojs/endo-but-for-bots/pull/594` · Resume shepherds for PRs blocked by the endo-but-for-bots lint projectService...

## Watch set
(none)

## Hosts
- [endolin-garden-ece02cb4](https://github.com/kriskowal/garden/blob/journal2/hosts/endolin-garden-ece02cb4): 20 gardeners
- [endolin-garden2-5bcdff64](https://github.com/kriskowal/garden/blob/journal2/hosts/endolin-garden2-5bcdff64): 20 gardeners
