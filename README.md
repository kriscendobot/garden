# Garden bulletin

_As of 2026-06-26T01:01:04Z · updated continuously as the job board advances (garden-bulletin.service). Rewritten only when the dashboard changes, so this marks the last change._

The maintainer dashboard: what needs a human first, then the state of ongoing
autonomous work. Regenerated deterministically by scripts/jobs/bulletin.sh; the
journalist's narrative leads in the Latest section above. This page (the journal's
README.md) IS the bulletin; the journal's layout and design narrative lives in
[DESIGN.md](DESIGN.md).

## Latest

The lone board move this cycle: the [sturdyref-retention-competing-design-pair](https://github.com/endojs/endo-but-for-bots/pull/500) job completed, so the competing SturdyRef-retention plans [endo-but-for-bots#510](https://github.com/endojs/endo-but-for-bots/pull/510) and [endo-but-for-bots#511](https://github.com/endojs/endo-but-for-bots/pull/511) are now fully aligned, compared side-by-side, and parked for kriskowal's decision. A two-juror design panel (determinism and user-agency lenses) independently converged on the same answer: synthesize with #510's daemon-owned retain/release syscall as the spine, grafting #511's proactive per-turn export deletion as a hard requirement and its FinalizationRegistry as an optional off-by-default leak-detector. The full rationale is on [endo-but-for-bots#500](https://github.com/endojs/endo-but-for-bots/pull/500#issuecomment-4805502325); the report also flags a typo to fix before it sets a public name — `getStudyRefLocator` should be `getSturdyRefLocator` in [endo-but-for-bots#521](https://github.com/endojs/endo-but-for-bots/pull/521). Separately, a routing question awaits a call: a mention on [endo-but-for-bots#525](https://github.com/endojs/endo-but-for-bots/pull/525) (authored by 0xpatrickbot, not kriscendobot) was triaged because the watcher gates on sender trust alone, and 0xpatrickdev suggests adding an authorship gate so kriscendobot only acts on PRs it authored.

## Parked for maintainer feedback

- [endojs/endo-but-for-bots#440](https://github.com/endojs/endo-but-for-bots/pull/440) — feat(daemon,cli,chat): drop @info name hub for formula-inspector design (#439) (waiting 45m)
- [endojs/endo-but-for-bots#503](https://github.com/endojs/endo-but-for-bots/pull/503) — feat(immutable-arraybuffer,pass-style): passable byte arrays (freezable TypedArray emulation + byteArray brand check) (waiting 4h)
- [endojs/endo-but-for-bots#513](https://github.com/endojs/endo-but-for-bots/pull/513) — feat(pubsub): create @endo/pubsub with Sink/Spring async promise linked list (changes + latest variants) (waiting 14m)
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


## Board
### todo (0)
(none)

### doin (3)
- `complete-finbot-as-designed` — GOAL: complete kriscendobot/finbot as designed (end-to-end dry-run OODA loop)
- `design-mcp-oauth-aws-minion-town` — Design an MCP server with OAuth authN/authZ — great local DX + AWS-deployable...
- `endojs-endo-but-for-bots-pr527-review-0fb462c4` — Review directive on endojs/endo-but-for-bots PR #527

### tada (195)
- `sturdyref-retention-competing-design-pair` — Completion report: sturdyref-retention-competing-design-pair
- `endojs-endo-but-for-bots-pr178-finish-merge-llm` — Waiting for the background CI watch to settle. Nothing more to do until then.
- `endojs-endo-but-for-bots-pr69-d9e42969` — The directive is handled. Final report below.
- `endojs-endo-but-for-bots-pr507-rebase` — Completion report: endojs-endo-but-for-bots-pr507-rebase
- `scholar-ingest-cask-18` — Completion report — scholar-ingest-cask-18 (cycle 18)
- … and 190 more

## Plan queue (parked — not claimable until promoted)
### awaiting go-ahead (maintainer authorization)
(none)

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
