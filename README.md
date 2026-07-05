# Garden bulletin

_As of 2026-07-05T23:29:53Z_

## Latest

The identity-drift guard fired three times on this host: `GARDEN=driftname` diverges from `hostname -s=endolinbot` with no recorded override, so `is-main-host` reports FOLLOWER on the true leader and every leader-only singleton (foreman, scheduler, watchers) is being skipped — if this host is meant to lead, correct `/home/kris/.garden` back to `endolinbot` and restart the pool. Two liaison follow-ups also need answers: the `design-streamlined-onboarding` design landed and its § 5 open questions (especially Q2, the security-flavored auto-mode default) gate four build jobs; and the probe for [endo-but-for-bots#595](https://github.com/endojs/endo-but-for-bots/pull/595), published as [endo-but-for-bots#605](https://github.com/endojs/endo-but-for-bots/pull/605), came back with 7 gaps rather than the 5 the job spec paraphrased and no `take`-semantics hazard — the gardener correctly declined to invent it, so a dedicated `take`-semantics analysis would be a fresh probe on your say-so. The board is otherwise near-idle: nothing in todo, two jobs in flight (a scholar ocap-kernel ingest and the stage-3b XS→Rust RegExp/String integration), and 26 PRs remain parked for review, the oldest being [endo#3073](https://github.com/endojs/endo/pull/3073) (`M.choose`, 54d).

## Parked for maintainer feedback

- [endojs/endo-but-for-bots#101](https://github.com/endojs/endo-but-for-bots/pull/101) — feat(chat): voice input via Web Speech API (waiting 3d)
- [endojs/endo-but-for-bots#503](https://github.com/endojs/endo-but-for-bots/pull/503) — feat(immutable-arraybuffer,pass-style): passable byte arrays (freezable TypedArray emulation + byteArray brand check) (waiting 5d)
- [endojs/endo-but-for-bots#403](https://github.com/endojs/endo-but-for-bots/pull/403) — feat(registry-capability): EndoRegistry capability + @registry special name (#358 layer 1) (waiting 6d)
- [endojs/endo-but-for-bots#379](https://github.com/endojs/endo-but-for-bots/pull/379) — fix(ses): cyclic star export with renaming reexport (issue #59) - refresh for #3276 feedback (waiting 9d)
- [endojs/endo#3137](https://github.com/endojs/endo/pull/3137) — feat: support .ts runtime modules via erasable type syntax (waiting 20d)
- [endojs/endo-but-for-bots#182](https://github.com/endojs/endo-but-for-bots/pull/182) — test(ses): isImmutableDataProperty regression for iOS Safari fix (closes #947) (waiting 44d)
- [endojs/endo-but-for-bots#186](https://github.com/endojs/endo-but-for-bots/pull/186) — feat(eventual-send): eager-shim/lazy-main delegate ponyfill (per #175) (waiting 44d)
- [endojs/endo-but-for-bots#266](https://github.com/endojs/endo-but-for-bots/pull/266) — design: opencode comparative analysis + gap-closing raft (endopen) (waiting 46d)
- [endojs/endo-but-for-bots#329](https://github.com/endojs/endo-but-for-bots/pull/329) — docs: introduce spackle, the polyfill+ponyfill race pattern (waiting 46d)
- [endojs/endo#3073](https://github.com/endojs/endo/pull/3073) — feat(patterns): Add `M.choose` (waiting 54d)

_Showing top 10 of 26 parked PRs (ranked by recency + roadmap relevance)._
## Messages to the maintainer

- `20260705T173845Z-99346f` — from liaison:follow-up, reply_to `?` · [open message](https://github.com/kriskowal/garden/blob/journal2/inbox/maintainer/unread/20260705T173845Z-99346f.md)

> The design job `design-streamlined-onboarding` completed. The maintainer should review `designs/streamlined-onboarding.md` and answer its § 5 open questions — especially Q2, the auto-mode default, which is a security-flavored decision. The four § 6 build jobs are gated on that review and should be posted as an orchestration only after you answer.

- `20260705T203815Z-e614d3` — from liaison:follow-up, reply_to `?` · [open message](https://github.com/kriskowal/garden/blob/journal2/inbox/maintainer/unread/20260705T203815Z-e614d3.md)

> On endojs/endo-but-for-bots PR #595 (probe published as PR #605, https://github.com/endojs/endo-but-for-bots/pull/605), the report-back surfaced a spec discrepancy: the job spec paraphrased 5 gaps including a "Gap 5 — destructive one-shot `take` semantics" correctness hazard, but the published probe actually has 7 gaps and no `take`-semantics gap. The gardener correctly did not invent the missing gap. Decision needed: do you specifically want a `take`-semantics analysis? If so, that is a genuinely new probe question rather than a report-back, and I can post it as a fresh probe job on your say-so.

- `20260705T230144Z-12089a` — from identity-drift-guard:endolinbot, reply_to `?` · [open message](https://github.com/kriskowal/garden/blob/journal2/inbox/maintainer/unread/20260705T230144Z-12089a.md)

> kind: error
>
> # Host-identity DRIFT detected (deterministic guard)
>
> **GARDEN=`driftname`** diverges from **hostname -s=`endolinbot`** on this host,
> with NO recorded parallel-pool override (checked GARDEN_IDENTITY_OVERRIDE and
> `/tmp/idg-ubnS9p/state/identity-override`).
>
> GARDEN is the single key every per-host structure hangs off — claim metadata, the
> `hosts/<host>` worker count, the journal index, and the leader/follower
> predicate. An unrecorded divergence silently mislabels all of it (here: up to this
> host's full gardener pool) and disables the leader gate.
>
> **Leader impact:** is-main-host reports FOLLOWER: the leader marker names 'endolinbot' (this host's real hostname -s), but the drifted GARDEN=driftname does not match it — every leader-only singleton is being SKIPPED on the true leader host
>
> **Likely source:** the gitignored per-instance identity file `/home/kris/.garden`
> (common.sh precedence step 2) or an inherited-env `GARDEN`. This is the
> endolinbot2 regression class.
>
> **Fix:** if this host is the leader, correct `/home/kris/.garden` (and any
> inherited `GARDEN`) to `endolinbot` and restart the pool; if this is a
> deliberate parallel pool, record the override in `/tmp/idg-ubnS9p/state/identity-override`
> (or export GARDEN_IDENTITY_OVERRIDE=`driftname`) so this guard stays quiet.
>
> Posted once per distinct drift state by `scripts/jobs/identity-drift-guard.sh`
> (gardener-scaler preflight). It will not repeat until the drift changes or clears.

- `20260705T230150Z-143d1c` — from identity-drift-guard:endolinbot, reply_to `?` · [open message](https://github.com/kriskowal/garden/blob/journal2/inbox/maintainer/unread/20260705T230150Z-143d1c.md)

> kind: error
>
> # Host-identity DRIFT detected (deterministic guard)
>
> **GARDEN=`driftname`** diverges from **hostname -s=`endolinbot`** on this host,
> with NO recorded parallel-pool override (checked GARDEN_IDENTITY_OVERRIDE and
> `/tmp/idg-ubnS9p/state/identity-override`).
>
> GARDEN is the single key every per-host structure hangs off — claim metadata, the
> `hosts/<host>` worker count, the journal index, and the leader/follower
> predicate. An unrecorded divergence silently mislabels all of it (here: up to this
> host's full gardener pool) and disables the leader gate.
>
> **Leader impact:** is-main-host reports FOLLOWER: the leader marker names 'endolinbot' (this host's real hostname -s), but the drifted GARDEN=driftname does not match it — every leader-only singleton is being SKIPPED on the true leader host
>
> **Likely source:** the gitignored per-instance identity file `/home/kris/.garden`
> (common.sh precedence step 2) or an inherited-env `GARDEN`. This is the
> endolinbot2 regression class.
>
> **Fix:** if this host is the leader, correct `/home/kris/.garden` (and any
> inherited `GARDEN`) to `endolinbot` and restart the pool; if this is a
> deliberate parallel pool, record the override in `/tmp/idg-ubnS9p/state/identity-override`
> (or export GARDEN_IDENTITY_OVERRIDE=`driftname`) so this guard stays quiet.
>
> Posted once per distinct drift state by `scripts/jobs/identity-drift-guard.sh`
> (gardener-scaler preflight). It will not repeat until the drift changes or clears.

- `20260705T230156Z-3d08c6` — from identity-drift-guard:endolinbot, reply_to `?` · [open message](https://github.com/kriskowal/garden/blob/journal2/inbox/maintainer/unread/20260705T230156Z-3d08c6.md)

> kind: error
>
> # Host-identity DRIFT detected (deterministic guard)
>
> **GARDEN=`driftname`** diverges from **hostname -s=`endolinbot`** on this host,
> with NO recorded parallel-pool override (checked GARDEN_IDENTITY_OVERRIDE and
> `/tmp/idg-ubnS9p/state/identity-override`).
>
> GARDEN is the single key every per-host structure hangs off — claim metadata, the
> `hosts/<host>` worker count, the journal index, and the leader/follower
> predicate. An unrecorded divergence silently mislabels all of it (here: up to this
> host's full gardener pool) and disables the leader gate.
>
> **Leader impact:** is-main-host reports FOLLOWER: the leader marker names 'endolinbot' (this host's real hostname -s), but the drifted GARDEN=driftname does not match it — every leader-only singleton is being SKIPPED on the true leader host
>
> **Likely source:** the gitignored per-instance identity file `/home/kris/.garden`
> (common.sh precedence step 2) or an inherited-env `GARDEN`. This is the
> endolinbot2 regression class.
>
> **Fix:** if this host is the leader, correct `/home/kris/.garden` (and any
> inherited `GARDEN`) to `endolinbot` and restart the pool; if this is a
> deliberate parallel pool, record the override in `/tmp/idg-ubnS9p/state/identity-override`
> (or export GARDEN_IDENTITY_OVERRIDE=`driftname`) so this guard stays quiet.
>
> Posted once per distinct drift state by `scripts/jobs/identity-drift-guard.sh`
> (gardener-scaler preflight). It will not repeat until the drift changes or clears.


## Board
### todo (0)
(none)

### doin (2)
- [`scholar-ingest-ocap-kernel-comment-fragments-3`](https://github.com/kriskowal/garden/blob/journal2/jobs/doin/scholar-ingest-ocap-kernel-comment-fragments-3.md) — PLAN: scholar — ingest the remaining ocap-kernel kernel-internals comment fra...
- [`xs2rust-endor-build-stage3b-xsre-integration`](https://github.com/kriskowal/garden/blob/journal2/jobs/doin/xs2rust-endor-build-stage3b-xsre-integration.md) — Builder: stage-3b child 9/9 — RegExp built-in + String integration over XSRE,...

### tada (1219)
- [`improve-gardener-memory-confinement`](https://github.com/kriskowal/garden/blob/journal2/jobs/tada/improve-gardener-memory-confinement.md) — What I did
- [`endojs-endo-but-for-bots-pr592-review-2e32890c-retro`](https://github.com/kriskowal/garden/blob/journal2/jobs/tada/endojs-endo-but-for-bots-pr592-review-2e32890c-retro.md) — Completion report
- [`deadmail-20260705T231852Z-f04664`](https://github.com/kriskowal/garden/blob/journal2/jobs/tada/deadmail-20260705T231852Z-f04664.md) — Completion report
- [`endojs-endo-but-for-bots-pr595-review-b3285075-retro`](https://github.com/kriskowal/garden/blob/journal2/jobs/tada/endojs-endo-but-for-bots-pr595-review-b3285075-retro.md) — Completion report
- [`endojs-endo-but-for-bots-pr592-review-9e382ba1-retro`](https://github.com/kriskowal/garden/blob/journal2/jobs/tada/endojs-endo-but-for-bots-pr592-review-9e382ba1-retro.md) — Completion report — endojs-endo-but-for-bots-pr592-review-9e382ba1-retro
- … and 1214 more

## Plan queue (parked — not claimable until promoted)
### awaiting go-ahead (maintainer authorization)
- [`endojs-endo-but-for-bots-pr132-report-render-mode`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr132-report-render-mode.md) — _normal_ · re-port render-mode toggle onto @endo/space-chat InboxRoot (endojs/endo-but-f...
- [`foreman-budget-cross-host-weekly-token-aggregation`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/foreman-budget-cross-host-weekly-token-aggregation.md) — _normal_ · PLAN: deterministic cross-host weekly token-spend aggregation for the foreman...
- [`synth-and-deploy-minion-town-aws`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/synth-and-deploy-minion-town-aws.md) — _normal_ · Synth, wire custom domain, and live-deploy minion.town to AWS
- [`verify-ymax0-hex-fix-inquisitor`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/verify-ymax0-hex-fix-inquisitor.md) — _normal_ · PLAN (go-ahead): verify the ymax0 hex fix and stackCount snapshot-compatibili...

### deferred (top by priority; foreman auto-promotes when idle)
(none)

### blocked (awaiting an artifact; unblock watcher auto-promotes on completion)
- [`build-daemon-rename-to-manager-phase2`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/build-daemon-rename-to-manager-phase2.md) — awaiting `https://github.com/endojs/endo-but-for-bots/pull/598` · Build: daemon→manager rename Phase 2 (identifier renames)
- [`build-daemon-rename-to-manager-phase3`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/build-daemon-rename-to-manager-phase3.md) — awaiting `build-daemon-rename-to-manager-phase2` · Build: daemon→manager rename Phase 3 (consumer sweep + CHANGELOG + docs)
- [`port-xs-to-rust-memory-safe-engine-s7`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/port-xs-to-rust-memory-safe-engine-s7.md) — awaiting `xs2rust-endor-build-stage3b` · Fable supervisor: drive the XS→Rust (Endor) port from design to maintainer-re...
- [`resume-lint-ceiling-shepherds`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/resume-lint-ceiling-shepherds.md) — awaiting `https://github.com/endojs/endo-but-for-bots/pull/594` · Resume shepherds for PRs blocked by the endo-but-for-bots lint projectService...
- [`xs2rust-endor-strings-utf16-arm`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/xs2rust-endor-strings-utf16-arm.md) — awaiting `port-xs-to-rust-memory-safe-engine-s7` · Arm the CESU-8→UTF-16 string-representation revisit (record its orchestration)

## Watch set
(none)

## Hosts
- [endolinbot](https://github.com/kriskowal/garden/blob/journal2/hosts/endolinbot): 20 gardeners
- [endolinbot2](https://github.com/kriskowal/garden/blob/journal2/hosts/endolinbot2): 20 gardeners
- [main-host](https://github.com/kriskowal/garden/blob/journal2/hosts/main-host): ? gardeners
