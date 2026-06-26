# Garden bulletin

_As of 2026-06-26T00:24:53Z · updated continuously as the job board advances (garden-bulletin.service). Rewritten only when the dashboard changes, so this marks the last change._

The maintainer dashboard: what needs a human first, then the state of ongoing
autonomous work. Regenerated deterministically by scripts/jobs/bulletin.sh; the
journalist's narrative leads in the Latest section above. This page (the journal's
README.md) IS the bulletin; the journal's layout and design narrative lives in
[DESIGN.md](DESIGN.md).

## Latest

The scholar finished cask cycle 16 and has already claimed cycle 17, now working the comment-fed library ingest. The only other in-flight job is hardening the bulletin loop so one bad tick can't take the service down (it went dark earlier). Recently landed: review passes on [endo-but-for-bots#532](https://github.com/endojs/endo-but-for-bots/pull/532) and the erights #3312 feedback on [endo-but-for-bots#474](https://github.com/endojs/endo-but-for-bots/pull/474), plus a triager that now detects maintainer approvals and a plan to remove driver dead code.

One item needs a human: a [message to the maintainer](https://github.com/kriskowal/garden/blob/journal2/inbox/maintainer/unread/20260625T220640Z-aa7070.md) asks whether kriscendobot's mention triage should add an **authorship gate** — acting only on mentions where the target PR or issue was authored by kriscendobot. The trigger was [endo-but-for-bots#525](https://github.com/endojs/endo-but-for-bots/pull/525), authored by 0xpatrickbot, where an allowlisted sender's comment got triaged (and acted on) even though it was meant for the other bot; the sender welcomed the help but flagged the expectation. It's a scope/identity call awaiting your decision before any infra change lands.

## Parked for maintainer feedback

- [endojs/endo-but-for-bots#178](https://github.com/endojs/endo-but-for-bots/pull/178) — refactor(daemon): introduce locator scheme with @-delimited connection hints (per kriskowal #178) (waiting 3h)
- [endojs/endo-but-for-bots#440](https://github.com/endojs/endo-but-for-bots/pull/440) — feat(daemon,cli,chat): drop @info name hub for formula-inspector design (#439) (waiting 10m)
- [endojs/endo-but-for-bots#503](https://github.com/endojs/endo-but-for-bots/pull/503) — feat(immutable-arraybuffer,pass-style): passable byte arrays (freezable TypedArray emulation + byteArray brand check) (waiting 3h)
- [endojs/endo-but-for-bots#513](https://github.com/endojs/endo-but-for-bots/pull/513) — feat(pubsub): create @endo/pubsub with Sink/Spring async promise linked list (changes + latest variants) (waiting 9h)
- [endojs/endo-but-for-bots#403](https://github.com/endojs/endo-but-for-bots/pull/403) — feat(registry-capability): EndoRegistry capability + @registry special name (#358 layer 1) (waiting 1d)
- [endojs/endo-but-for-bots#58](https://github.com/endojs/endo-but-for-bots/pull/58) — feat(daemon,cli): error tracing across CapTP workers (#1879) (waiting 2d)
- [endojs/endo-but-for-bots#379](https://github.com/endojs/endo-but-for-bots/pull/379) — fix(ses): cyclic star export with renaming reexport (issue #59) - refresh for #3276 feedback (waiting 3d)
- [endojs/endo#3137](https://github.com/endojs/endo/pull/3137) — feat: support .ts runtime modules via erasable type syntax (waiting 10d)
- [endojs/endo-but-for-bots#101](https://github.com/endojs/endo-but-for-bots/pull/101) — feat(chat): voice input via Web Speech API (waiting 35d)
- [endojs/endo-but-for-bots#182](https://github.com/endojs/endo-but-for-bots/pull/182) — test(ses): isImmutableDataProperty regression for iOS Safari fix (closes #947) (waiting 34d)

_Showing top 10 of 31 parked PRs (ranked by recency + roadmap relevance)._
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

### doin (2)
- `harden-bulletin-loop-crash-resilience` — Harden the bulletin loop: one bad tick must not kill the service (it went dar...
- `scholar-ingest-cask-16` — Scholar: continue the library ingest of kriskowal/cask (cycle 17) — comment-f...

### tada (186)
- `scholar-ingest-cask-15` — Completion report — scholar-ingest-cask-15 (cask cycle 16)
- `endojs-endo-but-for-bots-pr532-review-79d8b272` — Completion report
- `address-erights-3312-review-on-pr474` — Completion report: address-erights-3312-review-on-pr474
- `triager-detect-approvals` — Completion report — triager-detect-approvals
- `plan-remove-driver-dead-code` — Completion report
- … and 181 more

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
