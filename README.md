# Garden bulletin

_As of 2026-07-09T23:35:10Z_

## Latest

The [minion.town MCP guest ocap access-control design](https://github.com/kriskowal/garden/blob/journal2/jobs/tada/minion-town-mcp-guest-ocap-access-control.md) landed — `designs/mcp-endo-guest.md` revised and pushed, moving MCP access control off OAuth scopes toward object capabilities. Two items need a maintainer decision. First, conducting [endo-but-for-bots#123](https://github.com/endojs/endo-but-for-bots/pull/123) (lal-transcript hardening) is **stalled**: it's approved and green, but `assembleTranscript` and the whole transcript-node machinery no longer exist on the diverged `llm` trunk (agent.js was rewritten around `makePiAgent`), so the fix needs a **weave/redesign** decision rather than a surgical merge. Second, [endo-but-for-bots#286](https://github.com/endojs/endo-but-for-bots/pull/286) (http-client, reconciled onto merged [#566](https://github.com/endojs/endo-but-for-bots/pull/566)) has a real, deterministic **Node-22 bug** — hardening freezes undici's lazy `Symbol(headers map sorted)` slot, breaking cross-CapTP error decode — and wants a fixer.

On the exo-google-sheets push, a new daily supervisor schedule is live and posted `run the gauntlet` on the design-gate PR [endo-but-for-bots#621](https://github.com/endojs/endo-but-for-bots/pull/621) (endoclaw-oauth foundation); nothing downstream unblocks until it merges. Several gardeners stopped short of opening duplicate PRs and flagged existing work instead: [endo-but-for-bots#609](https://github.com/endojs/endo-but-for-bots/pull/609) already satisfies endoclaw-timer Phase 1 (ready for merge), and the daemon fs agent-tools job is already covered by landed [endo-but-for-bots#614](https://github.com/endojs/endo-but-for-bots/pull/614) plus conflicting draft [endo-but-for-bots#618](https://github.com/endojs/endo-but-for-bots/pull/618) (needs a weave). Two new mount drafts are stacked and awaiting their bases to land: CLI `--deny` follow-up [endo-but-for-bots#652](https://github.com/endojs/endo-but-for-bots/pull/652) (on [#650](https://github.com/endojs/endo-but-for-bots/pull/650)) and the Rust-side mount-glob parity runner [endo-but-for-bots#654](https://github.com/endojs/endo-but-for-bots/pull/654) (on [#653](https://github.com/endojs/endo-but-for-bots/pull/653)), the latter chosen over the unbuildable XS-run variant and open for your steer. Finally, the shepherd for [#650](https://github.com/endojs/endo-but-for-bots/pull/650)'s CI overran its handler budget and needs splitting into claim-sized stages.

## Parked for maintainer feedback

- [endojs/endo#3319](https://github.com/endojs/endo/pull/3319) — feat(eslint-plugin)!: support ESLint 10+ (waiting 44m)
- [endojs/endo-but-for-bots#113](https://github.com/endojs/endo-but-for-bots/pull/113) — test(ocapn-noise): integration + transport tests (#59 stack 3/3) (waiting 4h)
- [endojs/endo-but-for-bots#101](https://github.com/endojs/endo-but-for-bots/pull/101) — feat(chat): voice input via Web Speech API (waiting 7d)
- [endojs/endo-but-for-bots#503](https://github.com/endojs/endo-but-for-bots/pull/503) — feat(immutable-arraybuffer,pass-style): passable byte arrays (freezable TypedArray emulation + byteArray brand check) (waiting 9d)
- [endojs/endo-but-for-bots#403](https://github.com/endojs/endo-but-for-bots/pull/403) — feat(registry-capability): EndoRegistry capability + @registry special name (#358 layer 1) (waiting 10d)
- [endojs/endo-but-for-bots#379](https://github.com/endojs/endo-but-for-bots/pull/379) — fix(ses): cyclic star export with renaming reexport (issue #59) - refresh for #3276 feedback (waiting 13d)
- [endojs/endo#3137](https://github.com/endojs/endo/pull/3137) — feat: support .ts runtime modules via erasable type syntax (waiting 24d)
- [endojs/endo-but-for-bots#182](https://github.com/endojs/endo-but-for-bots/pull/182) — test(ses): isImmutableDataProperty regression for iOS Safari fix (closes #947) (waiting 48d)
- [endojs/endo-but-for-bots#186](https://github.com/endojs/endo-but-for-bots/pull/186) — feat(eventual-send): eager-shim/lazy-main delegate ponyfill (per #175) (waiting 48d)
- [endojs/endo-but-for-bots#266](https://github.com/endojs/endo-but-for-bots/pull/266) — design: opencode comparative analysis + gap-closing raft (endopen) (waiting 50d)

_Showing top 10 of 26 parked PRs (ranked by recency + roadmap relevance)._
## Messages to the maintainer

- `20260709T184832Z-f62451` — from gardener:endojs-endo-but-for-bots-pr612-33410353, reply_to `endojs-endo-but-for-bots-pr612-33410353` · [open message](https://github.com/kriskowal/garden/blob/journal2/inbox/maintainer/unread/20260709T184832Z-f62451.md)

> Actioned your PR #612 directive ("dispatch a supervisor … check in once per day … chase dependencies down until the whole tree is merged and operational").
>
> Routed as a DAILY recurring schedule rather than a single blocking job: `exo-google-sheets-impl-supervisor` (cadence=daily) is on journal2 and fires on the next scheduler tick, then once/day. Each fire: reconstructs the dep tree from `designs/exo-google-sheets.md` + `designs/README.md` (esheets ← endoclaw-oauth ← endoclaw-network-fetch; @endo/google-sheets → @endo/exo-google-sheets; webhooks/push deferred per design), assesses live PR/board state, posts the ONE deepest unblocked next step (designer/builder/gauntlet/shepherd), and sends you a one-line standup. It self-retires (deletes its own schedule) when the whole tree is merged + build/test green.
>
> Chose a schedule over a static orchestration job because the tree's node states aren't knowable up front — each day's supervisor must reassess and pick the next step. First check-in lands today.

- `20260709T184840Z-b2bc25` — from gardener:endojs-endo-but-for-bots-pr123-conduct, reply_to `endojs-endo-but-for-bots-pr123-conduct` · [open message](https://github.com/kriskowal/garden/blob/journal2/inbox/maintainer/unread/20260709T184840Z-b2bc25.md)

> STALLED — endojs/endo-but-for-bots PR #123 (fix/lal-transcript) cannot be conducted.
>
> The PR is APPROVED, not-draft, mergeable-onto-its-snapshot, and CI just kicked
> off. But the conductor's mandatory unfreeze-before-merge step hits a hard wall:
>
> - PR base is the frozen snapshot `llm-11a76ae`; live trunk `llm` has diverged
>   hard (llm is 569 commits ahead of the merge-base; the snapshot carries 29
>   unique commits). `llm` is a rebased/force-updated branch, so this is real
>   divergence, not "behind".
> - The PR's one commit hardens `assembleTranscript` in `packages/lal/agent.js`.
>   On live `llm`, agent.js was rewritten from 1781 lines to 325 lines around a
>   new `makePiAgent` architecture — **`assembleTranscript` and the whole
>   transcript-node machinery (getNode/putNode/nodeCache) no longer exist there.**
> - `git rebase --onto origin/llm origin/llm-11a76ae` therefore conflicts on the
>   entire file: it's a semantic re-implementation against a replaced module, not
>   a surgical conflict.
>
> This is beyond the conductor's surgical scope. It needs a **weave/redesign
> decision**: either port the broken-chain hardening onto the new makePiAgent
> agent.js, or judge the fix obsolete (the code it guards is gone). I did NOT
> merge, did NOT edit the PR base, and pushed nothing — PR #123 is untouched
> (base still llm-11a76ae, state OPEN).
>
> Recommend posting a **weave #123** job (or a designer/builder pass to re-target
> the fix onto the new agent.js) before re-attempting conduct.

- `20260709T185310Z-5d1d49` — from gardener:esheets-supervisor-20260709-185001, reply_to `esheets-supervisor-20260709-185001` · [open message](https://github.com/kriskowal/garden/blob/journal2/inbox/maintainer/unread/20260709T185310Z-5d1d49.md)

> 📊 exo-google-sheets daily supervisor (day 1 of push-to-implementation)
>
> Tree (design #612, merged): @endo/exo-google-sheets → @endo/google-sheets →
> endoclaw-oauth (OAuth exo) → endoclaw-network-fetch (allowlist). Webhooks/push
> deferred by design, not in the v1 "operational" bar.
>
> MERGED / done:
> • endoclaw-network-fetch substrate — @endo/http-confine + @endo/exo-http-client
>   landed on llm (PR #566). The fetch/allowlist floor is in place.
> • Design #612 (exo-google-sheets) merged; endoclaw-oauth base design present.
>
> IN FLIGHT:
> • PR #621 (design: refine endoclaw-oauth foundation, settle first-mint flow) —
>   DRAFT, CI all green, no reviews yet. This is the DESIGN GATE for the whole
>   tree: the OAuth exo (deepest unmet node) has no implementation, and its
>   refined foundation design must land before we build it.
>   https://github.com/endojs/endo-but-for-bots/pull/621
>
> ADVANCED TODAY:
> • Posted `run the gauntlet #621` to drive that design PR out of draft into your
>   review queue. That's the single deepest unblocked step; once #621 merges the
>   next step is a builder job for the OAuth exo, then @endo/google-sheets, then
>   @endo/exo-google-sheets.
>
> BLOCKING / needs you: nothing hard-blocked. #621 defers two open questions with
> recommended v1 defaults (per-host OAuth client registration; remote-headless
> redirect via a future gateway route at M5) — flag if you'd rather decide either
> now; otherwise the gauntlet lands it as-is. Nothing to implement is unblocked
> until #621 merges.

- `20260709T202811Z-53aebd` — from gardener:endojs-endo-but-for-bots-mount-denied-segments-cli, reply_to `endojs-endo-but-for-bots-mount-denied-segments-cli` · [open message](https://github.com/kriskowal/garden/blob/journal2/inbox/maintainer/unread/20260709T202811Z-53aebd.md)

> Opened draft PR endojs/endo-but-for-bots#652 — the CLI follow-up for the mount
> `deniedSegments` option (deferred by PR A, #650). It adds a repeatable
> `--deny <segment>` and `--no-deny` to `endo mount` and `endo mktmp`, forwarding
> to provideMount/provideScratchMount, mirroring `--read-only`.
>
> Dependency note: #652 is STACKED on #650 (base = frozen snapshot
> `feat/mount-revocation-104895e` of #650's head). I intentionally left it draft
> and did NOT run the panel/un-draft yet: #650 is still an open draft, so
> un-drafting #652 now would enqueue it against a base that disappears when #650
> merges/rebases. Suggested sequencing: after #650 merges to `llm`, post a
> `rebase #652` (move its base to the live/merged base) then `run the gauntlet
> #652` to panel + un-draft. Happy to do both as a follow-up when #650 lands.
>
> Local verification done at the slice level (offline): help surface for both
> commands advertises the flags; the option resolver's three branches
> (default/replace/disable) are unit-tested and shown load-bearing via
> break-and-observe. eslint, tsc, prettier, and the banner probe are green. The
> full monorepo local-verify gate and daemon-backed CLI tests require a live
> `endo` daemon binary not present in this sandbox; GitHub CI exercises those.

- `20260709T203825Z-00f82d` — from gardener:endojs-endo-but-for-bots-mount-glob-rust-runner, reply_to `endojs-endo-but-for-bots-mount-glob-rust-runner` · [open message](https://github.com/kriskowal/garden/blob/journal2/inbox/maintainer/unread/20260709T203825Z-00f82d.md)

> Impasse on job `endojs-endo-but-for-bots-mount-glob-rust-runner` (Rust/XS mount glob case-table runner). Need a steer before I build, because the task's literal ask isn't buildable in this tree.
>
> TASK asks: a runner in the Rust workspace that materializes mount-fixture-manifest.json and iterates mount-glob-cases.json, asserting **the XS-run mount.js** produces byte-identical results.
>
> BLOCKER (verified, not stale): the XS worker/SES-boot path is not buildable from endo-but-for-bots as it stands.
> - rust/endo/xsnap `include_str!`s three generated bundles — ses_boot.js, worker_bootstrap.js, daemon_bootstrap.js — all gitignored and ABSENT, so the xsnap crate cannot even compile. No cargo test touching XS can build here.
> - The worker/SES-boot generators (`bundle-bus-worker-xs.mjs` + the SES boot generator + the `bus-worker-xs.js` entry) are absent and NOT in git history (rust/endo/README §"Not yet runnable" #2).
> - The daemon bundler (`bundle-bus-daemon-rust-xs.mjs`) currently FAILS on Node-only imports (@endo/git, a @endo/platform/fs/lite path) — pre-existing (README #1).
> - No prebuilt `endor` binary or bundles anywhere on the host; node_modules absent (full monorepo install needed).
> - mount.js's glob is a pure walk over injected filePowers, but it's packaged as an exo (makeExo/E/harden) whose graph needs the same failing compartment-mapper bundle — no clean minimal XS harness without fixing the boot path.
>
> So "run the real mount.js under XS and diff the case table" cannot be built or verified here today.
>
> OPTIONS:
>   A) Build the **Rust-side** parity runner now — the design's other sanctioned form (mount-extensions-reconstruction §"Test strategy": "a Rust-side OR XS-supervisor-side runner"; the glob language "is specified normatively so a Rust implementation can match it"). A standalone workspace crate (no xsnap dep, so it compiles/tests independently) that materializes the manifest exactly like _mount-fixture.js (root subdir + escape-target sibling, base64 probe, optional-symlink skip) and iterates the glob (and later grep) case tables against a Rust glob mirroring the normative spec + UTF-16 sort + requiresSymlink gate. Verifiable today; a real durable guard; coordinates with PR C via the same harness.
>   B) The **XS-supervisor-side** runner as written in the task — but this first needs the XS boot path unblocked: make the git backend injectable + extend the bundler exclude list, author the worker/SES-boot generators + bus-worker-xs.js entry (README calls this ~half a day of bundler hygiene plus locating/authoring the missing worker path). That's a separate, larger prerequisite job; the runner is trivial once it lands.
>
> Recommendation: do A now (it's the design-sanctioned, verifiable guard and unblocks PR C's grep table), and file B as a tracked follow-up gated on the XS boot path becoming buildable. Confirm A, or tell me to pursue B (and whether to take on the boot-path prerequisite)?

- `20260709T204935Z-655979` — from gardener:endojs-endo-but-for-bots-mount-glob-rust-runner, reply_to `endojs-endo-but-for-bots-mount-glob-rust-runner` · [open message](https://github.com/kriskowal/garden/blob/journal2/inbox/maintainer/unread/20260709T204935Z-655979.md)

> Followup to my impasse message on `endojs-endo-but-for-bots-mount-glob-rust-runner`: rather than block, I proceeded with the recommended default (Option A, the design-sanctioned Rust-side parity runner), since the XS-run path is not buildable in this tree. Draft PR is up and easy to redirect if you'd rather I pursue Option B instead.
>
> Draft PR #654 (base = frozen feat/mount-glob-e2abb76, stacked on PR B #653): new `rust/mount_parity` crate that materializes mount-fixture-manifest.json exactly like _mount-fixture.js and asserts a faithful Rust mirror of mount.js's glob reproduces every mount-glob-cases.json `expect` byte-for-byte (UTF-16 sort, deny filter, symlink confinement, GLOB_MAX_RESULTS). `cargo test -p mount_parity` = 5 green; regression-checked (neutering deny / reversing sort both turn it red); crate has no xsnap/endo dep so it builds without the XS bundles. tests/mount_grep_parity.rs is the reuse seam for PR C's grep table.
>
> Still open for your steer:
> 1. Is the Rust-side runner acceptable as the durable guard, or do you want the XS-run-mount.js variant (Option B), which first needs the XS boot path unblocked (fix daemon bundler + author the missing worker/SES-boot generators + bus-worker-xs.js)? If B, want me to take on that boot-path prerequisite as its own job?
> 2. If A stands, should I file a tracked follow-up job for the XS-supervisor-side runner gated on the boot path becoming buildable?
>
> Not urgent — the draft can sit for the panel/your review.

- `20260709T212252Z-402b49` — from foreman, reply_to `?` · [open message](https://github.com/kriskowal/garden/blob/journal2/inbox/maintainer/unread/20260709T212252Z-402b49.md)

> foreman: next step 'endojs-endo-but-for-bots-endoclaw-timer-phase4-host-integration' recurred after the previous post drained without milestone progress. Holding the re-post pending review; it may be stuck.

- `20260709T213356Z-1e2aab` — from gardener:endojs-endo-but-for-bots-endoclaw-timer-daemon-graduation-phase-one, reply_to `endojs-endo-but-for-bots-endoclaw-timer-daemon-graduation-phase-one` · [open message](https://github.com/kriskowal/garden/blob/journal2/inbox/maintainer/unread/20260709T213356Z-1e2aab.md)

> Job 'endoclaw-timer-daemon-graduation-phase-one' is ALREADY SATISFIED by an open, green, non-draft PR — no duplicate opened.
>
> PR #609 "feat(daemon): interval-scheduler formula (endoclaw-timer Phase 1 remainder)" (base llm, head build/endoclaw-timer-daemon-formula-integration) implements exactly this job's named scope: the `interval-scheduler` formula type (formula-type.js + types.d.ts IntervalSchedulerFormula), the extractDeps case (daemon.js:809, strong agent edge), the maker-table entry (daemon.js:3918 + formulateIntervalScheduler), a 737-line SES-safe port of the genie prototype into packages/daemon/src/interval-scheduler.js (additive — genie prototype left in place), host.js/interfaces.js wiring, tests (interval-scheduler.test.js 571 lines + formula-type.test.js), and a changeset. State: OPEN, non-draft, MERGEABLE/CLEAN, all CI checks SUCCESS.
>
> Stacked follow-ons already exist for the later phases (out of this job's scope): #617 Phase 2 (tick delivery as mail + TickResponse exo), #619 Phase 3 (startup recovery). Suggest closing this job as a duplicate; #609 is ready for the conductor/merge path.

- `20260709T215830Z-61c5d2` — from liaison:follow-up, reply_to `?` · [open message](https://github.com/kriskowal/garden/blob/journal2/inbox/maintainer/unread/20260709T215830Z-61c5d2.md)

> On endojs/endo-but-for-bots PR #286 (http-client reconcile onto merged #566, https://github.com/endojs/endo-but-for-bots/pull/286): the landed `HttpClientControl` mutators (`addAllowedOrigin`, `revoke`, rate/byte/timeout) are not yet wired through the daemon controller facet — the controller is a read-only allowlist holder and the paired control facet is unused. Wiring it is described as Phase 2/3 work. Do you want to post a designer/builder job to plan and land that wiring now, or defer it?

- `20260709T220229Z-957984` — from gardener:endojs-endo-but-for-bots-daemon-agent-tools-phase-one-filesystem-tools, reply_to `endojs-endo-but-for-bots-daemon-agent-tools-phase-one-filesystem-tools` · [open message](https://github.com/kriskowal/garden/blob/journal2/inbox/maintainer/unread/20260709T220229Z-957984.md)

> Builder impasse on job `daemon-agent-tools-phase-one-filesystem-tools` — the requested build already exists / is in-flight; I did NOT open a colliding PR.
>
> The ask ("Dir-backed filesystem agent tools in Lal/Fae — file browse+edit confined to a granted Dir") is already delivered across two PRs on `llm`:
>
> - **#614 (LANDED)** — the file-tool *makers* in `@endo/agent-tools`: `makeMountListTool` / `makeMountEditTool` / `makeMountStatTool` + composite `makeMountFsTools` over an `@endo/platform/fs/extended` Filesystem (read-only deployments drop the edit tool at construction). Design's "Phase 1".
> - **#618 (OPEN DRAFT, but CONFLICTING/stale since 2026-07-06)** — the Lal/Fae *wiring*: a new `discoverCapabilityTools(powers)` in `@endo/agent-tools/discover.js` that looks up a `Dir`/mount cap under pet name `fs`, projects it via `mountAsFilesystem`, and registers `makeMountFsTools`; wired into `packages/lal/agent.js` AND `packages/fae/src/capability-tools.js`, plus the provisioning flow (`provideMount` + a "Coding capabilities: fs, shell, git" form field). This is verbatim the job. It bundles shell+git+form-provisioning too (the job said Shell/Git were out of scope).
>
> The job's "Phase 1" is the 2026-03 sketch's numbering (fs=first of fs/shell/git); the reconciled design (updated 2026-07-09) numbers the fs makers as Phase 1 (landed #614) and the harness wiring as Phase 4 (#618).
>
> I stopped rather than open a third overlapping PR. Two sensible paths — your call:
> 1. **Redundant** → close/withdraw this job; if #618 is what you want, it needs a **weave/rebase** (it's CONFLICTING against `llm`), which is a weaver job, not a build.
> 2. **Extract a clean fs-only slice** → you want the filesystem wiring landed independently of #618's conflicting shell/git bundle. I can build a narrow PR that adds only the `fs`-cap discovery+wiring into Lal/Fae (reusing landed #614 makers), leaving shell/git out. Say the word and I'll do that.
>
> Which do you want?

- `20260709T222519Z-c6292a` — from gardener:fu-endojs-endo-but-for-bots-pull-request-286-http-client-reconcile-onto-merged-566-2, reply_to `fu-endojs-endo-but-for-bots-pull-request-286-http-client-reconcile-onto-merged-566-2` · [open message](https://github.com/kriskowal/garden/blob/journal2/inbox/maintainer/unread/20260709T222519Z-c6292a.md)

> PR #286 (endo http mk Phase 1) CI: the full-daemon e2e suite FAILS — not flaky/infra, a real Node-22-specific bug.
>
> Failing test: @endo/daemon › http-client › client request to allowed origin succeeds
>   - FAILS on Node 22.x (ubuntu-latest AND macos-15) — deterministic, both OSes
>   - PASSES on Node 24.x (ubuntu-latest); 24.x macos still finishing
> All other checks (lint, build, browser-tests, coverage, test262, xs, hermes, sandbox-drivers, ws-relay, etc.) are green.
>
> Root cause (from the log):
>   TypeError: Cannot assign to read only property 'Symbol(headers map sorted)' of object '[object Object]'
>     at decodeErrorCommon (packages/marshal/src/marshal.js:316:24)
>     at decodeErrorFromCapData ... fromCapData ... CTP_RETURN (captp) ... daemon/src/connection.js:192
> The daemon-side http request returns an error that carries a whatwg Headers object; undici's Headers on Node 22 caches a lazy internal `Symbol(headers map sorted)` slot, which hardening freezes, so error-decode on the client cannot reconstruct it and throws. Node 24's undici changed the internal so it doesn't trip. This is inside the new http-client feature of #286.
>
> Recommend: dispatch a fixer. Likely fix is to avoid marshalling/hardening the live Headers object across CapTP (pass plain header entries), or normalize headers before they cross the boundary. Not fixing here — this was a watch/report job.

- `20260709T225349Z-04b451` — from watchdog:gardener/5, reply_to `?` · [open message](https://github.com/kriskowal/garden/blob/journal2/inbox/maintainer/unread/20260709T225349Z-04b451.md)

> gardener job 'shepherd-endo-but-for-bots-pr650-mount-revocation-ci-green' DETERMINISTICALLY overran its handler budget (rc=124 at the wall, elapsed=2400s ≈ handler-budget=2400s). It does not fit in a single claim-scoped handler and will be POISONED after GARDEN_REAP_OVERRUN_THRESHOLD (2) cycles without completing. Same root cause as an over-large declared handler-timeout, but under the default budget it gets no early signal — surfaced here so you don't have to reverse-engineer it from the reaper's generic poison report. Remedy: SPLIT it into claim-sized stages, or run it DETACHED outside the claim-scoped handler.


## Board
### todo (0)
(none)

### doin (1)
- [`shepherd-endo-but-for-bots-pr286-cli-http-client-lint-green`](https://github.com/kriskowal/garden/blob/journal2/jobs/doin/shepherd-endo-but-for-bots-pr286-cli-http-client-lint-green.md) — ---

### tada (1596)
- [`minion-town-mcp-guest-ocap-access-control`](https://github.com/kriskowal/garden/blob/journal2/jobs/tada/minion-town-mcp-guest-ocap-access-control.md) — Revised designs/mcp-endo-guest.md on kriscendobot/minion.town and pushed dire...
- [`improve-triager-failure-circuit-breaker`](https://github.com/kriskowal/garden/blob/journal2/jobs/tada/improve-triager-failure-circuit-breaker.md) — Completion report
- [`design-auto-provision-fork-watchers`](https://github.com/kriskowal/garden/blob/journal2/jobs/tada/design-auto-provision-fork-watchers.md) — Completion report
- [`kriscendobot-minion.town-pr3-review-3c9cea83-retro`](https://github.com/kriskowal/garden/blob/journal2/jobs/tada/kriscendobot-minion.town-pr3-review-3c9cea83-retro.md) — Completion report
- [`shepherd-endo-but-for-bots-pr656-mount-provide-submount-lint-green`](https://github.com/kriskowal/garden/blob/journal2/jobs/tada/shepherd-endo-but-for-bots-pr656-mount-provide-submount-lint-green.md) — Completion report
- … and 1591 more

## Plan queue (parked — not claimable until promoted)
### awaiting go-ahead (maintainer authorization)
- [`build-account-store-minion-town`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/build-account-store-minion-town.md) — _normal_ · Build: account store + auto-provisioning for minion.town (Phase A — ships dar...
- [`build-endo-daemon-aws-storage-wiring`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/build-endo-daemon-aws-storage-wiring.md) — _normal_ · Build: wire the AWS storage platform into a daemon flavour (phases 2-3 of des...
- [`build-endo-daemon-cloudflare-storage`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/build-endo-daemon-cloudflare-storage.md) — _normal_ · Build: Endo daemon Cloudflare storage platform (phases 1-2 of the design)
- [`deploy-endo-daemon-aws-storage-reference`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/deploy-endo-daemon-aws-storage-reference.md) — _normal_ · Build: reference deployment + operations for the daemon AWS storage platform ...
- [`deploy-siwe-thunk-minion-town`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/deploy-siwe-thunk-minion-town.md) — _normal_ · Deploy the SIWE OIDC thunk (mirroring the GitHub thunk's AWS path)
- [`ebfb-124-resume-rebase-review-fixups`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/ebfb-124-resume-rebase-review-fixups.md) — _normal_ · ---
- [`ebfb-124-sqlite-iterate-streaming`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/ebfb-124-sqlite-iterate-streaming.md) — _normal_ · ---
- [`ebfb-124-sqlite-nongeneralised-design`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/ebfb-124-sqlite-nongeneralised-design.md) — _normal_ · ---
- [`ebfb-124-sqlite-pragma-simple`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/ebfb-124-sqlite-pragma-simple.md) — _normal_ · ---
- [`ebfb-124-sqlite-shutdown-checkpoint`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/ebfb-124-sqlite-shutdown-checkpoint.md) — _normal_ · ---
- [`endojs-endo-but-for-bots-pr132-report-render-mode`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr132-report-render-mode.md) — _normal_ · re-port render-mode toggle onto @endo/space-chat InboxRoot (endojs/endo-but-f...
- [`foreman-budget-cross-host-weekly-token-aggregation`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/foreman-budget-cross-host-weekly-token-aggregation.md) — _normal_ · PLAN: deterministic cross-host weekly token-spend aggregation for the foreman...
- [`garden-style-typist-codepoints`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/garden-style-typist-codepoints.md) — _normal_ · ---
- [`garden-style-url-not-path`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/garden-style-url-not-path.md) — _normal_ · ---
- [`open-signup-gate-flip-minion-town`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/open-signup-gate-flip-minion-town.md) — _normal_ · Build: open-signup gate flip for minion.town (Phase B — THE consequential cha...
- [`styled-privilege-surfaces-minion-town`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/styled-privilege-surfaces-minion-town.md) — _normal_ · Build: styled privilege surfaces for minion.town (Phase C — role-aware landin...
- [`verify-ymax0-hex-fix-inquisitor`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/verify-ymax0-hex-fix-inquisitor.md) — _normal_ · PLAN (go-ahead): verify the ymax0 hex fix and stackCount snapshot-compatibili...
- [`wire-siwe-onchain-authz-minion-town`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/wire-siwe-onchain-authz-minion-town.md) — _normal_ · Wire the chosen SIWE on-chain authorization tier into minion.town's policy layer

### deferred (top by priority; foreman auto-promotes when idle)
(none)

### blocked (awaiting an artifact; unblock watcher auto-promotes on completion)
- [`build-daemon-rename-to-manager-phase2`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/build-daemon-rename-to-manager-phase2.md) — awaiting `https://github.com/endojs/endo-but-for-bots/pull/598` · Build: daemon→manager rename Phase 2 (identifier renames)
- [`build-daemon-rename-to-manager-phase3`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/build-daemon-rename-to-manager-phase3.md) — awaiting `build-daemon-rename-to-manager-phase2` · Build: daemon→manager rename Phase 3 (consumer sweep + CHANGELOG + docs)
- [`port-xs-to-rust-memory-safe-engine-s18`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/port-xs-to-rust-memory-safe-engine-s18.md) — awaiting `xs2rust-endor-build-stage5-fix6` · Fable supervisor: drive the XS→Rust (Endor) port from design to maintainer-re...
- [`resume-lint-ceiling-shepherds`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/resume-lint-ceiling-shepherds.md) — awaiting `https://github.com/endojs/endo-but-for-bots/pull/594` · Resume shepherds for PRs blocked by the endo-but-for-bots lint projectService...

## Watch set
kriscendobot-minion.town

## Hosts
- [endolin-garden-ece02cb4](https://github.com/kriskowal/garden/blob/journal2/hosts/endolin-garden-ece02cb4): 20 gardeners
- [endolin-garden2-5bcdff64](https://github.com/kriskowal/garden/blob/journal2/hosts/endolin-garden2-5bcdff64): 20 gardeners
