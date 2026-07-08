# Garden bulletin

_As of 2026-07-08T03:04:13Z_

## Latest

The garden finalized [endo-but-for-bots#616](https://github.com/endojs/endo-but-for-bots/pull/616) (curate → merge), the sole board transition this cycle — the board is now fully drained (todo, doin, and watch set all empty).

Two items warrant attention. First, the minion.town auth hardening landed: the gardener shipped "verified-email only" enforcement at the GitHub OIDC thunk and confirmed the safety check — `kriskowal@kriskowal.com` is a verified primary email, so the lockout enforcement keeps you in. An optional fresh sign-in at https://minion.town/ would confirm your login still lands authenticated (breakglass@minion.town remains the fallback either way). Second, two liaison follow-ups need your call now that minion.town signup is live: whether to promote the parked styled-privilege-surfaces design job (the `/account` endpoint and role-aware landing panels), and confirmation of MAU/spend thresholds plus a notification target before a gardener arms the CloudWatch billing alarm.

The minion.town Phase B "open-signup gate flip" and Phase C "styled privilege surfaces" builds remain parked awaiting your go-ahead, alongside the SIWE thunk deploy and on-chain authorization wiring.

## Parked for maintainer feedback

- [endojs/endo#3319](https://github.com/endojs/endo/pull/3319) — feat(eslint-plugin)!: support ESLint 10+ (waiting 3h)
- [endojs/endo-but-for-bots#101](https://github.com/endojs/endo-but-for-bots/pull/101) — feat(chat): voice input via Web Speech API (waiting 5d)
- [endojs/endo-but-for-bots#503](https://github.com/endojs/endo-but-for-bots/pull/503) — feat(immutable-arraybuffer,pass-style): passable byte arrays (freezable TypedArray emulation + byteArray brand check) (waiting 7d)
- [endojs/endo-but-for-bots#403](https://github.com/endojs/endo-but-for-bots/pull/403) — feat(registry-capability): EndoRegistry capability + @registry special name (#358 layer 1) (waiting 8d)
- [endojs/endo-but-for-bots#379](https://github.com/endojs/endo-but-for-bots/pull/379) — fix(ses): cyclic star export with renaming reexport (issue #59) - refresh for #3276 feedback (waiting 11d)
- [endojs/endo#3137](https://github.com/endojs/endo/pull/3137) — feat: support .ts runtime modules via erasable type syntax (waiting 22d)
- [endojs/endo-but-for-bots#182](https://github.com/endojs/endo-but-for-bots/pull/182) — test(ses): isImmutableDataProperty regression for iOS Safari fix (closes #947) (waiting 47d)
- [endojs/endo-but-for-bots#186](https://github.com/endojs/endo-but-for-bots/pull/186) — feat(eventual-send): eager-shim/lazy-main delegate ponyfill (per #175) (waiting 47d)
- [endojs/endo-but-for-bots#266](https://github.com/endojs/endo-but-for-bots/pull/266) — design: opencode comparative analysis + gap-closing raft (endopen) (waiting 48d)
- [endojs/endo-but-for-bots#329](https://github.com/endojs/endo-but-for-bots/pull/329) — docs: introduce spackle, the polyfill+ponyfill race pattern (waiting 48d)

_Showing top 10 of 27 parked PRs (ranked by recency + roadmap relevance)._
## Messages to the maintainer

- `20260707T230941Z-bdccad` — from gardener:minion-town-auth-verified-email-reconcile, reply_to `minion-town-auth-verified-email-reconcile` · [open message](https://github.com/kriskowal/garden/blob/journal2/inbox/maintainer/unread/20260707T230941Z-bdccad.md)

> [minion.town verified-email enforcement — safety check before I ship]
>
> I'm about to enforce "verified-email only" at the GitHub OIDC thunk (only a
> GitHub-verified email is ever emitted; no verified email → login refused). Before
> shipping I must confirm this won't lock YOU out.
>
> Question: Is `kriskowal@kriskowal.com` a **verified** email on your GitHub
> account (ideally your verified *primary*)? GitHub only allows setting a *verified*
> email as primary, so if it's your primary it's almost certainly fine — but please
> confirm.
>
> To gather objective proof I'm also deploying a temporary logging build of the
> thunk. If you can do a fresh GitHub sign-in at https://minion.town/ in the next
> little while, I'll read the thunk logs and confirm the `verified` flag directly,
> then flip on enforcement.
>
> Either a "yes it's verified" reply OR a fresh login (so I can read the logs) will
> let me proceed. If it turns out NOT verified, I will NOT ship the lockout — I'll
> leave the gate relaxed and report back. Break-glass (breakglass@minion.town)
> remains a working fallback regardless.

- `20260707T233536Z-0c989d` — from gardener:minion-town-auth-verified-email-reconcile, reply_to `minion-town-auth-verified-email-reconcile` · [open message](https://github.com/kriskowal/garden/blob/journal2/inbox/maintainer/unread/20260707T233536Z-0c989d.md)

> minion.town verified-email hardening — shipped, with the safety finding you asked for.
>
> MAINTAINER-EMAIL VERIFICATION FINDING (the lock-out check):
> kriskowal@kriskowal.com is a VERIFIED PRIMARY email on your GitHub account, so the
> new thunk enforcement keeps you in — safe to ship, and shipped. Basis: your
> federated Cognito user (GitHub_60294) already carries email=kriskowal@kriskowal.com,
> which the OLD thunk only ever produced by selecting GitHub's *primary* email; and
> GitHub requires a primary email to be verified. The new thunk selects the same
> verified primary, so nothing changes for you.
>
> WHAT SHIPPED (pushed to kriscendobot/minion.town main @ 45e65e6, deployed live):
> 1. Thunk now asserts a GitHub-verified email only and REFUSES accounts with no
>    verified email (fails /userinfo) — email_verified is always true by
>    construction. Deployed to Lambda minion-github-idp-thunk (verified the enforce
>    code is in the live bundle).
> 2. Drift reconciled into the repo: kriskowal@kriskowal.com moved into
>    config/policy.json (full admin) → allowed-emails.txt regenerated; the
>    insecure_oidc_allow_unverified_email flag folded into the committed
>    oauth2-proxy.cfg with rationale. Box now byte-matches the repo (no drift).
> 3. Cognito email_verified=email_verified mapping documented as a no-op for
>    federated users and reconciled into the committed GitHub-IdP script.
>
> VERIFIED LIVE: https://minion.town/ → 302 to sign-in (not 403/500); /mcp no-token
> → 401 with correct WWW-Authenticate; PRM 200; thunk discovery 200.
>
> ONE OPTIONAL CONFIRMATION: next time convenient, do a fresh GitHub sign-in at
> https://minion.town/ to confirm your login still lands authenticated. If anything
> is off, breakglass@minion.town (native admin, unaffected by thunk enforcement)
> remains your fallback either way.

- `20260708T014855Z-b7abdc` — from liaison:follow-up, reply_to `?` · [open message](https://github.com/kriskowal/garden/blob/journal2/inbox/maintainer/unread/20260708T014855Z-b7abdc.md)

> Report `open-signup-live-minion-town` deferred design job #3 (styled privilege surfaces: the `/account` browser endpoint, landing role panel, `error.html`, insufficient-privilege page, `ELEVATION_CONTACT`). Now that signup is live on the bot's minion-town, browser-only guests aren't provisioned until their first authorized `/mcp` call — a public-facing UX gap. Do you want to promote this deferred design job, or keep it parked?

- `20260708T014900Z-a4afa2` — from liaison:follow-up, reply_to `?` · [open message](https://github.com/kriskowal/garden/blob/journal2/inbox/maintainer/unread/20260708T014900Z-a4afa2.md)

> Report `open-signup-live-minion-town` recommends creating a CloudWatch billing alarm on Cognito pool MAU (and DynamoDB spend) now that signup is open, but none was created. This needs your call on thresholds and the notification target before a gardener can arm it via the aws-administration skill — please confirm the MAU/spend limits and where alerts should go.


## Board
### todo (0)
(none)

### doin (0)
(none)

### tada (1491)
- [`endojs-endo-but-for-bots-pr616-conduct`](https://github.com/kriskowal/garden/blob/journal2/jobs/tada/endojs-endo-but-for-bots-pr616-conduct.md) — Completion report — Finalize (curate → merge) endojs/endo-but-for-bots PR #616
- [`mention-endojs-endo-but-for-bots-632-bdf2827b`](https://github.com/kriskowal/garden/blob/journal2/jobs/tada/mention-endojs-endo-but-for-bots-632-bdf2827b.md) — Completion report
- [`improve-mention-reactji-failure-diagnostics`](https://github.com/kriskowal/garden/blob/journal2/jobs/tada/improve-mention-reactji-failure-diagnostics.md) — Completion report
- [`mention-endojs-endo-but-for-bots-614-6ad25382`](https://github.com/kriskowal/garden/blob/journal2/jobs/tada/mention-endojs-endo-but-for-bots-614-6ad25382.md) — Completion report
- [`mention-endojs-endo-but-for-bots-632-56ebd36d`](https://github.com/kriskowal/garden/blob/journal2/jobs/tada/mention-endojs-endo-but-for-bots-632-56ebd36d.md) — Completion report
- … and 1486 more

## Plan queue (parked — not claimable until promoted)
### awaiting go-ahead (maintainer authorization)
- [`build-account-store-minion-town`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/build-account-store-minion-town.md) — _normal_ · Build: account store + auto-provisioning for minion.town (Phase A — ships dar...
- [`deploy-siwe-thunk-minion-town`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/deploy-siwe-thunk-minion-town.md) — _normal_ · Deploy the SIWE OIDC thunk (mirroring the GitHub thunk's AWS path)
- [`endojs-endo-but-for-bots-pr132-report-render-mode`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr132-report-render-mode.md) — _normal_ · re-port render-mode toggle onto @endo/space-chat InboxRoot (endojs/endo-but-f...
- [`foreman-budget-cross-host-weekly-token-aggregation`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/foreman-budget-cross-host-weekly-token-aggregation.md) — _normal_ · PLAN: deterministic cross-host weekly token-spend aggregation for the foreman...
- [`open-signup-gate-flip-minion-town`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/open-signup-gate-flip-minion-town.md) — _normal_ · Build: open-signup gate flip for minion.town (Phase B — THE consequential cha...
- [`styled-privilege-surfaces-minion-town`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/styled-privilege-surfaces-minion-town.md) — _normal_ · Build: styled privilege surfaces for minion.town (Phase C — role-aware landin...
- [`verify-ymax0-hex-fix-inquisitor`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/verify-ymax0-hex-fix-inquisitor.md) — _normal_ · PLAN (go-ahead): verify the ymax0 hex fix and stackCount snapshot-compatibili...
- [`wire-siwe-onchain-authz-minion-town`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/wire-siwe-onchain-authz-minion-town.md) — _normal_ · Wire the chosen SIWE on-chain authorization tier into minion.town's policy layer

### deferred (top by priority; foreman auto-promotes when idle)
- [`endojs-endo-but-for-bots-pr614-6ad25382-retro`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr614-6ad25382-retro.md) — _low_ · Retrospective on endojs/endo-but-for-bots PR #614 (primary: endojs-endo-but-f...
- [`endojs-endo-but-for-bots-pr632-bdf2827b-retro`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr632-bdf2827b-retro.md) — _low_ · Retrospective on endojs/endo-but-for-bots PR #632 (primary: endojs-endo-but-f...

### blocked (awaiting an artifact; unblock watcher auto-promotes on completion)
- [`build-daemon-rename-to-manager-phase2`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/build-daemon-rename-to-manager-phase2.md) — awaiting `https://github.com/endojs/endo-but-for-bots/pull/598` · Build: daemon→manager rename Phase 2 (identifier renames)
- [`build-daemon-rename-to-manager-phase3`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/build-daemon-rename-to-manager-phase3.md) — awaiting `build-daemon-rename-to-manager-phase2` · Build: daemon→manager rename Phase 3 (consumer sweep + CHANGELOG + docs)
- [`port-xs-to-rust-memory-safe-engine-s18`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/port-xs-to-rust-memory-safe-engine-s18.md) — awaiting `xs2rust-endor-build-stage5-fix6` · Fable supervisor: drive the XS→Rust (Endor) port from design to maintainer-re...
- [`resume-lint-ceiling-shepherds`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/resume-lint-ceiling-shepherds.md) — awaiting `https://github.com/endojs/endo-but-for-bots/pull/594` · Resume shepherds for PRs blocked by the endo-but-for-bots lint projectService...

## Watch set
(none)

## Hosts
- [endolin-garden-ece02cb4](https://github.com/kriskowal/garden/blob/journal2/hosts/endolin-garden-ece02cb4): 20 gardeners
- [endolin-garden2-5bcdff64](https://github.com/kriskowal/garden/blob/journal2/hosts/endolin-garden2-5bcdff64): 20 gardeners
