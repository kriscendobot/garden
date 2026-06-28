# Garden bulletin

_As of 2026-06-28T16:25:35Z_

## Latest

Garden scholar work dominated this cycle: the [erights-3](https://github.com/kriskowal/garden/blob/journal2/jobs/tada/scholar-ingest-erights-3.md) ingest completed and the next erights E-language batch ([erights-4](https://github.com/kriskowal/garden/blob/journal2/jobs/doin/scholar-ingest-erights-4.md)) and an ocap-kernel comment-fragment ingest are now in flight, alongside the earlier ocap concept-cluster landing on journal2 (distributed-ocap synthesis; grant-matcher-puzzle flagged because erights.org was unreachable). On the PR front, [endo-but-for-bots#284](https://github.com/endojs/endo-but-for-bots/pull/284) was claimed by a shepherd to drive its CI green — worth watching since the parked formula-inspector retention-paths table is blocked on it. Lint classification of endo-but-for-bots master came back clean (only five non-blocking jsdoc warnings, parked as a low-priority fix). Two maintainer asks await a decision: the liaison is holding off on continuing the [kriskowal/garden#9](https://github.com/kriskowal/garden/issues/9) investigation "without the export" pending scope confirmation, and a deferred jsdoc-warning fix can be promoted if you want the warnings cleared.

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

- `20260627T082148Z-6fd4ed` — from gardener:ingest-ocap-library-sections, reply_to `ingest-ocap-library-sections` · [open message](https://github.com/kriskowal/garden/blob/journal2/inbox/maintainer/unread/20260627T082148Z-6fd4ed.md)

> Scholar ingest — six ocap library sections (job ingest-ocap-library-sections, gardener 93):
>
> Synthesis: the six requested topics already had their authoritative SOURCES ingested in the library; the gap was the concept-layer synthesis tying them together. Landed a distributed-ocap concept cluster on journal2 (commit dc5d328e):
>
> - three-party-handoff — OCapN CapTP § Third Party Handoffs (Gifter/Receiver/Exporter, signed gift/handoff certificates); the Granovetter operator across sessions.
> - sturdyref — OCapN Locators § Sturdyref (Peer Locator + swiss-num) + Concurrency Among Strangers §9.2; the durable/offline reference, Initial-Conditions made persistent.
> - distributed-confinement — Paradigm Regained §5 (Cassie/Max factory, data diode, non-discretionary) + the Confinement Myth; confinement across vats.
> - eventual-send — @endo/eventual-send (E()/HandledPromise) + CAS vat/event-loop; umbrella over promise-pipelining and handler-protocol.
> - grant-matcher-puzzle ("grant matching") — Mark Miller's erights.org equality puzzle. This is the one with NO in-corpus source: erights.org/caplet.com were unreachable (ECONNREFUSED). Page is flagged draft/external-lineage; follow-on scholar-ingest-grant-matcher-puzzle parked (deferred) to ingest the source when erights.org is reachable.
>
> Cross-linked the three pre-existing concepts (granovetter-operator, pass-invariant-handle-equality, promise-pipelining) bidirectionally; the six interlock exactly as predicted (handoff↔grant-matching↔sturdyref↔eventual-send↔confinement; pass-invariant equality underlies all). Also parked scholar-ingest-passable-equality (low) to broaden equality beyond the Handle-side instance.
>
> Topic whose source I could not locate: grant matching (erights.org down) — concept written from a web-search summary, honestly flagged, source-ingest deferred.

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


## Board
### todo (0)
(none)

### doin (7)
- [`bulletin-rearch-ci-from-journal2`](https://github.com/kriskowal/garden/blob/journal2/jobs/doin/bulletin-rearch-ci-from-journal2.md) — Re-architect the GitHub Pages bulletin: CI-generated, not committed to main2
- [`deadmail-20260628T161937Z-f19557`](https://github.com/kriskowal/garden/blob/journal2/jobs/doin/deadmail-20260628T161937Z-f19557.md) — Dead-lettered message — pick up its intent
- [`improve-sections-readme-regenerator`](https://github.com/kriskowal/garden/blob/journal2/jobs/doin/improve-sections-readme-regenerator.md) — Add a deterministic regenerator script (e.g. scripts/jobs/regenerate-sections...
- [`improve-sections-table-row-insert-anchor`](https://github.com/kriskowal/garden/blob/journal2/jobs/doin/improve-sections-table-row-insert-anchor.md) — Add a small deterministic Markdown helper (e.g. scripts/jobs/insert-sections-...
- [`pr-ebfb-284-shepherd`](https://github.com/kriskowal/garden/blob/journal2/jobs/doin/pr-ebfb-284-shepherd.md) — Land endo-but-for-bots#284 (shepherd) — drive CI green
- [`scholar-ingest-erights-4`](https://github.com/kriskowal/garden/blob/journal2/jobs/doin/scholar-ingest-erights-4.md) — Scholar: ingest the remaining erights.org E-language pages (erights ingest, p...
- [`scholar-ingest-ocap-kernel-comment-fragments`](https://github.com/kriskowal/garden/blob/journal2/jobs/doin/scholar-ingest-ocap-kernel-comment-fragments.md) — PLAN: scholar — ingest MetaMask/ocap-kernel kernel-internals comment fragments

### tada (510)
- [`deadmail-20260628T162052Z-7d1eca`](https://github.com/kriskowal/garden/blob/journal2/jobs/tada/deadmail-20260628T162052Z-7d1eca.md) — Completion report — deadmail-20260628T162052Z-7d1eca (gardener)
- [`scholar-ingest-erights-3`](https://github.com/kriskowal/garden/blob/journal2/jobs/tada/scholar-ingest-erights-3.md) — Completion report — scholar-ingest-erights-3
- [`deadmail-20260628T161527Z-35092c`](https://github.com/kriskowal/garden/blob/journal2/jobs/tada/deadmail-20260628T161527Z-35092c.md) — Completion report
- [`deadmail-20260628T160726Z-bef943`](https://github.com/kriskowal/garden/blob/journal2/jobs/tada/deadmail-20260628T160726Z-bef943.md) — Completion report
- [`scholar-ingest-erights-2`](https://github.com/kriskowal/garden/blob/journal2/jobs/tada/scholar-ingest-erights-2.md) — Completion report
- … and 505 more

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
