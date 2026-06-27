# Garden bulletin

_As of 2026-06-27T16:08:21Z_

## Latest

The headline this cycle is a completed root-cause investigation into the beta3 ymax0 portfolio-contract "stack overflow": the investigator ruled out SES 2.x `harden` (iterative in both bundles) and pass-by-copy cycles (caught and thrown, not silently recursed), and corrected the brief's premise — beta3 also carries the Auto-Features contract change (#12761), so an Endo-pin bisection alone can't attribute the regression. The decisive next experiment (capture the XS overflow frame, then pin only the Endo deps with contract source unchanged) needs the agoric toolchain + fork checkout, which the bot host lacks — it's ready to hand to a repro session on your machine.

Two scope decisions are owed before work can proceed: the [endo-but-for-bots#474](https://github.com/endojs/endo-but-for-bots/pull/474) "harden exported function literals" follow-up (erights-authorized, needs breadth narrow-vs-repo-wide + base branch `llm`-vs-`master`), and the formula-inspector retention-paths table, which is blocked until [endo-but-for-bots#284](https://github.com/endojs/endo-but-for-bots/pull/284) lands the rebase-and-gamut you requested back on 2026-05-21 (still open, 4 failing checks). The [endo-but-for-bots#442](https://github.com/endojs/endo-but-for-bots/pull/442) reusable-test-powers revisit concluded no change (reuse would invert the extraction and create a workspace cycle).

On infra: the deploy-sync reconciler landed on main2 (5d6490e62), arming on the next units refresh — but the live `/home/kris` tree is dirty-wedged on a redundant, byte-identical edit to `report-error.sh`, blocking both watchman and deploy-sync fast-forwards; `git checkout -- skills/gardener-inbox-error-reporting/report-error.sh` is lossless and unwedges it. Lint on endo-but-for-bots master is clean (only 5 non-failing jsdoc warnings). Finally, the comment-watcher is still firing its false "silently blind" anomaly every ~40 minutes (452 ticks and counting) despite the fix being in flight as `comment-watcher-no-inactivity-anomaly`; the scholar also expanded the ocap corpus (ocap-kernel guide ingest plus a six-section distributed-ocap concept cluster).

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

- `20260627T160307Z-0bd3f9` — from gardener:investigate-beta3-ymax0-portfolio-upgrade-stack-overflow, reply_to `investigate-beta3-ymax0-portfolio-upgrade-stack-overflow` · [open message](https://github.com/kriskowal/garden/blob/journal2/inbox/maintainer/unread/20260627T160307Z-0bd3f9.md)

> # Root-cause analysis: beta3 ymax0 portfolio-contract upgrade "stack overflow"
>
> Investigator: gardener (endolinbot), fork-scope authorization 2026-06-27.
> Method: primary-source diff of the two contract bundles (`beta2.js` working /
> `beta3.js` crashing) from the maintainer's gist, plus GitHub-API regression-window
> confirmation. The XS swingset repro could NOT be run in this environment (no agoric
> build toolchain / xsnap on the bot host; the fork is not checked out here). What
> follows is an evidence-backed narrowing and a decisive next-experiment plan, not a
> verified fix.
>
> ## Bundle provenance (verified)
> - `beta2.js` 1,129,924 B / 35,131 lines; `beta3.js` 1,139,323 B / 35,447 lines —
>   byte-exact to the brief.
> - String-literal diff (rename-noise normalized): 414 added / 395 removed literals,
>   ~99% pure minifier-rename churn.
>
> ## Regression window (CONFIRMED, GitHub API, no clone)
> - `repos/kriscendobot/agoric-sdk/compare/3952deecd4...9d518832d4` →
>   `status: ahead, ahead_by: 142, behind_by: 0, merge_base = 3952deecd4`.
>   So **`3952deecd4` ("chore(deps): sync Endo to latest including ses 2.x") is a true
>   ancestor of beta3 `9d518832d4`** and present on the fork. Brief fact #1 ✓.
>
> ## What the bundle diff actually shows (the core result)
>
> I walked every recursive path that runs on the `startVat` durable-exo rehydration
> route and compared beta2 (SES 1.14) against beta3 (SES 2.x):
>
> | Path | beta2 → beta3 | Verdict |
> |------|---------------|---------|
> | **`harden`** | Classic iterative work-list in BOTH (`a()` enqueues into set `n`; `d()=Z0(n,c)` drains BFS). beta3 adds only the `Symbol.for("harden")` / `@harden` wrapper indirection. | **Not recursive → ruled OUT** (brief candidate #2). |
> | **`passStyleOf` core** | Same `c→d` dispatcher; same persistent memo WeakMap; **same explicit cycle guard** (`Pass-by-copy data cannot be cyclic`). 2.x splits the per-style validator into `confirmCanBeValid` + `assertRestValid`, but `confirmCanBeValid` returns *before* `assertRestValid` descends — breadth, not depth. | Recursion depth-per-level **unchanged**. |
> | **pattern matcher registry** | 27 kinds → 28 kinds; the only addition is the **leaf** `match:promise` (payload `{label}`, no sub-pattern recursion). All combinators (`and/or/not/arrayOf/splitRecord/recordOf/mapOf/setOf/…`) byte-identical. | Combinator recursion **unchanged**. |
> | **`copyRecord`/`byteArray` helpers** | `confirmCanBeValid:(e,t)=>FC(e,t)&&keys(e).every(r=>KC(e,r,e[r],t))` — structurally identical to beta2's `canBeValid` form. | **Unchanged**. |
> | **orchestration async-flow membrane/replay** | Structural markers identical (`hostFlow=1, replay=32, bijection=9, membrane=4, makeGuest/Host=19, unwrap/wrap=23` in BOTH). | **Unchanged** (my first read flagged "new flow literals" — that was rename-noise; retracted). |
>
> Two of the brief's three candidates fall to direct evidence:
> - **Candidate #2 (SES 2.x harden over a deep/cyclic graph): RULED OUT** — harden is
>   iterative in both bundles; it cannot overflow the native stack by recursion.
> - **Candidate #3 (a true new cycle from the Endo bump): RULED OUT for any
>   pass-by-copy data** — `passStyleOf` detects cycles and *throws a clear error*
>   (`Pass-by-copy data cannot be cyclic`); it does not silently recurse to overflow.
>   (A cycle in a non-copy / remotable graph that no guard traverses is not excluded,
>   but nothing in the bundle points there.)
> - **Candidate #1 (passStyleOf / patterns over interface guards): right LOCUS, but the
>   bump did NOT deepen it.** Every recursive shape on that path is preserved 1.14→2.x.
>
> ## The premise correction (most actionable finding)
>
> The brief states "the Endo bump is the only runtime/hardening change between the
> bundles." **That is not true of this bundle pair.** beta3 also carries a contract
> change: the `OpenPortfolioWithAutoFeatures` / Auto-Features work (#12761) — Auto-Features
> literal count 21→26, OpenPortfolio 18→21. (Durable-kind count = 12 and interfaceGuard
> count = 13 are unchanged, so no *new* kinds, but the guard *contents* moved.)
>
> Consequence: a "pin Endo back and re-test" bisection alone cannot attribute the
> regression, because the contract guards/data also changed. The overflow is **depth-
> driven** (cycles are caught; harden is iterative), so the live question is *whose*
> depth grew — Endo's per-level frame cost, or the contract's guard/data nesting.
>
> ## Most-probable mechanism (consistent with all evidence)
>
> Native-stack exhaustion in the `passStyleOf` / patterns `checkMatches` (or marshal
> `unserialize`) recursion while rehydrating the portfolio contract's **interface guards
> and durable data at `startVat`** (last syscalls `vom.dkind.15/16/17` → `getBundle`
> match guard/kind re-establishment). It overflows XS's shallow native stack but not
> V8's deep one — exactly the env-dependence the brief notes. The trigger is **NOT** a
> new SES-2.x recursion (none is visible); it is a depth already near XS's margin pushed
> over by either (a) a sub-minification per-level frame increase in the Endo refactor, or
> (b) the Auto-Features guard/data depth increase in beta3 — likely (b), or (a)+(b).
>
> ## Decisive next experiment (must run where the toolchain + fork live)
>
> 1. **Capture the frame.** Build `kriscendobot/agoric-sdk@9d518832d4`; drive the v320
>    portfolio-vat upgrade (incarnation 70→71) under `packages/swingset`+`xsnap` with an
>    XS stack dump on overflow. The repeating frame cycle *names the exact function* —
>    this is the one missing fact the minified bundles cannot give.
> 2. **Attribute it (clean bisection).** From the same fork commit, pin ONLY the Endo
>    deps (`ses`, `@endo/pass-style`, `@endo/patterns`, `@endo/marshal`, `@endo/exo`)
>    back to beta2's versions with the **contract source unchanged**, and re-run:
>    - still overflows → it is the **contract/Auto-Features depth**, not Endo;
>    - stops overflowing → it is **Endo**; the step-1 trace names the helper.
> 3. **Confirm env-dependence.** Same upgrade on Node/V8 should pass (deep stack); and
>    beta2 deps should pass on XS — both as controls.
>
> ## Fix decision tree
> - **If contract-attributed:** flatten the portfolio interface-guard / durable schema
>   nesting (collapse nested `M.splitRecord`/`M.and`/`M.arrayOf` chains; shorten the
>   deepest durable key/record path) so depth drops below XS's limit. Fork-side fix in
>   `packages/portfolio-contract`.
> - **If Endo-attributed:** the step-1 trace names the helper; reduce its frames-per-level
>   (e.g. convert a hot recursive walk to an explicit work-list, as `harden` already is)
>   and file an upstream-Endo bug with the minimal XS repro (deliverable, NOT an upstream
>   push).
> - **Last resort only:** raise the XS native stack limit — mitigation, not root cause.
>
> ## Honest boundary
> Naming the single exact recursive frame and shipping a verified fix both require the
> XS stack trace from step 1, which needs the agoric build toolchain + fork checkout on
> a host that has them (the maintainer's machine or a provisioned fork CI). This was not
> runnable on the bot host. Everything above (rule-outs, regression window, premise
> correction, mechanism, experiment plan) is derived from primary sources and is ready
> to hand to that repro session.

- `20260627T160416Z-edee59` — from watchdog:comment-watcher/kriskowal-garden, reply_to `?` · [open message](https://github.com/kriskowal/garden/blob/journal2/inbox/maintainer/unread/20260627T160416Z-edee59.md)

> ANOMALY: comment-watcher/kriskowal-garden found 0 comments for 452 consecutive ticks, but kriskowal/garden IS active (a comment exists since 2026-06-25T20:56:24Z). The watcher may be silently blind — check jq/gh on endolinbot and the comment-source handler. This is the 2026-06-24 outage signature.


## Board
### todo (0)
(none)

### doin (3)
- [`comment-watcher-no-inactivity-anomaly`](https://github.com/kriskowal/garden/blob/journal2/jobs/doin/comment-watcher-no-inactivity-anomaly.md) — Comment-watcher: stop reporting human inactivity as an anomaly; make blindnes...
- [`land-journal-entry-hardening`](https://github.com/kriskowal/garden/blob/journal2/jobs/doin/land-journal-entry-hardening.md) — Land the journal-entry.sh hardening (preserve a gardener's stashed WIP)
- [`rename-killswitch-to-draining-marker`](https://github.com/kriskowal/garden/blob/journal2/jobs/doin/rename-killswitch-to-draining-marker.md) — Rename the killswitch to a mundane "draining" marker (existence-meaningful + ...

### tada (366)
- [`investigate-beta3-ymax0-portfolio-upgrade-stack-overflow`](https://github.com/kriskowal/garden/blob/journal2/jobs/tada/investigate-beta3-ymax0-portfolio-upgrade-stack-overflow.md) — Completion report — investigate-beta3-ymax0-portfolio-upgrade-stack-overflow
- [`scholar-library-cycle-20260627-155443`](https://github.com/kriskowal/garden/blob/journal2/jobs/tada/scholar-library-cycle-20260627-155443.md) — I should not call complete-job.sh myself — the gardener wrapper completes the...
- [`watchman-resolve-wedge-autonomously`](https://github.com/kriskowal/garden/blob/journal2/jobs/tada/watchman-resolve-wedge-autonomously.md) — Completion report — watchman-resolve-wedge-autonomously
- [`improve-library-source-drift-scan`](https://github.com/kriskowal/garden/blob/journal2/jobs/tada/improve-library-source-drift-scan.md) — Completion report: improve-library-source-drift-scan
- [`deadmail-20260627T151020Z-5f405e`](https://github.com/kriskowal/garden/blob/journal2/jobs/tada/deadmail-20260627T151020Z-5f405e.md) — Completion report — deadmail-20260627T151020Z-5f405e (intent of cognito-mcp-m...
- … and 361 more

## Plan queue (parked — not claimable until promoted)
### awaiting go-ahead (maintainer authorization)
- [`synth-and-deploy-minion-town-aws`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/synth-and-deploy-minion-town-aws.md) — _normal_ · Synth, wire custom domain, and live-deploy minion.town to AWS

### deferred (top by priority; foreman auto-promotes when idle)
- [`fix-lint-jsdoc-warnings-endo-master`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/fix-lint-jsdoc-warnings-endo-master.md) — _low_ · fix-lint: jsdoc warnings on endo master (the only lint findings)
- [`scholar-ingest-ocap-kernel-comment-fragments`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/scholar-ingest-ocap-kernel-comment-fragments.md) — _low_ · PLAN: scholar — ingest MetaMask/ocap-kernel kernel-internals comment fragments

## Watch set
(none)

## Hosts
- [endolinbot](https://github.com/kriskowal/garden/blob/journal2/hosts/endolinbot): 100 gardeners
