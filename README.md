# Garden bulletin

_As of 2026-06-30T06:15:17Z_

## Latest

Design review on [endo-but-for-bots#572](https://github.com/endojs/endo-but-for-bots/pull/572) (the byteArray view design doc) closed out: erights resolved its open questions, and a gardener recorded the disposition decision — "withdraw and open fresh" — as Design Decision 6, resolved the restrictive-span question (now [endo-but-for-bots#573](https://github.com/endojs/endo-but-for-bots/issues/573)), and pushed the bookkeeping to the PR branch. Two maintainer authorization requests are now parked in the inbox: executing the disposition needs your go-ahead to close [endo-but-for-bots#429](https://github.com/endojs/endo-but-for-bots/pull/429) and [endo-but-for-bots#57](https://github.com/endojs/endo-but-for-bots/pull/57), withdraw upstream [endo#3226](https://github.com/endojs/endo/pull/3226) (out of bot scope — needs you or the boatman), and open a fresh view-based implementation PR; the helper-naming question was deferred to you. An attention directive on [endo-but-for-bots#475](https://github.com/endojs/endo-but-for-bots/pull/475) is still in flight. Heads-up on infra: the journal worktree on endolinbot2 has diverged from origin/journal2 (3 ahead, 5549 behind, 5 dirty) and was left untouched for manual reconciliation.

## Parked for maintainer feedback

- [endojs/endo-but-for-bots#58](https://github.com/endojs/endo-but-for-bots/pull/58) — feat(daemon,cli): error tracing across CapTP workers (#1879) (waiting 1h)
- [endojs/endo-but-for-bots#503](https://github.com/endojs/endo-but-for-bots/pull/503) — feat(immutable-arraybuffer,pass-style): passable byte arrays (freezable TypedArray emulation + byteArray brand check) (waiting 1h)
- [endojs/endo-but-for-bots#343](https://github.com/endojs/endo-but-for-bots/pull/343) — design(gateway): overarching @endo/gateway package integrating the gateway/weblet/Noise cluster (waiting 21h)
- [endojs/endo-but-for-bots#403](https://github.com/endojs/endo-but-for-bots/pull/403) — feat(registry-capability): EndoRegistry capability + @registry special name (#358 layer 1) (waiting 21h)
- [endojs/endo-but-for-bots#379](https://github.com/endojs/endo-but-for-bots/pull/379) — fix(ses): cyclic star export with renaming reexport (issue #59) - refresh for #3276 feedback (waiting 4d)
- [endojs/endo#3137](https://github.com/endojs/endo/pull/3137) — feat: support .ts runtime modules via erasable type syntax (waiting 14d)
- [endojs/endo-but-for-bots#101](https://github.com/endojs/endo-but-for-bots/pull/101) — feat(chat): voice input via Web Speech API (waiting 39d)
- [endojs/endo-but-for-bots#182](https://github.com/endojs/endo-but-for-bots/pull/182) — test(ses): isImmutableDataProperty regression for iOS Safari fix (closes #947) (waiting 39d)
- [endojs/endo-but-for-bots#186](https://github.com/endojs/endo-but-for-bots/pull/186) — feat(eventual-send): eager-shim/lazy-main delegate ponyfill (per #175) (waiting 39d)
- [endojs/endo-but-for-bots#266](https://github.com/endojs/endo-but-for-bots/pull/266) — design: opencode comparative analysis + gap-closing raft (endopen) (waiting 41d)

_Showing top 10 of 29 parked PRs (ranked by recency + roadmap relevance)._
## Messages to the maintainer

- `20260630T054655Z-c69950` — from gardener:endojs-endo-but-for-bots-pr572-dea7fcb4, reply_to `endojs-endo-but-for-bots-pr572-dea7fcb4` · [open message](https://github.com/kriskowal/garden/blob/journal2/inbox/maintainer/unread/20260630T054655Z-c69950.md)

> ATTENTION / authorization request — erights' review on endojs/endo-but-for-bots#572 (byteArray design doc)
>
> erights left a 3-comment review on the design doc PR #572 resolving its open questions. One part needs your authorization because it crosses repos (incl. upstream Endo) and the directive arrived on an untrusted PR comment, which I can't self-promote into a PR-close authorization.
>
> erights' decisions:
> 1. Sub-view open question: "go with the restrictive option for now" (whole-buffer-span / no permissive sub-views); capture the question+discussion as a SEPARATE ISSUE assigned to erights and link it from #572.
> 2. Disposition open question (this job's trigger, anchored on the doc's "withdraw all three vs retarget" line): "For all, withdraw and open fresh." → withdraw #429, #57, and upstream endojs/endo#3226, and open a fresh view-based implementation PR.
> 3. Helper-naming unification: erights defers to @kriskowal.
>
> What executing #2 entails (and why I'm routing, not acting):
> - Close endo-but-for-bots #429 (kriscendobot, draft) and #57 (kriscendobot) — bot CAN close these, but PR-close is not covered by the endo-but-for-bots standing authorization (comments/reactjis only), so it needs your go-ahead.
> - Close upstream endojs/endo#3226 — kriskowal-authored, upstream Endo: bot CANNOT touch it (identity boundary). This needs you / the boatman path.
> - Open a fresh view-based implementation PR grounded in design #572 + the existing feat/narrow-bytearray-to-uint8 prototype — a builder job I can post once authorized.
>
> Recommended plan if you approve:
>   a. I close #429 and #57 with a close-comment citing #572 + the fresh-impl plan (branches preserved, reversible).
>   b. I post a build job: "fresh view-based byteArray implementation PR per design #572, restrictive whole-buffer-span option."
>   c. I file the sub-view issue assigned to erights and link it from #572 (also resolves erights' comment #1).
>   d. You/boatman handle closing upstream endojs/endo#3226.
>
> I've added an 'eyes' reactji to erights' directive comment to mark it received. Awaiting your go-ahead on a-d (or a subset).

- `20260630T054924Z-17df96` — from gardener:endojs-endo-but-for-bots-pr572-review-f9f39a71, reply_to `endojs-endo-but-for-bots-pr572-review-f9f39a71` · [open message](https://github.com/kriskowal/garden/blob/journal2/inbox/maintainer/unread/20260630T054924Z-17df96.md)

> endo-but-for-bots PR #572 (byteArray view design) — erights resolved the disposition
> open question (review 4597598287): "For all, withdraw and open fresh."
>
> Done autonomously (design-of-record bookkeeping): recorded it as Design Decision 6,
> updated the Status + "Relationship to existing changes" prose, removed the disposition
> open question, replied on the thread. Pushed to the PR branch (c31c6a312).
>
> Needs your / a boatman's hand (lifecycle execution I did NOT do autonomously):
>   1. Withdraw (close) #429 and #57 on endo-but-for-bots.
>   2. Withdraw upstream endojs/endo#3226 — upstream endojs/endo action, out of bot scope.
>   3. Open a fresh view-based implementation PR, seeded from feat/narrow-bytearray-to-uint8.
>
> Note: this PR also has two sibling review threads being handled by peer gardeners —
> the restrictive-span question (already resolved to restrictive + issue #573, Decision 3)
> and the helper-naming question (erights deferred it to @kriskowal — needs your call).

- `20260630T061511Z-d43efe` — from watchdog:journal-worktree-keeper, reply_to `?` · [open message](https://github.com/kriskowal/garden/blob/journal2/inbox/maintainer/unread/20260630T061511Z-d43efe.md)

> journal worktree /home/kris/journal has DIVERGED from origin/journal2 and was left UNTOUCHED (no reset/pull/stash): 3 local-ahead commit(s), 5549 behind, 5 dirty path(s). Reconcile by hand: 'git -C /home/kris/journal status', 'git -C /home/kris/journal log --oneline origin/journal2..HEAD', then rebase/push or discard the local commits. (host=endolinbot2)


## Board
### todo (0)
(none)

### doin (1)
- [`endojs-endo-but-for-bots-pr475-14cfb16e`](https://github.com/kriskowal/garden/blob/journal2/jobs/doin/endojs-endo-but-for-bots-pr475-14cfb16e.md) — attention directive on endojs/endo-but-for-bots PR #475

### tada (686)
- [`deadmail-20260630T055455Z-9d5f3c`](https://github.com/kriskowal/garden/blob/journal2/jobs/tada/deadmail-20260630T055455Z-9d5f3c.md) — Completion report — dead-letter pickup deadmail-20260630T055455Z-9d5f3c
- [`deadmail-20260630T054746Z-40346c`](https://github.com/kriskowal/garden/blob/journal2/jobs/tada/deadmail-20260630T054746Z-40346c.md) — Completion report — job deadmail-20260630T054746Z-40346c
- [`endojs-endo-but-for-bots-pr572-review-1007395e`](https://github.com/kriskowal/garden/blob/journal2/jobs/tada/endojs-endo-but-for-bots-pr572-review-1007395e.md) — Completion report: review directive on endojs/endo-but-for-bots PR #572
- [`endojs-endo-but-for-bots-pr572-b07c1061`](https://github.com/kriskowal/garden/blob/journal2/jobs/tada/endojs-endo-but-for-bots-pr572-b07c1061.md) — Completion report
- [`endojs-endo-but-for-bots-pr572-review-f9f39a71`](https://github.com/kriskowal/garden/blob/journal2/jobs/tada/endojs-endo-but-for-bots-pr572-review-f9f39a71.md) — Completion report — job endojs-endo-but-for-bots-pr572-review-f9f39a71
- … and 681 more

## Plan queue (parked — not claimable until promoted)
### awaiting go-ahead (maintainer authorization)
- [`foreman-budget-cross-host-weekly-token-aggregation`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/foreman-budget-cross-host-weekly-token-aggregation.md) — _normal_ · PLAN: deterministic cross-host weekly token-spend aggregation for the foreman...
- [`port-ebfb-pr57-onto-475-restage`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/port-ebfb-pr57-onto-475-restage.md) — _normal_ · restage endo-but-for-bots #57 onto the updated #475
- [`port-xs-to-rust-memory-safe-engine`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/port-xs-to-rust-memory-safe-engine.md) — _normal_ · PLAN (go-ahead): port XS to Rust — a memory-safe, meterable, no-JIT JS engine...
- [`synth-and-deploy-minion-town-aws`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/synth-and-deploy-minion-town-aws.md) — _normal_ · Synth, wire custom domain, and live-deploy minion.town to AWS
- [`verify-ymax0-hex-fix-inquisitor`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/verify-ymax0-hex-fix-inquisitor.md) — _normal_ · PLAN (go-ahead): verify the ymax0 hex fix and stackCount snapshot-compatibili...

### deferred (top by priority; foreman auto-promotes when idle)
- [`bot-email-dedicated-domain-counter-plan-aws-hetzner`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/bot-email-dedicated-domain-counter-plan-aws-hetzner.md) — _low_ · PLAN (low priority, counter-plan to FastMail-masking): bot-driven email on a ...
- [`investigate-fastmail-masked-email-api-for-bot-personas`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/investigate-fastmail-masked-email-api-for-bot-personas.md) — _low_ · PLAN (low priority, investigate): FastMail masked-email API for bot persona m...
- [`scholar-ingest-ocap-kernel-comment-fragments-2`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/scholar-ingest-ocap-kernel-comment-fragments-2.md) — _low_ · PLAN: scholar — ingest the remaining ocap-kernel kernel-internals comment fra...
- [`fix-lint-jsdoc-warnings-endo-master`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/fix-lint-jsdoc-warnings-endo-master.md) — _low_ · SUPERSEDED — fix-lint: jsdoc warnings on endo master

### blocked (awaiting an artifact; unblock watcher auto-promotes on completion)
- [`formula-inspector-retention-paths-table-v2`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/formula-inspector-retention-paths-table-v2.md) — awaiting `https://github.com/endojs/endo-but-for-bots/pull/284` · PLAN (follow-on, re-parked): add a retention-paths table to the formula inspe...

## Watch set
(none)

## Hosts
- [endolinbot](https://github.com/kriskowal/garden/blob/journal2/hosts/endolinbot): 100 gardeners
- [endolinbot2](https://github.com/kriskowal/garden/blob/journal2/hosts/endolinbot2): 100 gardeners
- [main-host](https://github.com/kriskowal/garden/blob/journal2/hosts/main-host): ? gardeners
