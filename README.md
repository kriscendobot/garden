# Garden bulletin

_As of 2026-06-26T01:18:03Z · updated continuously as the job board advances (garden-bulletin.service). Rewritten only when the dashboard changes, so this marks the last change._

The maintainer dashboard: what needs a human first, then the state of ongoing
autonomous work. Regenerated deterministically by scripts/jobs/bulletin.sh; the
journalist's narrative leads in the Latest section above. This page (the journal's
README.md) IS the bulletin; the journal's layout and design narrative lives in
[DESIGN.md](DESIGN.md).

## Latest

The conductor's CI-wait-to-merge hardening [just landed](https://github.com/endojs/endo-but-for-bots/pull/532) — the fix that keeps a merge job from ending while CI is merely pending now backs the active shepherd/conduct loop on [endo-but-for-bots#532](https://github.com/endojs/endo-but-for-bots/pull/532) and [#527](https://github.com/endojs/endo-but-for-bots/pull/527), both parked on CI and set to re-invoke when checks settle. A new garden-infra job is in flight to harden producer-clone locking so a crashed `post-plan`/`post-job` can't wedge future posts with a stale lock. Three things want a human: the SturdyRef competing-design pair ([#510](https://github.com/endojs/endo-but-for-bots/pull/510) vs #511) is complete and a two-juror panel converged on a synthesis recommendation ([side-by-side here](https://github.com/endojs/endo-but-for-bots/pull/500#issuecomment-4805502325)) — also flagging a `getStudyRefLocator`→`getSturdyRefLocator` typo in #521 worth fixing before it sets the public name; a scope question on whether kriscendobot's mention triage should add an authorship gate (it acted on [#525](https://github.com/endojs/endo-but-for-bots/pull/525), authored by another bot, on an allowlisted sender's mention); and a watchdog warning that `gh` was missing from PATH on endolinbot, which silently drops CI-wait work. Two minion.town AWS plans (Cognito↔MCP OAuth bridge, synth-and-deploy) are parked awaiting go-ahead.

## Parked for maintainer feedback

- [endojs/endo-but-for-bots#440](https://github.com/endojs/endo-but-for-bots/pull/440) — feat(daemon,cli,chat): drop @info name hub for formula-inspector design (#439) (waiting 1h)
- [endojs/endo-but-for-bots#503](https://github.com/endojs/endo-but-for-bots/pull/503) — feat(immutable-arraybuffer,pass-style): passable byte arrays (freezable TypedArray emulation + byteArray brand check) (waiting 4h)
- [endojs/endo-but-for-bots#513](https://github.com/endojs/endo-but-for-bots/pull/513) — feat(pubsub): create @endo/pubsub with Sink/Spring async promise linked list (changes + latest variants) (waiting 29m)
- [endojs/endo-but-for-bots#403](https://github.com/endojs/endo-but-for-bots/pull/403) — feat(registry-capability): EndoRegistry capability + @registry special name (#358 layer 1) (waiting 1d)
- [endojs/endo-but-for-bots#58](https://github.com/endojs/endo-but-for-bots/pull/58) — feat(daemon,cli): error tracing across CapTP workers (#1879) (waiting 2d)
- [endojs/endo-but-for-bots#379](https://github.com/endojs/endo-but-for-bots/pull/379) — fix(ses): cyclic star export with renaming reexport (issue #59) - refresh for #3276 feedback (waiting 3d)
- [endojs/endo#3137](https://github.com/endojs/endo/pull/3137) — feat: support .ts runtime modules via erasable type syntax (waiting 10d)
- [endojs/endo-but-for-bots#101](https://github.com/endojs/endo-but-for-bots/pull/101) — feat(chat): voice input via Web Speech API (waiting 35d)
- [endojs/endo-but-for-bots#182](https://github.com/endojs/endo-but-for-bots/pull/182) — test(ses): isImmutableDataProperty regression for iOS Safari fix (closes #947) (waiting 34d)
- [endojs/endo-but-for-bots#186](https://github.com/endojs/endo-but-for-bots/pull/186) — feat(eventual-send): eager-shim/lazy-main delegate ponyfill (per #175) (waiting 34d)

_Showing top 10 of 30 parked PRs (ranked by recency + roadmap relevance)._
## Messages to the maintainer

- `20260625T220640Z-aa7070` — from gardener:endojs-endo-but-for-bots-pr525-a17a2dbe, reply_to `endojs-endo-but-for-bots-pr525-a17a2dbe` · [open message](https://github.com/kriskowal/garden/blob/journal2/inbox/maintainer/unread/20260625T220640Z-aa7070.md)

> Routing decision on endojs/endo-but-for-bots #525 (no action taken; surfacing a gating question).
>
> What happened: 0xpatrickdev (allowlisted sender) commented on #525, a PR authored by **0xpatrickbot** (not kriscendobot). Earlier today kriscendobot acted on that PR anyway (commit 661fb57, "Addressed @0xpatrickdev's review — split the live eval, update README"). 0xpatrickdev's new comment clarifies the message was meant for @0xpatrickbot, welcomes the help ("appreciate you picking it up"), and notes: "@kriskowal is likely already tuning you to only act on messages from me _if_ they're on a PR or issue you authored."
>
> The mention-watcher gates on SENDER trust only (0xpatrickdev is on the allowlist), not on PR/issue AUTHORSHIP — so it triaged a mention on another bot's PR. The commit isn't being reverted (the work was welcomed), but I'm not engaging further on #525.
>
> Question (scope/identity call, your decision): do you want kriscendobot's mention triage to add an authorship gate — only act on mentions where the target PR/issue is authored by kriscendobot? That matches 0xpatrickdev's stated expectation and would have dropped this one. If yes, I'll post a garden-infra job to land it in mention-watcher.sh.

- `20260626T010008Z-d7c8da` — from gardener:sturdyref-retention-competing-design-pair, reply_to `sturdyref-retention-competing-design-pair` · [open message](https://github.com/kriskowal/garden/blob/journal2/inbox/maintainer/unread/20260626T010008Z-d7c8da.md)

> SturdyRef competing design pair (#510 vs #511) is complete and compared — ready for your decision.
>
> Both plans now cover the full shared problem (pass-style sturdyref + petname-placeholder + their retention approach), preserve the user-agency invariant, engage the ocap-kernel/daemon crux, and are aligned with #521's inert-data-box correction (#510 still had the stale E(sturdyRef)/HandledPromise framing; corrected).
>
> A two-juror design panel (determinism lens + user-agency lens) independently converged on the SAME recommendation: synthesis with #510 (endor retain/release syscall) as the spine — daemon owns retention, authoritative per-handle revocation edges, no new FinalizationRegistry — plus three grafts: (1) promote #510's deferred proactive per-turn deleteExport to a requirement so BOTH paths are GC-timing-independent; (2) keep #511's FinalizationRegistry only as an optional off-by-default leak-detector; (3) borrow #511's local-only-at-the-boundary rule.
>
> Full side-by-side + rationale: https://github.com/endojs/endo-but-for-bots/pull/500#issuecomment-4805502325
>
> For your call: adopt the synthesis, pick one as-is, or redirect. Also surfaced: getStudyRefLocator is a typo for getSturdyRefLocator in #521's shipped surface — worth fixing before it sets the public name.

- `20260626T011048Z-6f52fa` — from watchdog:ci-wait-merge, reply_to `?` · [open message](https://github.com/kriskowal/garden/blob/journal2/inbox/maintainer/unread/20260626T011048Z-6f52fa.md)

> required tool(s) missing on PATH (host=endolinbot, tag=ci-wait-merge): /tmp/tmp.rrolnKVTO1/gh — this silently drops work; install them or fix PATH


## Board
### todo (0)
(none)

### doin (4)
- `complete-finbot-as-designed` — GOAL: complete kriscendobot/finbot as designed (end-to-end dry-run OODA loop)
- `design-mcp-oauth-aws-minion-town` — Design an MCP server with OAuth authN/authZ — great local DX + AWS-deployable...
- `endojs-endo-but-for-bots-pr510-review-93293593` — Review directive on endojs/endo-but-for-bots PR #510
- `garden-harden-producer-clone-lock` — Harden producer-clone locking so a crashed post-plan/post-job can't wedge the...

### tada (200)
- `harden-conductor-ci-wait-complete-merge` — Completion report: harden-conductor-ci-wait-complete-merge
- `endojs-endo-but-for-bots-pr532-shepherd` — Waiting on CI. The background poller (bk06xiv1m) will re-invoke me the moment...
- `endojs-endo-but-for-bots-pr532-conduct` — Inbox is empty. The background CI poll (bs3izgx4m) will notify me when PR #53...
- `endojs-endo-but-for-bots-pr527-shepherd` — I've kicked off CI monitoring for PR #527. The watcher will re-invoke me when...
- `endojs-endo-but-for-bots-pr527-review-0fb462c4` — Completion report
- … and 195 more

## Plan queue (parked — not claimable until promoted)
### awaiting go-ahead (maintainer authorization)
- `cognito-mcp-metadata-bridge` — _normal_ · Build the Cognito↔MCP OAuth metadata/DCR/audience bridge for minion.town
- `synth-and-deploy-minion-town-aws` — _normal_ · Synth, wire custom domain, and live-deploy minion.town to AWS

### deferred (top by priority; foreman auto-promotes when idle)
- `investigate-systemd-run-vs-gardener-loops` — _normal_ · PLAN: investigate systemd-run vs. the fixed 100-gardener-loop pool → garden d...
- `investigate-resumable-gardeners` — _normal_ · PLAN: investigate making gardeners RESUMABLE (don't lose work when an agent s...
- `ingest-ocap-library-sections` — _normal_ · PLAN: scholar — ingest sources for six missing ocap library sections
- `ingest-ocap-kernel` — _normal_ · PLAN: scholar — ingest MetaMask/ocap-kernel into the library
- `formula-inspector-retention-paths-table` — _normal_ · PLAN (follow-on): add a retention-paths table to the formula inspector
- `classify-lint-endo-master` — _low_ · PLAN: classify lint errors on endo master, then post per-class fix plans

## Watch set
(none)

## Hosts
- endolinbot: 100 gardeners
