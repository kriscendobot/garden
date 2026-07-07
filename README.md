# Garden bulletin

_As of 2026-07-07T06:02:54Z_

## Latest

The **minion.town OAuth deployment** is now orchestrated end-to-end and Phase 2 (the MCP server on EC2, with fan-out) has completed. Two phases now wait on the maintainer directly: **Phase 3** (Google federation into Cognito) needs a Google OAuth 2.0 Web client, and **Phase 5** (GitHub federation via the OIDC thunk) needs a GitHub OAuth App — both deliverable via Secrets Manager in us-west-1 or by replying to the running phase jobs; each parks a `--go-ahead` remainder rather than failing if the input is late, and all non-gated plumbing proceeds in parallel. Separately, @kriscendobot tried to drive the garden via issue [kriskowal/garden#29](https://github.com/kriskowal/garden/issues/29) but is not on the maintainer allowlist, so that interaction was dropped — add them with `add-maintainer.sh` and ask them to re-post if it still matters. The board is otherwise quiet (one stage-5 xs2rust coder job in flight, empty todo).

## Parked for maintainer feedback

- [endojs/endo-but-for-bots#101](https://github.com/endojs/endo-but-for-bots/pull/101) — feat(chat): voice input via Web Speech API (waiting 4d)
- [endojs/endo-but-for-bots#503](https://github.com/endojs/endo-but-for-bots/pull/503) — feat(immutable-arraybuffer,pass-style): passable byte arrays (freezable TypedArray emulation + byteArray brand check) (waiting 7d)
- [endojs/endo-but-for-bots#403](https://github.com/endojs/endo-but-for-bots/pull/403) — feat(registry-capability): EndoRegistry capability + @registry special name (#358 layer 1) (waiting 7d)
- [endojs/endo-but-for-bots#379](https://github.com/endojs/endo-but-for-bots/pull/379) — fix(ses): cyclic star export with renaming reexport (issue #59) - refresh for #3276 feedback (waiting 11d)
- [endojs/endo#3137](https://github.com/endojs/endo/pull/3137) — feat: support .ts runtime modules via erasable type syntax (waiting 21d)
- [endojs/endo-but-for-bots#182](https://github.com/endojs/endo-but-for-bots/pull/182) — test(ses): isImmutableDataProperty regression for iOS Safari fix (closes #947) (waiting 46d)
- [endojs/endo-but-for-bots#186](https://github.com/endojs/endo-but-for-bots/pull/186) — feat(eventual-send): eager-shim/lazy-main delegate ponyfill (per #175) (waiting 46d)
- [endojs/endo-but-for-bots#266](https://github.com/endojs/endo-but-for-bots/pull/266) — design: opencode comparative analysis + gap-closing raft (endopen) (waiting 47d)
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


## Board
### todo (0)
(none)

### doin (1)
- [`xs2rust-endor-stage5-coder-decl`](https://github.com/kriskowal/garden/blob/journal2/jobs/doin/xs2rust-endor-stage5-coder-decl.md) — Stage-5 child 6/7: coder — functions, classes, control flow, generators/async...

### tada (1390)
- [`minion-town-phase2-mcp-server`](https://github.com/kriskowal/garden/blob/journal2/jobs/tada/minion-town-phase2-mcp-server.md) — Completion report — minion-town-phase2-mcp-server
- [`mention-kriskowal-garden-29-d1daaa55`](https://github.com/kriskowal/garden/blob/journal2/jobs/tada/mention-kriskowal-garden-29-d1daaa55.md) — Completion report
- [`deadmail-issue-comment-4900532627`](https://github.com/kriskowal/garden/blob/journal2/jobs/tada/deadmail-issue-comment-4900532627.md) — Completion report
- [`minion-town-deployment-doc`](https://github.com/kriskowal/garden/blob/journal2/jobs/tada/minion-town-deployment-doc.md) — Completion report
- [`orchestrate-minion-town-oauth-deploy`](https://github.com/kriskowal/garden/blob/journal2/jobs/tada/orchestrate-minion-town-oauth-deploy.md) — Completion report: orchestrate-minion-town-oauth-deploy
- … and 1385 more

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
