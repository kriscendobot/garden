# Garden bulletin

_As of 2026-07-02T02:47:29Z_

## Latest

The [#587](https://github.com/endojs/endo-but-for-bots/pull/587) shepherd was the only job to complete this window; the board is otherwise drained to five in-flight items (a lint-infra fix plus shepherds/weavers on [#242](https://github.com/endojs/endo-but-for-bots/pull/242), [#318](https://github.com/endojs/endo-but-for-bots/pull/318), [#438](https://github.com/endojs/endo-but-for-bots/pull/438), and [#79](https://github.com/endojs/endo-but-for-bots/pull/79)). The dominant signal is a large wave of reaper POISON drops — roughly thirty shepherd/weaver/fixer jobs (spanning [#60](https://github.com/endojs/endo-but-for-bots/pull/60), [#101](https://github.com/endojs/endo-but-for-bots/pull/101), [#216](https://github.com/endojs/endo-but-for-bots/pull/216), [#235](https://github.com/endojs/endo-but-for-bots/pull/235), [#301](https://github.com/endojs/endo-but-for-bots/pull/301), [#306](https://github.com/endojs/endo-but-for-bots/pull/306), [#394](https://github.com/endojs/endo-but-for-bots/pull/394), and many more) plus the daemon-rename build and four garden-infra hardening jobs all fell off the board after five failed requeue cycles, consistent with a correlated Claude quota/API outage churning the ~100-gardener fleet — which is itself what two of the poisoned infra jobs (`improve-gardener-transient-failure-backoff-and-fleet-brake`, `improve-garden-identity-drift-detector`) were meant to prevent. Two escalations need a human decision: the typescript-eslint projectService **lint scaling ceiling** now blocks [#590](https://github.com/endojs/endo-but-for-bots/pull/590), [#592](https://github.com/endojs/endo-but-for-bots/pull/592), and [#593](https://github.com/endojs/endo-but-for-bots/pull/593) (a dedicated `endo-but-for-bots-lint-projectservice-ceiling` job is now in flight, but the fix is lint-infra scope, not a per-PR shepherd fix), and the follow-up liaison flagged that standing board-audit capability, if wanted, is an architecture call before any role work.

## Parked for maintainer feedback

- [endojs/endo-but-for-bots#503](https://github.com/endojs/endo-but-for-bots/pull/503) — feat(immutable-arraybuffer,pass-style): passable byte arrays (freezable TypedArray emulation + byteArray brand check) (waiting 1d)
- [endojs/endo-but-for-bots#403](https://github.com/endojs/endo-but-for-bots/pull/403) — feat(registry-capability): EndoRegistry capability + @registry special name (#358 layer 1) (waiting 2d)
- [endojs/endo-but-for-bots#379](https://github.com/endojs/endo-but-for-bots/pull/379) — fix(ses): cyclic star export with renaming reexport (issue #59) - refresh for #3276 feedback (waiting 5d)
- [endojs/endo#3137](https://github.com/endojs/endo/pull/3137) — feat: support .ts runtime modules via erasable type syntax (waiting 16d)
- [endojs/endo-but-for-bots#101](https://github.com/endojs/endo-but-for-bots/pull/101) — feat(chat): voice input via Web Speech API (waiting 41d)
- [endojs/endo-but-for-bots#182](https://github.com/endojs/endo-but-for-bots/pull/182) — test(ses): isImmutableDataProperty regression for iOS Safari fix (closes #947) (waiting 41d)
- [endojs/endo-but-for-bots#186](https://github.com/endojs/endo-but-for-bots/pull/186) — feat(eventual-send): eager-shim/lazy-main delegate ponyfill (per #175) (waiting 41d)
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

- `20260702T011310Z-224366` — from reaper:endolinbot, reply_to `?` · [open message](https://github.com/kriskowal/garden/blob/journal2/inbox/maintainer/unread/20260702T011310Z-224366.md)

> POISON job dropped from the board after 5 requeue cycles on endolinbot.
> Its handler appears to fail every time; the reaper stopped requeueing it.
> Original job base: endojs-endo-but-for-bots-pr587-shepherd
>
> --- original job body ---
> # shepherd (auto: red CI) on endojs/endo-but-for-bots PR #587
>
> CI is RED on this OPEN bot-authored PR (completed failure, not in-progress).
> Nothing settling — a shepherd was dispatched AUTOMATICALLY by the CI-status
> watcher, with no maintainer comment. Map: **shepherd** → drive CI to green.
>
> PR: https://github.com/endojs/endo-but-for-bots/pull/587
> Head: endojs/endo-but-for-bots (bot-pushable)
>
> Read the failing checks and drive them green (see roles/shepherd/AGENT.md).
> If the failure is out of a shepherds scope, escalate to a fixer per the
> shepherd→fixer auto-chain. Re-fetch the live check state before acting;
> this job was minted from a rollup read at post time.

- `20260702T011322Z-7b9d48` — from reaper:endolinbot, reply_to `?` · [open message](https://github.com/kriskowal/garden/blob/journal2/inbox/maintainer/unread/20260702T011322Z-7b9d48.md)

> POISON job dropped from the board after 5 requeue cycles on endolinbot.
> Its handler appears to fail every time; the reaper stopped requeueing it.
> Original job base: endojs-endo-but-for-bots-pr588-shepherd
>
> --- original job body ---
> # shepherd (auto: red CI) on endojs/endo-but-for-bots PR #588
>
> CI is RED on this OPEN bot-authored PR (completed failure, not in-progress).
> Nothing settling — a shepherd was dispatched AUTOMATICALLY by the CI-status
> watcher, with no maintainer comment. Map: **shepherd** → drive CI to green.
>
> PR: https://github.com/endojs/endo-but-for-bots/pull/588
> Head: endojs/endo-but-for-bots (bot-pushable)
>
> Read the failing checks and drive them green (see roles/shepherd/AGENT.md).
> If the failure is out of a shepherds scope, escalate to a fixer per the
> shepherd→fixer auto-chain. Re-fetch the live check state before acting;
> this job was minted from a rollup read at post time.

- `20260702T012313Z-f47566` — from reaper:endolinbot, reply_to `?` · [open message](https://github.com/kriskowal/garden/blob/journal2/inbox/maintainer/unread/20260702T012313Z-f47566.md)

> POISON job dropped from the board after 5 requeue cycles on endolinbot.
> Its handler appears to fail every time; the reaper stopped requeueing it.
> Original job base: build-daemon-rename-to-manager
>
> --- original job body ---
> # Build: rename `daemon.js` → `manager.js` (`Daemon`/`Mignonic` → `Manager`/`Worker`)
>
> Batch design→build dispatch for the **current active milestone (M3: Remote Access
> and Coding Capabilities)** on the endo roadmap. This is the one M3 design that is
> **ready to build** — design-complete, no unmet dependency, and no build in flight.
>
> Repo: **endojs/endo-but-for-bots**, base branch **`llm`**, **bot identity**
> (kriscendobot / bot fork — bot-repo work only, no upstream `endojs/endo` touch).
>
> ## Design (blessed, merged)
>
> `designs/daemon-rename-to-manager.md` on `llm` (Status: Not Started; design landed
> via merged PR #85). Align the JS orchestration layer's naming with the Rust
> `endor` supervisor, which already calls this role the **manager**:
>
> - `packages/daemon/src/daemon.js` → `manager.js` (and peer `daemon-*.js` per the
>   design's *File renames* table).
> - Identifiers `Daemon`/`Daemonic` → `Manager`, and `MignonicPowers` →
>   `WorkerPowers` (the exo tag `'EndoDaemonFacetForWorker'` renamed on both
>   producer and consumer in the same package — no wire-compat window needed).
> - The npm package `@endo/daemon` and the directory `packages/daemon/` **keep**
>   their names; only the orchestration file and the `Daemon*` identifiers change.
>
> ## What to do
>
> Wear **designer** only if a short implementation delta is needed, then
> **builder**; the standard researcher-precedes-builder chain and the gardening
> state machine apply. Ground the work in the design's **Phased Implementation**:
>
> - **Phase 1** — file renames only (`git mv`, update `import` specifiers pointing
>   at the renamed files, no identifier renames). Package builds, types check, tests
>   pass. This is the safest, smallest-review slice — open the initial **DRAFT** PR
>   on `llm` here.
> - **Phase 2** — whole-word identifier renames (`Daemon`/`Daemonic` → `Manager`,
>   `MignonicPowers` → `WorkerPowers`, exo tag). Independently mergeable; depends on
>   Phase 1.
> - **Phase 3** — sweep workspace consumers (small; most import unchanged names like
>   `EndoHost`/`EndoGuest`/`EndoWorker`). Add the `@endo/daemon` CHANGELOG entry
>   (`makeDaemon` → `makeManager`, exports otherwise unchanged; outright cut, no
>   deprecated alias — no downstream consumers of `Daemon*` identifiers).
>
> ## Sequencing / collision note (read before pushing)
>
> `packages/daemon/*` is under heavy concurrent churn — ~40 open PRs (the mount
> stack #135, the gateway-package stack #343/#388–#397/#409–#420, sturdyrefs #541,
> etc.). A project-wide identifier rename will conflict with any of them that edit
> `daemon.js` or `Daemon*` names. Mitigations, in order:
>
> - Keep the PR **DRAFT** and land **Phase 1 first** (mechanical, smallest surface),
>   so review can sequence it against the in-flight daemon PRs rather than
>   merge-storming them.
> - Rebase on `llm` immediately before each push; expect to re-run the whole-word
>   replace after a rebase.
> - If the maintainer prefers to hold the rename until the daemon PRs quiesce,
>   surface that on the PR and park — do not force it through against open work.
>
> ## Idempotency
>
> Deterministic basename `build-daemon-rename-to-manager` — a re-run of this batch
> collides and no-ops.

- `20260702T012803Z-4e1d80` — from reaper:endolinbot, reply_to `?` · [open message](https://github.com/kriskowal/garden/blob/journal2/inbox/maintainer/unread/20260702T012803Z-4e1d80.md)

> POISON job dropped from the board after 5 requeue cycles on endolinbot.
> Its handler appears to fail every time; the reaper stopped requeueing it.
> Original job base: endojs-endo-but-for-bots-pr250-shepherd
>
> --- original job body ---
> # shepherd (auto: red CI) on endojs/endo-but-for-bots PR #250
>
> CI is RED on this OPEN bot-authored PR (completed failure, not in-progress).
> Nothing settling — a shepherd was dispatched AUTOMATICALLY by the CI-status
> watcher, with no maintainer comment. Map: **shepherd** → drive CI to green.
>
> PR: https://github.com/endojs/endo-but-for-bots/pull/250
> Head: endojs/endo-but-for-bots (bot-pushable)
>
> Read the failing checks and drive them green (see roles/shepherd/AGENT.md).
> If the failure is out of a shepherds scope, escalate to a fixer per the
> shepherd→fixer auto-chain. Re-fetch the live check state before acting;
> this job was minted from a rollup read at post time.

- `20260702T012836Z-3caf67` — from reaper:endolinbot, reply_to `?` · [open message](https://github.com/kriskowal/garden/blob/journal2/inbox/maintainer/unread/20260702T012836Z-3caf67.md)

> POISON job dropped from the board after 5 requeue cycles on endolinbot.
> Its handler appears to fail every time; the reaper stopped requeueing it.
> Original job base: endojs-endo-but-for-bots-pr316-shepherd
>
> --- original job body ---
> # shepherd (auto: red CI) on endojs/endo-but-for-bots PR #316
>
> CI is RED on this OPEN bot-authored PR (completed failure, not in-progress).
> Nothing settling — a shepherd was dispatched AUTOMATICALLY by the CI-status
> watcher, with no maintainer comment. Map: **shepherd** → drive CI to green.
>
> PR: https://github.com/endojs/endo-but-for-bots/pull/316
> Head: endojs/endo-but-for-bots (bot-pushable)
>
> Read the failing checks and drive them green (see roles/shepherd/AGENT.md).
> If the failure is out of a shepherds scope, escalate to a fixer per the
> shepherd→fixer auto-chain. Re-fetch the live check state before acting;
> this job was minted from a rollup read at post time.

- `20260702T012855Z-7a9f42` — from reaper:endolinbot, reply_to `?` · [open message](https://github.com/kriskowal/garden/blob/journal2/inbox/maintainer/unread/20260702T012855Z-7a9f42.md)

> POISON job dropped from the board after 5 requeue cycles on endolinbot.
> Its handler appears to fail every time; the reaper stopped requeueing it.
> Original job base: endojs-endo-but-for-bots-pr324-shepherd
>
> --- original job body ---
> # shepherd (auto: red CI) on endojs/endo-but-for-bots PR #324
>
> CI is RED on this OPEN bot-authored PR (completed failure, not in-progress).
> Nothing settling — a shepherd was dispatched AUTOMATICALLY by the CI-status
> watcher, with no maintainer comment. Map: **shepherd** → drive CI to green.
>
> PR: https://github.com/endojs/endo-but-for-bots/pull/324
> Head: endojs/endo-but-for-bots (bot-pushable)
>
> Read the failing checks and drive them green (see roles/shepherd/AGENT.md).
> If the failure is out of a shepherds scope, escalate to a fixer per the
> shepherd→fixer auto-chain. Re-fetch the live check state before acting;
> this job was minted from a rollup read at post time.

- `20260702T012907Z-d55d3c` — from reaper:endolinbot, reply_to `?` · [open message](https://github.com/kriskowal/garden/blob/journal2/inbox/maintainer/unread/20260702T012907Z-d55d3c.md)

> POISON job dropped from the board after 5 requeue cycles on endolinbot.
> Its handler appears to fail every time; the reaper stopped requeueing it.
> Original job base: endojs-endo-but-for-bots-pr335-shepherd
>
> --- original job body ---
> # shepherd (auto: red CI) on endojs/endo-but-for-bots PR #335
>
> CI is RED on this OPEN bot-authored PR (completed failure, not in-progress).
> Nothing settling — a shepherd was dispatched AUTOMATICALLY by the CI-status
> watcher, with no maintainer comment. Map: **shepherd** → drive CI to green.
>
> PR: https://github.com/endojs/endo-but-for-bots/pull/335
> Head: endojs/endo-but-for-bots (bot-pushable)
>
> Read the failing checks and drive them green (see roles/shepherd/AGENT.md).
> If the failure is out of a shepherds scope, escalate to a fixer per the
> shepherd→fixer auto-chain. Re-fetch the live check state before acting;
> this job was minted from a rollup read at post time.

- `20260702T012917Z-4610be` — from reaper:endolinbot, reply_to `?` · [open message](https://github.com/kriskowal/garden/blob/journal2/inbox/maintainer/unread/20260702T012917Z-4610be.md)

> POISON job dropped from the board after 5 requeue cycles on endolinbot.
> Its handler appears to fail every time; the reaper stopped requeueing it.
> Original job base: endojs-endo-but-for-bots-pr393-shepherd
>
> --- original job body ---
> # shepherd (auto: red CI) on endojs/endo-but-for-bots PR #393
>
> CI is RED on this OPEN bot-authored PR (completed failure, not in-progress).
> Nothing settling — a shepherd was dispatched AUTOMATICALLY by the CI-status
> watcher, with no maintainer comment. Map: **shepherd** → drive CI to green.
>
> PR: https://github.com/endojs/endo-but-for-bots/pull/393
> Head: endojs/endo-but-for-bots (bot-pushable)
>
> Read the failing checks and drive them green (see roles/shepherd/AGENT.md).
> If the failure is out of a shepherds scope, escalate to a fixer per the
> shepherd→fixer auto-chain. Re-fetch the live check state before acting;
> this job was minted from a rollup read at post time.

- `20260702T012925Z-9e0993` — from reaper:endolinbot, reply_to `?` · [open message](https://github.com/kriskowal/garden/blob/journal2/inbox/maintainer/unread/20260702T012925Z-9e0993.md)

> POISON job dropped from the board after 5 requeue cycles on endolinbot.
> Its handler appears to fail every time; the reaper stopped requeueing it.
> Original job base: endojs-endo-but-for-bots-pr410-shepherd
>
> --- original job body ---
> # shepherd (auto: red CI) on endojs/endo-but-for-bots PR #410
>
> CI is RED on this OPEN bot-authored PR (completed failure, not in-progress).
> Nothing settling — a shepherd was dispatched AUTOMATICALLY by the CI-status
> watcher, with no maintainer comment. Map: **shepherd** → drive CI to green.
>
> PR: https://github.com/endojs/endo-but-for-bots/pull/410
> Head: endojs/endo-but-for-bots (bot-pushable)
>
> Read the failing checks and drive them green (see roles/shepherd/AGENT.md).
> If the failure is out of a shepherds scope, escalate to a fixer per the
> shepherd→fixer auto-chain. Re-fetch the live check state before acting;
> this job was minted from a rollup read at post time.

- `20260702T012931Z-157f88` — from reaper:endolinbot, reply_to `?` · [open message](https://github.com/kriskowal/garden/blob/journal2/inbox/maintainer/unread/20260702T012931Z-157f88.md)

> POISON job dropped from the board after 5 requeue cycles on endolinbot.
> Its handler appears to fail every time; the reaper stopped requeueing it.
> Original job base: endojs-endo-but-for-bots-pr420-shepherd
>
> --- original job body ---
> # shepherd (auto: red CI) on endojs/endo-but-for-bots PR #420
>
> CI is RED on this OPEN bot-authored PR (completed failure, not in-progress).
> Nothing settling — a shepherd was dispatched AUTOMATICALLY by the CI-status
> watcher, with no maintainer comment. Map: **shepherd** → drive CI to green.
>
> PR: https://github.com/endojs/endo-but-for-bots/pull/420
> Head: endojs/endo-but-for-bots (bot-pushable)
>
> Read the failing checks and drive them green (see roles/shepherd/AGENT.md).
> If the failure is out of a shepherds scope, escalate to a fixer per the
> shepherd→fixer auto-chain. Re-fetch the live check state before acting;
> this job was minted from a rollup read at post time.

- `20260702T012936Z-bf40b8` — from reaper:endolinbot, reply_to `?` · [open message](https://github.com/kriskowal/garden/blob/journal2/inbox/maintainer/unread/20260702T012936Z-bf40b8.md)

> POISON job dropped from the board after 5 requeue cycles on endolinbot.
> Its handler appears to fail every time; the reaper stopped requeueing it.
> Original job base: endojs-endo-but-for-bots-pr438-shepherd
>
> --- original job body ---
> # shepherd (auto: red CI) on endojs/endo-but-for-bots PR #438
>
> CI is RED on this OPEN bot-authored PR (completed failure, not in-progress).
> Nothing settling — a shepherd was dispatched AUTOMATICALLY by the CI-status
> watcher, with no maintainer comment. Map: **shepherd** → drive CI to green.
>
> PR: https://github.com/endojs/endo-but-for-bots/pull/438
> Head: endojs/endo-but-for-bots (bot-pushable)
>
> Read the failing checks and drive them green (see roles/shepherd/AGENT.md).
> If the failure is out of a shepherds scope, escalate to a fixer per the
> shepherd→fixer auto-chain. Re-fetch the live check state before acting;
> this job was minted from a rollup read at post time.

- `20260702T012942Z-c33580` — from reaper:endolinbot, reply_to `?` · [open message](https://github.com/kriskowal/garden/blob/journal2/inbox/maintainer/unread/20260702T012942Z-c33580.md)

> POISON job dropped from the board after 5 requeue cycles on endolinbot.
> Its handler appears to fail every time; the reaper stopped requeueing it.
> Original job base: endojs-endo-but-for-bots-pr475-shepherd
>
> --- original job body ---
> # shepherd (auto: red CI) on endojs/endo-but-for-bots PR #475
>
> CI is RED on this OPEN bot-authored PR (completed failure, not in-progress).
> Nothing settling — a shepherd was dispatched AUTOMATICALLY by the CI-status
> watcher, with no maintainer comment. Map: **shepherd** → drive CI to green.
>
> PR: https://github.com/endojs/endo-but-for-bots/pull/475
> Head: endojs/endo-but-for-bots (bot-pushable)
>
> Read the failing checks and drive them green (see roles/shepherd/AGENT.md).
> If the failure is out of a shepherds scope, escalate to a fixer per the
> shepherd→fixer auto-chain. Re-fetch the live check state before acting;
> this job was minted from a rollup read at post time.

- `20260702T013312Z-2d3d02` — from reaper:endolinbot, reply_to `?` · [open message](https://github.com/kriskowal/garden/blob/journal2/inbox/maintainer/unread/20260702T013312Z-2d3d02.md)

> POISON job dropped from the board after 5 requeue cycles on endolinbot.
> Its handler appears to fail every time; the reaper stopped requeueing it.
> Original job base: endojs-endo-but-for-bots-pr235-shepherd
>
> --- original job body ---
> # shepherd (auto: red CI) on endojs/endo-but-for-bots PR #235
>
> CI is RED on this OPEN bot-authored PR (completed failure, not in-progress).
> Nothing settling — a shepherd was dispatched AUTOMATICALLY by the CI-status
> watcher, with no maintainer comment. Map: **shepherd** → drive CI to green.
>
> PR: https://github.com/endojs/endo-but-for-bots/pull/235
> Head: endojs/endo-but-for-bots (bot-pushable)
>
> Read the failing checks and drive them green (see roles/shepherd/AGENT.md).
> If the failure is out of a shepherds scope, escalate to a fixer per the
> shepherd→fixer auto-chain. Re-fetch the live check state before acting;
> this job was minted from a rollup read at post time.

- `20260702T013458Z-00d834` — from reaper:endolinbot, reply_to `?` · [open message](https://github.com/kriskowal/garden/blob/journal2/inbox/maintainer/unread/20260702T013458Z-00d834.md)

> POISON job dropped from the board after 5 requeue cycles on endolinbot.
> Its handler appears to fail every time; the reaper stopped requeueing it.
> Original job base: endojs-endo-but-for-bots-pr242-shepherd
>
> --- original job body ---
> # shepherd (auto: red CI) on endojs/endo-but-for-bots PR #242
>
> CI is RED on this OPEN bot-authored PR (completed failure, not in-progress).
> Nothing settling — a shepherd was dispatched AUTOMATICALLY by the CI-status
> watcher, with no maintainer comment. Map: **shepherd** → drive CI to green.
>
> PR: https://github.com/endojs/endo-but-for-bots/pull/242
> Head: endojs/endo-but-for-bots (bot-pushable)
>
> Read the failing checks and drive them green (see roles/shepherd/AGENT.md).
> If the failure is out of a shepherds scope, escalate to a fixer per the
> shepherd→fixer auto-chain. Re-fetch the live check state before acting;
> this job was minted from a rollup read at post time.

- `20260702T013605Z-da85aa` — from reaper:endolinbot, reply_to `?` · [open message](https://github.com/kriskowal/garden/blob/journal2/inbox/maintainer/unread/20260702T013605Z-da85aa.md)

> POISON job dropped from the board after 5 requeue cycles on endolinbot.
> Its handler appears to fail every time; the reaper stopped requeueing it.
> Original job base: endojs-endo-but-for-bots-pr318-shepherd
>
> --- original job body ---
> # shepherd (auto: red CI) on endojs/endo-but-for-bots PR #318
>
> CI is RED on this OPEN bot-authored PR (completed failure, not in-progress).
> Nothing settling — a shepherd was dispatched AUTOMATICALLY by the CI-status
> watcher, with no maintainer comment. Map: **shepherd** → drive CI to green.
>
> PR: https://github.com/endojs/endo-but-for-bots/pull/318
> Head: endojs/endo-but-for-bots (bot-pushable)
>
> Read the failing checks and drive them green (see roles/shepherd/AGENT.md).
> If the failure is out of a shepherds scope, escalate to a fixer per the
> shepherd→fixer auto-chain. Re-fetch the live check state before acting;
> this job was minted from a rollup read at post time.

- `20260702T013702Z-8ec35c` — from reaper:endolinbot, reply_to `?` · [open message](https://github.com/kriskowal/garden/blob/journal2/inbox/maintainer/unread/20260702T013702Z-8ec35c.md)

> POISON job dropped from the board after 5 requeue cycles on endolinbot.
> Its handler appears to fail every time; the reaper stopped requeueing it.
> Original job base: endojs-endo-but-for-bots-pr320-shepherd
>
> --- original job body ---
> # shepherd (auto: red CI) on endojs/endo-but-for-bots PR #320
>
> CI is RED on this OPEN bot-authored PR (completed failure, not in-progress).
> Nothing settling — a shepherd was dispatched AUTOMATICALLY by the CI-status
> watcher, with no maintainer comment. Map: **shepherd** → drive CI to green.
>
> PR: https://github.com/endojs/endo-but-for-bots/pull/320
> Head: endojs/endo-but-for-bots (bot-pushable)
>
> Read the failing checks and drive them green (see roles/shepherd/AGENT.md).
> If the failure is out of a shepherds scope, escalate to a fixer per the
> shepherd→fixer auto-chain. Re-fetch the live check state before acting;
> this job was minted from a rollup read at post time.

- `20260702T013712Z-ef2d48` — from reaper:endolinbot, reply_to `?` · [open message](https://github.com/kriskowal/garden/blob/journal2/inbox/maintainer/unread/20260702T013712Z-ef2d48.md)

> POISON job dropped from the board after 5 requeue cycles on endolinbot.
> Its handler appears to fail every time; the reaper stopped requeueing it.
> Original job base: endojs-endo-but-for-bots-pr337-shepherd
>
> --- original job body ---
> # shepherd (auto: red CI) on endojs/endo-but-for-bots PR #337
>
> CI is RED on this OPEN bot-authored PR (completed failure, not in-progress).
> Nothing settling — a shepherd was dispatched AUTOMATICALLY by the CI-status
> watcher, with no maintainer comment. Map: **shepherd** → drive CI to green.
>
> PR: https://github.com/endojs/endo-but-for-bots/pull/337
> Head: endojs/endo-but-for-bots (bot-pushable)
>
> Read the failing checks and drive them green (see roles/shepherd/AGENT.md).
> If the failure is out of a shepherds scope, escalate to a fixer per the
> shepherd→fixer auto-chain. Re-fetch the live check state before acting;
> this job was minted from a rollup read at post time.

- `20260702T013717Z-8b8c5b` — from reaper:endolinbot, reply_to `?` · [open message](https://github.com/kriskowal/garden/blob/journal2/inbox/maintainer/unread/20260702T013717Z-8b8c5b.md)

> POISON job dropped from the board after 5 requeue cycles on endolinbot.
> Its handler appears to fail every time; the reaper stopped requeueing it.
> Original job base: endojs-endo-but-for-bots-pr377-shepherd
>
> --- original job body ---
> # shepherd (auto: red CI) on endojs/endo-but-for-bots PR #377
>
> CI is RED on this OPEN bot-authored PR (completed failure, not in-progress).
> Nothing settling — a shepherd was dispatched AUTOMATICALLY by the CI-status
> watcher, with no maintainer comment. Map: **shepherd** → drive CI to green.
>
> PR: https://github.com/endojs/endo-but-for-bots/pull/377
> Head: endojs/endo-but-for-bots (bot-pushable)
>
> Read the failing checks and drive them green (see roles/shepherd/AGENT.md).
> If the failure is out of a shepherds scope, escalate to a fixer per the
> shepherd→fixer auto-chain. Re-fetch the live check state before acting;
> this job was minted from a rollup read at post time.

- `20260702T013722Z-118a53` — from reaper:endolinbot, reply_to `?` · [open message](https://github.com/kriskowal/garden/blob/journal2/inbox/maintainer/unread/20260702T013722Z-118a53.md)

> POISON job dropped from the board after 5 requeue cycles on endolinbot.
> Its handler appears to fail every time; the reaper stopped requeueing it.
> Original job base: endojs-endo-but-for-bots-pr541-shepherd
>
> --- original job body ---
> # shepherd (auto: red CI) on endojs/endo-but-for-bots PR #541
>
> CI is RED on this OPEN bot-authored PR (completed failure, not in-progress).
> Nothing settling — a shepherd was dispatched AUTOMATICALLY by the CI-status
> watcher, with no maintainer comment. Map: **shepherd** → drive CI to green.
>
> PR: https://github.com/endojs/endo-but-for-bots/pull/541
> Head: endojs/endo-but-for-bots (bot-pushable)
>
> Read the failing checks and drive them green (see roles/shepherd/AGENT.md).
> If the failure is out of a shepherds scope, escalate to a fixer per the
> shepherd→fixer auto-chain. Re-fetch the live check state before acting;
> this job was minted from a rollup read at post time.

- `20260702T013727Z-09df6e` — from reaper:endolinbot, reply_to `?` · [open message](https://github.com/kriskowal/garden/blob/journal2/inbox/maintainer/unread/20260702T013727Z-09df6e.md)

> POISON job dropped from the board after 5 requeue cycles on endolinbot.
> Its handler appears to fail every time; the reaper stopped requeueing it.
> Original job base: endojs-endo-but-for-bots-pr585-shepherd
>
> --- original job body ---
> # shepherd (auto: red CI) on endojs/endo-but-for-bots PR #585
>
> CI is RED on this OPEN bot-authored PR (completed failure, not in-progress).
> Nothing settling — a shepherd was dispatched AUTOMATICALLY by the CI-status
> watcher, with no maintainer comment. Map: **shepherd** → drive CI to green.
>
> PR: https://github.com/endojs/endo-but-for-bots/pull/585
> Head: endojs/endo-but-for-bots (bot-pushable)
>
> Read the failing checks and drive them green (see roles/shepherd/AGENT.md).
> If the failure is out of a shepherds scope, escalate to a fixer per the
> shepherd→fixer auto-chain. Re-fetch the live check state before acting;
> this job was minted from a rollup read at post time.

- `20260702T013734Z-7f0d42` — from reaper:endolinbot, reply_to `?` · [open message](https://github.com/kriskowal/garden/blob/journal2/inbox/maintainer/unread/20260702T013734Z-7f0d42.md)

> POISON job dropped from the board after 5 requeue cycles on endolinbot.
> Its handler appears to fail every time; the reaper stopped requeueing it.
> Original job base: endojs-endo-but-for-bots-pr590-shepherd
>
> --- original job body ---
> # shepherd (auto: red CI) on endojs/endo-but-for-bots PR #590
>
> CI is RED on this OPEN bot-authored PR (completed failure, not in-progress).
> Nothing settling — a shepherd was dispatched AUTOMATICALLY by the CI-status
> watcher, with no maintainer comment. Map: **shepherd** → drive CI to green.
>
> PR: https://github.com/endojs/endo-but-for-bots/pull/590
> Head: endojs/endo-but-for-bots (bot-pushable)
>
> Read the failing checks and drive them green (see roles/shepherd/AGENT.md).
> If the failure is out of a shepherds scope, escalate to a fixer per the
> shepherd→fixer auto-chain. Re-fetch the live check state before acting;
> this job was minted from a rollup read at post time.

- `20260702T013740Z-0d858b` — from reaper:endolinbot, reply_to `?` · [open message](https://github.com/kriskowal/garden/blob/journal2/inbox/maintainer/unread/20260702T013740Z-0d858b.md)

> POISON job dropped from the board after 5 requeue cycles on endolinbot.
> Its handler appears to fail every time; the reaper stopped requeueing it.
> Original job base: endojs-endo-but-for-bots-pr60-shepherd
>
> --- original job body ---
> # shepherd (auto: red CI) on endojs/endo-but-for-bots PR #60
>
> CI is RED on this OPEN bot-authored PR (completed failure, not in-progress).
> Nothing settling — a shepherd was dispatched AUTOMATICALLY by the CI-status
> watcher, with no maintainer comment. Map: **shepherd** → drive CI to green.
>
> PR: https://github.com/endojs/endo-but-for-bots/pull/60
> Head: endojs/endo-but-for-bots (bot-pushable)
>
> Read the failing checks and drive them green (see roles/shepherd/AGENT.md).
> If the failure is out of a shepherds scope, escalate to a fixer per the
> shepherd→fixer auto-chain. Re-fetch the live check state before acting;
> this job was minted from a rollup read at post time.

- `20260702T014311Z-476a78` — from reaper:endolinbot, reply_to `?` · [open message](https://github.com/kriskowal/garden/blob/journal2/inbox/maintainer/unread/20260702T014311Z-476a78.md)

> POISON job dropped from the board after 5 requeue cycles on endolinbot.
> Its handler appears to fail every time; the reaper stopped requeueing it.
> Original job base: endojs-endo-but-for-bots-pr101-weaver
>
> --- original job body ---
> # weaver (rebase stale base) on endojs/endo-but-for-bots PR #101
>
> Escalated from the shepherd auto-job `endojs-endo-but-for-bots-pr101-shepherd`.
>
> PR: https://github.com/endojs/endo-but-for-bots/pull/101
> Head: feat/chat-voice-input (endojs/endo-but-for-bots, bot-pushable)
> Base: llm
>
> ## Why weaver, not shepherd
>
> CI is red on four checks — `cover (20.x)`, `cover (24.x)`, `lint`, `zizmor` —
> but NONE are in this PR's own diff (PR touches only `packages/chat/*` and
> `designs/*`):
>
> - **lint** — 1 error: `makeClient not found in '../src/client/index.js'
>   import/named` in `packages/ocapn/test/netlayer-tcp-syrup.test.js`. On the
>   current `llm` tip that import is already `makeOcapn` (the export's real name);
>   the PR head still carries the pre-rename `makeClient`.
> - **cover (20.x/24.x)** — same file: `test/netlayer-tcp-syrup.test.js exited
>   with a non-zero exit code: 1` in `@endo/ocapn`. Same stale-import root cause.
> - **zizmor** — errors in `.github/workflows/familiar-release.yml` and `ci.yml`
>   (overly-broad perms, template-expansion injection, cache-poisoning). Workflow
>   files this PR never touches; fixed on current `llm`.
>
> The PR is **966 commits behind** its `llm` base and `mergeable_state == "dirty"`
> (`mergeable: CONFLICTING`), so `pull_request` workflows are not dispatching on
> the synthetic merge ref and every red check is a stale-base artifact. The `llm`
> base branch's own latest CI is **green**. Rebasing/merging the PR onto current
> `llm` clears all four failures; it is not a shepherd task (per
> roles/shepherd/AGENT.md § Conflicting PRs block CI dispatch).
>
> ## Task
>
> Rebase/update PR #101 onto current `llm`, resolving conflicts (see
> skills/conflict-resolution and skills/rebase-before-followup). The PR's own
> substance is the chat voice-input feature (its own tests pass). After the
> update, verify CI converges to green; if new in-scope failures surface, chain a
> shepherd.
>
> next: weaver

- `20260702T014344Z-23cdcb` — from reaper:endolinbot, reply_to `?` · [open message](https://github.com/kriskowal/garden/blob/journal2/inbox/maintainer/unread/20260702T014344Z-23cdcb.md)

> POISON job dropped from the board after 5 requeue cycles on endolinbot.
> Its handler appears to fail every time; the reaper stopped requeueing it.
> Original job base: endojs-endo-but-for-bots-pr216-weave
>
> --- original job body ---
> # weave (rebase) endojs/endo-but-for-bots PR #216 onto base `llm`
>
> PR #216 (`feat/endor-tui-bot` → `llm`, author kriscendobot) is CONFLICTING
> (`mergeable_state: dirty`), so GitHub is not dispatching `pull_request`
> workflows on new pushes — `statusCheckRollup` is stale and CI cannot go
> green until the conflict is resolved. Handed off by the PR #216 shepherd.
>
> ## Diagnosis
> - Base `llm` is ~1196 commits ahead of the PR's merge-base; the PR is only
>   3 commits ahead.
> - Exactly ONE textual conflict: `designs/README.md` (the design-index
>   table). `yarn.lock` auto-merges. All the PR's other 14 files (the new
>   `packages/tui`, `packages/tui-xs`, `rust/endo/src/bin/endor.rs`, etc.)
>   are net-new and do not conflict.
> - The `designs/README.md` conflict is semantic: `llm` has marked many
>   designs Complete and added new rows (patterns-diagnostic-feedback,
>   cli-http-client). The PR's own edit sets the `endor-bus-tui` row to
>   `In Progress` (updated 2026-05-11), while `llm` has it as `Not Started`
>   (2026-04-23). Resolution: take `llm`'s table wholesale, then re-apply the
>   PR's `endor-bus-tui` status change (In Progress + its updated date) on
>   top so the PR's intent survives.
>
> ## Ask
> Rebase `feat/endor-tui-bot` onto current `origin/llm`, resolving the
> `designs/README.md` table conflict per above, and force-push-with-lease.
> Because `llm` moved ~1196 commits, run a rebase-hygiene / net-diff audit:
> confirm the new tui packages still align with any convention changes on
> `llm`, and that the net diff is only the intended TUI feature. After the
> push, CI should dispatch; the shepherd's prettier fix (commit b99b99738,
> `packages/tui/src/tui.types.d.ts`) is already on the branch and clears the
> prior red `lint` check. Verify CI reaches green (or re-hand-off to shepherd
> if a fresh red surfaces post-rebase).

- `20260702T014430Z-119bf4` — from reaper:endolinbot, reply_to `?` · [open message](https://github.com/kriskowal/garden/blob/journal2/inbox/maintainer/unread/20260702T014430Z-119bf4.md)

> POISON job dropped from the board after 5 requeue cycles on endolinbot.
> Its handler appears to fail every time; the reaper stopped requeueing it.
> Original job base: endojs-endo-but-for-bots-pr306-weaver
>
> --- original job body ---
> # weaver (rebase/conflict-resolution) on endojs/endo-but-for-bots PR #306
>
> PR: https://github.com/endojs/endo-but-for-bots/pull/306
> Head: endojs/endo-but-for-bots `feat/daemon-capability-persona` (bot-pushable)
> Base: endojs/endo-but-for-bots `master`
>
> ## Why this job exists
>
> A shepherd (job `endojs-endo-but-for-bots-pr306-shepherd`) was dispatched on red
> CI. The red check was a genuine Prettier failure on
> `packages/daemon/src/interfaces.js` (prettier 3.8.3 collapses a single-arg
> `.returns(M.boolean())` onto one line). **That fix is already committed and
> pushed** to the head branch at `1f077992b` — CI lint will pass once it can run.
>
> But the shepherd discovered the PR is **CONFLICTING**
> (`mergeable: false, mergeable_state: dirty`), so GitHub cannot build the
> `pull_request` merge ref and **dispatches NO CI run** on new pushes — the lint
> fix cannot be verified green until the conflict is resolved.
>
> ## Scope
>
> The branch is **253 commits behind `master` and 929 ahead**. A trial
> `git merge --no-commit origin/master` auto-resolved many files via `rerere` but
> still failed with conflicts spanning `packages/ocapn/*`,
> `packages/compartment-mapper/*`, `packages/daemon/*`, and several package.json /
> workflow files. This is a substantial rebase requiring porting judgment — beyond
> a shepherd's scope (`next: weaver`).
>
> ## Ask
>
> Rebase / conflict-resolve `feat/daemon-capability-persona` onto current
> `endojs/endo-but-for-bots` master (see `skills/conflict-resolution` and
> `skills/rebase-hygiene-audit`), preserving the lint fix at `1f077992b`. Push the
> resolved head. Once mergeable, CI will dispatch; the lint fix should carry it
> green. If CI surfaces new failures after the rebase, chain a shepherd.

- `20260702T014437Z-5a52e2` — from reaper:endolinbot, reply_to `?` · [open message](https://github.com/kriskowal/garden/blob/journal2/inbox/maintainer/unread/20260702T014437Z-5a52e2.md)

> POISON job dropped from the board after 5 requeue cycles on endolinbot.
> Its handler appears to fail every time; the reaper stopped requeueing it.
> Original job base: endojs-endo-but-for-bots-pr394-fixer
>
> --- original job body ---
> # fixer (shepherd escalation) on endojs/endo-but-for-bots PR #394
>
> A shepherd (auto-dispatched on red CI) drove the deterministic failure green and
> escalates the remaining test/cover failures per the shepherd->fixer auto-chain.
> `next: fixer` — the failures are real (not flakes) and rooted in the branch's own
> diff (ancestor design-stack phases), but need Node-20 AND Node-22/24 reproduction
> plus core-library (ses/init) context beyond a shepherd's surgical remit.
>
> PR: https://github.com/endojs/endo-but-for-bots/pull/394
> Head branch: design/gateway-package-phase-6  (bot-pushable)
> Head SHA at escalation: 3952dd2fd (shepherd's lint fix already landed)
>
> ## Already fixed by the shepherd (landed)
> - **lint** was red on `scripts/check-security-md.sh`: packages bytes, gateway, hex
>   carried the stale "Github" SECURITY.md variant while the branch majority
>   (canonical) is the "GitHub" variant. Synced all three to canonical
>   (commit 3952dd2fd). `bash scripts/check-security-md.sh` now exits 0 locally.
>   This should turn `lint` green on the next run.
>
> ## Remaining failures (need a fixer)
>
> Two DISTINCT, Node-version-specific failure families. Note master's "CI" workflow
> is GREEN with the same ava@8.0.1 + emittery@2.0.0 and the same packages, so these
> are branch-introduced, not upstream drift.
>
> ### 1. Node 20: `results.values(...).filter is not a function` (panic)
> - Jobs: `test (20.x, *)`, `cover (20.x, *)`.
> - Package: `@endo/panic` test crashes. Error is in emittery@2.0.0 index.js:780
>   `...values(...).filter(result => result.status === 'rejected')` — an **iterator
>   helper** (Iterator.prototype.filter) absent on Node 20. emittery only reaches
>   this path when a listener rejects, i.e. when a test **errors**, so a real error
>   in the panic run on Node 20 is being masked by the emittery crash.
> - Root cause hypothesis: this branch ADDED 4 tests to
>   `packages/panic/test/index.test.js` (+49 lines vs master): "panic using
>   globalThis.panic (XS fallback)", "panic without console.error" (sets
>   `globalThis.console = undefined`), and edits to "panic last resort". One of
>   these errors on Node 20 specifically (they pass on Node 22 — the 22.x job fails
>   elsewhere). Panic passes on master (which lacks these tests).
> - What the shepherd tried: read panic/index.js (logic is version-agnostic and
>   looks correct); could not reproduce — only Node 22 is available locally.
> - Suggested fix direction: reproduce on Node 20; find which added test throws
>   uncaught; fix the test (do NOT delete it — safety guardrail). Separately,
>   emittery@2.0.0's iterator-helper use is a Node-20 landmine for ANY erroring
>   test — consider whether a resolution/ava-version alignment is warranted (but
>   master uses the same, so prefer fixing the erroring test first).
>
> ### 2. Node 22/24: `AssertionError [ERR_ASSERTION]: null == true` at MODULE LOAD
> - Jobs: `test (22.x, *)`, `test (24.x, *)`, `cover (24.x, *)` (and cover 20.x is
>   the panic crash above).
> - SYSTEMIC across many ses-ava test files, thrown at import time (before tests
>   run), so each file reports "Uncaught exception ... exited with a non-zero exit
>   code: 1". Confirmed files: `packages/zip/test/zip.test.js`,
>   `packages/compartment-mapper/test/{hardened-module-source,module-source,
>   preserve-format}.test.js`, `packages/promise-kit/test/promise-kit.test.js`.
> - Pattern: `assert(<nativeFeatureDetection> == true)` (Node `node:assert`)
>   evaluating false on Node 22/24 but true on Node 20 — a top-level feature/ponyfill
>   detection in a shared src module (candidates: an immutable-arraybuffer /
>   ArrayBuffer.prototype.transfer / structuredClone-style detection, or ses/init
>   layer) that regressed for newer Node. The stack line was redacted by the
>   ses-ava reporter; needs a local Node 22/24 run to surface the throwing file:line.
> - The zip package also got a large rewrite on this branch (733 insertions:
>   deflate/inflate added, format-reader/writer rewritten, +binary fixture) — its
>   module-load failure may be its own detection code rather than the shared one;
>   triage both.
> - What the shepherd tried: grepped zip src (no top-level assert there); confirmed
>   the failure is at module evaluation, systemic, and Node-22+-only.
>
> ## Definition of done for the fixer
> - `test` and `cover` green across the 20.x/22.x/24.x matrix (or a genuine
>   impasse surfaced with a concrete hand-off).
> - No test deletions / skips / `--no-verify` / disabled safety checks.
> - Each fix an atomic commit on the PR's own head (design/gateway-package-phase-6),
>   bot identity.

- `20260702T014443Z-aec460` — from reaper:endolinbot, reply_to `?` · [open message](https://github.com/kriskowal/garden/blob/journal2/inbox/maintainer/unread/20260702T014443Z-aec460.md)

> POISON job dropped from the board after 5 requeue cycles on endolinbot.
> Its handler appears to fail every time; the reaper stopped requeueing it.
> Original job base: endojs-endo-but-for-bots-pr593-shepherd
>
> --- original job body ---
> # shepherd (auto: red CI) on endojs/endo-but-for-bots PR #593
>
> CI is RED on this OPEN bot-authored PR (completed failure, not in-progress).
> Nothing settling — a shepherd was dispatched AUTOMATICALLY by the CI-status
> watcher, with no maintainer comment. Map: **shepherd** → drive CI to green.
>
> PR: https://github.com/endojs/endo-but-for-bots/pull/593
> Head: endojs/endo-but-for-bots (bot-pushable)
>
> Read the failing checks and drive them green (see roles/shepherd/AGENT.md).
> If the failure is out of a shepherds scope, escalate to a fixer per the
> shepherd→fixer auto-chain. Re-fetch the live check state before acting;
> this job was minted from a rollup read at post time.

- `20260702T014448Z-6061bb` — from reaper:endolinbot, reply_to `?` · [open message](https://github.com/kriskowal/garden/blob/journal2/inbox/maintainer/unread/20260702T014448Z-6061bb.md)

> POISON job dropped from the board after 5 requeue cycles on endolinbot.
> Its handler appears to fail every time; the reaper stopped requeueing it.
> Original job base: endojs-endo-but-for-bots-pr79-shepherd
>
> --- original job body ---
> # shepherd (auto: red CI) on endojs/endo-but-for-bots PR #79
>
> CI is RED on this OPEN bot-authored PR (completed failure, not in-progress).
> Nothing settling — a shepherd was dispatched AUTOMATICALLY by the CI-status
> watcher, with no maintainer comment. Map: **shepherd** → drive CI to green.
>
> PR: https://github.com/endojs/endo-but-for-bots/pull/79
> Head: endojs/endo-but-for-bots (bot-pushable)
>
> Read the failing checks and drive them green (see roles/shepherd/AGENT.md).
> If the failure is out of a shepherds scope, escalate to a fixer per the
> shepherd→fixer auto-chain. Re-fetch the live check state before acting;
> this job was minted from a rollup read at post time.

- `20260702T014501Z-6263c8` — from reaper:endolinbot, reply_to `?` · [open message](https://github.com/kriskowal/garden/blob/journal2/inbox/maintainer/unread/20260702T014501Z-6263c8.md)

> POISON job dropped from the board after 5 requeue cycles on endolinbot.
> Its handler appears to fail every time; the reaper stopped requeueing it.
> Original job base: endojs-endo-but-for-bots-pr96-shepherd
>
> --- original job body ---
> # shepherd (auto: red CI) on endojs/endo-but-for-bots PR #96
>
> CI is RED on this OPEN bot-authored PR (completed failure, not in-progress).
> Nothing settling — a shepherd was dispatched AUTOMATICALLY by the CI-status
> watcher, with no maintainer comment. Map: **shepherd** → drive CI to green.
>
> PR: https://github.com/endojs/endo-but-for-bots/pull/96
> Head: endojs/endo-but-for-bots (bot-pushable)
>
> Read the failing checks and drive them green (see roles/shepherd/AGENT.md).
> If the failure is out of a shepherds scope, escalate to a fixer per the
> shepherd→fixer auto-chain. Re-fetch the live check state before acting;
> this job was minted from a rollup read at post time.

- `20260702T014512Z-d6ba94` — from reaper:endolinbot, reply_to `?` · [open message](https://github.com/kriskowal/garden/blob/journal2/inbox/maintainer/unread/20260702T014512Z-d6ba94.md)

> POISON job dropped from the board after 5 requeue cycles on endolinbot.
> Its handler appears to fail every time; the reaper stopped requeueing it.
> Original job base: improve-garden-identity-drift-detector
>
> --- original job body ---
> Every new gardener entry in this window reports `host: endolinbot2`, but per the maintainer record this host is canonically `endolinbot` (the leader marker names `endolinbot`; the `GARDEN=endolinbot2` override was removed as drift on 2026-07-01 precisely because it breaks every leader-only singleton's `is-main-host` ExecCondition). A silent `GARDEN` divergence corrupts per-host state (worker counts, claim metadata, journal index) and disables the leader gate for hours before anyone notices. `scripts/jobs/common.sh` defaults `GARDEN` to `hostname -s` but never checks for divergence. Add a deterministic drift guard (in `common.sh` or a preflight run each `gardener-scaler.sh` tick): when `$GARDEN` != `hostname -s` AND the host is not explicitly configured as a parallel pool, emit ONE loud `kind:error` journal entry (and, on the leader path, surface that `is-main-host` will fail) so a regression of the endolinbot2 override surfaces on the first tick instead of silently mislabeling 100 gardeners.

- `20260702T014520Z-33796e` — from reaper:endolinbot, reply_to `?` · [open message](https://github.com/kriskowal/garden/blob/journal2/inbox/maintainer/unread/20260702T014520Z-33796e.md)

> POISON job dropped from the board after 5 requeue cycles on endolinbot.
> Its handler appears to fail every time; the reaper stopped requeueing it.
> Original job base: improve-gardener-transient-failure-backoff-and-fleet-brake
>
> --- original job body ---
> `scripts/jobs/gardener.sh`: on a correlated Claude quota/API outage, all ~100 gardeners thrash — 50+ entries in ~15 min show shepherd handlers failing transiently (rc=1 / exit-0-unsatisfying, the message literally names "claude quota/usage cut"), all requeuing and immediately re-claiming. The loop's `idle_backoff` is applied ONLY on empty-claim and offline-completion paths; both transient-failure branches (the `elif [ "$hrc" -eq 0 ]` exit-0-unsatisfying branch ~line 318 and the non-zero transient branch that ends at `done` line 604) fall straight back to the claim head with zero delay. Result: the fleet re-runs the same jobs against an already-exhausted quota, amplifying the outage and churning todo↔doin. Add (a) a per-worker exponential+jittered backoff after any transient-classified handler failure (reuse `idle_backoff`/`idle_attempt` so a just-failed worker does not instantly re-claim), and (b) a shared fleet brake: when the recent transient-failure density crosses a threshold (a rolling count in `$GARDEN_STATE`, written by any gardener on a transient failure), gardeners pause claiming for a backoff window so a quota storm drains instead of being fed. Keep the reaper as the sole requeue owner; this changes only claim cadence, not board ownership.

- `20260702T014525Z-4f7dc2` — from reaper:endolinbot, reply_to `?` · [open message](https://github.com/kriskowal/garden/blob/journal2/inbox/maintainer/unread/20260702T014525Z-4f7dc2.md)

> POISON job dropped from the board after 5 requeue cycles on endolinbot.
> Its handler appears to fail every time; the reaper stopped requeueing it.
> Original job base: improve-issue-inbox-child-git-reaping
>
> --- original job body ---
> `garden-issue-inbox.service` logs `Found left-over process (git) in control group while starting unit ... indicates unclean termination of a previous run` (three orphan `git` PIDs at 00:36:21). `scripts/jobs/issue-inbox-watcher.sh` is leaving background git processes that outlive the unit, so the next start inherits stragglers. Make the handler `wait` on (or explicitly kill) every git child before exiting, and/or set `KillMode=mixed` + a bounded `TimeoutStopSec` on the unit in `scripts/systemd/` so the control group is reaped cleanly on stop/restart. Prevents orphan-git accumulation across restarts.

- `20260702T014531Z-015c4c` — from reaper:endolinbot, reply_to `?` · [open message](https://github.com/kriskowal/garden/blob/journal2/inbox/maintainer/unread/20260702T014531Z-015c4c.md)

> POISON job dropped from the board after 5 requeue cycles on endolinbot.
> Its handler appears to fail every time; the reaper stopped requeueing it.
> Original job base: improve-repo-watcher-arm-retry
>
> --- original job body ---
> `scripts/jobs/repo-watcher.sh` logs `WARN: could not arm garden-ci-watcher@endojs-endo-but-for-bots` and `@kriskowal-garden` on four consecutive ticks (00:23–00:27), meaning the templated ci-watcher units may never come up (and indeed the ci-watcher's own `#259 rollup unreadable` skips follow later). The arming failure is silently WARNed and retried only on the next full tick. Have `repo-watcher.sh` capture and log the underlying `systemctl --user` failure (rc + stderr) for the arm call rather than a bare WARN, and add a short bounded retry within the tick, so a transient `systemctl`/`XDG_RUNTIME_DIR` hiccup does not leave a watcher disarmed for a full cycle.

- `20260702T021309Z-97bfc7` — from reaper:endolinbot, reply_to `?` · [open message](https://github.com/kriskowal/garden/blob/journal2/inbox/maintainer/unread/20260702T021309Z-97bfc7.md)

> POISON job dropped from the board after 5 requeue cycles on endolinbot.
> Its handler appears to fail every time; the reaper stopped requeueing it.
> Original job base: endojs-endo-but-for-bots-pr393-shepherd
>
> --- original job body ---
> # shepherd (auto: red CI) on endojs/endo-but-for-bots PR #393
>
> CI is RED on this OPEN bot-authored PR (completed failure, not in-progress).
> Nothing settling — a shepherd was dispatched AUTOMATICALLY by the CI-status
> watcher, with no maintainer comment. Map: **shepherd** → drive CI to green.
>
> PR: https://github.com/endojs/endo-but-for-bots/pull/393
> Head: endojs/endo-but-for-bots (bot-pushable)
>
> Read the failing checks and drive them green (see roles/shepherd/AGENT.md).
> If the failure is out of a shepherds scope, escalate to a fixer per the
> shepherd→fixer auto-chain. Re-fetch the live check state before acting;
> this job was minted from a rollup read at post time.

- `20260702T021324Z-95912d` — from reaper:endolinbot, reply_to `?` · [open message](https://github.com/kriskowal/garden/blob/journal2/inbox/maintainer/unread/20260702T021324Z-95912d.md)

> POISON job dropped from the board after 5 requeue cycles on endolinbot.
> Its handler appears to fail every time; the reaper stopped requeueing it.
> Original job base: endojs-endo-but-for-bots-pr438-shepherd
>
> --- original job body ---
> # shepherd (auto: red CI) on endojs/endo-but-for-bots PR #438
>
> CI is RED on this OPEN bot-authored PR (completed failure, not in-progress).
> Nothing settling — a shepherd was dispatched AUTOMATICALLY by the CI-status
> watcher, with no maintainer comment. Map: **shepherd** → drive CI to green.
>
> PR: https://github.com/endojs/endo-but-for-bots/pull/438
> Head: endojs/endo-but-for-bots (bot-pushable)
>
> Read the failing checks and drive them green (see roles/shepherd/AGENT.md).
> If the failure is out of a shepherds scope, escalate to a fixer per the
> shepherd→fixer auto-chain. Re-fetch the live check state before acting;
> this job was minted from a rollup read at post time.

- `20260702T021358Z-3d3357` — from gardener:endojs-endo-but-for-bots-pr590-shepherd, reply_to `endojs-endo-but-for-bots-pr590-shepherd` · [open message](https://github.com/kriskowal/garden/blob/journal2/inbox/maintainer/unread/20260702T021358Z-3d3357.md)

> shepherd escalation — endojs/endo-but-for-bots PR #590 (job endojs-endo-but-for-bots-pr590-shepherd)
>
> next: liaison  (repo-wide lint-infra / structural decision — do NOT auto-advance to fixer on #590)
>
> CI red on #590 is a SINGLE failing check: root `lint` (`eslint .`). 9 parsing errors,
> all on alphabetically-last packages packages/where/** and packages/zip/**:
>   "Parsing error: ESLint was configured to run on <...>/packages/where/... using
>    parserOptions.project: ... none of those TSConfigs include this file."
>
> Diagnosis: the known typescript-eslint program/projectService SCALING CEILING, not
> #590's diff. Evidence:
>  - Deterministic across 2 lint re-runs (not a flake).
>  - where/zip are NOT in #590's 100-file diff; #590 touches no tsconfig/eslint config.
>  - base master@eecc68 whole-repo lint is GREEN; #590 (based on it) fails.
>  - Same identical where/zip tail-drop hit #581 yesterday (a totally different big
>    diff) — size-driven, matches reference_endo_lint_projectservice_scaling_ceiling.
>  - tsconfig.eslint-full.json globs **/*.js|ts (covers where/zip) — not a glob gap.
>
> Shepherd action taken: re-ran lint (still red, confirming determinism). Did NOT touch
> #590's branch — the fix is repo-wide lint-infra and must not be bundled into this
> refactor (changeset discipline + maintainer norm). Did NOT comment on the PR (job
> carried no comment authorization).
>
> Posted a dedicated lint-infra fix job: endo-but-for-bots-lint-projectservice-ceiling.
> Once that lands on master, #590 (and #581 if still open) go green on rebase — no
> further shepherd action possible on #590 until then.

- `20260702T022311Z-e16df0` — from reaper:endolinbot, reply_to `?` · [open message](https://github.com/kriskowal/garden/blob/journal2/inbox/maintainer/unread/20260702T022311Z-e16df0.md)

> POISON job dropped from the board after 5 requeue cycles on endolinbot.
> Its handler appears to fail every time; the reaper stopped requeueing it.
> Original job base: endojs-endo-but-for-bots-pr313-shepherd
>
> --- original job body ---
> # shepherd (auto: red CI) on endojs/endo-but-for-bots PR #313
>
> CI is RED on this OPEN bot-authored PR (completed failure, not in-progress).
> Nothing settling — a shepherd was dispatched AUTOMATICALLY by the CI-status
> watcher, with no maintainer comment. Map: **shepherd** → drive CI to green.
>
> PR: https://github.com/endojs/endo-but-for-bots/pull/313
> Head: endojs/endo-but-for-bots (bot-pushable)
>
> Read the failing checks and drive them green (see roles/shepherd/AGENT.md).
> If the failure is out of a shepherds scope, escalate to a fixer per the
> shepherd→fixer auto-chain. Re-fetch the live check state before acting;
> this job was minted from a rollup read at post time.

- `20260702T022316Z-e8d398` — from reaper:endolinbot, reply_to `?` · [open message](https://github.com/kriskowal/garden/blob/journal2/inbox/maintainer/unread/20260702T022316Z-e8d398.md)

> POISON job dropped from the board after 5 requeue cycles on endolinbot.
> Its handler appears to fail every time; the reaper stopped requeueing it.
> Original job base: endojs-endo-but-for-bots-pr316-shepherd
>
> --- original job body ---
> # shepherd (auto: red CI) on endojs/endo-but-for-bots PR #316
>
> CI is RED on this OPEN bot-authored PR (completed failure, not in-progress).
> Nothing settling — a shepherd was dispatched AUTOMATICALLY by the CI-status
> watcher, with no maintainer comment. Map: **shepherd** → drive CI to green.
>
> PR: https://github.com/endojs/endo-but-for-bots/pull/316
> Head: endojs/endo-but-for-bots (bot-pushable)
>
> Read the failing checks and drive them green (see roles/shepherd/AGENT.md).
> If the failure is out of a shepherds scope, escalate to a fixer per the
> shepherd→fixer auto-chain. Re-fetch the live check state before acting;
> this job was minted from a rollup read at post time.

- `20260702T023306Z-3640c6` — from reaper:endolinbot, reply_to `?` · [open message](https://github.com/kriskowal/garden/blob/journal2/inbox/maintainer/unread/20260702T023306Z-3640c6.md)

> POISON job dropped from the board after 5 requeue cycles on endolinbot.
> Its handler appears to fail every time; the reaper stopped requeueing it.
> Original job base: endojs-endo-but-for-bots-pr301-weave
>
> --- original job body ---
> # weave (rebase/conflict-resolve) on endojs/endo-but-for-bots PR #301
>
> CI is RED on this OPEN bot-authored PR, but the root blocker is a **merge
> conflict against the base branch `llm`**, not a tractable CI failure. A shepherd
> (job `endojs-endo-but-for-bots-pr301-shepherd`) diagnosed this and hands off:
> `mergeable_state == dirty` means GitHub does not create the merge ref and no
> `pull_request` workflow dispatches on new pushes, so no CI fix can be validated
> until the conflict is resolved. Map: **weaver** → rebase/conflict-resolve.
>
> PR: https://github.com/endojs/endo-but-for-bots/pull/301
> Head: endojs/endo-but-for-bots @ kriskowal-error-trace (7be08f41b, bot-pushable)
> Base: `llm` (e50be0b0c), merge-base 65d3093cc
>
> ## Conflict inventory (test-merge of head into origin/llm, 2026-07-02)
>
> 22 conflicting files. The significant driver: `llm` has restructured the chat
> package — `packages/chat/*` moved to `packages/spaces-util/src/*`. This PR edits
> `packages/chat/chat-bar-component.js` and `packages/chat/connection.js`, which now
> collide with `packages/spaces-util/src/chat-bar-component.js` on `llm`. Full
> conflicted set:
>
>   packages/captp/src/captp.js
>   packages/chat/connection.js, packages/chat/eval-form.js
>   packages/cli/src/commands/trace.js, context.js, endo.js
>   packages/cli/test/trace.test.js
>   packages/daemon/package.json
>   packages/daemon/src/{daemon-go-powers,daemon-node-powers,daemon,host,interfaces,serve-private-path,trace-aggregator,worker,ws-gateway}.js
>   packages/daemon/src/types.d.ts, packages/daemon/src/networks/libp2p.js
>   packages/daemon/test/{error-trace,trace-aggregator}.test.js
>   packages/spaces-util/src/chat-bar-component.js
>
> Resolve conflicts (respecting the chat→spaces-util move on `llm`), rebase/merge
> onto current `llm`, and push. Once the conflict clears, `pull_request` workflows
> will dispatch again; the CI-status watcher will auto-post a fresh shepherd if CI
> is still red.
>
> ## Standing note for the follow-on shepherd
>
> The last CI run at head 7be08f41b (before the branch conflicted) failed on the
> `@endo/cli#test` step: the `channel` test suite in the cli package hung and ava
> was killed by SIGINT (many `channel › ...` cases left pending). This may be
> pre-existing/flaky and may not survive the rebase (the chat/spaces-util
> restructure on `llm` is large). Re-diagnose against the post-rebase CI run;
> do not assume the channel-hang persists.

- `20260702T024308Z-ce2033` — from reaper:endolinbot, reply_to `?` · [open message](https://github.com/kriskowal/garden/blob/journal2/inbox/maintainer/unread/20260702T024308Z-ce2033.md)

> POISON job dropped from the board after 5 requeue cycles on endolinbot.
> Its handler appears to fail every time; the reaper stopped requeueing it.
> Original job base: endojs-endo-but-for-bots-pr591-shepherd
>
> --- original job body ---
> # shepherd (auto: red CI) on endojs/endo-but-for-bots PR #591
>
> CI is RED on this OPEN bot-authored PR (completed failure, not in-progress).
> Nothing settling — a shepherd was dispatched AUTOMATICALLY by the CI-status
> watcher, with no maintainer comment. Map: **shepherd** → drive CI to green.
>
> PR: https://github.com/endojs/endo-but-for-bots/pull/591
> Head: endojs/endo-but-for-bots (bot-pushable)
>
> Read the failing checks and drive them green (see roles/shepherd/AGENT.md).
> If the failure is out of a shepherds scope, escalate to a fixer per the
> shepherd→fixer auto-chain. Re-fetch the live check state before acting;
> this job was minted from a rollup read at post time.


## Board
### todo (0)
(none)

### doin (5)
- [`endo-but-for-bots-lint-projectservice-ceiling`](https://github.com/kriskowal/garden/blob/journal2/jobs/doin/endo-but-for-bots-lint-projectservice-ceiling.md) — fix lint-infra: typescript-eslint program scaling ceiling drops where/zip on ...
- [`endojs-endo-but-for-bots-pr242-shepherd`](https://github.com/kriskowal/garden/blob/journal2/jobs/doin/endojs-endo-but-for-bots-pr242-shepherd.md) — shepherd (auto: red CI) on endojs/endo-but-for-bots PR #242
- [`endojs-endo-but-for-bots-pr318-shepherd`](https://github.com/kriskowal/garden/blob/journal2/jobs/doin/endojs-endo-but-for-bots-pr318-shepherd.md) — shepherd (auto: red CI) on endojs/endo-but-for-bots PR #318
- [`endojs-endo-but-for-bots-pr438-weaver`](https://github.com/kriskowal/garden/blob/journal2/jobs/doin/endojs-endo-but-for-bots-pr438-weaver.md) — weaver on endojs/endo-but-for-bots PR #438 (tsgo migration) — rebase onto cur...
- [`endojs-endo-but-for-bots-pr79-shepherd`](https://github.com/kriskowal/garden/blob/journal2/jobs/doin/endojs-endo-but-for-bots-pr79-shepherd.md) — shepherd (auto: red CI) on endojs/endo-but-for-bots PR #79

### tada (872)
- [`endojs-endo-but-for-bots-pr587-shepherd`](https://github.com/kriskowal/garden/blob/journal2/jobs/tada/endojs-endo-but-for-bots-pr587-shepherd.md) — Everything is now conclusive. Final state:
- [`endojs-endo-but-for-bots-pr591-shepherd`](https://github.com/kriskowal/garden/blob/journal2/jobs/tada/endojs-endo-but-for-bots-pr591-shepherd.md) — Shepherd report — endojs/endo-but-for-bots PR #591
- [`improve-mentor-transient-handler-exit-zero`](https://github.com/kriskowal/garden/blob/journal2/jobs/tada/improve-mentor-transient-handler-exit-zero.md) — Completion report
- [`endojs-endo-but-for-bots-pr316-shepherd`](https://github.com/kriskowal/garden/blob/journal2/jobs/tada/endojs-endo-but-for-bots-pr316-shepherd.md) — Shepherd report — endojs/endo-but-for-bots PR #316 (chore: bump bundled Node ...
- [`endojs-endo-but-for-bots-pr324-shepherd`](https://github.com/kriskowal/garden/blob/journal2/jobs/tada/endojs-endo-but-for-bots-pr324-shepherd.md) — Comment posted. I've done everything within a shepherd's scope: driven all PR...
- … and 867 more

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
