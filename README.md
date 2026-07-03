# Garden bulletin

_As of 2026-07-03T02:54:17Z_

## Latest

An operational alarm tops this cycle: a gardener investigating five poisoned garden-infra jobs [surfaced a live host-identity drift](https://github.com/kriskowal/garden/blob/journal2/inbox/maintainer/unread/20260702T100530Z-a43c17.md) on the leader host — `/home/kris/.garden` resolves `endolinbot2` while `journal/leader` names `endolinbot`, so `is-main-host.sh` reports FOLLOWER on the true leader and every leader-only singleton (foreman, scheduler, reaper, bulletin, triager, ci-watcher, orchestrate, maintainer-inbox Monitor) is being silently skipped. This same drift compounded the five poisonings during the 07-01/07-02 Claude quota outage. The fix is deployed-root state out of a gardener's scope and needs the maintainer: either `echo endolinbot > /home/kris/.garden` or re-point the marker with `set-main-host.sh endolinbot2`, then restart the fleet.

Two dispositions also await your call. Shepherd on [endo-but-for-bots#301](https://github.com/endojs/endo-but-for-bots/pull/301) found the PR is subsumed, not lint-blocked — its entire CapTP error-tracing feature already re-landed on `llm` via the merged #58, so a rebase collapses to an essentially empty PR; the recommendation is to CLOSE as superseded, optionally extracting the two unique refactors (`error-id.js`, `trace-constants.js`) as a fresh PR. On [endo-but-for-bots#472](https://github.com/endojs/endo-but-for-bots/pull/472), gibson042 reviewed the freezable-TypedArray design doc and rebutted all three "Why not a Proxy wrapper?" arguments, asking you and @erights to weigh in on whether the emulated view should throw on canonical-index writes.

Meanwhile the XS→Rust (Endor) port advanced: stage 2b (2/3) frames/closures/user-functions completed, stage 2b (3/3) exceptions is now in progress, and a press check-in landed for [#600](https://github.com/endojs/endo-but-for-bots/pull/600).

## Parked for maintainer feedback

- [endojs/endo-but-for-bots#101](https://github.com/endojs/endo-but-for-bots/pull/101) — feat(chat): voice input via Web Speech API (waiting 12h)
- [endojs/endo-but-for-bots#503](https://github.com/endojs/endo-but-for-bots/pull/503) — feat(immutable-arraybuffer,pass-style): passable byte arrays (freezable TypedArray emulation + byteArray brand check) (waiting 2d)
- [endojs/endo-but-for-bots#403](https://github.com/endojs/endo-but-for-bots/pull/403) — feat(registry-capability): EndoRegistry capability + @registry special name (#358 layer 1) (waiting 3d)
- [endojs/endo-but-for-bots#379](https://github.com/endojs/endo-but-for-bots/pull/379) — fix(ses): cyclic star export with renaming reexport (issue #59) - refresh for #3276 feedback (waiting 6d)
- [endojs/endo#3137](https://github.com/endojs/endo/pull/3137) — feat: support .ts runtime modules via erasable type syntax (waiting 17d)
- [endojs/endo-but-for-bots#182](https://github.com/endojs/endo-but-for-bots/pull/182) — test(ses): isImmutableDataProperty regression for iOS Safari fix (closes #947) (waiting 42d)
- [endojs/endo-but-for-bots#186](https://github.com/endojs/endo-but-for-bots/pull/186) — feat(eventual-send): eager-shim/lazy-main delegate ponyfill (per #175) (waiting 42d)
- [endojs/endo-but-for-bots#266](https://github.com/endojs/endo-but-for-bots/pull/266) — design: opencode comparative analysis + gap-closing raft (endopen) (waiting 43d)
- [endojs/endo-but-for-bots#288](https://github.com/endojs/endo-but-for-bots/pull/288) — feat(cbor-frame): add @endo/cbor-frame package for CBOR byte-string framing (waiting 42d)
- [endojs/endo-but-for-bots#329](https://github.com/endojs/endo-but-for-bots/pull/329) — docs: introduce spackle, the polyfill+ponyfill race pattern (waiting 43d)

_Showing top 10 of 27 parked PRs (ranked by recency + roadmap relevance)._
## Messages to the maintainer

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

- `20260702T223440Z-5b9cb3` — from gardener:endojs-endo-but-for-bots-pr472-review-72d18f86, reply_to `endojs-endo-but-for-bots-pr472-review-72d18f86` · [open message](https://github.com/kriskowal/garden/blob/journal2/inbox/maintainer/unread/20260702T223440Z-5b9cb3.md)

> DESIGN DECISION NEEDED — endojs/endo-but-for-bots PR #472 (freezable-TypedArray design doc)
>
> @gibson042 submitted review 4621538762 (one inline comment, id 3516427461) on
> packages/immutable-arraybuffer/designs/freezable-typedarray.md, and closed it with:
> "I'd like @kriskowal and/or @erights to weigh in here as well."
>
> This is a genuine design tradeoff that needs your call — a bot should not decide it.
> No code/doc change was made; nothing was pushed. The PR thread already has gibson's
> comment and @-mentions you both, so you can reply there directly.
>
> CONTEXT: The doc's section "Why not a Proxy wrapper?" gives three reasons for keeping
> the emulated view a plain ordinary object (so integer-indexed assignment silently
> creates a wrapper-local own property rather than throwing). gibson042 rebuts all three
> and argues for a Proxy `set` trap that rejects canonical-numeric-index writes:
>
> 1. Freezability risk (Object.freeze on a Proxy runs traps under proxy invariants).
>    gibson: "I do not believe this is a practical risk; we know exactly how to write
>    such a proxy (basically pass-through except for property keys that are canonical
>    numeric indices)."
> 2. Cost (Proxy taxes the integer-indexed hot path).
>    gibson: only bites where the shim is needed (no native immutable ArrayBuffer) AND
>    only on paths that do many direct indexed reads instead of using @endo/bytes
>    helpers (bytesFromImmutable/bytesEqual) — which we're actively avoiding anyway. He
>    prefers defaulting to correctness and providing mitigations for perf degradation.
> 3. "Throwing write is a nicety, not a safety property."
>    gibson: it's more than a nicety — not throwing risks silently masking real bugs
>    (our code runs strict mode; nothing verifies a non-exceptional property set had its
>    ostensible effect).
>
> Decision options: (a) keep the plain-object wrapper as designed; (b) switch the
> emulated view to a Proxy that throws on canonical-index writes; (c) something in
> between. Once you decide, I (or a fixer) can update the design doc's "Why not a Proxy"
> section and the shim accordingly. Reply here or on the PR thread.


## Board
### todo (0)
(none)

### doin (2)
- [`improve-clone-keeper-selfheal-missing-bare-clone`](https://github.com/kriskowal/garden/blob/journal2/jobs/doin/improve-clone-keeper-selfheal-missing-bare-clone.md) — Harden scripts/jobs/clone-keeper.sh so a *missing* tracked bare clone self-he...
- [`xs2rust-endor-build-stage2b-exceptions`](https://github.com/kriskowal/garden/blob/journal2/jobs/doin/xs2rust-endor-build-stage2b-exceptions.md) — Builder: xs2rust-endor stage 2b (3/3) — exceptions, full opcode coverage, sta...

### tada (993)
- [`xs2rust-endor-press-20260703-025032`](https://github.com/kriskowal/garden/blob/journal2/jobs/tada/xs2rust-endor-press-20260703-025032.md) — Press check-in complete for PR #600 (xs2rust-endor), tick at 02:50Z. This was...
- [`xs2rust-endor-build-stage2b-frames`](https://github.com/kriskowal/garden/blob/journal2/jobs/tada/xs2rust-endor-build-stage2b-frames.md) — Completion report — xs2rust-endor stage 2b (2/3): user functions, closures, m...
- [`improve-clone-keeper-recreate-missing-clone`](https://github.com/kriskowal/garden/blob/journal2/jobs/tada/improve-clone-keeper-recreate-missing-clone.md) — Completion report
- [`improve-gardener-single-deadline-overrun-note`](https://github.com/kriskowal/garden/blob/journal2/jobs/tada/improve-gardener-single-deadline-overrun-note.md) — Completion report
- [`deadmail-issue-comment-4871521636`](https://github.com/kriskowal/garden/blob/journal2/jobs/tada/deadmail-issue-comment-4871521636.md) — Completion report
- … and 988 more

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
- [`port-xs-to-rust-memory-safe-engine-s5`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/port-xs-to-rust-memory-safe-engine-s5.md) — awaiting `xs2rust-endor-build-stage2b` · Fable supervisor: drive the XS→Rust (Endor) port from design to maintainer-re...
- [`resume-lint-ceiling-shepherds`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/resume-lint-ceiling-shepherds.md) — awaiting `https://github.com/endojs/endo-but-for-bots/pull/594` · Resume shepherds for PRs blocked by the endo-but-for-bots lint projectService...

## Watch set
(none)

## Hosts
- [endolinbot](https://github.com/kriskowal/garden/blob/journal2/hosts/endolinbot): 20 gardeners
- [endolinbot2](https://github.com/kriskowal/garden/blob/journal2/hosts/endolinbot2): 20 gardeners
- [main-host](https://github.com/kriskowal/garden/blob/journal2/hosts/main-host): ? gardeners
