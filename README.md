# Garden bulletin

_As of 2026-07-10T11:12:47Z_

## Latest

The dominant signal this cycle is a fleet that has run out of unblockable work: the board's todo queue is empty, and the foreman reported three times (M3 [saturated](https://github.com/endojs/endo-but-for-bots/pull/650), gateway/timer/mount stacks all green-but-unmerged) that forward progress now depends on **merge attention, not more building** — the mount stack ([#650](https://github.com/endojs/endo-but-for-bots/pull/650), [#653](https://github.com/endojs/endo-but-for-bots/pull/653), [#655](https://github.com/endojs/endo-but-for-bots/pull/655), [#657](https://github.com/endojs/endo-but-for-bots/pull/657), [#658](https://github.com/endojs/endo-but-for-bots/pull/658)) and the endoclaw-timer stack ([#609](https://github.com/endojs/endo-but-for-bots/pull/609), [#617](https://github.com/endojs/endo-but-for-bots/pull/617), [#619](https://github.com/endojs/endo-but-for-bots/pull/619)) are CI-green and mergeable but stranded on `llm`, blocking every stacked follower. On the bright side, a shepherd took [#653](https://github.com/endojs/endo-but-for-bots/pull/653) (mount-glob) to green by rebasing onto the just-landed durable revoke fix on [#650](https://github.com/endojs/endo-but-for-bots/pull/650), unblocking the grep/json followers.

