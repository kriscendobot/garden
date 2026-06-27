# Garden bulletin

_As of 2026-06-27T16:41:23Z_

## Latest

The comment-watcher's false "human inactivity" anomaly was removed in favor of a positive self-test, and the fleet draining killswitch was renamed to a self-describing draining marker — both landed on `main2`. A **deploy-sync reconciler** (`5d6490e62`) also landed: it fast-forwards the live checkout and restarts long-running services when `scripts/` changes, so future fixes reach running workers without manual restarts. Notably, that pipeline is currently jammed — the live `/home/kris` tree is dirty-wedged on a redundant, byte-identical uncommitted edit to `skills/gardener-inbox-error-reporting/report-error.sh`, which makes both the watchman and deploy-sync skip the advance (now ~6 commits behind). This is why the comment-watcher kept firing the old inactivity anomaly all afternoon: the fix is on `main2` but the running unit hasn't picked it up. A lossless `git checkout -- skills/gardener-inbox-error-reporting/report-error.sh` unwedges it.

Two scope decisions are owed to the maintainer. First, the [endo-but-for-bots#474](https://github.com/endojs/endo-but-for-bots/pull/474) "harden exported function literals" follow-up (erights-authorized, #474 now merged) is gated on two answers — narrow (two evasive-transform exports) vs. repo-wide, and base branch `llm` vs. `master`. Second, the formula-inspector retention-paths table is blocked on [endo-but-for-bots#284](https://github.com/endojs/endo-but-for-bots/pull/284), which has been stalled since May 21 awaiting the rebase-and-gamut you already requested (4 failing checks); a gardener offered to take that on as a separate job if you say the word.

On the quieter side: endo master lint is clean (only 5 non-blocking jsdoc warnings, plan parked); scholars ingested MetaMask/ocap-kernel's kernel guide plus a six-topic distributed-ocap concept cluster; and two new plans await your go-ahead — cross-host weekly token aggregation for the foreman, and service host-roles (singletons on the main host only).

## Parked for maintainer feedback

- [endojs/endo-but-for-bots#379](https://github.com/endojs/endo-but-for-bots/pull/379) — fix(ses): cyclic star export with renaming reexport (issue #59) - refresh for #3276 feedback (waiting 1d)
- [endojs/endo-but-for-bots#503](https://github.com/endojs/endo-but-for-bots/pull/503) — feat(immutable-arraybuffer,pass-style): passable byte arrays (freezable TypedArray emulation + byteArray brand check) (waiting 1d)
- [endojs/endo-but-for-bots#403](https://github.com/endojs/endo-but-for-bots/pull/403) — feat(registry-capability): EndoRegistry capability + @registry special name (#358 layer 1) (waiting 3d)
- [endojs/endo-but-for-bots#58](https://github.com/endojs/endo-but-for-bots/pull/58) — feat(daemon,cli): error tracing across CapTP workers (#1879) (waiting 4d)
- [endojs/endo#3137](https://github.com/endojs/endo/pull/3137) — feat: support .ts runtime modules via erasable type syntax (waiting 11d)
- [endojs/endo-but-for-bots#101](https://github.com/endojs/endo-but-for-bots/pull/101) — feat(chat): voice input via Web Speech API (waiting 37d)
- [endojs/endo-but-for-bots#182](https://github.com/endojs/endo-but-for-bots/pull/182) — test(ses): isImmutableDataProperty regression for iOS Safari fix (closes #947) (waiting 36d)
- [endojs/endo-but-for-bots#186](https://github.com/endojs/endo-but-for-bots/pull/186) — feat(eventual-send): eager-shim/lazy-main delegate ponyfill (per #175) (waiting 36d)
- [endojs/endo-but-for-bots#266](https://github.com/endojs/endo-but-for-bots/pull/266) — design: opencode comparative analysis + gap-closing raft (endopen) (waiting 38d)
- [endojs/endo-but-for-bots#288](https://github.com/endojs/endo-but-for-bots/pull/288) — feat(cbor-frame): add @endo/cbor-frame package for CBOR byte-string framing (waiting 37d)

_Showing top 10 of 28 parked PRs (ranked by recency + roadmap relevance)._
## Messages to the maintainer

- `20260627T070019Z-cf49fc` — from watchdog:comment-watcher/kriskowal-garden, reply_to `?` · [open message](https://github.com/kriskowal/garden/blob/journal2/inbox/maintainer/unread/20260627T070019Z-cf49fc.md)

> ANOMALY: comment-watcher/kriskowal-garden found 0 comments for 100 consecutive ticks, but kriskowal/garden IS active (a comment exists since 2026-06-25T20:56:24Z). The watcher may be silently blind — check jq/gh on endolinbot and the comment-source handler. This is the 2026-06-24 outage signature.

- `20260627T071028Z-d3cf33` — from watchdog:self-heal-claude, reply_to `?` · [open message](https://github.com/kriskowal/garden/blob/journal2/inbox/maintainer/unread/20260627T071028Z-d3cf33.md)

> self-heal: garden-gardener exited rc=1 with no scoped fix. Capture: aa06bfa333e088a3ceb27279e19eeb3e822b0fb5 (git -C /home/kris/.garden-state/self-heal/journal cat-file -p aa06bfa333e088a3ceb27279e19eeb3e822b0fb5). Diagnosis: ## Diagnosis
>
> **No fix job to post — the code fix already landed and a deploy job for the recurrence is already in flight.**
>
> The failure signature is `FATAL: claim failed (rc=128)` → exit 1 → systemd restart. The crash came with **no preceding claim log** (no "offline", no "fetch failed", no "lost claim race"), meaning `claim-job.sh` died under `set -euo pipefail` on an unguarded git op during the claim's `sync_clone` — a transient connectivity/DNS blip surfacing as a raw git 128. The old `gardener.sh` loop treated any non-0/non-3 claim rc as a hard `die`, so a self-resolving network blip crash-looped the worker.
>
> That is **already fixed on `origin/main2`**. The running unit at `/home/kris` is **4 commits behind** `origin/main2`, and exactly those 4 commits are the fix chain:
> - `5

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

- `20260627T080041Z-e5e019` — from watchdog:comment-watcher/kriskowal-garden, reply_to `?` · [open message](https://github.com/kriskowal/garden/blob/journal2/inbox/maintainer/unread/20260627T080041Z-e5e019.md)

> ANOMALY: comment-watcher/kriskowal-garden found 0 comments for 140 consecutive ticks, but kriskowal/garden IS active (a comment exists since 2026-06-25T20:56:24Z). The watcher may be silently blind — check jq/gh on endolinbot and the comment-source handler. This is the 2026-06-24 outage signature.

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

- `20260627T090109Z-b8fee9` — from watchdog:comment-watcher/kriskowal-garden, reply_to `?` · [open message](https://github.com/kriskowal/garden/blob/journal2/inbox/maintainer/unread/20260627T090109Z-b8fee9.md)

> ANOMALY: comment-watcher/kriskowal-garden found 0 comments for 180 consecutive ticks, but kriskowal/garden IS active (a comment exists since 2026-06-25T20:56:24Z). The watcher may be silently blind — check jq/gh on endolinbot and the comment-source handler. This is the 2026-06-24 outage signature.

- `20260627T100134Z-2f9b1a` — from watchdog:comment-watcher/kriskowal-garden, reply_to `?` · [open message](https://github.com/kriskowal/garden/blob/journal2/inbox/maintainer/unread/20260627T100134Z-2f9b1a.md)

> ANOMALY: comment-watcher/kriskowal-garden found 0 comments for 220 consecutive ticks, but kriskowal/garden IS active (a comment exists since 2026-06-25T20:56:24Z). The watcher may be silently blind — check jq/gh on endolinbot and the comment-source handler. This is the 2026-06-24 outage signature.

- `20260627T110207Z-3896f2` — from watchdog:comment-watcher/kriskowal-garden, reply_to `?` · [open message](https://github.com/kriskowal/garden/blob/journal2/inbox/maintainer/unread/20260627T110207Z-3896f2.md)

> ANOMALY: comment-watcher/kriskowal-garden found 0 comments for 260 consecutive ticks, but kriskowal/garden IS active (a comment exists since 2026-06-25T20:56:24Z). The watcher may be silently blind — check jq/gh on endolinbot and the comment-source handler. This is the 2026-06-24 outage signature.

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

- `20260627T120229Z-1abe89` — from watchdog:comment-watcher/kriskowal-garden, reply_to `?` · [open message](https://github.com/kriskowal/garden/blob/journal2/inbox/maintainer/unread/20260627T120229Z-1abe89.md)

> ANOMALY: comment-watcher/kriskowal-garden found 0 comments for 300 consecutive ticks, but kriskowal/garden IS active (a comment exists since 2026-06-25T20:56:24Z). The watcher may be silently blind — check jq/gh on endolinbot and the comment-source handler. This is the 2026-06-24 outage signature.

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

- `20260627T130256Z-0f8641` — from watchdog:comment-watcher/kriskowal-garden, reply_to `?` · [open message](https://github.com/kriskowal/garden/blob/journal2/inbox/maintainer/unread/20260627T130256Z-0f8641.md)

> ANOMALY: comment-watcher/kriskowal-garden found 0 comments for 340 consecutive ticks, but kriskowal/garden IS active (a comment exists since 2026-06-25T20:56:24Z). The watcher may be silently blind — check jq/gh on endolinbot and the comment-source handler. This is the 2026-06-24 outage signature.

- `20260627T140312Z-ac103b` — from watchdog:comment-watcher/kriskowal-garden, reply_to `?` · [open message](https://github.com/kriskowal/garden/blob/journal2/inbox/maintainer/unread/20260627T140312Z-ac103b.md)

> ANOMALY: comment-watcher/kriskowal-garden found 0 comments for 380 consecutive ticks, but kriskowal/garden IS active (a comment exists since 2026-06-25T20:56:24Z). The watcher may be silently blind — check jq/gh on endolinbot and the comment-source handler. This is the 2026-06-24 outage signature.

- `20260627T150334Z-79820a` — from watchdog:comment-watcher/kriskowal-garden, reply_to `?` · [open message](https://github.com/kriskowal/garden/blob/journal2/inbox/maintainer/unread/20260627T150334Z-79820a.md)

> ANOMALY: comment-watcher/kriskowal-garden found 0 comments for 420 consecutive ticks, but kriskowal/garden IS active (a comment exists since 2026-06-25T20:56:24Z). The watcher may be silently blind — check jq/gh on endolinbot and the comment-source handler. This is the 2026-06-24 outage signature.

- `20260627T160416Z-edee59` — from watchdog:comment-watcher/kriskowal-garden, reply_to `?` · [open message](https://github.com/kriskowal/garden/blob/journal2/inbox/maintainer/unread/20260627T160416Z-edee59.md)

> ANOMALY: comment-watcher/kriskowal-garden found 0 comments for 452 consecutive ticks, but kriskowal/garden IS active (a comment exists since 2026-06-25T20:56:24Z). The watcher may be silently blind — check jq/gh on endolinbot and the comment-source handler. This is the 2026-06-24 outage signature.


## Board
### todo (0)
(none)

### doin (2)
- [`foreman-meter-from-claude-code-session-logs`](https://github.com/kriskowal/garden/blob/journal2/jobs/doin/foreman-meter-from-claude-code-session-logs.md) — Foreman token meter: re-point at Claude Code session logs (Max x20 subscripti...
- [`investigate-beta3-ymax0-xs-repro-and-fix`](https://github.com/kriskowal/garden/blob/journal2/jobs/doin/investigate-beta3-ymax0-xs-repro-and-fix.md) — beta3 ymax0 stack-overflow: build the fork on this host and run the XS repro ...

### tada (369)
- [`comment-watcher-no-inactivity-anomaly`](https://github.com/kriskowal/garden/blob/journal2/jobs/tada/comment-watcher-no-inactivity-anomaly.md) — Completion report — comment-watcher-no-inactivity-anomaly
- [`rename-killswitch-to-draining-marker`](https://github.com/kriskowal/garden/blob/journal2/jobs/tada/rename-killswitch-to-draining-marker.md) — Completion report — rename-killswitch-to-draining-marker
- [`land-journal-entry-hardening`](https://github.com/kriskowal/garden/blob/journal2/jobs/tada/land-journal-entry-hardening.md) — The job is already fully landed. No code changes were needed.
- [`investigate-beta3-ymax0-portfolio-upgrade-stack-overflow`](https://github.com/kriskowal/garden/blob/journal2/jobs/tada/investigate-beta3-ymax0-portfolio-upgrade-stack-overflow.md) — Completion report — investigate-beta3-ymax0-portfolio-upgrade-stack-overflow
- [`scholar-library-cycle-20260627-155443`](https://github.com/kriskowal/garden/blob/journal2/jobs/tada/scholar-library-cycle-20260627-155443.md) — I should not call complete-job.sh myself — the gardener wrapper completes the...
- … and 364 more

## Plan queue (parked — not claimable until promoted)
### awaiting go-ahead (maintainer authorization)
- [`foreman-budget-cross-host-weekly-token-aggregation`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/foreman-budget-cross-host-weekly-token-aggregation.md) — _normal_ · PLAN: deterministic cross-host weekly token-spend aggregation for the foreman...
- [`service-host-roles-singletons-on-main-host`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/service-host-roles-singletons-on-main-host.md) — _normal_ · PLAN: service host-roles — gardeners run everywhere, singletons run only on t...
- [`synth-and-deploy-minion-town-aws`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/synth-and-deploy-minion-town-aws.md) — _normal_ · Synth, wire custom domain, and live-deploy minion.town to AWS

### deferred (top by priority; foreman auto-promotes when idle)
- [`fix-lint-jsdoc-warnings-endo-master`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/fix-lint-jsdoc-warnings-endo-master.md) — _low_ · fix-lint: jsdoc warnings on endo master (the only lint findings)
- [`scholar-ingest-ocap-kernel-comment-fragments`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/scholar-ingest-ocap-kernel-comment-fragments.md) — _low_ · PLAN: scholar — ingest MetaMask/ocap-kernel kernel-internals comment fragments

## Watch set
(none)

## Hosts
- [endolinbot](https://github.com/kriskowal/garden/blob/journal2/hosts/endolinbot): 100 gardeners
