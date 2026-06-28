# Garden bulletin

_As of 2026-06-28T17:57:16Z_

## Latest

I'll write the bulletin's "## Latest" section based on the board transitions and dashboard.

Two gardener jobs completed since the last bulletin: [`issue-inbox-watcher-reactji-acknowledge`](https://github.com/kriskowal/garden/blob/journal2/jobs/tada/issue-inbox-watcher-reactji-acknowledge.md) wired a reactji acknowledgment into the issue-inbox watcher, and [`service-host-roles-singletons-on-main-host`](https://github.com/kriskowal/garden/blob/journal2/jobs/tada/service-host-roles-singletons-on-main-host.md) pinned singleton service roles to the main host. Scholar ingestion keeps moving — `scholar-ingest-erights-9` landed and `scholar-ingest-erights-10` (six ELib concurrency chapters) is in flight alongside `improve-regenerate-topics-counts`. Two maintainer messages await a reply: a lint classification of endo-but-for-bots master (CI-green; only 5 non-failing jsdoc warnings, with the fix parked as the low-priority `fix-lint-jsdoc-warnings-endo-master` plan), and a dead-letter close-out confirming the erights→github.io mirror note is honored end-to-end in `fetch-source.sh`. No new PR activity — the parked queue is unchanged, still topped by [endo-but-for-bots#58](https://github.com/endojs/endo-but-for-bots/pull/58) (10h) and [endo-but-for-bots#503](https://github.com/endojs/endo-but-for-bots/pull/503) (passable byte arrays), with three plans still awaiting maintainer go-ahead.

## Parked for maintainer feedback

- [endojs/endo-but-for-bots#58](https://github.com/endojs/endo-but-for-bots/pull/58) — feat(daemon,cli): error tracing across CapTP workers (#1879) (waiting 10h)
- [endojs/endo-but-for-bots#379](https://github.com/endojs/endo-but-for-bots/pull/379) — fix(ses): cyclic star export with renaming reexport (issue #59) - refresh for #3276 feedback (waiting 2d)
- [endojs/endo-but-for-bots#503](https://github.com/endojs/endo-but-for-bots/pull/503) — feat(immutable-arraybuffer,pass-style): passable byte arrays (freezable TypedArray emulation + byteArray brand check) (waiting 2d)
- [endojs/endo-but-for-bots#403](https://github.com/endojs/endo-but-for-bots/pull/403) — feat(registry-capability): EndoRegistry capability + @registry special name (#358 layer 1) (waiting 4d)
- [endojs/endo#3137](https://github.com/endojs/endo/pull/3137) — feat: support .ts runtime modules via erasable type syntax (waiting 13d)
- [endojs/endo-but-for-bots#101](https://github.com/endojs/endo-but-for-bots/pull/101) — feat(chat): voice input via Web Speech API (waiting 38d)
- [endojs/endo-but-for-bots#182](https://github.com/endojs/endo-but-for-bots/pull/182) — test(ses): isImmutableDataProperty regression for iOS Safari fix (closes #947) (waiting 37d)
- [endojs/endo-but-for-bots#186](https://github.com/endojs/endo-but-for-bots/pull/186) — feat(eventual-send): eager-shim/lazy-main delegate ponyfill (per #175) (waiting 37d)
- [endojs/endo-but-for-bots#288](https://github.com/endojs/endo-but-for-bots/pull/288) — feat(cbor-frame): add @endo/cbor-frame package for CBOR byte-string framing (waiting 38d)
- [endojs/endo-but-for-bots#329](https://github.com/endojs/endo-but-for-bots/pull/329) — docs: introduce spackle, the polyfill+ponyfill race pattern (waiting 38d)

_Showing top 10 of 28 parked PRs (ranked by recency + roadmap relevance)._
## Messages to the maintainer

- `20260627T120202Z-99ffce` — from gardener:classify-lint-endo-master, reply_to `classify-lint-endo-master` · [open message](https://github.com/kriskowal/garden/blob/journal2/inbox/maintainer/unread/20260627T120202Z-99ffce.md)

> Lint classification — endo master (endo-but-for-bots master @364d69ba1).
>
> FINDING: master lint is CLEAN. CI's `yarn lint` gate (prettier + root eslint + shellcheck) is fully green; per-package eslint across 49 packages and spot-checked tsc are clean too. There are NO lint ERROR classes to fix.
>
> The only findings are 5 jsdoc WARNINGS (do not fail CI), in 2 rule-classes:
>   - jsdoc/require-param ×4 (packages/daemon) — autofixable
>   - jsdoc/check-tag-names ×1 (compartment-mapper, @remarks tag) — needs judgment
>
> Posted ONE deferred/low plan covering both: `fix-lint-jsdoc-warnings-endo-master` (consolidated rather than two near-empty per-rule plans, since both are tiny jsdoc warnings). Promote it if you want the warnings cleared.
>
> Note: bot master is 64 commits AHEAD of upstream endo (legitimately merged bot-fork PRs) and 8 behind; I did NOT force-sync to upstream — the ahead commits are real work, not drift.

- `20260628T162805Z-a5b575` — from gardener:deadmail-20260628T162622Z-7df898, reply_to `deadmail-20260628T162622Z-7df898` · [open message](https://github.com/kriskowal/garden/blob/journal2/inbox/maintainer/unread/20260628T162805Z-a5b575.md)

> Re: ingest-ocap-library-sections (dead-lettered; I picked up the intent as gardener-93 on endolinbot).
>
> Verified — you're right on all three counts, thank you:
>
> 1. The mirror note is in the always-read doc. journal/library/conventions.md § PDF acquisition guidance (lines ~314–325) documents that erights.org/caplet.com refuse the bot sandbox and the canonical substitute is the GitHub Pages mirror https://erights.github.io/erights-org-website/<path>, with the Internet Archive id_ fallback for the PDFs/talk files the mirror 404s.
> 2. The tool honors it deterministically. scripts/jobs/fetch-source.sh rewrites erights.org/caplet.com URLs to that mirror automatically (confirmed at lines 13/35/126), so the note isn't just prose — it's enforced in the fetch path.
> 3. The ingestion has continued. scholar-ingest-erights-3 completed (tada by gardener-69) and scholar-ingest-ocap-kernel-comment-fragments is claimed and in flight (gardener-56). The library now carries the erights-- elang/elib sources plus the ocap concept files (object-capability, object-sameness, passable-equality, etc.).
>
> Nothing further needed from me on this — closing the dead-letter as already-handled. Thank you for leaving the note where the scholar would actually find it.


## Board
### todo (0)
(none)

### doin (2)
- [`improve-regenerate-topics-counts`](https://github.com/kriskowal/garden/blob/journal2/jobs/doin/improve-regenerate-topics-counts.md) — Add scripts/jobs/regenerate-topics-counts.sh, a sibling to the existing scrip...
- [`scholar-ingest-erights-10`](https://github.com/kriskowal/garden/blob/journal2/jobs/doin/scholar-ingest-erights-10.md) — Scholar: ingest the six ELib concurrency sub-hub child chapters (erights inge...

### tada (544)
- [`issue-inbox-watcher-reactji-acknowledge`](https://github.com/kriskowal/garden/blob/journal2/jobs/tada/issue-inbox-watcher-reactji-acknowledge.md) — Completion report
- [`service-host-roles-singletons-on-main-host`](https://github.com/kriskowal/garden/blob/journal2/jobs/tada/service-host-roles-singletons-on-main-host.md) — Completion report: service-host-roles-singletons-on-main-host
- [`scholar-ingest-erights-9`](https://github.com/kriskowal/garden/blob/journal2/jobs/tada/scholar-ingest-erights-9.md) — Completion report: scholar-ingest-erights-9
- [`deadmail-20260628T174147Z-8cbe3e`](https://github.com/kriskowal/garden/blob/journal2/jobs/tada/deadmail-20260628T174147Z-8cbe3e.md) — Done. Completion report follows.
- [`issue-kriskowal-garden-13`](https://github.com/kriskowal/garden/blob/journal2/jobs/tada/issue-kriskowal-garden-13.md) — Completion report follows.
- … and 539 more

## Plan queue (parked — not claimable until promoted)
### awaiting go-ahead (maintainer authorization)
- [`foreman-budget-cross-host-weekly-token-aggregation`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/foreman-budget-cross-host-weekly-token-aggregation.md) — _normal_ · PLAN: deterministic cross-host weekly token-spend aggregation for the foreman...
- [`port-xs-to-rust-memory-safe-engine`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/port-xs-to-rust-memory-safe-engine.md) — _normal_ · PLAN (go-ahead): port XS to Rust — a memory-safe, meterable, no-JIT JS engine...
- [`synth-and-deploy-minion-town-aws`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/synth-and-deploy-minion-town-aws.md) — _normal_ · Synth, wire custom domain, and live-deploy minion.town to AWS

### deferred (top by priority; foreman auto-promotes when idle)
- [`fix-lint-jsdoc-warnings-endo-master`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/fix-lint-jsdoc-warnings-endo-master.md) — _low_ · fix-lint: jsdoc warnings on endo master (the only lint findings)
- [`bot-email-dedicated-domain-counter-plan-aws-hetzner`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/bot-email-dedicated-domain-counter-plan-aws-hetzner.md) — _low_ · PLAN (low priority, counter-plan to FastMail-masking): bot-driven email on a ...
- [`investigate-fastmail-masked-email-api-for-bot-personas`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/investigate-fastmail-masked-email-api-for-bot-personas.md) — _low_ · PLAN (low priority, investigate): FastMail masked-email API for bot persona m...
- [`scholar-ingest-ocap-kernel-comment-fragments-2`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/scholar-ingest-ocap-kernel-comment-fragments-2.md) — _low_ · PLAN: scholar — ingest the remaining ocap-kernel kernel-internals comment fra...

### blocked (awaiting an artifact; unblock watcher auto-promotes on completion)
- [`formula-inspector-retention-paths-table-v2`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/formula-inspector-retention-paths-table-v2.md) — awaiting `https://github.com/endojs/endo-but-for-bots/pull/284` · PLAN (follow-on, re-parked): add a retention-paths table to the formula inspe...

## Watch set
(none)

## Hosts
- [endolinbot](https://github.com/kriskowal/garden/blob/journal2/hosts/endolinbot): 100 gardeners
- [main-host](https://github.com/kriskowal/garden/blob/journal2/hosts/main-host): ? gardeners
