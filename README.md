# Garden bulletin

_As of 2026-07-02T19:13:10Z_

## Latest

The leader-plane is dark on the current designated leader, endolinbot2, and needs your call: the journal bulletin has been stale since 14:31Z because every leader-only singleton (foreman, scheduler, reaper, bulletin, triager, issue-inbox, orchestrate, and the maintainer-inbox Monitor) is stopped and disabled there. Two threads converge on the same root cause — a `GARDEN` host-identity drift: `/home/kris/.garden` resolves `endolinbot2` while `hostname -s` and the `leader` marker have ping-ponged (6× today), so `is-main-host` has been misreporting FOLLOWER and skipping the singletons. A gardener is holding for your go/no-go on re-running `install-units.sh enable-services` to restore the plane, and flags that the durable fix likely lives at the host-side identity enforcer, not the container. The reaper also dropped **five** garden-infra jobs as poison after five requeue cycles each (the `daemon.js`→`manager.js` rename build, the identity-drift detector, the gardener transient-failure backoff/fleet-brake, issue-inbox git-child reaping, and repo-watcher arm-retry), most colored by the same drift and a Claude quota outage overnight.

On the PR side, a wave of `llm` lint-ceiling shepherds resumed and completed — [#242](https://github.com/endojs/endo-but-for-bots/pull/242), [#306](https://github.com/endojs/endo-but-for-bots/pull/306), [#313](https://github.com/endojs/endo-but-for-bots/pull/313), [#316](https://github.com/endojs/endo-but-for-bots/pull/316), [#318](https://github.com/endojs/endo-but-for-bots/pull/318), [#320](https://github.com/endojs/endo-but-for-bots/pull/320), [#324](https://github.com/endojs/endo-but-for-bots/pull/324), [#581](https://github.com/endojs/endo-but-for-bots/pull/581), [#585](https://github.com/endojs/endo-but-for-bots/pull/585), [#590](https://github.com/endojs/endo-but-for-bots/pull/590), [#592](https://github.com/endojs/endo-but-for-bots/pull/592), and [#593](https://github.com/endojs/endo-but-for-bots/pull/593) — and [#598](https://github.com/endojs/endo-but-for-bots/pull/598) (daemon→manager rename Phase 1) cleared shepherd and weaver, with Phase 2/3 parked behind it. One disposition call needs you: the shepherd on [#301](https://github.com/endojs/endo-but-for-bots/pull/301) found the error-tracing feature already re-landed on `llm` via the merged #58, so it recommends closing #301 as superseded (optionally salvaging two small refactors into a fresh PR). The XS→Rust "endor engine" design is now in flight.

## Parked for maintainer feedback

- [endojs/endo-but-for-bots#101](https://github.com/endojs/endo-but-for-bots/pull/101) — feat(chat): voice input via Web Speech API (waiting 4h)
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

- `20260702T191042Z-bd932e` — from gardener:fix-stale-bulletin-leader-singleton, reply_to `fix-stale-bulletin-leader-singleton` · [open message](https://github.com/kriskowal/garden/blob/journal2/inbox/maintainer/unread/20260702T191042Z-bd932e.md)

> ESCALATION (job fix-stale-bulletin-leader-singleton, gardener on endolinbot2, 2026-07-02T19:10Z)
>
> **TL;DR** The journal bulletin (journal/README.md) has been stale since 14:31:58Z
> because the ENTIRE leader-only singleton plane is down on the current designated
> leader host — which is now THIS host (endolinbot2). Restoring it needs a
> re-enable + start of the leader units (an out-of-autonomous-scope fleet action),
> so I'm asking for your go/no-go rather than doing it myself.
>
> **Identity — the job's "contested point" is now RESOLVED, self-consistent on endolinbot2:**
> - leader marker = `endolinbot2` (set 17:37:11Z, "designated by endolinbot2")
> - GARDEN = `endolinbot2` across env, the `systemctl --user` manager, `.garden`,
>   `$GARDEN_STATE/identity-override`, and `environment.d`
> - `is-main-host.sh` returns **LEADER** here; no identity-drift marker present.
> (The marker has ping-ponged 6x today; 17:37Z endolinbot2 is the latest.)
>
> **Root cause of the outage (not a bulletin.sh defect):** During the earlier
> 14:34Z "yield to endolinbot" directive, this host STOPPED + DISABLED all its
> leader-only units. Leadership was later re-pointed back to endolinbot2 (17:37Z),
> but the restore step (`install-units.sh enable-services`) was never run. So on the
> designated leader right now:
> - leader-only TIMERS inactive + **disabled**: foreman, scheduler, reaper,
>   deadmail, follow-up, orchestrate
> - garden-bulletin: **disabled** + inactive (last ran 14:34:30Z, then stopped)
> - other continuous singletons (watchman, proxy, mentor, repo-watcher): inactive
> - gardener pool + per-host infra: healthy, running
> The whole leader plane is dark — bulletin staleness is just the visible symptom.
>
> **Recommended remediation (please authorize, or run it yourself):**
> On endolinbot2 (this host):
>   `scripts/jobs/install-units.sh enable-services`
> then start the continuous singletons (`systemctl --user start
> garden-bulletin.service` etc.) — the standard leader stand-up.
>
> **Caveat before you say go:** the host-side identity enforcer (the garden2
> bind-mount provisioner that at 14:28Z force-wrote GARDEN=endolinbot) is the reason
> we yielded in the first place. If it is NOT yet fixed to write `endolinbot2` at
> the host, the singletons will flap the next time it fires and we'll be back here.
> Is that enforcer confirmed fixed? If not, the durable fix is at the host, not in
> the container.
>
> **Questions:**
> 1. Is endolinbot2 the intended leader now (the marker says yes)?
> 2. Authorize me to run `install-units.sh enable-services` + start the continuous
>    singletons on this host — or will you do it?
> 3. Is the host-side garden2 identity enforcer fixed to write endolinbot2?
>
> I'll hold and drain my inbox for your reply.


## Board
### todo (0)
(none)

### doin (3)
- [`daily-progress-summary-20260702-191237`](https://github.com/kriskowal/garden/blob/journal2/jobs/doin/daily-progress-summary-20260702-191237.md) — Daily midnight Pacific progress summary
- [`fix-stale-bulletin-leader-singleton`](https://github.com/kriskowal/garden/blob/journal2/jobs/doin/fix-stale-bulletin-leader-singleton.md) — Fix the stale bulletin (leader-only singleton is not running)
- [`xs2rust-endor-design`](https://github.com/kriskowal/garden/blob/journal2/jobs/doin/xs2rust-endor-design.md) — Design: port XS to Rust ("endor engine") — feasibility, architecture, staged ...

### tada (943)
- [`set-designer-fable-builder-opus-model-policy`](https://github.com/kriskowal/garden/blob/journal2/jobs/tada/set-designer-fable-builder-opus-model-policy.md) — Completion report
- [`reconcile-garden-shard-env-naming`](https://github.com/kriskowal/garden/blob/journal2/jobs/tada/reconcile-garden-shard-env-naming.md) — Completion report
- [`port-xs-to-rust-memory-safe-engine`](https://github.com/kriskowal/garden/blob/journal2/jobs/tada/port-xs-to-rust-memory-safe-engine.md) — Completion report — port-xs-to-rust-memory-safe-engine (supervisor, stage 1)
- [`investigate-missed-pr594-review-detection`](https://github.com/kriskowal/garden/blob/journal2/jobs/tada/investigate-missed-pr594-review-detection.md) — Completion report
- [`formula-inspector-retention-paths-table-v2`](https://github.com/kriskowal/garden/blob/journal2/jobs/tada/formula-inspector-retention-paths-table-v2.md) — Completion report
- … and 938 more

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

### blocked (awaiting an artifact; unblock watcher auto-promotes on completion)
- [`build-daemon-rename-to-manager-phase2`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/build-daemon-rename-to-manager-phase2.md) — awaiting `https://github.com/endojs/endo-but-for-bots/pull/598` · Build: daemon→manager rename Phase 2 (identifier renames)
- [`build-daemon-rename-to-manager-phase3`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/build-daemon-rename-to-manager-phase3.md) — awaiting `build-daemon-rename-to-manager-phase2` · Build: daemon→manager rename Phase 3 (consumer sweep + CHANGELOG + docs)
- [`port-xs-to-rust-memory-safe-engine-s2`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/port-xs-to-rust-memory-safe-engine-s2.md) — awaiting `xs2rust-endor-design` · Fable supervisor: drive the XS→Rust (Endor) port from design to maintainer-re...
- [`resume-lint-ceiling-shepherds`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/resume-lint-ceiling-shepherds.md) — awaiting `https://github.com/endojs/endo-but-for-bots/pull/594` · Resume shepherds for PRs blocked by the endo-but-for-bots lint projectService...

## Watch set
(none)

## Hosts
- [endolinbot](https://github.com/kriskowal/garden/blob/journal2/hosts/endolinbot): 20 gardeners
- [endolinbot2](https://github.com/kriskowal/garden/blob/journal2/hosts/endolinbot2): 20 gardeners
- [main-host](https://github.com/kriskowal/garden/blob/journal2/hosts/main-host): ? gardeners
