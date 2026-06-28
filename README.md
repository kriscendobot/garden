# Garden bulletin

_As of 2026-06-28T17:03:09Z_

## Latest

The garden's scholar continued ingesting erights.org E-language material — `scholar-ingest-erights-5` and `-6` completed, the `fu-scholar-ingest-erights-5-2` follow-up closed as already-satisfied, and `scholar-ingest-erights-7` (the remaining E-language pages) is now the only job in flight. On the infrastructure side, the sections-index regenerator landed and its periodic regeneration timer is now in place (`improve-land-sections-index-regenerator`, `improve-periodic-sections-index-regen-timer`). A gardener also confirmed to the maintainer that endo-but-for-bots master lint is fully clean — the only findings are five non-blocking jsdoc warnings, parked as the deferred `fix-lint-jsdoc-warnings-endo-master` plan to promote if wanted. The board is otherwise quiet (todo empty), with 28 PRs still parked for review — the most recent being [endo-but-for-bots#58](https://github.com/endojs/endo-but-for-bots/pull/58) (CapTP error tracing, waiting 9h) and [endo-but-for-bots#503](https://github.com/endojs/endo-but-for-bots/pull/503) (passable byte arrays).

## Parked for maintainer feedback

- [endojs/endo-but-for-bots#58](https://github.com/endojs/endo-but-for-bots/pull/58) — feat(daemon,cli): error tracing across CapTP workers (#1879) (waiting 9h)
- [endojs/endo-but-for-bots#379](https://github.com/endojs/endo-but-for-bots/pull/379) — fix(ses): cyclic star export with renaming reexport (issue #59) - refresh for #3276 feedback (waiting 2d)
- [endojs/endo-but-for-bots#503](https://github.com/endojs/endo-but-for-bots/pull/503) — feat(immutable-arraybuffer,pass-style): passable byte arrays (freezable TypedArray emulation + byteArray brand check) (waiting 2d)
- [endojs/endo-but-for-bots#403](https://github.com/endojs/endo-but-for-bots/pull/403) — feat(registry-capability): EndoRegistry capability + @registry special name (#358 layer 1) (waiting 4d)
- [endojs/endo#3137](https://github.com/endojs/endo/pull/3137) — feat: support .ts runtime modules via erasable type syntax (waiting 12d)
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

### doin (1)
- [`scholar-ingest-erights-7`](https://github.com/kriskowal/garden/blob/journal2/jobs/doin/scholar-ingest-erights-7.md) — Scholar: ingest the remaining erights.org E-language pages (erights ingest, p...

### tada (531)
- [`fu-scholar-ingest-erights-5-2`](https://github.com/kriskowal/garden/blob/journal2/jobs/tada/fu-scholar-ingest-erights-5-2.md) — Both parts of this job were already satisfied at the current origin/journal2 ...
- [`scholar-ingest-erights-6`](https://github.com/kriskowal/garden/blob/journal2/jobs/tada/scholar-ingest-erights-6.md) — What I did
- [`improve-periodic-sections-index-regen-timer`](https://github.com/kriskowal/garden/blob/journal2/jobs/tada/improve-periodic-sections-index-regen-timer.md) — Done. Completion report below.
- [`improve-land-sections-index-regenerator`](https://github.com/kriskowal/garden/blob/journal2/jobs/tada/improve-land-sections-index-regenerator.md) — Completion report
- [`scholar-ingest-erights-5`](https://github.com/kriskowal/garden/blob/journal2/jobs/tada/scholar-ingest-erights-5.md) — scholar-ingest-erights-5 — complete
- … and 526 more

## Plan queue (parked — not claimable until promoted)
### awaiting go-ahead (maintainer authorization)
- [`foreman-budget-cross-host-weekly-token-aggregation`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/foreman-budget-cross-host-weekly-token-aggregation.md) — _normal_ · PLAN: deterministic cross-host weekly token-spend aggregation for the foreman...
- [`port-xs-to-rust-memory-safe-engine`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/port-xs-to-rust-memory-safe-engine.md) — _normal_ · PLAN (go-ahead): port XS to Rust — a memory-safe, meterable, no-JIT JS engine...
- [`service-host-roles-singletons-on-main-host`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/service-host-roles-singletons-on-main-host.md) — _normal_ · PLAN: service host-roles — gardeners run everywhere, singletons run only on t...
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
