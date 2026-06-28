# Garden bulletin

_As of 2026-06-28T07:23:27Z_

## Latest

Three jobs now converge on [endo-but-for-bots#405](https://github.com/endojs/endo-but-for-bots/pull/405) (inventory grouping) — a round-2 review carry, an attention directive, and a just-claimed grouping-toggle fixer directive. [endo-but-for-bots#58](https://github.com/endojs/endo-but-for-bots/pull/58) (CapTP error tracing) was refreshed and is freshly parked for review, and the shepherd on [endo-but-for-bots#277](https://github.com/endojs/endo-but-for-bots/pull/277) pushed three atomic fixes with CI re-running. Two items want maintainer eyes: the formula-inspector retention-paths table is blocked on [endo-but-for-bots#284](https://github.com/endojs/endo-but-for-bots/pull/284), which still needs the rebase-and-re-gamut you requested back on 2026-05-21 (currently 4 failing checks) before it can land — a gardener offered to take that as its own job on your word. The liaison is also holding for a scope decision on continuing the kriskowal/garden#9 investigation "without the export," which the completed job deliberately left out of bounds. On the library side, scholar ingested MetaMask/ocap-kernel's host-app guide plus six distributed-ocap concept syntheses, and a lint sweep of endo master came back clean (only 5 non-blocking jsdoc warnings, parked low).

## Parked for maintainer feedback

- [endojs/endo-but-for-bots#58](https://github.com/endojs/endo-but-for-bots/pull/58) — feat(daemon,cli): error tracing across CapTP workers (#1879) (waiting 12m)
- [endojs/endo-but-for-bots#379](https://github.com/endojs/endo-but-for-bots/pull/379) — fix(ses): cyclic star export with renaming reexport (issue #59) - refresh for #3276 feedback (waiting 2d)
- [endojs/endo-but-for-bots#503](https://github.com/endojs/endo-but-for-bots/pull/503) — feat(immutable-arraybuffer,pass-style): passable byte arrays (freezable TypedArray emulation + byteArray brand check) (waiting 2d)
- [endojs/endo-but-for-bots#403](https://github.com/endojs/endo-but-for-bots/pull/403) — feat(registry-capability): EndoRegistry capability + @registry special name (#358 layer 1) (waiting 3d)
- [endojs/endo#3137](https://github.com/endojs/endo/pull/3137) — feat: support .ts runtime modules via erasable type syntax (waiting 12d)
- [endojs/endo-but-for-bots#101](https://github.com/endojs/endo-but-for-bots/pull/101) — feat(chat): voice input via Web Speech API (waiting 37d)
- [endojs/endo-but-for-bots#182](https://github.com/endojs/endo-but-for-bots/pull/182) — test(ses): isImmutableDataProperty regression for iOS Safari fix (closes #947) (waiting 37d)
- [endojs/endo-but-for-bots#186](https://github.com/endojs/endo-but-for-bots/pull/186) — feat(eventual-send): eager-shim/lazy-main delegate ponyfill (per #175) (waiting 37d)
- [endojs/endo-but-for-bots#288](https://github.com/endojs/endo-but-for-bots/pull/288) — feat(cbor-frame): add @endo/cbor-frame package for CBOR byte-string framing (waiting 38d)
- [endojs/endo-but-for-bots#329](https://github.com/endojs/endo-but-for-bots/pull/329) — docs: introduce spackle, the polyfill+ponyfill race pattern (waiting 38d)

_Showing top 10 of 28 parked PRs (ranked by recency + roadmap relevance)._
## Messages to the maintainer

- `20260627T073148Z-d2f9fb` — from gardener:formula-inspector-retention-paths-table, reply_to `formula-inspector-retention-paths-table` · [open message](https://github.com/kriskowal/garden/blob/journal2/inbox/maintainer/unread/20260627T073148Z-d2f9fb.md)

> Job `formula-inspector-retention-paths-table` is BLOCKED on its data source and I'm reporting the gap (not reimplementing the graph walk, per the plan's own instruction).
>
> Why blocked:
> - The table must source its data from #284 (`listRetentionPaths` host API). #284 is still OPEN and NOT on base `llm`.
> - #284 is stalled since 2026-05-21: you asked "Please rebase and run the gamut again" — that rebase/re-gamut never happened, and it currently has 4 failing CI checks (22/26 green). Not mergeable as-is.
> - Building the table now would require either binding to a non-existent host method (CI can't pass on `llm`) or duplicating the graph walk in the UI — which the plan explicitly forbids.
>
> Good news (the follow-on is ready the moment #284 lands):
> - #284 exposes the right shape over the captp `HostInterface`: `listRetentionPaths(locator) -> Promise<RetentionPath[]>` and `followRetentionPaths(locator) -> AsyncIterator<RetentionPathDelta>`. Each `RetentionPath` is segments with `{ groupMembers, referencedBy, labels }` (pet edges => `pet:<name>`, root segment `type:"root"`) — exactly a table's rows. The chat UI can reach it because it's on the host captp interface, not CLI-only.
> - The inspector back-face to extend is `packages/spaces-util/src/formula-view.js` (#440, merged into `llm` 2026-06-27).
>
> Recommended unblock: land #284 first (the rebase + gamut you already requested), then re-promote this plan from `jobs/plan/` to `todo/`. I can take the #284 rebase-and-gamut as a separate job if you want — say the word and I'll post it.

- `20260627T075134Z-f5bbc7` — from gardener:ingest-ocap-kernel, reply_to `ingest-ocap-kernel` · [open message](https://github.com/kriskowal/garden/blob/journal2/inbox/maintainer/unread/20260627T075134Z-f5bbc7.md)

> Library: ingested MetaMask/ocap-kernel `docs/kernel-guide.md` (the 689-line host-app developer
> guide) — the **sixth ocap-kernel ingest** and the most direct source yet for the kernel/vat model.
> 11 sections + a synthesizing [[ocap-kernel]] concept, cross-linked to the garden's ocap corpus.
>
> Synthesis — how MetaMask's kernel (an external SwingSet-lineage sibling, distinct from @endo)
> relates to our material:
> - Shared substrate: `E()` is imported straight from `@endo/eventual-send`; exos wrap `@endo/exo`
>   `makeExo`.
> - Signature divergences (flagged honestly per section): kref/vref/rref/eref four-scope reference
>   name-space vs Endo's single formula identifier; first-class `kernel.revoke(kref)` vs Endo's
>   compositional caretaker/membrane revocation; kernel services registered-by-name + access-checked
>   at subcluster launch vs Endo powers through the formula graph; `Far()` forbidden in favor of
>   `makeDefaultExo`.
> - Six-sections ocap cross-links wired: distributed confinement (vat endowment allowlists),
>   three-party hand-off (bootstrap-as-introducer; bidirectional links into granovetter-operator +
>   four-ways-to-acquire-references), eventual send, sturdyrefs (baggage-stored cross-vat refs).
>
> Deferred follow-on plans parked: `scholar-ingest-ocap-kernel-usage` (docs/usage.md) and
> `scholar-ingest-ocap-kernel-packages` (per-package READMEs + kernel-internals comment fragments).

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

### doin (4)
- [`endo-but-for-bots-pr405-inventory-grouping-review-round2`](https://github.com/kriskowal/garden/blob/journal2/jobs/doin/endo-but-for-bots-pr405-inventory-grouping-review-round2.md) — Carry kriskowal's review feedback on endo-but-for-bots PR #405 (inventory gro...
- [`endojs-endo-but-for-bots-pr405-9719d4b3`](https://github.com/kriskowal/garden/blob/journal2/jobs/doin/endojs-endo-but-for-bots-pr405-9719d4b3.md) — attention directive on endojs/endo-but-for-bots PR #405
- [`endojs-endo-but-for-bots-pr405-grouping-toggle`](https://github.com/kriskowal/garden/blob/journal2/jobs/doin/endojs-endo-but-for-bots-pr405-grouping-toggle.md) — fixer directive on endojs/endo-but-for-bots PR #405
- [`notifier-pubsub-migration`](https://github.com/kriskowal/garden/blob/journal2/jobs/doin/notifier-pubsub-migration.md) — notifier-pubsub-migration: add @endo/exo-pubsub (all bridges) + migrate daemo...

### tada (482)
- [`deadmail-20260628T071109Z-475cc4`](https://github.com/kriskowal/garden/blob/journal2/jobs/tada/deadmail-20260628T071109Z-475cc4.md) — Completion report
- [`endojs-endo-but-for-bots-pr277-shepherd`](https://github.com/kriskowal/garden/blob/journal2/jobs/tada/endojs-endo-but-for-bots-pr277-shepherd.md) — Pushed the three atomic fixes; CI is re-running on head 157fd818b. I'm waitin...
- [`kriskowal-garden-pr9-8d0a4132`](https://github.com/kriskowal/garden/blob/journal2/jobs/tada/kriskowal-garden-pr9-8d0a4132.md) — Done. Title updated and verified.
- [`endojs-endo-but-for-bots-pr58-refresh`](https://github.com/kriskowal/garden/blob/journal2/jobs/tada/endojs-endo-but-for-bots-pr58-refresh.md) — Completion report: refresh endojs/endo-but-for-bots PR #58
- [`scholar-library-cycle-20260628-065003`](https://github.com/kriskowal/garden/blob/journal2/jobs/tada/scholar-library-cycle-20260628-065003.md) — Completion report
- … and 477 more

## Plan queue (parked — not claimable until promoted)
### awaiting go-ahead (maintainer authorization)
- [`foreman-budget-cross-host-weekly-token-aggregation`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/foreman-budget-cross-host-weekly-token-aggregation.md) — _normal_ · PLAN: deterministic cross-host weekly token-spend aggregation for the foreman...
- [`port-xs-to-rust-memory-safe-engine`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/port-xs-to-rust-memory-safe-engine.md) — _normal_ · PLAN (go-ahead): port XS to Rust — a memory-safe, meterable, no-JIT JS engine...
- [`service-host-roles-singletons-on-main-host`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/service-host-roles-singletons-on-main-host.md) — _normal_ · PLAN: service host-roles — gardeners run everywhere, singletons run only on t...
- [`synth-and-deploy-minion-town-aws`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/synth-and-deploy-minion-town-aws.md) — _normal_ · Synth, wire custom domain, and live-deploy minion.town to AWS

### deferred (top by priority; foreman auto-promotes when idle)
- [`fix-lint-jsdoc-warnings-endo-master`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/fix-lint-jsdoc-warnings-endo-master.md) — _low_ · fix-lint: jsdoc warnings on endo master (the only lint findings)
- [`scholar-ingest-ocap-kernel-comment-fragments`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/scholar-ingest-ocap-kernel-comment-fragments.md) — _low_ · PLAN: scholar — ingest MetaMask/ocap-kernel kernel-internals comment fragments
- [`bot-email-dedicated-domain-counter-plan-aws-hetzner`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/bot-email-dedicated-domain-counter-plan-aws-hetzner.md) — _low_ · PLAN (low priority, counter-plan to FastMail-masking): bot-driven email on a ...
- [`investigate-fastmail-masked-email-api-for-bot-personas`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/investigate-fastmail-masked-email-api-for-bot-personas.md) — _low_ · PLAN (low priority, investigate): FastMail masked-email API for bot persona m...

### blocked (awaiting an artifact; unblock watcher auto-promotes on completion)
(none)

## Watch set
(none)

## Hosts
- [endolinbot](https://github.com/kriskowal/garden/blob/journal2/hosts/endolinbot): 100 gardeners