Several jobs turned out to be already-done and were reported rather than duplicated: [#609](https://github.com/endojs/endo-but-for-bots/pull/609) (interval-scheduler) and [#614](https://github.com/endojs/endo-but-for-bots/pull/614)/[#618](https://github.com/endojs/endo-but-for-bots/pull/618) (fs agent-tools) already cover their asks, and the daemon-locator-terminology design is already merged. The exo-google-sheets daily supervisor opened day 1 by posting a gauntlet on design [#621](https://github.com/endojs/endo-but-for-bots/pull/621), the gate for the whole OAuth tree. Two items need a maintainer decision before they can move: the conductor on [#123](https://github.com/endojs/endo-but-for-bots/pull/123) **stalled** (the fix targets code that no longer exists on live `llm` — needs a weave/redesign), and the agoric-sdk fork XS-16.7.1 validation ([#13](https://github.com/kriscendobot/agoric-sdk/pull/13), [#14](https://github.com/kriscendobot/agoric-sdk/pull/14)) is blocked on consensus calls (golden-snapshot regen, `METER_TYPE` bump, Depot integration access). Note also a ~9:10am UTC session-limit outage that knocked out the foreman pump and two triagers via self-heal, and a poisoned gauntlet on [#661](https://github.com/endojs/endo-but-for-bots/pull/661) now parked awaiting go-ahead.

## Parked for maintainer feedback

- [endojs/endo#3319](https://github.com/endojs/endo/pull/3319) — feat(eslint-plugin)!: support ESLint 10+ (waiting 12h)
- [endojs/endo-but-for-bots#113](https://github.com/endojs/endo-but-for-bots/pull/113) — test(ocapn-noise): integration + transport tests (#59 stack 3/3) (waiting 16h)
- [endojs/endo-but-for-bots#101](https://github.com/endojs/endo-but-for-bots/pull/101) — feat(chat): voice input via Web Speech API (waiting 7d)
- [endojs/endo-but-for-bots#503](https://github.com/endojs/endo-but-for-bots/pull/503) — feat(immutable-arraybuffer,pass-style): passable byte arrays (freezable TypedArray emulation + byteArray brand check) (waiting 10d)
- [endojs/endo-but-for-bots#403](https://github.com/endojs/endo-but-for-bots/pull/403) — feat(registry-capability): EndoRegistry capability + @registry special name (#358 layer 1) (waiting 11d)
- [endojs/endo-but-for-bots#379](https://github.com/endojs/endo-but-for-bots/pull/379) — fix(ses): cyclic star export with renaming reexport (issue #59) - refresh for #3276 feedback (waiting 14d)
- [endojs/endo#3137](https://github.com/endojs/endo/pull/3137) — feat: support .ts runtime modules via erasable type syntax (waiting 24d)
- [endojs/endo-but-for-bots#182](https://github.com/endojs/endo-but-for-bots/pull/182) — test(ses): isImmutableDataProperty regression for iOS Safari fix (closes #947) (waiting 49d)
- [endojs/endo-but-for-bots#186](https://github.com/endojs/endo-but-for-bots/pull/186) — feat(eventual-send): eager-shim/lazy-main delegate ponyfill (per #175) (waiting 49d)
- [endojs/endo-but-for-bots#266](https://github.com/endojs/endo-but-for-bots/pull/266) — design: opencode comparative analysis + gap-closing raft (endopen) (waiting 51d)

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

- `20260709T234317Z-817bae` — from foreman, reply_to `?` · [open message](https://github.com/kriskowal/garden/blob/journal2/inbox/maintainer/unread/20260709T234317Z-817bae.md)

> foreman: next step 'shepherd-endo-but-for-bots-pr653-mount-glob-ci-green' recurred after the previous post drained without milestone progress. Holding the re-post pending review; it may be stuck.

- `20260709T234901Z-a90de3` — from gardener:shepherd-endo-but-for-bots-pr653-mount-glob-ci-green, reply_to `shepherd-endo-but-for-bots-pr653-mount-glob-ci-green` · [open message](https://github.com/kriskowal/garden/blob/journal2/inbox/maintainer/unread/20260709T234901Z-a90de3.md)

> Shepherding endo-but-for-bots#653 (mount-glob, PR B of #127): root-caused the red `test` matrix. The failing test — `mount-revocation › an open followNameChanges stream fails after revoke` — is a pre-existing FLAKY test that lives in the BASE PR #650 (mount-revocation), not in #653's own diff. It relies on an fs.watch event arriving after revoke() to trip the lazy liveness recheck; a single racy write can be missed, hanging the stream ("Promise returned by test never resolved"). #653's added test file shifts AVA's file ordering enough to expose it deterministically (reproduced locally: fails 100% under `ava --serial`, which is exactly what the daemon package runs in CI).
>
> Fixed on #653's head (f9d7d2a0a3) by making the test provoke events on an interval until the revoked stream fails — no product-behavior change. Local: was 5/5 fail, now 3/3 pass serial-alone + passes serial-with-glob. CI re-verifying now.
>
> Heads-up: the SAME flaky test still exists in #650 (currently green by timing luck). It should get the same deflake there (or #650 fixed + #653 rebased) so it doesn't resurface upstream. I can't push to feat/mount-revocation from this job (not #653's head). Also a latent design note: an open followNameChanges stream on a revoked-but-idle mount never trips until the next fs event — worth a durable source fix (revoke() actively waking the stream) if you want the documented "revoke trips any open stream" contract honored for idle streams.

- `20260710T001650Z-9e7573` — from gardener:shepherd-endo-but-for-bots-pr653-mount-glob-ci-green, reply_to `shepherd-endo-but-for-bots-pr653-mount-glob-ci-green` · [open message](https://github.com/kriskowal/garden/blob/journal2/inbox/maintainer/unread/20260710T001650Z-9e7573.md)

> #653 (mount-glob) is GREEN. Resolution: while I was investigating, the durable source fix landed on the base #650 as `fix(daemon): wake open followNameChanges streams on mount revoke` (adds a `whenRevoked` promise, races each event pull against it — exactly the fix I'd flagged). That advanced #653's base, flipping it to CONFLICTING (dirty) so CI stopped dispatching.
>
> I rebased feat/mount-glob onto the fixed base (dropping my now-redundant/​conflicting test-only deflake commit), keeping just the glob feature commit. Force-pushed with lease to the PR head (6680a60c20). All 23 checks now pass — the 4 red `test (Node,OS)` matrix jobs are green, including the previously-hung `mount-revocation › open followNameChanges stream fails after revoke`. mergeable_state: clean. Green run: https://github.com/endojs/endo-but-for-bots/actions/runs/29058573797
>
> Stack is unblocked: grep (#655) and json (#657) can now rebase onto the green #653. Did not post a PR comment (no commenting authorization in the job body).

- `20260710T003335Z-cc8392` — from watchdog:gardener/3, reply_to `?` · [open message](https://github.com/kriskowal/garden/blob/journal2/inbox/maintainer/unread/20260710T003335Z-cc8392.md)

> gardener job 'shepherd-endo-but-for-bots-pr652-mount-deny-cli-ci-green' DETERMINISTICALLY overran its handler budget (rc=124 at the wall, elapsed=2400s ≈ handler-budget=2400s). It does not fit in a single claim-scoped handler and will be POISONED after GARDEN_REAP_OVERRUN_THRESHOLD (2) cycles without completing. Same root cause as an over-large declared handler-timeout, but under the default budget it gets no early signal — surfaced here so you don't have to reverse-engineer it from the reaper's generic poison report. Remedy: SPLIT it into claim-sized stages, or run it DETACHED outside the claim-scoped handler.

- `20260710T014722Z-82612e` — from watchdog:gardener/6, reply_to `?` · [open message](https://github.com/kriskowal/garden/blob/journal2/inbox/maintainer/unread/20260710T014722Z-82612e.md)

> gardener job 'shepherd-endo-but-for-bots-pr654-mount-glob-rust-parity-ci-green' DETERMINISTICALLY overran its handler budget (rc=124 at the wall, elapsed=2400s ≈ handler-budget=2400s). It does not fit in a single claim-scoped handler and will be POISONED after GARDEN_REAP_OVERRUN_THRESHOLD (2) cycles without completing. Same root cause as an over-large declared handler-timeout, but under the default budget it gets no early signal — surfaced here so you don't have to reverse-engineer it from the reaper's generic poison report. Remedy: SPLIT it into claim-sized stages, or run it DETACHED outside the claim-scoped handler.

- `20260710T021754Z-9348e3` — from gardener:build-endo-but-for-bots-daemon-locator-terminology, reply_to `build-endo-but-for-bots-daemon-locator-terminology` · [open message](https://github.com/kriskowal/garden/blob/journal2/inbox/maintainer/unread/20260710T021754Z-9348e3.md)

> Re: build-endo-but-for-bots-daemon-locator-terminology (design daemon-locator-terminology.md, M3/S)
>
> This design is ALREADY IMPLEMENTED AND MERGED on endojs/endo-but-for-bots @ llm — there is no fresh feature to build, and opening a "fresh feature PR" would be an empty/duplicate PR. I did NOT open one.
>
> Already landed (commits 5bd2f09d69 "locator scheme with @-delimited connection hints (closes #34)" and 24b8dcb688 "align locator hint terminology"):
>   • New terminology types in types.d.ts: PeerKey, FormulaAddress, FormulaKey, ConnectionHint, PeerLocator, FormulaLocator
>   • New endo:// locator format with @-delimited connection hints (locator.js): parseLocator returns hints; formatLocatorWithHints; hintsFromLocator; internalizeLocator/externalizeId
>   • locateWithHints fully wired (host.js, interfaces.js, types.d.ts, help.md, help-text-data.js)
>   • directory.locate() already returns a locator WITH hints; isLocalKey plumbed into directory
>   • Comprehensive locator.test.js covering the design's locator test-plan (parse/format round-trip, URL-encoded @ // hints, externalize/internalize local+remote round-trips)
>
> NOT implemented — and I believe intentionally out of scope for this size-S job:
>   • The "LOCAL_NODE Normalization" section (sentinel-based STORAGE, repairIds startup DB-repair pass, normalizeId, internalizeLocator taking isLocalKey to fold local keys → LOCAL_NODE, externalizeId replacing LOCAL_NODE → agentKey). The LOCAL_NODE sentinel exists in locator.js but storage still uses real node numbers; there is no repairIds/normalizeId anywhere in src/. This is a large, high-risk core-identity + on-disk migration — not size-S — and the design says it "builds on daemon-256-bit-identifiers.md", so it reads as a separate/later phase.
>
> Recommendation: mark this design Complete/Landed (terminology + locator format shipped via #34), and if the LOCAL_NODE storage-normalization phase is actually wanted, post it as a SEPARATE, larger job (M-sized) rather than folding it in here. Tell me which and I'll proceed.

- `20260710T040650Z-22e8fc` — from watchdog:gardener/4, reply_to `?` · [open message](https://github.com/kriskowal/garden/blob/journal2/inbox/maintainer/unread/20260710T040650Z-22e8fc.md)

> gardener job 'gauntlet-endo-but-for-bots-pr655-mount-grep' DETERMINISTICALLY overran its handler budget (rc=124 at the wall, elapsed=2400s ≈ handler-budget=2400s). It does not fit in a single claim-scoped handler and will be POISONED after GARDEN_REAP_OVERRUN_THRESHOLD (2) cycles without completing. Same root cause as an over-large declared handler-timeout, but under the default budget it gets no early signal — surfaced here so you don't have to reverse-engineer it from the reaper's generic poison report. Remedy: SPLIT it into claim-sized stages, or run it DETACHED outside the claim-scoped handler.

- `20260710T041312Z-0793d4` — from watchdog:gardener/16, reply_to `?` · [open message](https://github.com/kriskowal/garden/blob/journal2/inbox/maintainer/unread/20260710T041312Z-0793d4.md)

> gardener job 'gauntlet-endo-but-for-bots-pr659-module-loading-stack-sequencing' DETERMINISTICALLY overran its handler budget (rc=124 at the wall, elapsed=2400s ≈ handler-budget=2400s). It does not fit in a single claim-scoped handler and will be POISONED after GARDEN_REAP_OVERRUN_THRESHOLD (2) cycles without completing. Same root cause as an over-large declared handler-timeout, but under the default budget it gets no early signal — surfaced here so you don't have to reverse-engineer it from the reaper's generic poison report. Remedy: SPLIT it into claim-sized stages, or run it DETACHED outside the claim-scoped handler.

- `20260710T043251Z-0d4df5` — from gardener:gauntlet-endo-but-for-bots-pr644-git-commit-amend-reword, reply_to `gauntlet-endo-but-for-bots-pr644-git-commit-amend-reword` · [open message](https://github.com/kriskowal/garden/blob/journal2/inbox/maintainer/unread/20260710T043251Z-0d4df5.md)

> Gauntlet on endojs/endo-but-for-bots #644 (feat/git commit amend + reword): CONCURRENCY NOTE + panel result.
>
> While I ran the code panel, the PR OWNER's own fleet (0xpatrickbot) was actively pushing fixer commits to the same branch (two landed at 04:24-04:25Z, ~7 min after I claimed the job). So TWO fleets are on #644 concurrently. To avoid racing a branch another fleet is rewriting, I did NOT push my own fixer commits and did NOT un-draft.
>
> Panel verdict: request-changes, posted as a formal review on head fd54abba9 (CHANGES_REQUESTED). It confirmed the 6 prior-round must-fixes are resolved, and found ONE new correctness bug their prior panel missed:
>
>   reword('HEAD', msg) fast-path (packages/git/src/native-git-backend.js:2260) runs `git commit --amend -m` with no pathspec, so a staged index is silently folded into the "message-only" reworded commit — violating the tool's "keeps its patch unchanged" contract on a model-facing history-rewrite surface. Reproduced directly (staged file changes the commit tree). Plus should-fixes: missing rejected-input test, no rebase --abort on failure, changeset omits @endo/agentry, exo-git README omits allowHistoryRewrite.
>
> The fix + un-draft is best left to whichever fleet owns the fix loop. If you want MY fleet to take the fixer + un-draft (coordinating with 0xpatrickbot so we don't double-push), re-post a build/fix job and I or a peer will drive it. Otherwise 0xpatrickbot's active loop will likely address the must-fix and un-draft.

- `20260710T045955Z-ea428a` — from foreman, reply_to `?` · [open message](https://github.com/kriskowal/garden/blob/journal2/inbox/maintainer/unread/20260710T045955Z-ea428a.md)

> Milestone M3's build threads are stalled on merge, not on missing work: the mount chain (#650/#652/#653/#656/#658) and the endoclaw-timer stack (#609/#617/#619) are build-complete and gauntleted but sitting unmerged on the fork's `llm` branch, which blocks every stacked follower (mount-json #657 conflicting on unmerged grep, the git-verb stack #644→#645→#646, and the module-loading builds behind design #659). Please review/merge the ready M3 fork PRs — and/or promote the `go-ahead`-gated next-tranche jobs (endo-gateway/AWS-storage, daemon-rename-to-manager) — so the fleet has unblocked work to claim.

- `20260710T051333Z-6e9180` — from foreman, reply_to `?` · [open message](https://github.com/kriskowal/garden/blob/journal2/inbox/maintainer/unread/20260710T051333Z-6e9180.md)

> M3 (Remote Access and Coding Capabilities) is saturated in flight across all pillars — the next confined-outbound-HTTP slice (live `policyAuthority` wiring for the `tofu-prompt`/`tofu-attenuator` consent modes #661 deferred, designed in `trust-on-first-bind.md`) is blocked on the in-flight http-client PR #661, and every other pillar's next increment (timer #609/#617/#619, gateway #577/#578/#579, mount #655 series) is likewise blocked on in-flight predecessors, so no unblocked build step remains to post. Forward progress now depends on reviewing/merging the ~60-PR ready backlog — a merge/authority decision outside foreman bounds — so the fleet needs merge attention (conductor/maintainer), not more build work queued.

- `20260710T061435Z-6062e0` — from gardener:kriscendobot-agoric-sdk-pr12-fixer, reply_to `kriscendobot-agoric-sdk-pr12-fixer` · [open message](https://github.com/kriskowal/garden/blob/journal2/inbox/maintainer/unread/20260710T061435Z-6062e0.md)

> Fixer for kriscendobot/agoric-sdk PR #12 (XS 16.7.1 / Moddable 5.5.0 mirror of Agoric#11297).
>
> I built xsnap from source locally — `xsnap 0.14.2 (XS 16.7.1)` — and am regenerating the engine-behavior test values. Two of the six red items carry a **within-consensus decision** I want your call on before I touch them; the rest I'm doing deterministically.
>
> **(1) Golden snapshot hashes** — `xsnap.test.js` "produce golden snapshot hashes".
> The XS snapshot binary format changed 11.x → 16.7.1, so the stored ava golden hashes (test/snapshots/xsnap.test.js.{md,snap}) no longer match. The test's OWN docstring warns an engine upgrade needs "special accommodation for the new version, not just generating new golden hashes" — the hash is a within-consensus value tied to Agoric's supported platforms. I can regenerate the hashes mechanically (ava --update-snapshots), but per the docstring that alone is insufficient/possibly wrong.
> QUESTION: For this experimental fork-validation PR, do you want me to (a) regenerate the golden snapshots to unblock CI (documenting that it's a placeholder pending real cross-platform consensus validation), or (b) leave the test failing and mark it as a known consensus-gated item?
>
> **(2) METER_TYPE bump** — `xs-perf.test.js` "meter details".
> Compute/allocate meter accounting changed with the engine. The branch already updated the golden meter counts (compute 1_380_185 → 1_300_705, REDOS 140 → 127, currentHeapCount 103_930 → 104_559) but LEFT `METER_TYPE = 'xs-meter-36'` (api.js) unchanged. The test message literally asks "update METER_TYPE?". Bumping it (xs-meter-36 → -37) is consensus-affecting — it signals changed metering semantics chain-wide.
> QUESTION: Do you want METER_TYPE bumped to xs-meter-37 to accompany the changed meter accounting, or held at -36 for this fork experiment?
>
> I'll proceed now on the non-consensus items (#3 boot-lockdown console detail, #4 inspect output, #5 SwingSet perf characterization, #6 codegen idempotence) and hold #1/#2 for your answer. No upstream agoric/agoric-sdk interaction — fork only.

- `20260710T062415Z-e291a2` — from gardener:finbot-progress-20260710-062011, reply_to `finbot-progress-20260710-062011` · [open message](https://github.com/kriskowal/garden/blob/journal2/inbox/maintainer/unread/20260710T062415Z-e291a2.md)

> finbot progress (cycle 2026-07-10): landed the SES-compartments increment — the design's capability-attenuation safety cornerstone — on kriscendobot/finbot@main.
>
> What advanced:
> - Rebased the completed-but-stranded feat/ses-compartments branch onto main (1 additive conflict in pipeline/index.js, resolved) and fast-forwarded main (bdf67ee → 071c58f): real SES lockdown + @endo/exo Far wallet behind a revocable forwarder + InterfaceGuard, CapTP signing-worker reference path, ambient-authority-denial proofs. Replaces the in-process v0.5 attenuator.
> - 388 tests green; bin/finbot-ooda dry-run still reports walletTouched:false, all 6 auditor invariants PASS. Live executor stays gated (no key/funds wired).
> - Cleaned up two now-redundant branches: deleted feat/ses-compartments (merged) and feat/forecast-eval-fixtures (0-ahead, fully superseded).
>
> Root cause worth a maintainer decision: finbot inherited the garden's "no self-PR, fast-forward main" convention, but nobody is fast-forwarding promptly — so builder branches strand and go stale the moment main advances. Two more green branches are stranded this way and need a rebase before they can land:
> - feat/additional-instruments (multi-instrument portfolios + yield-bearing legs, +22 tests) — now ~3 behind main.
> - feat/cyclical-forecaster (harmonic seasonal forecaster, +778 lines, big cyclic-CRPS win) — now ~5 behind main.
>
> Next unblocked increment (next cycle): rebase+land feat/additional-instruments (smaller delta). Decision for you: either let builders land finbot increments directly on main (garden-style), or stand up a weaver/conductor sweep to fast-forward branches promptly — otherwise every cycle keeps paying rebase cost on stranding branches.

- `20260710T063539Z-33f87e` — from gardener:kriscendobot-agoric-sdk-pr10-shepherd, reply_to `kriscendobot-agoric-sdk-pr10-shepherd` · [open message](https://github.com/kriskowal/garden/blob/journal2/inbox/maintainer/unread/20260710T063539Z-33f87e.md)

> shepherd on kriscendobot/agoric-sdk PR #10 (docs: beans-v2 design) — the only red check is `test-codegen`, and it is NOT this PR's fault. The PR changes one markdown file (designs/beans-v2-deflation.md); test-codegen fails because `yarn codegen` regenerates packages/orchestration/src/fetched-chain-info.js, a file PR #10 never touches. PR #10 is behind:0 from master, so master itself carries the stale generated file — a global codegen drift.
>
> This is already owned by PR #8 (regen-fetched-chain-info), which is OPEN, non-draft, MERGEABLE, and has test-codegen=SUCCESS. Fixing it inside a docs PR would duplicate PR #8 and create a conflicting generated-file diff — the wrong place.
>
> Recommended: merge PR #8 to master, then refresh (weave) PR #10 so its CI re-runs green. I did not push anything to PR #10 (correct scope). next: liaison (merge #8 is a human/conductor decision).

- `20260710T065145Z-32f978` — from gardener:kriscendobot-agoric-sdk-pr9-shepherd, reply_to `kriscendobot-agoric-sdk-pr9-shepherd` · [open message](https://github.com/kriskowal/garden/blob/journal2/inbox/maintainer/unread/20260710T065145Z-32f978.md)

> shepherd on kriscendobot/agoric-sdk PR #9 (prototype: promote ymax vat to critical, garden#29) — diagnosis, no push made:
>
> The 3 red checks are all base-staleness / environmental, NOT caused by the PR diff:
> - test-codegen: fails on packages/orchestration/src/fetched-chain-info.js drift. That file is unchanged by this PR and is regenerated by fetching the LIVE chain registry (non-deterministic). Upstream fixed it in master commit 88a5a67322 "chore(orchestration): refresh fetched chain info" — which is absent from this PR's base.
> - test-quick (node-old): the failures are in packages/orchestration (3) and packages/portfolio-deploy (1, "upgrade not faked") — both byte-identical to master here; the PR doesn't touch them.
> - test-quick (node-new): cancelled by concurrency, not a real failure.
>
> Root cause: PR #9's base is 503 commits behind upstream/master. The remedy is a rebase/weave onto current master (picks up the chain-info refresh + evolved orchestration/portfolio packages), which is out of shepherd scope and design-consequential on a prototype.
>
> The checks that actually exercise this PR's SwingSet/cosmic-swingset upgrade changes (test-swingset, test-boot, test-cosmic-swingset, test-portfolio-contract) are still PENDING — their verdict isn't in yet.
>
> Recommendation: weave #9 (rebase onto master) if you want it green; otherwise it's a known-stale-base prototype red. I did not push anything to keep the draft clean.

- `20260710T070940Z-d51352` — from gardener:minion-town-endo-root-host-bootstrap, reply_to `minion-town-endo-root-host-bootstrap` · [open message](https://github.com/kriskowal/garden/blob/journal2/inbox/maintainer/unread/20260710T070940Z-d51352.md)

> Builder job `minion-town-endo-root-host-bootstrap` (root-host out-of-band mechanism) — delivered a PR, but LIVE validation is blocked and needs your call.
>
> DONE (PR kriscendobot/minion.town#7, against main):
> - The out-of-band root-host mechanism, transplant-shaped in `src/endo/`:
>   bind/repoint an email→root facet, and promote a guest→its own host. Grounded
>   on the real EndoHost primitives (provideHost/provideGuest/invite consume-once).
> - SSM admin wrapper `deploy/aws/scripts/endo-root-host.sh` (mirrors set-account-role.sh; guard = the endo-daemon socket, not a scope).
> - Design delta: `designs/mcp-endo-guest.md` § 10 (mechanism, ocap guard, sequencing, design deltas discovered).
> - Unit-validated end-to-end vs an in-memory daemon backend: 13/13 tests, typecheck clean.
>
> BLOCKED (why "validate in production" is not in this PR):
> The mechanism presupposes design Gate 2 (endo-daemon.service + CapTP-over-UDS
> control path), which is NOT stood up (no src/endo control path, no daemon unit;
> DEPLOYMENT.md stops at Phase 10). Gate 2 is itself gated behind Gate 1 (Claude ↔
> live MCP — a human/browser OAuth validation) by the design's strict ordering.
> So production validation needs two prerequisite gates first, one of which only
> you (a human at claude.ai + GitHub-federated login) can complete. I also could
> not build a local daemon: the sandbox denies native builds (better-sqlite3/node-gyp).
>
> PROPOSED DECOMPOSITION (orchestration job, serial), for your go-ahead:
>   1. Gate 1 — validate Claude against the live MCP (needs you; a gardener can't).
>   2. Gate 2 — deploy endo-daemon.service + the src/endo control path, incl. the
>      RootHost socket adapter (src/endo/root-host-socket, the seam I left).
>   3. Live-validate THIS mechanism on the box: bind a root, repoint it, promote a
>      guest — recorded evidence (endo list, CLI JSON, app-log sub).
>
> Want me to file that orchestration job now (children parked, orchestrator serial),
> or will you drive Gate 1 first and have me pick up Gate 2 after? PR #7 is
> reviewable on its own merits meanwhile.

- `20260710T080657Z-b2a12b` — from watchdog:self-heal-claude, reply_to `?` · [open message](https://github.com/kriskowal/garden/blob/journal2/inbox/maintainer/unread/20260710T080657Z-b2a12b.md)

> self-heal: garden-triager@kriscendobot-agoric-sdk exited rc=1 with no scoped fix. Capture: 2f131b35374b9b62693863cfc7998cf9bcbfdfba (git -C /home/kris/garden/.garden-state/self-heal/journal cat-file -p 2f131b35374b9b62693863cfc7998cf9bcbfdfba). Diagnosis: You've hit your session limit · resets 9:10am (UTC)

- `20260710T080904Z-9ec7b5` — from watchdog:foreman, reply_to `?` · [open message](https://github.com/kriskowal/garden/blob/journal2/inbox/maintainer/unread/20260710T080904Z-9ec7b5.md)

> garden-foreman's pump handler (/home/kris/garden/scripts/jobs/handlers/foreman-claude.sh) failed rc=1 on endolin-garden-ece02cb4; the board pump is starving. stderr tail: /home/kris/garden/scripts/jobs/handlers/foreman-claude.sh: line 92: designer: command not found
> /home/kris/garden/scripts/jobs/handlers/foreman-claude.sh: line 92: builder: command not found
> <6>08:09:04 [foreman-claude] usage-meter: claude exited rc=1; usage not recorded

- `20260710T083558Z-403210` — from watchdog:self-heal-claude, reply_to `?` · [open message](https://github.com/kriskowal/garden/blob/journal2/inbox/maintainer/unread/20260710T083558Z-403210.md)

> self-heal: garden-triager@kriscendobot-endo exited rc=1 with no scoped fix. Capture: 0c1602929aab473ba431caa511022045f934b02b (git -C /home/kris/garden/.garden-state/self-heal/journal cat-file -p 0c1602929aab473ba431caa511022045f934b02b). Diagnosis: You've hit your session limit · resets 9:10am (UTC)

- `20260710T094650Z-557e87` — from gardener:xst-validation-orchestrator-20260710-083510, reply_to `xst-validation-orchestrator-20260710-083510` · [open message](https://github.com/kriskowal/garden/blob/journal2/inbox/maintainer/unread/20260710T094650Z-557e87.md)

> XS-validation effort (kriskowal/garden#33) is now blocked on two decisions only you can make; everything else is green.
>
> 1. **Gauntlet Leg 4 (`force:integration`) is infeasible on the fork as provisioned.** The fork's integration.yml jobs all target Depot cloud runners (upstream-Agoric-org-only; fork OIDC maps to no Depot project — verified empirically, run 29082957968, cancelled + label removed), and the gardener container has no docker for a local a3p run. Options: (a) connect kriscendobot/agoric-sdk to a Depot org, (b) provide a docker-capable host for local a3p-integration, or (c) waive Leg 4, accepting the already-green package-suite substitute. Evidence: journal2:jobs/tada/xst-force-integration.md and PR #13 comment issuecomment-4933929249.
>
> 2. **Park-on-fail "landed" call.** Draft fork PR kriscendobot/agoric-sdk#14 (kernel-first slice, 34/34 tests green) is up, with named remainders (panic→park detection hook, critical-vat policy). Does the current slice count as "landed" for the effort's done-check, or should the remainders (or a subset) be built first?
>
> State otherwise: both engine trains (legacy XS 13.3.0 / latest XS 16.7.1) validated at the package level on xst/integrate-variant-bump (fork PR #13) — snapshot goldens byte-stable, transcript replay zero-divergence, A/B divergence harness clean, variant-gated test lane landed. Full log on issue #33 (latest: issuecomment-4934079088). Upstream Agoric/agoric-sdk untouched. Reply routes to my inbox; the hourly orchestrator will act on your answers.

- `20260710T095715Z-c160a6` — from foreman, reply_to `?` · [open message](https://github.com/kriskowal/garden/blob/journal2/inbox/maintainer/unread/20260710T095715Z-c160a6.md)

> Milestone M3 (Remote Access and Coding Capabilities): the fleet has no unblocked build work because the active daemon-mount stack (`endojs/endo-but-for-bots` #650, #653, #655, #657, #658), the endoclaw-timer stack (#609, #617, #619), and daemon-agent-tools #618 are all CI-green and MERGEABLE but unmerged, and the next phases can only be built atop them. Decision needed: review and merge (or request changes on) that ready M3 stack so subsequent phases become buildable — the remaining M3 threads (gateway, Docker self-host) are maintainer-paced and not fleet-dispatchable.

- `20260710T110104Z-0ab1cf` — from watchdog:gardener/15, reply_to `?` · [open message](https://github.com/kriskowal/garden/blob/journal2/inbox/maintainer/unread/20260710T110104Z-0ab1cf.md)

> gardener job 'kriscendobot-agoric-sdk-pr13-fix-chaininfo-snapshots' DETERMINISTICALLY overran its handler budget (rc=124 at the wall, elapsed=2400s ≈ handler-budget=2400s). It does not fit in a single claim-scoped handler and will be POISONED after GARDEN_REAP_OVERRUN_THRESHOLD (2) cycles without completing. Same root cause as an over-large declared handler-timeout, but under the default budget it gets no early signal — surfaced here so you don't have to reverse-engineer it from the reaper's generic poison report. Remedy: SPLIT it into claim-sized stages, or run it DETACHED outside the claim-scoped handler.

- `poison-gauntlet-endo-but-for-bots-pr661-agent-tools-http-client-requeue-exhausted` — from reaper:endolin-garden-ece02cb4, reply_to `?` · [open message](https://github.com/kriskowal/garden/blob/journal2/inbox/maintainer/unread/poison-gauntlet-endo-but-for-bots-pr661-agent-tools-http-client-requeue-exhausted.md)

> POISON job PARKED in jobs/plan/ (held, gate=go-ahead) after 5 requeue cycles on endolin-garden-ece02cb4.
> Its handler appears to fail every time; the reaper stopped requeueing it.
> The work is preserved at jobs/plan/gauntlet-endo-but-for-bots-pr661-agent-tools-http-client; it stays HELD until a human promotes it
> (promote-plan.sh gauntlet-endo-but-for-bots-pr661-agent-tools-http-client) or removes it, so nothing is lost.
> Original job base: gauntlet-endo-but-for-bots-pr661-agent-tools-http-client
>
> --- original job body ---
> Run the gauntlet (clean → panel review → fix-loop → un-draft) on endojs/endo-but-for-bots DRAFT PR #661 `feat(daemon): provideHttpClient + makeHttpTool (daemon-agent-tools Phase 3.6)` on base `llm`, advancing the just-built HTTP-client agent tool wiring toward mergeable; the sole remaining red check is the known repo-wide lint projectService ceiling (tracked by #594), so treat that lint failure as pre-existing and out of scope.


## Board
### todo (0)
(none)

### doin (2)
- [`kriscendobot-agoric-sdk-pr13-fix-chaininfo-snapshots`](https://github.com/kriskowal/garden/blob/journal2/jobs/doin/kriscendobot-agoric-sdk-pr13-fix-chaininfo-snapshots.md) — fixer (shepherd→fixer auto-chain) on kriscendobot/agoric-sdk PR #13
- [`kriscendobot-agoric-sdk-pr14-fix-chaininfo-snapshots`](https://github.com/kriskowal/garden/blob/journal2/jobs/doin/kriscendobot-agoric-sdk-pr14-fix-chaininfo-snapshots.md) — fixer on kriscendobot/agoric-sdk PR #14 — regenerate chain-info baggage snaps...

### tada (1705)
- [`self-heal-fix-garden-triager-kriscendobot-agoric-sdk-revparse-verify-guard`](https://github.com/kriskowal/garden/blob/journal2/jobs/tada/self-heal-fix-garden-triager-kriscendobot-agoric-sdk-revparse-verify-guard.md) — Completion report
- [`self-heal-fix-garden-triager-kriscendobot-endo-revparse-verify-cold-start`](https://github.com/kriskowal/garden/blob/journal2/jobs/tada/self-heal-fix-garden-triager-kriscendobot-endo-revparse-verify-cold-start.md) — Completion report
- [`build-endopi-provider-registry-oauth`](https://github.com/kriskowal/garden/blob/journal2/jobs/tada/build-endopi-provider-registry-oauth.md) — Completion report
- [`build-endopi-jsonl-transcript-format`](https://github.com/kriskowal/garden/blob/journal2/jobs/tada/build-endopi-jsonl-transcript-format.md) — Completion report — build-endopi-jsonl-transcript-format
- [`xst-validation-orchestrator-20260710-105007`](https://github.com/kriskowal/garden/blob/journal2/jobs/tada/xst-validation-orchestrator-20260710-105007.md) — **XS-validation orchestrator — tick report (2026-07-10 ~10:55Z, dispatch 10:5...
- … and 1700 more

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
- [`gauntlet-endo-but-for-bots-pr661-agent-tools-http-client`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/gauntlet-endo-but-for-bots-pr661-agent-tools-http-client.md) — _normal_ · ---
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
kriscendobot-agoric-3-proposals kriscendobot-agoric-sdk kriscendobot-cosgov kriscendobot-endo kriscendobot-finbot kriscendobot-minion.town kriscendobot-ocapn kriscendobot-vattr97

## Hosts
- [endolin-garden-ece02cb4](https://github.com/kriskowal/garden/blob/journal2/hosts/endolin-garden-ece02cb4): 20 gardeners
- [endolin-garden2-5bcdff64](https://github.com/kriskowal/garden/blob/journal2/hosts/endolin-garden2-5bcdff64): 20 gardeners
