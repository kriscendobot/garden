# Garden bulletin

_As of 2026-07-01T01:15:21Z_

## Latest

No jobs changed state this cycle, so activity is concentrated in what's in flight. The gardeners are reworking [endo-but-for-bots#58](https://github.com/endojs/endo-but-for-bots/pull/58) (CapTP error tracing) to actually fix the error rendering *and* verify it in a real Chrome — the direct application of the just-landed "verification claims require real execution evidence" directive — alongside a review directive on [endo-but-for-bots#442](https://github.com/endojs/endo-but-for-bots/pull/442) and issue kriskowal/garden#20. #58 has been parked for maintainer review for an hour; [endo-but-for-bots#503](https://github.com/endojs/endo-but-for-bots/pull/503) (passable byte arrays) has now waited 20h and [#403](https://github.com/endojs/endo-but-for-bots/pull/403) (registry-capability) over a day.

One item needs a human hand: the `endolinbot2` journal worktree at `/home/kris/journal` has **diverged** from `origin/journal2` — 3 commits ahead, 6052 behind, 6 dirty paths — and the keeper left it untouched rather than clobber local work. It won't self-reconcile; inspect and rebase/discard by hand per the maintainer message.

## Parked for maintainer feedback

- [endojs/endo-but-for-bots#58](https://github.com/endojs/endo-but-for-bots/pull/58) — feat(daemon,cli): error tracing across CapTP workers (#1879) (waiting 1h)
- [endojs/endo-but-for-bots#503](https://github.com/endojs/endo-but-for-bots/pull/503) — feat(immutable-arraybuffer,pass-style): passable byte arrays (freezable TypedArray emulation + byteArray brand check) (waiting 20h)
- [endojs/endo-but-for-bots#403](https://github.com/endojs/endo-but-for-bots/pull/403) — feat(registry-capability): EndoRegistry capability + @registry special name (#358 layer 1) (waiting 1d)
- [endojs/endo-but-for-bots#379](https://github.com/endojs/endo-but-for-bots/pull/379) — fix(ses): cyclic star export with renaming reexport (issue #59) - refresh for #3276 feedback (waiting 4d)
- [endojs/endo#3137](https://github.com/endojs/endo/pull/3137) — feat: support .ts runtime modules via erasable type syntax (waiting 15d)
- [endojs/endo-but-for-bots#101](https://github.com/endojs/endo-but-for-bots/pull/101) — feat(chat): voice input via Web Speech API (waiting 40d)
- [endojs/endo-but-for-bots#182](https://github.com/endojs/endo-but-for-bots/pull/182) — test(ses): isImmutableDataProperty regression for iOS Safari fix (closes #947) (waiting 39d)
- [endojs/endo-but-for-bots#186](https://github.com/endojs/endo-but-for-bots/pull/186) — feat(eventual-send): eager-shim/lazy-main delegate ponyfill (per #175) (waiting 39d)
- [endojs/endo-but-for-bots#266](https://github.com/endojs/endo-but-for-bots/pull/266) — design: opencode comparative analysis + gap-closing raft (endopen) (waiting 41d)
- [endojs/endo-but-for-bots#288](https://github.com/endojs/endo-but-for-bots/pull/288) — feat(cbor-frame): add @endo/cbor-frame package for CBOR byte-string framing (waiting 40d)

_Showing top 10 of 28 parked PRs (ranked by recency + roadmap relevance)._
## Messages to the maintainer

- `20260701T011512Z-67bbf6` — from watchdog:journal-worktree-keeper, reply_to `?` · [open message](https://github.com/kriskowal/garden/blob/journal2/inbox/maintainer/unread/20260701T011512Z-67bbf6.md)

> journal worktree /home/kris/journal has DIVERGED from origin/journal2 and was left UNTOUCHED (no reset/pull/stash): 3 local-ahead commit(s), 6052 behind, 6 dirty path(s). Reconcile by hand: 'git -C /home/kris/journal status', 'git -C /home/kris/journal log --oneline origin/journal2..HEAD', then rebase/push or discard the local commits. (host=endolinbot2)


## Board
### todo (0)
(none)

### doin (9)
- [`build-bid-accept-market-phase0-1`](https://github.com/kriskowal/garden/blob/journal2/jobs/doin/build-bid-accept-market-phase0-1.md) — Build: bid/accept market — Phase 0/1 (opt-in field + shadow reputation ledger)
- [`build-ebfb-namehub-interface-unification`](https://github.com/kriskowal/garden/blob/journal2/jobs/doin/build-ebfb-namehub-interface-unification.md) — Build: EndoMount name-hub interface unification (unblocked by PR #277)
- [`builder-ebfb-enforce-js-extension-jsdoc-import-lint`](https://github.com/kriskowal/garden/blob/journal2/jobs/doin/builder-ebfb-enforce-js-extension-jsdoc-import-lint.md) — builder: enforce .js extension on module specifiers via lint (endojs/endo-but...
- [`deadmail-issue-comment-4849045455`](https://github.com/kriskowal/garden/blob/journal2/jobs/doin/deadmail-issue-comment-4849045455.md) — Dead-lettered message — pick up its intent
- [`ebfb-pr-58-fix-error-rendering-verify-in-chrome`](https://github.com/kriskowal/garden/blob/journal2/jobs/doin/ebfb-pr-58-fix-error-rendering-verify-in-chrome.md) — PR #58 — actually fix the error rendering AND verify in real Chrome (prior "v...
- [`endojs-endo-but-for-bots-pr442-review-ea91182a`](https://github.com/kriskowal/garden/blob/journal2/jobs/doin/endojs-endo-but-for-bots-pr442-review-ea91182a.md) — Review directive on endojs/endo-but-for-bots PR #442
- [`endojs-endo-but-for-bots-pr58-15926293`](https://github.com/kriskowal/garden/blob/journal2/jobs/doin/endojs-endo-but-for-bots-pr58-15926293.md) — attention directive on endojs/endo-but-for-bots PR #58
- [`enforce-js-extension-lint-endo-but-for-bots`](https://github.com/kriskowal/garden/blob/journal2/jobs/doin/enforce-js-extension-lint-endo-but-for-bots.md) — Builder: enforce .js extension on imports via lint (endojs/endo-but-for-bots)
- [`issue-kriskowal-garden-20`](https://github.com/kriskowal/garden/blob/journal2/jobs/doin/issue-kriskowal-garden-20.md) — Issue from kriskowal on kriskowal/garden #20

### tada (746)
- [`endojs-endo-but-for-bots-pr277-review-64e9f470`](https://github.com/kriskowal/garden/blob/journal2/jobs/tada/endojs-endo-but-for-bots-pr277-review-64e9f470.md) — Waiting on the CI-settle watcher; I'll dispatch the conductor merge once chec...
- [`garden-encode-verification-claims-require-real-evidence`](https://github.com/kriskowal/garden/blob/journal2/jobs/tada/garden-encode-verification-claims-require-real-evidence.md) — The work is complete and landed on main2. Here is my completion report.
- [`endojs-endo-but-for-bots-pr442-f8df35b4`](https://github.com/kriskowal/garden/blob/journal2/jobs/tada/endojs-endo-but-for-bots-pr442-f8df35b4.md) — Completion report
- [`kriskowal-garden-pr16-review-94229b78`](https://github.com/kriskowal/garden/blob/journal2/jobs/tada/kriskowal-garden-pr16-review-94229b78.md) — Completion report — job kriskowal-garden-pr16-review-94229b78
- [`endojs-endo-but-for-bots-pr277-268a7246`](https://github.com/kriskowal/garden/blob/journal2/jobs/tada/endojs-endo-but-for-bots-pr277-268a7246.md) — Job complete. Here is my report.
- … and 741 more

## Plan queue (parked — not claimable until promoted)
### awaiting go-ahead (maintainer authorization)
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
- [`garden-encode-directives-reliably-become-jobs`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/garden-encode-directives-reliably-become-jobs.md) — awaiting `garden-encode-acknowledged-comment-needs-reply` · Widen the comment-watcher: actionable maintainer directives reliably become J...

## Watch set
(none)

## Hosts
- [endolinbot](https://github.com/kriskowal/garden/blob/journal2/hosts/endolinbot): 100 gardeners
- [endolinbot2](https://github.com/kriskowal/garden/blob/journal2/hosts/endolinbot2): 100 gardeners
- [main-host](https://github.com/kriskowal/garden/blob/journal2/hosts/main-host): ? gardeners
