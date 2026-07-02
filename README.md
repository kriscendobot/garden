# Garden bulletin

_As of 2026-07-02T01:36:48Z_

## Latest

A wave of shepherd runs closed out: [#101](https://github.com/endojs/endo-but-for-bots/pull/101), [#262](https://github.com/endojs/endo-but-for-bots/pull/262), [#306](https://github.com/endojs/endo-but-for-bots/pull/306), [#394](https://github.com/endojs/endo-but-for-bots/pull/394), [#395](https://github.com/endojs/endo-but-for-bots/pull/395), and [#409](https://github.com/endojs/endo-but-for-bots/pull/409), and the [#389](https://github.com/endojs/endo-but-for-bots/pull/389) weave landed. [#394](https://github.com/endojs/endo-but-for-bots/pull/394) escalated shepherd→fixer, while [#101](https://github.com/endojs/endo-but-for-bots/pull/101) and [#306](https://github.com/endojs/endo-but-for-bots/pull/306) were handed to a weaver to rebase their stale bases. Four garden-infra fixes were also posted and claimed — a host-identity drift detector, gardener transient-failure backoff / fleet brake, issue-inbox child-git reaping, and repo-watcher arm-retry.

Two items want a maintainer eye. First, [#592](https://github.com/endojs/endo-but-for-bots/pull/592) is green on 24 of 25 checks but red on `lint` from the known typescript-eslint projectService scaling ceiling — the failure lands in `packages/zip`, which this 6-file platform/daemon PR never touches, meaning the `llm` baseline is already at the ceiling; the same wall now blocks [#590](https://github.com/endojs/endo-but-for-bots/pull/590) and [#593](https://github.com/endojs/endo-but-for-bots/pull/593), so it likely wants its own lint-infra job rather than being folded into any refactor. Second, the botanist board-audit report asks whether recurring board audits should become a standing capability, and if so whether to build them on foreman/watchman or a new script — an architecture call before any work is posted.

## Parked for maintainer feedback

- [endojs/endo-but-for-bots#503](https://github.com/endojs/endo-but-for-bots/pull/503) — feat(immutable-arraybuffer,pass-style): passable byte arrays (freezable TypedArray emulation + byteArray brand check) (waiting 1d)
- [endojs/endo-but-for-bots#403](https://github.com/endojs/endo-but-for-bots/pull/403) — feat(registry-capability): EndoRegistry capability + @registry special name (#358 layer 1) (waiting 2d)
- [endojs/endo-but-for-bots#379](https://github.com/endojs/endo-but-for-bots/pull/379) — fix(ses): cyclic star export with renaming reexport (issue #59) - refresh for #3276 feedback (waiting 5d)
- [endojs/endo#3137](https://github.com/endojs/endo/pull/3137) — feat: support .ts runtime modules via erasable type syntax (waiting 16d)
- [endojs/endo-but-for-bots#101](https://github.com/endojs/endo-but-for-bots/pull/101) — feat(chat): voice input via Web Speech API (waiting 41d)
- [endojs/endo-but-for-bots#182](https://github.com/endojs/endo-but-for-bots/pull/182) — test(ses): isImmutableDataProperty regression for iOS Safari fix (closes #947) (waiting 40d)
- [endojs/endo-but-for-bots#186](https://github.com/endojs/endo-but-for-bots/pull/186) — feat(eventual-send): eager-shim/lazy-main delegate ponyfill (per #175) (waiting 40d)
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


## Board
### todo (0)
(none)

### doin (18)
- [`endojs-endo-but-for-bots-pr101-weaver`](https://github.com/kriskowal/garden/blob/journal2/jobs/doin/endojs-endo-but-for-bots-pr101-weaver.md) — weaver (rebase stale base) on endojs/endo-but-for-bots PR #101
- [`endojs-endo-but-for-bots-pr216-weave`](https://github.com/kriskowal/garden/blob/journal2/jobs/doin/endojs-endo-but-for-bots-pr216-weave.md) — weave (rebase) endojs/endo-but-for-bots PR #216 onto base llm
- [`endojs-endo-but-for-bots-pr301-weave`](https://github.com/kriskowal/garden/blob/journal2/jobs/doin/endojs-endo-but-for-bots-pr301-weave.md) — weave (rebase/conflict-resolve) on endojs/endo-but-for-bots PR #301
- [`endojs-endo-but-for-bots-pr306-weaver`](https://github.com/kriskowal/garden/blob/journal2/jobs/doin/endojs-endo-but-for-bots-pr306-weaver.md) — weaver (rebase/conflict-resolution) on endojs/endo-but-for-bots PR #306
- [`endojs-endo-but-for-bots-pr313-shepherd`](https://github.com/kriskowal/garden/blob/journal2/jobs/doin/endojs-endo-but-for-bots-pr313-shepherd.md) — shepherd (auto: red CI) on endojs/endo-but-for-bots PR #313
- [`endojs-endo-but-for-bots-pr393-shepherd`](https://github.com/kriskowal/garden/blob/journal2/jobs/doin/endojs-endo-but-for-bots-pr393-shepherd.md) — shepherd (auto: red CI) on endojs/endo-but-for-bots PR #393
- [`endojs-endo-but-for-bots-pr394-fixer`](https://github.com/kriskowal/garden/blob/journal2/jobs/doin/endojs-endo-but-for-bots-pr394-fixer.md) — fixer (shepherd escalation) on endojs/endo-but-for-bots PR #394
- [`endojs-endo-but-for-bots-pr438-shepherd`](https://github.com/kriskowal/garden/blob/journal2/jobs/doin/endojs-endo-but-for-bots-pr438-shepherd.md) — shepherd (auto: red CI) on endojs/endo-but-for-bots PR #438
- [`endojs-endo-but-for-bots-pr587-shepherd`](https://github.com/kriskowal/garden/blob/journal2/jobs/doin/endojs-endo-but-for-bots-pr587-shepherd.md) — shepherd (auto: red CI) on endojs/endo-but-for-bots PR #587
- [`endojs-endo-but-for-bots-pr590-shepherd`](https://github.com/kriskowal/garden/blob/journal2/jobs/doin/endojs-endo-but-for-bots-pr590-shepherd.md) — shepherd (auto: red CI) on endojs/endo-but-for-bots PR #590
- [`endojs-endo-but-for-bots-pr591-shepherd`](https://github.com/kriskowal/garden/blob/journal2/jobs/doin/endojs-endo-but-for-bots-pr591-shepherd.md) — shepherd (auto: red CI) on endojs/endo-but-for-bots PR #591
- [`endojs-endo-but-for-bots-pr593-shepherd`](https://github.com/kriskowal/garden/blob/journal2/jobs/doin/endojs-endo-but-for-bots-pr593-shepherd.md) — shepherd (auto: red CI) on endojs/endo-but-for-bots PR #593
- [`endojs-endo-but-for-bots-pr79-shepherd`](https://github.com/kriskowal/garden/blob/journal2/jobs/doin/endojs-endo-but-for-bots-pr79-shepherd.md) — shepherd (auto: red CI) on endojs/endo-but-for-bots PR #79
- [`endojs-endo-but-for-bots-pr96-shepherd`](https://github.com/kriskowal/garden/blob/journal2/jobs/doin/endojs-endo-but-for-bots-pr96-shepherd.md) — shepherd (auto: red CI) on endojs/endo-but-for-bots PR #96
- [`improve-garden-identity-drift-detector`](https://github.com/kriskowal/garden/blob/journal2/jobs/doin/improve-garden-identity-drift-detector.md) — Every new gardener entry in this window reports host: endolinbot2, but per th...
- [`improve-gardener-transient-failure-backoff-and-fleet-brake`](https://github.com/kriskowal/garden/blob/journal2/jobs/doin/improve-gardener-transient-failure-backoff-and-fleet-brake.md) — scripts/jobs/gardener.sh: on a correlated Claude quota/API outage, all ~100 g...
- [`improve-issue-inbox-child-git-reaping`](https://github.com/kriskowal/garden/blob/journal2/jobs/doin/improve-issue-inbox-child-git-reaping.md) — garden-issue-inbox.service logs Found left-over process (git) in control grou...
- [`improve-repo-watcher-arm-retry`](https://github.com/kriskowal/garden/blob/journal2/jobs/doin/improve-repo-watcher-arm-retry.md) — scripts/jobs/repo-watcher.sh logs WARN: could not arm garden-ci-watcher@endoj...

### tada (860)
- [`endojs-endo-but-for-bots-pr239-shepherd`](https://github.com/kriskowal/garden/blob/journal2/jobs/tada/endojs-endo-but-for-bots-pr239-shepherd.md) — Completion report — endojs-endo-but-for-bots-pr239-shepherd
- [`endojs-endo-but-for-bots-pr286-shepherd`](https://github.com/kriskowal/garden/blob/journal2/jobs/tada/endojs-endo-but-for-bots-pr286-shepherd.md) — Completion report — shepherd on endojs/endo-but-for-bots PR #286
- [`endojs-endo-but-for-bots-pr394-shepherd`](https://github.com/kriskowal/garden/blob/journal2/jobs/tada/endojs-endo-but-for-bots-pr394-shepherd.md) — The new CI run for my pushed SHA is classified **"CI (docs-only)"** — since t...
- [`endojs-endo-but-for-bots-pr306-shepherd`](https://github.com/kriskowal/garden/blob/journal2/jobs/tada/endojs-endo-but-for-bots-pr306-shepherd.md) — My shepherd work on PR #306 is complete. Report follows.
- [`endojs-endo-but-for-bots-pr262-shepherd`](https://github.com/kriskowal/garden/blob/journal2/jobs/tada/endojs-endo-but-for-bots-pr262-shepherd.md) — Shepherd report — endojs/endo-but-for-bots PR #262
- … and 855 more

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
