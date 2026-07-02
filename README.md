# Garden bulletin

_As of 2026-07-02T20:24:24Z_

## Latest

Lead item is a live infrastructure incident, not a PR: a gardener investigating five poisoned garden-infra jobs found that this leader host is silently demoted — `/home/kris/.garden` still reads `endolinbot2` while `hostname -s`, the `leader` marker, and canon all say `endolinbot`, so `is-main-host.sh` returns FOLLOWER and every leader-only singleton (foreman, scheduler, reaper, bulletin, triager, issue-inbox, ci-watcher, orchestrate, and the maintainer-inbox Monitor) is being skipped while all recent gardener entries mislabel per-host state. The fix is operator-only (`echo endolinbot > /home/kris/.garden`, or re-point the marker if `endolinbot2` was intended, then restart the fleet); a sharpened `improve-garden-identity-drift-detector` job was re-posted so the next regression is loud on tick one.

That same drift compounded a Claude quota outage into **five poisoned jobs** the reaper dropped after 5 requeue cycles, now surfaced as maintainer messages: the daemon→manager rename build, the identity drift-detector, a gardener transient-failure backoff + fleet brake, issue-inbox orphan-git reaping, and repo-watcher arm-retry logging — all worth triaging as garden-hardening work.

Two shepherd calls also need a disposition: [endo-but-for-bots#301](https://github.com/endojs/endo-but-for-bots/pull/301) is not lint-blocked but **subsumed** — its entire error-tracing feature already re-landed on `llm` via the merged #58, so a rebase collapses it to near-empty; the shepherd recommends closing it as superseded (optionally extracting its two unique refactors, `error-id.js` and `trace-constants.js`, as a fresh PR). Meanwhile [endo-but-for-bots#599](https://github.com/endojs/endo-but-for-bots/pull/599) went fully green (22/22 checks). On the build side, the XS→Rust (Endor) stage-1 build completed, unblocking its downstream supervisor stage; the daemon→manager rename now proceeds in phases, with Phase 2 blocked on [endo-but-for-bots#598](https://github.com/endojs/endo-but-for-bots/pull/598).

## Parked for maintainer feedback

- [endojs/endo-but-for-bots#101](https://github.com/endojs/endo-but-for-bots/pull/101) — feat(chat): voice input via Web Speech API (waiting 5h)
- [endojs/endo-but-for-bots#503](https://github.com/endojs/endo-but-for-bots/pull/503) — feat(immutable-arraybuffer,pass-style): passable byte arrays (freezable TypedArray emulation + byteArray brand check) (waiting 2d)
- [endojs/endo-but-for-bots#403](https://github.com/endojs/endo-but-for-bots/pull/403) — feat(registry-capability): EndoRegistry capability + @registry special name (#358 layer 1) (waiting 3d)
- [endojs/endo-but-for-bots#379](https://github.com/endojs/endo-but-for-bots/pull/379) — fix(ses): cyclic star export with renaming reexport (issue #59) - refresh for #3276 feedback (waiting 6d)
- [endojs/endo#3137](https://github.com/endojs/endo/pull/3137) — feat: support .ts runtime modules via erasable type syntax (waiting 17d)
- [endojs/endo-but-for-bots#182](https://github.com/endojs/endo-but-for-bots/pull/182) — test(ses): isImmutableDataProperty regression for iOS Safari fix (closes #947) (waiting 41d)
- [endojs/endo-but-for-bots#186](https://github.com/endojs/endo-but-for-bots/pull/186) — feat(eventual-send): eager-shim/lazy-main delegate ponyfill (per #175) (waiting 41d)
- [endojs/endo-but-for-bots#266](https://github.com/endojs/endo-but-for-bots/pull/266) — design: opencode comparative analysis + gap-closing raft (endopen) (waiting 43d)
- [endojs/endo-but-for-bots#288](https://github.com/endojs/endo-but-for-bots/pull/288) — feat(cbor-frame): add @endo/cbor-frame package for CBOR byte-string framing (waiting 42d)
- [endojs/endo-but-for-bots#329](https://github.com/endojs/endo-but-for-bots/pull/329) — docs: introduce spackle, the polyfill+ponyfill race pattern (waiting 42d)

_Showing top 10 of 27 parked PRs (ranked by recency + roadmap relevance)._
## Messages to the maintainer

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

- `20260702T100530Z-a43c17` — from gardener:investigate-poisoned-garden-infra-jobs, reply_to `investigate-poisoned-garden-infra-jobs` · [open message](https://github.com/kriskowal/garden/blob/journal2/inbox/maintainer/unread/20260702T100530Z-a43c17.md)

> LIVE INCIDENT surfaced while investigating the 5 poisoned garden-infra jobs
> (job investigate-poisoned-garden-infra-jobs): the endolinbot2 host-identity drift
> is still active on the leader host and is silently disabling the leader.
>
>   /home/kris/.garden  ->  "endolinbot2"
>   hostname -s         ->  "endolinbot"
>   journal/leader      ->  "endolinbot"
>   is-main-host.sh     ->  exit 1 (FOLLOWER)
>
> Because common.sh reads .garden (identity precedence step 2) it resolves
> GARDEN=endolinbot2, so is-main-host compares endolinbot2 != leader(endolinbot) and
> reports FOLLOWER on the true leader host. Every leader-only singleton (foreman,
> scheduler, reaper, bulletin, triager, issue-inbox, ci-watcher, orchestrate, and the
> maintainer-inbox Monitor) is being SKIPPED here. All 276 recent gardener journal
> entries key host: endolinbot2, mislabeling per-host state.
>
> This same drift was the compounding factor behind the 5 poisonings (during the
> 2026-07-01T00:26-00:50Z / 07-02T01:20-01:45Z Claude quota outage; see the result
> entry). The existing gardener.sh:98 spawn WARN and gardener-scaler reconcile-identity
> do NOT catch it because a .garden-FILE override makes every worker resolve
> endolinbot2 CONSISTENTLY (their /proc environ agrees), so the inconsistency-based
> reconcile sees no drift.
>
> Requested operational fix (deployed-root state, out of a gardener's autonomous
> scope so I did not touch it): either
>   (a) correct the shard identity  -> `echo endolinbot > /home/kris/.garden`  (if
>       this host is meant to be the single leader shard "endolinbot"), OR
>   (b) if endolinbot2 is the intended identity, re-point the leader marker with
>       set-main-host.sh endolinbot2 and record the parallel-pool override so the
>       spawn WARN silences.
> Then restart the fleet (deploy-restart / re-exec) so workers pick up the corrected
> GARDEN and is-main-host flips to leader.
>
> I re-posted the improve-garden-identity-drift-detector job (sharpened) so the NEXT
> regression is loud on tick 1 as a kind:error, but that detector cannot fix the
> already-live .garden value.

- `20260702T100825Z-a5961c` — from gardener:endojs-endo-but-for-bots-pr301-shepherd-llm-resume, reply_to `endojs-endo-but-for-bots-pr301-shepherd-llm-resume` · [open message](https://github.com/kriskowal/garden/blob/journal2/inbox/maintainer/unread/20260702T100825Z-a5961c.md)

> shepherd #301 (llm lint-ceiling resume) — finding: PR #301 is SUBSUMED, not lint-blocked.
>
> Re-fetched live: #301 is OPEN, base=llm, head=kriskowal-error-trace, mergeable=CONFLICTING/DIRTY.
> Rebasing onto current origin/llm reveals the real blocker is NOT the typescript-eslint ceiling
> (that fix is present on llm) — it's that the ENTIRE error-tracing feature #301 implements has
> already been independently re-landed on llm via:
>   e50be0b0c  feat(daemon,cli): error tracing across CapTP workers (#1879) (#58)
>   + 3b411aa25 marshal hooks, 48bf20f2d captp forwarding, bbc997dee daemon aggregator, etc.
>
> Evidence during rebase onto origin/llm:
>   - commit 66d6abc9 (marshal: add marshalLoadError hook) auto-SKIPPED as "already applied";
>   - packages/captp/src/captp.js conflict resolved trivially (llm already forwards the hooks);
>   - packages/daemon/src/trace-aggregator.js + its test: add/add conflicts — llm's copy is
>     near-identical to #301's (470 vs 463 lines; diff is 5+/12-, i.e. 17 lines total).
>
> So a rebase-and-green would try to re-introduce an already-merged feature and collapses to an
> essentially empty PR. This is out of shepherd scope and out of a mechanical fixer's scope too —
> it's a disposition call.
>
> Unique to #301 over llm (NOT on llm): two later refactor commits' artifacts —
>   packages/daemon/src/error-id.js (dedup of recordInboundErrorId/extractErrorId helpers, +115),
>   packages/daemon/src/trace-constants.js (DAEMON_WORKER_ID / networkWorkerId sentinels).
> Everything else is duplicated.
>
> Recommendation: CLOSE #301 as superseded by the merged #58 error-tracing feature. If you want the
> two small refactors (shared error-id module + trace-constants sentinels) applied on top of llm's
> merged implementation, that's a fresh small builder/fixer PR against llm, not a rebase of #301.
>
> I did not push anything and left #301 untouched (no comment authorization on this job). Awaiting
> your call: close #301, or open a fresh refactor PR extracting error-id.js/trace-constants.js?


## Board
### todo (0)
(none)

### doin (2)
- [`improve-ci-rollup-gh-pr-view-transient-retry`](https://github.com/kriskowal/garden/blob/journal2/jobs/doin/improve-ci-rollup-gh-pr-view-transient-retry.md) — Route the single-shot gh pr view "$pr" -R "$repo" --json state,statusCheckRol...
- [`improve-clone-keeper-missing-clone-escalation`](https://github.com/kriskowal/garden/blob/journal2/jobs/doin/improve-clone-keeper-missing-clone-escalation.md) — In scripts/jobs/clone-keeper.sh, keep_clone currently logs WARN: tracked clon...

### tada (956)
- [`xs2rust-endor-build-stage1`](https://github.com/kriskowal/garden/blob/journal2/jobs/tada/xs2rust-endor-build-stage1.md) — The job is complete. PR #600 is still draft, the stage-1 status section (with...
- [`improve-clone-keeper-self-heal-missing-clone`](https://github.com/kriskowal/garden/blob/journal2/jobs/tada/improve-clone-keeper-self-heal-missing-clone.md) — Completion report
- [`endojs-endo-but-for-bots-pr599-shepherd`](https://github.com/kriskowal/garden/blob/journal2/jobs/tada/endojs-endo-but-for-bots-pr599-shepherd.md) — All 22 checks pass — CI is fully green on head 478b17e7e.
- [`improve-ci-rollup-transient-network-retry`](https://github.com/kriskowal/garden/blob/journal2/jobs/tada/improve-ci-rollup-transient-network-retry.md) — Completion report
- [`port-xs-to-rust-memory-safe-engine-s2`](https://github.com/kriskowal/garden/blob/journal2/jobs/tada/port-xs-to-rust-memory-safe-engine-s2.md) — Everything is in place — the builder job is already claimed by a gardener (do...
- … and 951 more

## Plan queue (parked — not claimable until promoted)
### awaiting go-ahead (maintainer authorization)
- [`endojs-endo-but-for-bots-pr132-report-render-mode`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr132-report-render-mode.md) — _normal_ · re-port render-mode toggle onto @endo/space-chat InboxRoot (endojs/endo-but-f...
- [`foreman-budget-cross-host-weekly-token-aggregation`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/foreman-budget-cross-host-weekly-token-aggregation.md) — _normal_ · PLAN: deterministic cross-host weekly token-spend aggregation for the foreman...
- [`synth-and-deploy-minion-town-aws`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/synth-and-deploy-minion-town-aws.md) — _normal_ · Synth, wire custom domain, and live-deploy minion.town to AWS
- [`verify-ymax0-hex-fix-inquisitor`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/verify-ymax0-hex-fix-inquisitor.md) — _normal_ · PLAN (go-ahead): verify the ymax0 hex fix and stackCount snapshot-compatibili...

### deferred (top by priority; foreman auto-promotes when idle)
- [`reconcile-claude-md-with-v2-tree`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/reconcile-claude-md-with-v2-tree.md) — _normal_ · Reconcile CLAUDE.md with the v2 tree (drift found during the README rewrite)
- [`bot-email-dedicated-domain-counter-plan-aws-hetzner`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/bot-email-dedicated-domain-counter-plan-aws-hetzner.md) — _low_ · PLAN (low priority, counter-plan to FastMail-masking): bot-driven email on a ...
- [`fix-lint-jsdoc-warnings-endo-master`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/fix-lint-jsdoc-warnings-endo-master.md) — _low_ · SUPERSEDED — fix-lint: jsdoc warnings on endo master
- [`investigate-fastmail-masked-email-api-for-bot-personas`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/investigate-fastmail-masked-email-api-for-bot-personas.md) — _low_ · PLAN (low priority, investigate): FastMail masked-email API for bot persona m...
- [`scholar-ingest-ocap-kernel-comment-fragments-2`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/scholar-ingest-ocap-kernel-comment-fragments-2.md) — _low_ · PLAN: scholar — ingest the remaining ocap-kernel kernel-internals comment fra...
- [`endojs-endo-but-for-bots-pr101-shepherd-llm-resume`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr101-shepherd-llm-resume.md) — _low_ · shepherd on endojs/endo-but-for-bots PR #101 (PARKED from doin — churn/near-p...
- [`endojs-endo-but-for-bots-pr588-shepherd-llm-resume`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr588-shepherd-llm-resume.md) — _low_ · shepherd on endojs/endo-but-for-bots PR #588 (PARKED from doin — churn/near-p...
- [`scheduler-timezone-anchored-cadence`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/scheduler-timezone-anchored-cadence.md) — _low_ · design/build: timezone-anchored scheduler cadence (fix daily-progress-summary...

### blocked (awaiting an artifact; unblock watcher auto-promotes on completion)
- [`build-daemon-rename-to-manager-phase2`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/build-daemon-rename-to-manager-phase2.md) — awaiting `https://github.com/endojs/endo-but-for-bots/pull/598` · Build: daemon→manager rename Phase 2 (identifier renames)
- [`build-daemon-rename-to-manager-phase3`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/build-daemon-rename-to-manager-phase3.md) — awaiting `build-daemon-rename-to-manager-phase2` · Build: daemon→manager rename Phase 3 (consumer sweep + CHANGELOG + docs)
- [`port-xs-to-rust-memory-safe-engine-s3`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/port-xs-to-rust-memory-safe-engine-s3.md) — awaiting `xs2rust-endor-build-stage1` · Fable supervisor: drive the XS→Rust (Endor) port from design to maintainer-re...
- [`resume-lint-ceiling-shepherds`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/resume-lint-ceiling-shepherds.md) — awaiting `https://github.com/endojs/endo-but-for-bots/pull/594` · Resume shepherds for PRs blocked by the endo-but-for-bots lint projectService...

## Watch set
(none)

## Hosts
- [endolinbot](https://github.com/kriskowal/garden/blob/journal2/hosts/endolinbot): 20 gardeners
- [endolinbot2](https://github.com/kriskowal/garden/blob/journal2/hosts/endolinbot2): 20 gardeners
- [main-host](https://github.com/kriskowal/garden/blob/journal2/hosts/main-host): ? gardeners
