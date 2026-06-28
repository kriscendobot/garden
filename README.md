# Garden bulletin

_As of 2026-06-28T16:32:49Z_

## Latest

The bulletin pipeline itself was just re-architected to build CI from journal2 (`bulletin-rearch-ci-from-journal2`), and the scholar's library tooling advanced — the section-row inserter is now wired in (`wire-scholar-to-sections-row-inserter`) with a deterministic sections-README regenerator and ocap/erights ingestion still in flight. A lint classification of endo-but-for-bots master came back clean: CI's `yarn lint` gate is fully green, with only five non-blocking jsdoc warnings, parked as the deferred/low `fix-lint-jsdoc-warnings-endo-master` plan to promote at will. Shepherd work on [endo-but-for-bots#284](https://github.com/endojs/endo-but-for-bots/pull/284) is claimed and driving CI green (it also gates the re-parked formula-inspector retention-paths plan). Two items await a maintainer call: whether to open a tracking job to continue the [kriskowal/garden#9](https://github.com/kriskowal/garden/issues/9) investigation "without the export," which the prior job deliberately left out of scope, and the unread lint-warnings note.

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

- `20260628T015826Z-ac972d` — from liaison:follow-up, reply_to `?` · [open message](https://github.com/kriskowal/garden/blob/journal2/inbox/maintainer/unread/20260628T015826Z-ac972d.md)

> Report kriskowal-garden-pr9-b87e3247 flags a still-open thread on kriskowal/garden issue #9 — the issue body's ask to "continue this investigation to the possible extent without the export." The completed job deliberately scoped this out as not part of the comment's directive and called it only a "candidate for its own job." It also sits near scope-sensitive territory (the prior work distinguished a bot-owned fork of agoric-sdk from excluded upstream agoric-sdk). Do you want me to open a tracking job to continue the issue #9 investigation, and if so, what's the intended scope of "without the export"? I'm holding off rather than autonomously spawning an investigation the report author explicitly left out of bounds.

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

### doin (5)
- [`deadmail-20260628T162700Z-1e5d9b`](https://github.com/kriskowal/garden/blob/journal2/jobs/doin/deadmail-20260628T162700Z-1e5d9b.md) — Dead-lettered message — pick up its intent
- [`improve-sections-readme-regenerator`](https://github.com/kriskowal/garden/blob/journal2/jobs/doin/improve-sections-readme-regenerator.md) — Add a deterministic regenerator script (e.g. scripts/jobs/regenerate-sections...
- [`pr-ebfb-284-shepherd`](https://github.com/kriskowal/garden/blob/journal2/jobs/doin/pr-ebfb-284-shepherd.md) — Land endo-but-for-bots#284 (shepherd) — drive CI green
- [`scholar-ingest-erights-4`](https://github.com/kriskowal/garden/blob/journal2/jobs/doin/scholar-ingest-erights-4.md) — Scholar: ingest the remaining erights.org E-language pages (erights ingest, p...
- [`scholar-ingest-ocap-kernel-comment-fragments`](https://github.com/kriskowal/garden/blob/journal2/jobs/doin/scholar-ingest-ocap-kernel-comment-fragments.md) — PLAN: scholar — ingest MetaMask/ocap-kernel kernel-internals comment fragments

### tada (515)
- [`wire-scholar-to-sections-row-inserter`](https://github.com/kriskowal/garden/blob/journal2/jobs/tada/wire-scholar-to-sections-row-inserter.md) — Completion report: wire-scholar-to-sections-row-inserter
- [`bulletin-rearch-ci-from-journal2`](https://github.com/kriskowal/garden/blob/journal2/jobs/tada/bulletin-rearch-ci-from-journal2.md) — Completion report: bulletin-rearch-ci-from-journal2
- [`deadmail-20260628T162622Z-7df898`](https://github.com/kriskowal/garden/blob/journal2/jobs/tada/deadmail-20260628T162622Z-7df898.md) — Completion report:
- [`deadmail-20260628T161937Z-f19557`](https://github.com/kriskowal/garden/blob/journal2/jobs/tada/deadmail-20260628T161937Z-f19557.md) — Completion report — deadmail-20260628T161937Z-f19557
- [`improve-sections-table-row-insert-anchor`](https://github.com/kriskowal/garden/blob/journal2/jobs/tada/improve-sections-table-row-insert-anchor.md) — Done. Here is my completion report.
- … and 510 more

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

### blocked (awaiting an artifact; unblock watcher auto-promotes on completion)
- [`formula-inspector-retention-paths-table-v2`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/formula-inspector-retention-paths-table-v2.md) — awaiting `https://github.com/endojs/endo-but-for-bots/pull/284` · PLAN (follow-on, re-parked): add a retention-paths table to the formula inspe...

## Watch set
(none)

## Hosts
- [endolinbot](https://github.com/kriskowal/garden/blob/journal2/hosts/endolinbot): 100 gardeners
