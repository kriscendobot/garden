# Garden bulletin

_As of 2026-06-27T17:52:56Z_

## Latest

Board movement was light: an attention-and-rebase directive on [endo-but-for-bots#405](https://github.com/endojs/endo-but-for-bots/pull/405) was claimed and is now in flight. The substance is in the maintainer inbox, where several items now wait on your call. The **harden-exported-function-literals** follow-up to merged [endo-but-for-bots#474](https://github.com/endojs/endo-but-for-bots/pull/474) is gated purely on two decisions — breadth (the two evasive-transform exports vs. a repo-wide pass aligned with the `@endo/harden-exports` rule) and base branch (`llm` vs. `master`); erights already authorized the PR, so a builder or designer→builder dispatch fires on your answer. A `formula-inspector` retention-paths table is **blocked** on the stalled host-API PR #284 (the rebase-and-re-gamut you asked for on 2026-05-21 never happened; it sits at 22/26 green) — landing it unblocks the table, and the gardener offered to take that rebase as a separate job. The **deploy-sync reconciler** landed on main2 (5d6490e62) but is inert until a routine units refresh arms its timer; note the live `/home/kris` tree is dirty-wedged on a redundant, byte-identical edit to `report-error.sh` that a lossless checkout clears (watchman territory). Separately, the ymax0/XS investigation surfaced two agoric-sdk-adjacent decisions (sourcing a v320 swing-store export; whether to file an upstream-Endo note) flagged as out-of-bounds for autonomous action. On the library side, scholar ingests continued — MetaMask/ocap-kernel's kernel guide, a distributed-ocap concept cluster, and a re-ingest of the erights E-language page now that the GitHub Pages mirror is reachable.

## Parked for maintainer feedback

- [endojs/endo-but-for-bots#379](https://github.com/endojs/endo-but-for-bots/pull/379) — fix(ses): cyclic star export with renaming reexport (issue #59) - refresh for #3276 feedback (waiting 1d)
- [endojs/endo-but-for-bots#503](https://github.com/endojs/endo-but-for-bots/pull/503) — feat(immutable-arraybuffer,pass-style): passable byte arrays (freezable TypedArray emulation + byteArray brand check) (waiting 1d)
- [endojs/endo-but-for-bots#403](https://github.com/endojs/endo-but-for-bots/pull/403) — feat(registry-capability): EndoRegistry capability + @registry special name (#358 layer 1) (waiting 3d)
- [endojs/endo-but-for-bots#58](https://github.com/endojs/endo-but-for-bots/pull/58) — feat(daemon,cli): error tracing across CapTP workers (#1879) (waiting 4d)
- [endojs/endo#3137](https://github.com/endojs/endo/pull/3137) — feat: support .ts runtime modules via erasable type syntax (waiting 12d)
- [endojs/endo-but-for-bots#101](https://github.com/endojs/endo-but-for-bots/pull/101) — feat(chat): voice input via Web Speech API (waiting 37d)
- [endojs/endo-but-for-bots#182](https://github.com/endojs/endo-but-for-bots/pull/182) — test(ses): isImmutableDataProperty regression for iOS Safari fix (closes #947) (waiting 36d)
- [endojs/endo-but-for-bots#186](https://github.com/endojs/endo-but-for-bots/pull/186) — feat(eventual-send): eager-shim/lazy-main delegate ponyfill (per #175) (waiting 36d)
- [endojs/endo-but-for-bots#266](https://github.com/endojs/endo-but-for-bots/pull/266) — design: opencode comparative analysis + gap-closing raft (endopen) (waiting 38d)
- [endojs/endo-but-for-bots#288](https://github.com/endojs/endo-but-for-bots/pull/288) — feat(cbor-frame): add @endo/cbor-frame package for CBOR byte-string framing (waiting 37d)

_Showing top 10 of 28 parked PRs (ranked by recency + roadmap relevance)._
## Messages to the maintainer

- `20260627T072235Z-b12c9f` — from gardener:improve-deploy-sync-fleet-onto-landed-fixes, reply_to `improve-deploy-sync-fleet-onto-landed-fixes` · [open message](https://github.com/kriskowal/garden/blob/journal2/inbox/maintainer/unread/20260627T072235Z-b12c9f.md)

> deploy-sync reconciler landed on main2 (5d6490e62): advances the checkout by a strict clean fast-forward and restarts the long-running services (gardeners between-claims via a busy marker, plus bulletin/driver/watcher) when scripts/ changes, so landed fixes reach running workers without a manual restart.
>
> Two bringup notes:
> 1. It is INERT until armed. garden-deploy-sync.timer auto-enables on the next 'install-units.sh install && enable-services' (it is in the derived enable-set), so a routine units refresh arms it; no special step.
> 2. The live /home/kris tree is currently dirty-wedged: 'skills/gardener-inbox-error-reporting/report-error.sh' is modified in the working copy, and its content is BYTE-IDENTICAL to origin/main2's committed version (a redundant uncommitted edit duplicating an already-landed fix). git refuses the fast-forward while it is dirty, so BOTH the watchman and deploy-sync skip the advance (the checkout is now 6 behind). 'git -C /home/kris checkout -- skills/gardener-inbox-error-reporting/report-error.sh' is lossless (content already on origin) and unwedges the deploy. I did not touch the shared live tree from a gardener job.

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

- `20260627T123905Z-ee2b02` — from gardener:endojs-endo-but-for-bots-pr442-revisit-reusable-test-powers, reply_to `endojs-endo-but-for-bots-pr442-revisit-reusable-test-powers` · [open message](https://github.com/kriskowal/garden/blob/journal2/inbox/maintainer/unread/20260627T123905Z-ee2b02.md)

> Revisit of PR #442 deferred plan (reusable file/crypto powers for @endo/daemon-cas tests) — concluded: intrinsic duplication, no change.
>
> Survey result:
> - The only API-exact match for the four-method ContentStoreFilePowers / ContentStoreCryptoPowers is @endo/daemon's makeFilePowers({fs,path}) + makeCryptoPowers(crypto) in daemon-node-powers.js (a superset of both contracts). BUT @endo/daemon has @endo/daemon-cas as a runtime dependency (the point of the #442 extraction), so a daemon-cas test depending on @endo/daemon — even devDep — inverts the extraction and creates a workspace cycle. Architecturally disallowed.
> - @endo/platform (a real daemon-cas dep) exposes makeLocalBlob/makeLocalTree (a higher-level blob/tree CAS abstraction), not the four-method powers shape, and no array->async-iterable helper. Not narrowable without a wrapper as large as the inline shim.
> - @endo/stream exports only queue/stream/pipe primitives — no array->async-iterable helper (trigger #1 does not hold).
> - content-store.test.js is the ONLY workspace file constructing this powers shim (trigger #2 does not hold). asAsyncIterable-style inline generators in other tests (chat, exo-stream, ocapn-noise) are each local 4-6 line generators, no shared helper.
>
> Both re-arm triggers stay armed; the plan re-fires if @endo/stream gains a real array->async-iterable helper, or a second test reaches for the same real-fs/crypto powers shim. Optional low-risk improvement if you want it folded into #442: a one-line comment by the inline shim noting the identical @endo/daemon powers are intentionally not reused because daemon depends on daemon-cas. I left the PR branch untouched since it is under active review.

- `20260627T125202Z-44b78c` — from gardener:endo-but-for-bots-harden-exported-literals-followup, reply_to `endo-but-for-bots-harden-exported-literals-followup` · [open message](https://github.com/kriskowal/garden/blob/journal2/inbox/maintainer/unread/20260627T125202Z-44b78c.md)

> # Scope decision needed: "harden exported function literals" follow-up (endo-but-for-bots)
>
> Origin: erights bullet 4 on endojs/endo-but-for-bots#474 — "agreed, not in this
> PR. Please start a separate PR with that change... Attn @kriskowal". The job is
> gated on you scoping its breadth before any cross-repo PR opens.
>
> What I verified (read-only) today:
>
> - **#474 is MERGED** (into `master`, 2026-06-26): "retire function-keyword in
>   favor of arrow/method syntax per erights review". No open PR on endo-but-for-bots
>   or endo covers the harden follow-up.
> - **The literal form differs by branch** — this matters for how the change is
>   written and which base to target:
>   - Default/working branch `llm`: `evadeCensorSync`/`evadeCensor` are still
>     un-hardened **function declarations** (index.js:65 / :129).
>   - `master` (post-#474): the arrow-const form erights reviewed (his ref was
>     index.js:91).
> - A real `@endo/harden-exports` eslint rule exists in the repo (#474 touched it),
>   so a repo-wide pass would lean on / interact with it.
> - Note: the parked job spec described the evasive-transform exports as
>   "un-hardened arrow consts" — that's only true on `master`; on the `llm` default
>   they're function declarations. So the base branch choice changes the diff shape.
>
> Decision I need from you (two axes):
>
> 1. **Breadth** — (a) **narrow**: harden only the two evasive-transform exports
>    (`evadeCensorSync`, `evadeCensor`); or (b) **repo-wide**: harden every exported
>    function literal, driven by/aligned with the `@endo/harden-exports` rule
>    (designer-first; larger blast radius). erights authorized (a) and framed (b) as
>    the better trailing form.
> 2. **Base branch** — target `llm` (default) or `master`?
>
> On your answer I'll dispatch a builder (narrow) or designer→builder (repo-wide) to
> open a DRAFT PR with that scope and run the gamut. Authorization to open the
> cross-repo PR is already carried by erights's directive; only breadth + base are
> owed.

- `20260627T164806Z-1db40f` — from liaison:follow-up, reply_to `?` · [open message](https://github.com/kriskowal/garden/blob/journal2/inbox/maintainer/unread/20260627T164806Z-1db40f.md)

> Report investigate-beta3-ymax0-xs-repro-and-fix raised two decisions that are yours, both touching ymax0/agoric-sdk territory (out of bounds for autonomous garden action):
>
> 1. A **v320 swing-store export** is the missing artifact gating the real-data trace and the targeted fix. Sourcing that production export is your call — the garden can't autonomously obtain it, and the downstream work lands in agoric-sdk/contract territory, which is off-limits to us.
>
> 2. The minimal XS repro (nested-record passStyleOf/checkMatches overflow → uncatchable vat abort at ~15/~116 levels) could seed an **upstream-Endo note "if desired"** — but the investigation concluded this is an XS native-stack-depth property, **not an Endo regression** (frames/level unchanged), so the real fix is **contract-side depth-bounding**, not Endo. Whether to file the Endo note at all, and the contract-side fix itself, are both yours to direct.
>
> Tell me if you want either turned into a job (e.g. a write-up I can draft on a bot repo), and please advise on obtaining the v320 export.


## Board
### todo (0)
(none)

### doin (4)
- [`endojs-endo-but-for-bots-pr405-de3edd06`](https://github.com/kriskowal/garden/blob/journal2/jobs/doin/endojs-endo-but-for-bots-pr405-de3edd06.md) — attention directive on endojs/endo-but-for-bots PR #405
- [`endojs-endo-but-for-bots-pr405-rebase`](https://github.com/kriskowal/garden/blob/journal2/jobs/doin/endojs-endo-but-for-bots-pr405-rebase.md) — rebase directive on endojs/endo-but-for-bots PR #405
- [`issue-inbox-maintainer-interaction-workflow`](https://github.com/kriskowal/garden/blob/journal2/jobs/doin/issue-inbox-maintainer-interaction-workflow.md) — Set up the issue-inbox workflow: maintainer interaction via the garden's own ...
- [`scholar-ingest-source-erights-elang-mirror`](https://github.com/kriskowal/garden/blob/journal2/jobs/doin/scholar-ingest-source-erights-elang-mirror.md) — Re-ingest erights.org E-language page from the now-reachable GitHub Pages mirror

### tada (378)
- [`improve-gardener-transient-line-carries-reap-count`](https://github.com/kriskowal/garden/blob/journal2/jobs/tada/improve-gardener-transient-line-carries-reap-count.md) — Completion report: improve-gardener-transient-line-carries-reap-count
- [`scholar-erights-github-pages-mirror-source`](https://github.com/kriskowal/garden/blob/journal2/jobs/tada/scholar-erights-github-pages-mirror-source.md) — Completion report: scholar-erights-github-pages-mirror-source
- [`resolve-wedge-endolinbot-00693cdbd594-238966609725`](https://github.com/kriskowal/garden/blob/journal2/jobs/tada/resolve-wedge-endolinbot-00693cdbd594-238966609725.md) — The wedge is resolved. The tree is now clean of tracked changes — the only bl...
- [`improve-mentor-treat-journalctl-no-entries-as-empty`](https://github.com/kriskowal/garden/blob/journal2/jobs/tada/improve-mentor-treat-journalctl-no-entries-as-empty.md) — Completion report
- [`scholar-library-cycle-20260627-165512`](https://github.com/kriskowal/garden/blob/journal2/jobs/tada/scholar-library-cycle-20260627-165512.md) — Completion report: scholar-library-cycle-20260627-165512
- … and 373 more

## Plan queue (parked — not claimable until promoted)
### awaiting go-ahead (maintainer authorization)
- [`foreman-budget-cross-host-weekly-token-aggregation`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/foreman-budget-cross-host-weekly-token-aggregation.md) — _normal_ · PLAN: deterministic cross-host weekly token-spend aggregation for the foreman...
- [`service-host-roles-singletons-on-main-host`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/service-host-roles-singletons-on-main-host.md) — _normal_ · PLAN: service host-roles — gardeners run everywhere, singletons run only on t...
- [`synth-and-deploy-minion-town-aws`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/synth-and-deploy-minion-town-aws.md) — _normal_ · Synth, wire custom domain, and live-deploy minion.town to AWS

### deferred (top by priority; foreman auto-promotes when idle)
- [`fix-lint-jsdoc-warnings-endo-master`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/fix-lint-jsdoc-warnings-endo-master.md) — _low_ · fix-lint: jsdoc warnings on endo master (the only lint findings)
- [`scholar-ingest-ocap-kernel-comment-fragments`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/scholar-ingest-ocap-kernel-comment-fragments.md) — _low_ · PLAN: scholar — ingest MetaMask/ocap-kernel kernel-internals comment fragments
- [`bot-email-dedicated-domain-counter-plan-aws-hetzner`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/bot-email-dedicated-domain-counter-plan-aws-hetzner.md) — _low_ · PLAN (low priority, counter-plan to FastMail-masking): bot-driven email on a ...
- [`investigate-fastmail-masked-email-api-for-bot-personas`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/investigate-fastmail-masked-email-api-for-bot-personas.md) — _low_ · PLAN (low priority, investigate): FastMail masked-email API for bot persona m...

## Watch set
(none)

## Hosts
- [endolinbot](https://github.com/kriskowal/garden/blob/journal2/hosts/endolinbot): 100 gardeners
