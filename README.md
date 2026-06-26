# Garden bulletin

_As of 2026-06-26T00:53:25Z · updated continuously as the job board advances (garden-bulletin.service). Rewritten only when the dashboard changes, so this marks the last change._

The maintainer dashboard: what needs a human first, then the state of ongoing
autonomous work. Regenerated deterministically by scripts/jobs/bulletin.sh; the
journalist's narrative leads in the Latest section above. This page (the journal's
README.md) IS the bulletin; the journal's layout and design narrative lives in
[DESIGN.md](DESIGN.md).

## Latest

The bulletin input is data to narrate — let me write the "## Latest" section prose.

Looking at the input: little of substance moved in this window. The only board transitions are one new progress note and one job claim ([endo-but-for-bots#69](https://github.com/endojs/endo-but-for-bots/pull/69) moving into `doin`). The notable item for a maintainer is the unread message about #525's authorship-gate question, plus freshly-parked PRs.

Let me write a terse Latest section.

A quiet window: the only board movement was a gardener claiming the attention directive on [endo-but-for-bots#69](https://github.com/endojs/endo-but-for-bots/pull/69), now in progress alongside the ongoing finbot dry-run and the [#510](https://github.com/endojs/endo-but-for-bots/pull/510)-vs-[#511](https://github.com/endojs/endo-but-for-bots/pull/511) sturdyref/retention design pair. Most maintainer attention is owed off the board: an **unread message** raises a scope question about whether kriscendobot's mention triage should add an authorship gate — it acted on [endo-but-for-bots#525](https://github.com/endojs/endo-but-for-bots/pull/525) (authored by 0xpatrickbot, not kriscendobot) on an allowlisted sender's comment; the work was welcomed, but 0xpatrickdev suggested mentions should only be acted on for PRs kriscendobot itself authored, and the gardener is awaiting your call before landing that change. Freshest in the parked queue are the new [@endo/pubsub](https://github.com/endojs/endo-but-for-bots/pull/513) PR and the [formula-inspector design](https://github.com/endojs/endo-but-for-bots/pull/440) (#439), both awaiting review.

## Parked for maintainer feedback

- [endojs/endo-but-for-bots#440](https://github.com/endojs/endo-but-for-bots/pull/440) — feat(daemon,cli,chat): drop @info name hub for formula-inspector design (#439) (waiting 35m)
- [endojs/endo-but-for-bots#503](https://github.com/endojs/endo-but-for-bots/pull/503) — feat(immutable-arraybuffer,pass-style): passable byte arrays (freezable TypedArray emulation + byteArray brand check) (waiting 4h)
- [endojs/endo-but-for-bots#513](https://github.com/endojs/endo-but-for-bots/pull/513) — feat(pubsub): create @endo/pubsub with Sink/Spring async promise linked list (changes + latest variants) (waiting 4m)
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


## Board
### todo (0)
(none)

### doin (3)
- `complete-finbot-as-designed` — GOAL: complete kriscendobot/finbot as designed (end-to-end dry-run OODA loop)
- `endojs-endo-but-for-bots-pr69-d9e42969` — attention directive on endojs/endo-but-for-bots PR #69
- `sturdyref-retention-competing-design-pair` — Advance the competing sturdyref + formula-retention design pair (#510 vs #511...

### tada (192)
- `endojs-endo-but-for-bots-pr507-rebase` — Completion report: endojs-endo-but-for-bots-pr507-rebase
- `scholar-ingest-cask-18` — Completion report — scholar-ingest-cask-18 (cycle 18)
- `apply-self-healing-wrapper-to-all-services` — Completion report
- `endojs-endo-but-for-bots-pr178-conduct-llm` — Waiting for CI completion. The harness will re-invoke me when the background ...
- `scholar-ingest-cask-16` — Completion report — scholar-ingest-cask-16 (cask cycle 17)
- … and 187 more

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
