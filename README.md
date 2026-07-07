# Garden bulletin

_As of 2026-07-07T23:06:43Z_

## Latest

Google federation (Phase 3) for minion.town stalled waiting on a Google OAuth client only the maintainer can provision — the gardener parked the remainder as the go-ahead job `minion-town-phase3-completion` (nothing lost; other phases proceeded in parallel) and left four inbox messages plus two proxy escalations explaining how to unblock it (create the Web client for the `.../oauth2/idpresponse` redirect and store it as Secrets Manager secret `minion/google-idp-client`). Two new docs translations landed as fork-only DRAFT PRs, both gated on a licensing decision before they can leave draft: Mark Miller & Melora Svoboda's "Distributed Capability Confinement" ([endo-but-for-bots#629](https://github.com/endojs/endo-but-for-bots/pull/629)) and Miller's "The Grant Matcher Puzzle" ([endo-but-for-bots#630](https://github.com/endojs/endo-but-for-bots/pull/630)) — the first redrawn as an original Mermaid figure to sidestep image rights, the second quoting attributed passages under an assumed no-license. A dead-lettered garden#29 correction was picked up and closed out: mhofman's exact-vatID pinning was already folded into [kriscendobot/agoric-sdk#9](https://github.com/kriskowal/agoric-sdk/pull/9), but the gardener found and fixed a real end-to-end gap (the Go switch only logged vatIDs, never writing the promotion directive) and flagged a Go-vs-JS design question for mhofman. The XS→Rust (Endor) port continues grinding through Stage-5 fix5 validation work, and a `minion-town-auth-verified-email-reconcile` job (enforce GitHub email verification) is in flight.

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
- [endojs/endo#3102](https://github.com/endojs/endo/pull/3102) — chore(ci): create custom CHANGELOG generator (waiting 55d)

_Showing top 10 of 26 parked PRs (ranked by recency + roadmap relevance)._
## Messages to the maintainer

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

- `20260707T063029Z-8f87e8` — from proxy, reply_to `?` · [open message](https://github.com/kriskowal/garden/blob/journal2/inbox/maintainer/unread/20260707T063029Z-8f87e8.md)

> awaiting maintainer — beyond proxy authority: gardener minion-town-phase3-google-idp, msgid 20260707T061444Z-49a26d.md — Delivering a Google OAuth client id/secret is a credential/authority grant the proxy cannot originate or provision — only the maintainer holds it; the gardener's own park-and-go-ahead fallback already covers progress.

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


## Board
### todo (0)
(none)

### doin (2)
- [`minion-town-auth-verified-email-reconcile`](https://github.com/kriskowal/garden/blob/journal2/jobs/doin/minion-town-auth-verified-email-reconcile.md) — minion.town: enforce GitHub email verification at the thunk + reconcile live ...
- [`xs2rust-endor-stage5-fix5-regexp-validation`](https://github.com/kriskowal/garden/blob/journal2/jobs/doin/xs2rust-endor-stage5-fix5-regexp-validation.md) — Stage-5 fix5 4/5 — regexp compile-time validation parity + module-goal fold a...

### tada (1463)
- [`project-xs-changes-to-endor-23b4d6b0`](https://github.com/kriskowal/garden/blob/journal2/jobs/tada/project-xs-changes-to-endor-23b4d6b0.md) — Completion report
- [`design-siwe-onchain-authz-minion-town`](https://github.com/kriskowal/garden/blob/journal2/jobs/tada/design-siwe-onchain-authz-minion-town.md) — What I did
- [`xs2rust-endor-stage5-fix5-lexer-validation`](https://github.com/kriskowal/garden/blob/journal2/jobs/tada/xs2rust-endor-stage5-fix5-lexer-validation.md) — Completion report — xs2rust-endor-stage5-fix5-lexer-validation
- [`deadmail-20260707T224512Z-feabd5`](https://github.com/kriskowal/garden/blob/journal2/jobs/tada/deadmail-20260707T224512Z-feabd5.md) — Completion report
- [`xs-upstream-watch-20260707-225001`](https://github.com/kriskowal/garden/blob/journal2/jobs/tada/xs-upstream-watch-20260707-225001.md) — The projection job is live (already claimed into jobs/doin/ by a peer gardene...
- … and 1458 more

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
