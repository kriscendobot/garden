# Garden bulletin

_As of 2026-07-07T23:46:30Z_

## Latest

minion.town auth hardening [shipped](https://github.com/kriskowal/garden/blob/journal2/jobs/tada/minion-town-auth-verified-email-reconcile.md): the GitHub OIDC thunk now refuses accounts without a GitHub-verified email, with the gardener confirming `kriskowal@kriskowal.com` is a verified primary so the change doesn't lock the maintainer out (breakglass remains a fallback either way). Two erights.org translations landed as fork-side **draft** PRs that need a licensing call before leaving draft: Miller & Svoboda's "Distributed Capability Confinement" ([endo-but-for-bots#629](https://github.com/endojs/endo-but-for-bots/pull/629)) and Miller's "Grant Matcher Puzzle" ([endo-but-for-bots#630](https://github.com/endojs/endo-but-for-bots/pull/630)) — the first hinges on whether the public-domain dedication covers the co-author and figure, the second on republishing copyrighted prose. minion.town Phase 3 (Google federation) is parked as a go-ahead job awaiting a Google OAuth client id/secret only the maintainer can provision; the other phases proceeded in parallel. The XS→Rust (Endor) port continues through its stage-5 fix5 sub-jobs (lexer validation done, regexp validation in flight), and a new unified GitHub/Google/SIWE login-page design for minion.town is in progress.

## Parked for maintainer feedback

- [endojs/endo#3319](https://github.com/endojs/endo/pull/3319) — feat(eslint-plugin)!: support ESLint 10+ (waiting 21m)
- [endojs/endo-but-for-bots#101](https://github.com/endojs/endo-but-for-bots/pull/101) — feat(chat): voice input via Web Speech API (waiting 5d)
- [endojs/endo-but-for-bots#503](https://github.com/endojs/endo-but-for-bots/pull/503) — feat(immutable-arraybuffer,pass-style): passable byte arrays (freezable TypedArray emulation + byteArray brand check) (waiting 7d)
- [endojs/endo-but-for-bots#403](https://github.com/endojs/endo-but-for-bots/pull/403) — feat(registry-capability): EndoRegistry capability + @registry special name (#358 layer 1) (waiting 8d)
- [endojs/endo-but-for-bots#379](https://github.com/endojs/endo-but-for-bots/pull/379) — fix(ses): cyclic star export with renaming reexport (issue #59) - refresh for #3276 feedback (waiting 11d)
- [endojs/endo#3137](https://github.com/endojs/endo/pull/3137) — feat: support .ts runtime modules via erasable type syntax (waiting 22d)
- [endojs/endo-but-for-bots#182](https://github.com/endojs/endo-but-for-bots/pull/182) — test(ses): isImmutableDataProperty regression for iOS Safari fix (closes #947) (waiting 46d)
- [endojs/endo-but-for-bots#186](https://github.com/endojs/endo-but-for-bots/pull/186) — feat(eventual-send): eager-shim/lazy-main delegate ponyfill (per #175) (waiting 46d)
- [endojs/endo-but-for-bots#266](https://github.com/endojs/endo-but-for-bots/pull/266) — design: opencode comparative analysis + gap-closing raft (endopen) (waiting 48d)
- [endojs/endo-but-for-bots#329](https://github.com/endojs/endo-but-for-bots/pull/329) — docs: introduce spackle, the polyfill+ponyfill race pattern (waiting 48d)

_Showing top 10 of 27 parked PRs (ranked by recency + roadmap relevance)._
## Messages to the maintainer

- `20260707T063029Z-8f87e8` — from proxy, reply_to `?` · [open message](https://github.com/kriskowal/garden/blob/journal2/inbox/maintainer/unread/20260707T063029Z-8f87e8.md)

> awaiting maintainer — beyond proxy authority: gardener minion-town-phase3-google-idp, msgid 20260707T061444Z-49a26d.md — Delivering a Google OAuth client id/secret is a credential/authority grant the proxy cannot originate or provision — only the maintainer holds it; the gardener's own park-and-go-ahead fallback already covers progress.

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

- `20260707T223801Z-f139ee` — from gardener:translate-distributed-confinement-to-docs, reply_to `translate-distributed-confinement-to-docs` · [open message](https://github.com/kriskowal/garden/blob/journal2/inbox/maintainer/unread/20260707T223801Z-f139ee.md)

> Translated Mark Miller & Melora Svoboda's "Distributed Capability Confinement" into an Endo docs page — DRAFT PR: https://github.com/endojs/endo-but-for-bots/pull/629 (fork only, not ferried upstream).
>
> Licensing decision needed before it leaves draft: the source page dedicates "all text ... by Mark S. Miller" to the public domain, but that dedication does NOT clearly cover (a) co-author Melora Svoboda's contribution or (b) the figure image. I wrote an original re-exposition (not a verbatim copy) and redrew the figure as an original Mermaid diagram to stay clear of (b). Please confirm whether the public-domain dedication is sufficient to publish, or whether we should seek explicit confirmation from the authors first. Also flagged: design-endo-thesis-translation conventions hadn't landed, so category ("Concepts") and figure-tooling (Mermaid) are judgment calls to reconcile.

- `20260707T224012Z-530858` — from gardener:translate-grant-matcher-to-docs, reply_to `translate-grant-matcher-to-docs` · [open message](https://github.com/kriskowal/garden/blob/journal2/inbox/maintainer/unread/20260707T224012Z-530858.md)

> Grant Matcher translation → draft PR endojs/endo-but-for-bots#630
> (https://github.com/endojs/endo-but-for-bots/pull/630)
>
> DONE: Translated Mark S. Miller's "The Grant Matcher Puzzle" (erights.org) into
> a docs.endojs.org page (docs/grant-matcher.md, registered in typedoc.json
> projectDocuments under Guides). E → Jessie/Hardened JS, CapTP → OCapN, Java
> reference impl → makeExo/E(); Miller's argument/prose kept faithful, each
> code/protocol substitution flagged inline. Fork-side draft only, no upstream
> ferry. Base = frozen master-eecc683.
>
> DECISION NEEDED — attribution & licensing. Miller's articles are copyrighted;
> I assumed NO license. The page quotes his key definitional passages (attributed
> block quotes) and paraphrases the rest. Before this is published to
> docs.endojs.org you'll need to either (1) confirm permission to republish this
> translated adaptation, or (2) have it reduced to a shorter summary-with-citation.
> The PR is draft and both the page and PR body say "do not merge/publish until
> this is settled." Flagging per the job.
>
> Minor judgment call: filed under the "Guides" category (where message-passing
> lives); it's arguably an "Annex" historical piece — your call.

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

- `20260707T232756Z-1f53fd` — from proxy, reply_to `?` · [open message](https://github.com/kriskowal/garden/blob/journal2/inbox/maintainer/unread/20260707T232756Z-1f53fd.md)

> awaiting maintainer — beyond proxy authority: gardener minion-town-auth-verified-email-reconcile, msgid 20260707T230941Z-bdccad.md — Whether `kriskowal@kriskowal.com` is a verified GitHub email — and whether to perform a fresh login — is personal account fact/action only the maintainer can supply, gating an irreversible lockout that could lock the maintainer out.

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


## Board
### todo (0)
(none)

### doin (2)
- [`design-minion-town-unified-login-page`](https://github.com/kriskowal/garden/blob/journal2/jobs/doin/design-minion-town-unified-login-page.md) — minion.town: one unified, minimal login page (GitHub / Google / SIWE) + a lan...
- [`xs2rust-endor-stage5-fix5-regexp-validation`](https://github.com/kriskowal/garden/blob/journal2/jobs/doin/xs2rust-endor-stage5-fix5-regexp-validation.md) — Stage-5 fix5 4/5 — regexp compile-time validation parity + module-goal fold a...

### tada (1464)
- [`minion-town-auth-verified-email-reconcile`](https://github.com/kriskowal/garden/blob/journal2/jobs/tada/minion-town-auth-verified-email-reconcile.md) — Completion report: minion.town verified-email enforcement + auth-config recon...
- [`project-xs-changes-to-endor-23b4d6b0`](https://github.com/kriskowal/garden/blob/journal2/jobs/tada/project-xs-changes-to-endor-23b4d6b0.md) — Completion report
- [`design-siwe-onchain-authz-minion-town`](https://github.com/kriskowal/garden/blob/journal2/jobs/tada/design-siwe-onchain-authz-minion-town.md) — What I did
- [`xs2rust-endor-stage5-fix5-lexer-validation`](https://github.com/kriskowal/garden/blob/journal2/jobs/tada/xs2rust-endor-stage5-fix5-lexer-validation.md) — Completion report — xs2rust-endor-stage5-fix5-lexer-validation
- [`deadmail-20260707T224512Z-feabd5`](https://github.com/kriskowal/garden/blob/journal2/jobs/tada/deadmail-20260707T224512Z-feabd5.md) — Completion report
- … and 1459 more

## Plan queue (parked — not claimable until promoted)
### awaiting go-ahead (maintainer authorization)
- [`deploy-siwe-thunk-minion-town`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/deploy-siwe-thunk-minion-town.md) — _normal_ · Deploy the SIWE OIDC thunk (mirroring the GitHub thunk's AWS path)
- [`endojs-endo-but-for-bots-pr132-report-render-mode`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr132-report-render-mode.md) — _normal_ · re-port render-mode toggle onto @endo/space-chat InboxRoot (endojs/endo-but-f...
- [`foreman-budget-cross-host-weekly-token-aggregation`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/foreman-budget-cross-host-weekly-token-aggregation.md) — _normal_ · PLAN: deterministic cross-host weekly token-spend aggregation for the foreman...
- [`verify-ymax0-hex-fix-inquisitor`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/verify-ymax0-hex-fix-inquisitor.md) — _normal_ · PLAN (go-ahead): verify the ymax0 hex fix and stackCount snapshot-compatibili...
- [`wire-siwe-onchain-authz-minion-town`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/wire-siwe-onchain-authz-minion-town.md) — _normal_ · Wire the chosen SIWE on-chain authorization tier into minion.town's policy layer

### deferred (top by priority; foreman auto-promotes when idle)
- [`port-endor-oracle-bump-8-3-1`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/port-endor-oracle-bump-8-3-1.md) — _normal_ · ---
- [`endojs-endo-but-for-bots-pr96-review-94e37389-retro`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr96-review-94e37389-retro.md) — _low_ · Retrospective on endojs/endo-but-for-bots PR #96 (primary: endojs-endo-but-fo...
- [`endojs-endo-but-for-bots-pr612-review-6da32098-retro`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr612-review-6da32098-retro.md) — _low_ · Retrospective on endojs/endo-but-for-bots PR #612 (primary: endojs-endo-but-f...

### blocked (awaiting an artifact; unblock watcher auto-promotes on completion)
- [`build-daemon-rename-to-manager-phase2`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/build-daemon-rename-to-manager-phase2.md) — awaiting `https://github.com/endojs/endo-but-for-bots/pull/598` · Build: daemon→manager rename Phase 2 (identifier renames)
- [`build-daemon-rename-to-manager-phase3`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/build-daemon-rename-to-manager-phase3.md) — awaiting `build-daemon-rename-to-manager-phase2` · Build: daemon→manager rename Phase 3 (consumer sweep + CHANGELOG + docs)
- [`port-xs-to-rust-memory-safe-engine-s17`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/port-xs-to-rust-memory-safe-engine-s17.md) — awaiting `xs2rust-endor-build-stage5-fix5` · Fable supervisor: drive the XS→Rust (Endor) port from design to maintainer-re...
- [`resume-lint-ceiling-shepherds`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/resume-lint-ceiling-shepherds.md) — awaiting `https://github.com/endojs/endo-but-for-bots/pull/594` · Resume shepherds for PRs blocked by the endo-but-for-bots lint projectService...

## Watch set
(none)

## Hosts
- [endolin-garden-ece02cb4](https://github.com/kriskowal/garden/blob/journal2/hosts/endolin-garden-ece02cb4): 20 gardeners
- [endolin-garden2-5bcdff64](https://github.com/kriskowal/garden/blob/journal2/hosts/endolin-garden2-5bcdff64): 20 gardeners
