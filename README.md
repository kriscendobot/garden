# Garden bulletin

_As of 2026-07-02T01:01:49Z_

## Latest

A wave of shepherd runs closed out: [#101](https://github.com/endojs/endo-but-for-bots/pull/101), [#262](https://github.com/endojs/endo-but-for-bots/pull/262), [#306](https://github.com/endojs/endo-but-for-bots/pull/306), [#394](https://github.com/endojs/endo-but-for-bots/pull/394), [#395](https://github.com/endojs/endo-but-for-bots/pull/395), and [#409](https://github.com/endojs/endo-but-for-bots/pull/409), and the [#389](https://github.com/endojs/endo-but-for-bots/pull/389) weave landed. [#394](https://github.com/endojs/endo-but-for-bots/pull/394) escalated shepherd→fixer, while [#101](https://github.com/endojs/endo-but-for-bots/pull/101) and [#306](https://github.com/endojs/endo-but-for-bots/pull/306) were handed to a weaver to rebase their stale bases. Four garden-infra fixes were also posted and claimed — a host-identity drift detector, gardener transient-failure backoff / fleet brake, issue-inbox child-git reaping, and repo-watcher arm-retry.

Two items want a maintainer eye. First, [#592](https://github.com/endojs/endo-but-for-bots/pull/592) is green on 24 of 25 checks but red on `lint` from the known typescript-eslint projectService scaling ceiling — the failure lands in `packages/zip`, which this 6-file platform/daemon PR never touches, meaning the `llm` baseline is already at the ceiling; the same wall now blocks [#590](https://github.com/endojs/endo-but-for-bots/pull/590) and [#593](https://github.com/endojs/endo-but-for-bots/pull/593), so it likely wants its own lint-infra job rather than being folded into any refactor. Second, the botanist board-audit report asks whether recurring board audits should become a standing capability, and if so whether to build them on foreman/watchman or a new script — an architecture call before any work is posted.

## Parked for maintainer feedback

- [endojs/endo-but-for-bots#503](https://github.com/endojs/endo-but-for-bots/pull/503) — feat(immutable-arraybuffer,pass-style): passable byte arrays (freezable TypedArray emulation + byteArray brand check) (waiting 1d)
- [endojs/endo-but-for-bots#403](https://github.com/endojs/endo-but-for-bots/pull/403) — feat(registry-capability): EndoRegistry capability + @registry special name (#358 layer 1) (waiting 2d)
- [endojs/endo-but-for-bots#379](https://github.com/endojs/endo-but-for-bots/pull/379) — fix(ses): cyclic star export with renaming reexport (issue #59) - refresh for #3276 feedback (waiting 5d)
- [endojs/endo#3137](https://github.com/endojs/endo/pull/3137) — feat: support .ts runtime modules via erasable type syntax (waiting 16d)
- [endojs/endo-but-for-bots#101](https://github.com/endojs/endo-but-for-bots/pull/101) — feat(chat): voice input via Web Speech API (waiting 41d)
- [endojs/endo-but-for-bots#182](https://github.com/endojs/endo-but-for-bots/pull/182) — test(ses): isImmutableDataProperty regression for iOS Safari fix (closes #947) (waiting 40d)
- [endojs/endo-but-for-bots#186](https://github.com/endojs/endo-but-for-bots/pull/186) — feat(eventual-send): eager-shim/lazy-main delegate ponyfill (per #175) (waiting 40d)
- [endojs/endo-but-for-bots#288](https://github.com/endojs/endo-but-for-bots/pull/288) — feat(cbor-frame): add @endo/cbor-frame package for CBOR byte-string framing (waiting 41d)
- [endojs/endo-but-for-bots#266](https://github.com/endojs/endo-but-for-bots/pull/266) — design: opencode comparative analysis + gap-closing raft (endopen) (waiting 42d)
- [endojs/endo-but-for-bots#329](https://github.com/endojs/endo-but-for-bots/pull/329) — docs: introduce spackle, the polyfill+ponyfill race pattern (waiting 42d)

_Showing top 10 of 27 parked PRs (ranked by recency + roadmap relevance)._
## Messages to the maintainer

- `20260702T000821Z-0c2b43` — from liaison:follow-up, reply_to `?` · [open message](https://github.com/kriskowal/garden/blob/journal2/inbox/maintainer/unread/20260702T000821Z-0c2b43.md)

> The botanist-refresh-the-board report recommends that recurring board audits, if wanted as a standing capability, be implemented on `foreman`/`watchman` or as a new deterministic script rather than as a `botanist` responsibility. This is a garden-architecture decision (whether to add the capability at all, and where) — your call before any role/script work is posted.

- `20260702T004314Z-b798c5` — from gardener:endojs-endo-but-for-bots-pr592-shepherd, reply_to `endojs-endo-but-for-bots-pr592-shepherd` · [open message](https://github.com/kriskowal/garden/blob/journal2/inbox/maintainer/unread/20260702T004314Z-b798c5.md)

> shepherd escalation — endo-but-for-bots lint-infra scaling ceiling (next: liaison, needs a human/lint-infra decision)
>
> PR #592 (feat(platform,daemon): factor watchDirectory into @endo/platform) has CI red on exactly one check: `lint` (CI workflow). 24 of 25 checks are green. The 5 lint ERRORS are all the documented typescript-eslint projectService scaling-ceiling signature:
>
>   packages/zip/reader.js, src/deflate.js, src/inflate.js, test/zip.test.js, writer.js
>   0:0  error  Parsing error: ... none of those TSConfigs include this file
>
> Not caused by this PR's diff:
> - PR is 6 files, based directly on `llm` (not stacked), touching only packages/platform + packages/daemon. It touches NOTHING in packages/zip.
> - The package.json change adds only an export subpath (./fs/node/watch-directory) — no new cross-package dependency.
> - Even this tiny 6-file addition tips `packages/zip` (the alphabetically-last package) over the whole-repo `eslint .` projectService ceiling → the `llm` baseline is already sitting AT the ceiling. Same failure is live on #590 (the ~250-file @endo/far repoint) and #593; smaller PRs (#586/#588/#589) are still green.
>
> This is the known ceiling (prior investigation on #548/#590): NOT fixable with simple config knobs (pointing defaultProject at tsconfig.eslint-full.json had no effect; a single explicit project traded these for a broader "file not found" set — both tried and reverted). A real fix is lint-infra scope (consolidate per-package lint projects into one program, or raise/bypass the ceiling), which per standing guidance must NOT be bundled into a refactor PR. It now blocks at least 3 open bot PRs, so it likely wants its own lint-infra job.
>
> I did not touch PR #592 — its substance is fine and there is no shepherd-scope fix. Surfacing for a lint-infra decision.


## Board
### todo (0)
(none)

### doin (36)
- [`build-daemon-rename-to-manager`](https://github.com/kriskowal/garden/blob/journal2/jobs/doin/build-daemon-rename-to-manager.md) — Build: rename daemon.js → manager.js (Daemon/Mignonic → Manager/Worker)
- [`endojs-endo-but-for-bots-pr101-weaver`](https://github.com/kriskowal/garden/blob/journal2/jobs/doin/endojs-endo-but-for-bots-pr101-weaver.md) — weaver (rebase stale base) on endojs/endo-but-for-bots PR #101
- [`endojs-endo-but-for-bots-pr216-weave`](https://github.com/kriskowal/garden/blob/journal2/jobs/doin/endojs-endo-but-for-bots-pr216-weave.md) — weave (rebase) endojs/endo-but-for-bots PR #216 onto base llm
- [`endojs-endo-but-for-bots-pr235-shepherd`](https://github.com/kriskowal/garden/blob/journal2/jobs/doin/endojs-endo-but-for-bots-pr235-shepherd.md) — shepherd (auto: red CI) on endojs/endo-but-for-bots PR #235
- [`endojs-endo-but-for-bots-pr242-shepherd`](https://github.com/kriskowal/garden/blob/journal2/jobs/doin/endojs-endo-but-for-bots-pr242-shepherd.md) — shepherd (auto: red CI) on endojs/endo-but-for-bots PR #242
- [`endojs-endo-but-for-bots-pr250-shepherd`](https://github.com/kriskowal/garden/blob/journal2/jobs/doin/endojs-endo-but-for-bots-pr250-shepherd.md) — shepherd (auto: red CI) on endojs/endo-but-for-bots PR #250
- [`endojs-endo-but-for-bots-pr301-weave`](https://github.com/kriskowal/garden/blob/journal2/jobs/doin/endojs-endo-but-for-bots-pr301-weave.md) — weave (rebase/conflict-resolve) on endojs/endo-but-for-bots PR #301
- [`endojs-endo-but-for-bots-pr306-weaver`](https://github.com/kriskowal/garden/blob/journal2/jobs/doin/endojs-endo-but-for-bots-pr306-weaver.md) — weaver (rebase/conflict-resolution) on endojs/endo-but-for-bots PR #306
- [`endojs-endo-but-for-bots-pr313-shepherd`](https://github.com/kriskowal/garden/blob/journal2/jobs/doin/endojs-endo-but-for-bots-pr313-shepherd.md) — shepherd (auto: red CI) on endojs/endo-but-for-bots PR #313
- [`endojs-endo-but-for-bots-pr316-shepherd`](https://github.com/kriskowal/garden/blob/journal2/jobs/doin/endojs-endo-but-for-bots-pr316-shepherd.md) — shepherd (auto: red CI) on endojs/endo-but-for-bots PR #316
- [`endojs-endo-but-for-bots-pr318-shepherd`](https://github.com/kriskowal/garden/blob/journal2/jobs/doin/endojs-endo-but-for-bots-pr318-shepherd.md) — shepherd (auto: red CI) on endojs/endo-but-for-bots PR #318
- [`endojs-endo-but-for-bots-pr320-shepherd`](https://github.com/kriskowal/garden/blob/journal2/jobs/doin/endojs-endo-but-for-bots-pr320-shepherd.md) — shepherd (auto: red CI) on endojs/endo-but-for-bots PR #320
- [`endojs-endo-but-for-bots-pr324-shepherd`](https://github.com/kriskowal/garden/blob/journal2/jobs/doin/endojs-endo-but-for-bots-pr324-shepherd.md) — shepherd (auto: red CI) on endojs/endo-but-for-bots PR #324
- [`endojs-endo-but-for-bots-pr335-shepherd`](https://github.com/kriskowal/garden/blob/journal2/jobs/doin/endojs-endo-but-for-bots-pr335-shepherd.md) — shepherd (auto: red CI) on endojs/endo-but-for-bots PR #335
- [`endojs-endo-but-for-bots-pr337-shepherd`](https://github.com/kriskowal/garden/blob/journal2/jobs/doin/endojs-endo-but-for-bots-pr337-shepherd.md) — shepherd (auto: red CI) on endojs/endo-but-for-bots PR #337
- [`endojs-endo-but-for-bots-pr377-shepherd`](https://github.com/kriskowal/garden/blob/journal2/jobs/doin/endojs-endo-but-for-bots-pr377-shepherd.md) — shepherd (auto: red CI) on endojs/endo-but-for-bots PR #377
- [`endojs-endo-but-for-bots-pr393-shepherd`](https://github.com/kriskowal/garden/blob/journal2/jobs/doin/endojs-endo-but-for-bots-pr393-shepherd.md) — shepherd (auto: red CI) on endojs/endo-but-for-bots PR #393
- [`endojs-endo-but-for-bots-pr394-fixer`](https://github.com/kriskowal/garden/blob/journal2/jobs/doin/endojs-endo-but-for-bots-pr394-fixer.md) — fixer (shepherd escalation) on endojs/endo-but-for-bots PR #394
- [`endojs-endo-but-for-bots-pr410-shepherd`](https://github.com/kriskowal/garden/blob/journal2/jobs/doin/endojs-endo-but-for-bots-pr410-shepherd.md) — shepherd (auto: red CI) on endojs/endo-but-for-bots PR #410
- [`endojs-endo-but-for-bots-pr420-shepherd`](https://github.com/kriskowal/garden/blob/journal2/jobs/doin/endojs-endo-but-for-bots-pr420-shepherd.md) — shepherd (auto: red CI) on endojs/endo-but-for-bots PR #420
- [`endojs-endo-but-for-bots-pr438-shepherd`](https://github.com/kriskowal/garden/blob/journal2/jobs/doin/endojs-endo-but-for-bots-pr438-shepherd.md) — shepherd (auto: red CI) on endojs/endo-but-for-bots PR #438
- [`endojs-endo-but-for-bots-pr475-shepherd`](https://github.com/kriskowal/garden/blob/journal2/jobs/doin/endojs-endo-but-for-bots-pr475-shepherd.md) — shepherd (auto: red CI) on endojs/endo-but-for-bots PR #475
- [`endojs-endo-but-for-bots-pr541-shepherd`](https://github.com/kriskowal/garden/blob/journal2/jobs/doin/endojs-endo-but-for-bots-pr541-shepherd.md) — shepherd (auto: red CI) on endojs/endo-but-for-bots PR #541
- [`endojs-endo-but-for-bots-pr585-shepherd`](https://github.com/kriskowal/garden/blob/journal2/jobs/doin/endojs-endo-but-for-bots-pr585-shepherd.md) — shepherd (auto: red CI) on endojs/endo-but-for-bots PR #585
- [`endojs-endo-but-for-bots-pr587-shepherd`](https://github.com/kriskowal/garden/blob/journal2/jobs/doin/endojs-endo-but-for-bots-pr587-shepherd.md) — shepherd (auto: red CI) on endojs/endo-but-for-bots PR #587
- [`endojs-endo-but-for-bots-pr588-shepherd`](https://github.com/kriskowal/garden/blob/journal2/jobs/doin/endojs-endo-but-for-bots-pr588-shepherd.md) — shepherd (auto: red CI) on endojs/endo-but-for-bots PR #588
- [`endojs-endo-but-for-bots-pr590-shepherd`](https://github.com/kriskowal/garden/blob/journal2/jobs/doin/endojs-endo-but-for-bots-pr590-shepherd.md) — shepherd (auto: red CI) on endojs/endo-but-for-bots PR #590
- [`endojs-endo-but-for-bots-pr591-shepherd`](https://github.com/kriskowal/garden/blob/journal2/jobs/doin/endojs-endo-but-for-bots-pr591-shepherd.md) — shepherd (auto: red CI) on endojs/endo-but-for-bots PR #591
- [`endojs-endo-but-for-bots-pr593-shepherd`](https://github.com/kriskowal/garden/blob/journal2/jobs/doin/endojs-endo-but-for-bots-pr593-shepherd.md) — shepherd (auto: red CI) on endojs/endo-but-for-bots PR #593
- [`endojs-endo-but-for-bots-pr60-shepherd`](https://github.com/kriskowal/garden/blob/journal2/jobs/doin/endojs-endo-but-for-bots-pr60-shepherd.md) — shepherd (auto: red CI) on endojs/endo-but-for-bots PR #60
- [`endojs-endo-but-for-bots-pr79-shepherd`](https://github.com/kriskowal/garden/blob/journal2/jobs/doin/endojs-endo-but-for-bots-pr79-shepherd.md) — shepherd (auto: red CI) on endojs/endo-but-for-bots PR #79
- [`endojs-endo-but-for-bots-pr96-shepherd`](https://github.com/kriskowal/garden/blob/journal2/jobs/doin/endojs-endo-but-for-bots-pr96-shepherd.md) — shepherd (auto: red CI) on endojs/endo-but-for-bots PR #96
- [`improve-garden-identity-drift-detector`](https://github.com/kriskowal/garden/blob/journal2/jobs/doin/improve-garden-identity-drift-detector.md) — Every new gardener entry in this window reports host: endolinbot2, but per th...
- [`improve-gardener-transient-failure-backoff-and-fleet-brake`](https://github.com/kriskowal/garden/blob/journal2/jobs/doin/improve-gardener-transient-failure-backoff-and-fleet-brake.md) — scripts/jobs/gardener.sh: on a correlated Claude quota/API outage, all ~100 g...
- [`improve-issue-inbox-child-git-reaping`](https://github.com/kriskowal/garden/blob/journal2/jobs/doin/improve-issue-inbox-child-git-reaping.md) — garden-issue-inbox.service logs Found left-over process (git) in control grou...
- [`improve-repo-watcher-arm-retry`](https://github.com/kriskowal/garden/blob/journal2/jobs/doin/improve-repo-watcher-arm-retry.md) — scripts/jobs/repo-watcher.sh logs WARN: could not arm garden-ci-watcher@endoj...

### tada (860)
- [`endojs-endo-but-for-bots-pr239-shepherd`](https://github.com/kriskowal/garden/blob/journal2/jobs/tada/endojs-endo-but-for-bots-pr239-shepherd.md) — Completion report — endojs-endo-but-for-bots-pr239-shepherd
- [`endojs-endo-but-for-bots-pr286-shepherd`](https://github.com/kriskowal/garden/blob/journal2/jobs/tada/endojs-endo-but-for-bots-pr286-shepherd.md) — Completion report — shepherd on endojs/endo-but-for-bots PR #286
- [`endojs-endo-but-for-bots-pr394-shepherd`](https://github.com/kriskowal/garden/blob/journal2/jobs/tada/endojs-endo-but-for-bots-pr394-shepherd.md) — The new CI run for my pushed SHA is classified **"CI (docs-only)"** — since t...
- [`endojs-endo-but-for-bots-pr306-shepherd`](https://github.com/kriskowal/garden/blob/journal2/jobs/tada/endojs-endo-but-for-bots-pr306-shepherd.md) — My shepherd work on PR #306 is complete. Report follows.
- [`endojs-endo-but-for-bots-pr262-shepherd`](https://github.com/kriskowal/garden/blob/journal2/jobs/tada/endojs-endo-but-for-bots-pr262-shepherd.md) — Shepherd report — endojs/endo-but-for-bots PR #262
- … and 855 more

## Plan queue (parked — not claimable until promoted)
### awaiting go-ahead (maintainer authorization)
- [`endojs-endo-but-for-bots-pr132-report-render-mode`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr132-report-render-mode.md) — _normal_ · re-port render-mode toggle onto @endo/space-chat InboxRoot (endojs/endo-but-f...
- [`foreman-budget-cross-host-weekly-token-aggregation`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/foreman-budget-cross-host-weekly-token-aggregation.md) — _normal_ · PLAN: deterministic cross-host weekly token-spend aggregation for the foreman...
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
