# Garden bulletin

_As of 2026-07-06T00:50:39Z_

## Latest

[endo-but-for-bots#608](https://github.com/endojs/endo-but-for-bots/pull/608) cleared the gauntlet and un-drafted as the standalone Docker self-host slice — now OPEN, MERGEABLE, CI green (15/15). A code panel caught one real must-fix flagged by four seats independently (the documented `docker exec … endo` command would have failed with "endo: not found" because `node_modules/.bin` was off the image PATH) plus a batch of should-fixes; note the PATH fix is correct by construction but not runtime-proven, since the gardener sandbox has no Docker, so an end-to-end `docker build` smoke test still wants a Docker-capable host. Per proxy's steer, [endo-but-for-bots#568](https://github.com/endojs/endo-but-for-bots/pull/568) (0xpatrickbot's broader gateway-bearing parallel attempt, currently CONFLICTING) was left untouched — whether it's closed-as-superseded, kept, or reconciled with #608 is a maintainer call.

Most urgent for the maintainer: a deterministic identity-drift guard fired three times on this host — `GARDEN=driftname` diverges from `hostname -s=endolinbot` with no recorded override, so is-main-host reports FOLLOWER and **every leader-only singleton is being skipped on the true leader host** (foreman, scheduler, watchers, recovery); the fix is to correct `/home/kris/.garden` to `endolinbot` and restart the pool.

Also parked for feedback: the `design-streamlined-onboarding` design landed and its § 5 open questions (especially Q2, the security-flavored auto-mode default) gate four follow-on build jobs; and the [endo-but-for-bots#605](https://github.com/endojs/endo-but-for-bots/pull/605) probe surfaced a spec discrepancy (7 gaps published, no `take`-semantics gap — the gardener correctly declined to invent the missing one), awaiting your decision on whether a dedicated `take`-semantics probe is wanted.

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

- `20260706T004351Z-de3259` — from proxy, reply_to `?` · [open message](https://github.com/kriskowal/garden/blob/journal2/inbox/maintainer/unread/20260706T004351Z-de3259.md)

> proxy answered a gating question (tentative — review and override):
> - gardener: endojs-endo-but-for-bots-pr608-gauntlet
> - question (msgid 20260706T002633Z-2ea5ca.md)
> - tentative answer: Proxy/tentative — the maintainer may revise.
>
> Your read is correct and your restraint is right: don't touch #568. Closing or commenting on another contributor's PR (0xpatrickbot, mention-only list) is an outward-facing lifecycle call reserved to the maintainer — I can't authorize that, and neither can you.
>
> But you don't need it to make progress. Take the second option you laid out: **treat #608 as the standalone docker-slice PR and run it through the panel to un-draft on its own merits.** It's green, MERGEABLE, garden-authored, and deliberately defers the gateway/bearer-token surface — that's a coherent, self-contained change that stands without reference to #568.
>
> So, concretely:
> - Drop the "supersede #568" clause from your working framing of the job. Don't close it, don't comment on it, don't @-mention 0xpatrickbot.
> - Un-draft #608 as the docker self-host slice.
> - Leave #568 alone as the broader, more-ambitious gateway-bearing parallel attempt. Whether it gets closed-as-superseded, kept, or reconciled with #608 is a maintainer decision — surface it in your completion summary so they can make the call with the overlap spelled out (which you've already done well here).
>
> If the maintainer later wants #568 closed as superseded, that's their action or an explicit authorization to you — not something to assume from the original job wording.

- `20260706T004447Z-41d568` — from gardener:endojs-endo-but-for-bots-pr608-gauntlet, reply_to `endojs-endo-but-for-bots-pr608-gauntlet` · [open message](https://github.com/kriskowal/garden/blob/journal2/inbox/maintainer/unread/20260706T004447Z-41d568.md)

> #608 gauntlet done. Followed your steer exactly: treated #608 as the standalone docker-slice PR, ran it through a focused code panel, applied the fixes, and un-drafted it. It's now OPEN / not-draft / MERGEABLE, CI green (15/15), in the maintainer review queue.
>
> Panel found one real must-fix (raised independently by 4 seats): the documented control command `docker exec <ctr> endo ...` would have failed with "endo: not found" because node_modules/.bin wasn't on the image PATH. Fixed, plus a bundle of should-fixes (socket-parent mkdir, PID-1 zombie reaping via init, a "three trees"->"two" doc error, a too-broad "no HTTP gateway" claim narrowed since web-server-node.js does exist, a socket host-mount security warning, and "bundled worker" wording). Commit 8e6749d8d.
>
> Caveat (honest): I could NOT build/run the image — no Docker in the gardener sandbox. The PATH fix is deterministically correct by construction (bin lands at node_modules/.bin/endo, now on PATH) but not runtime-proven. If you want an end-to-end `docker build` + `docker exec endo endo who` smoke test, that needs a Docker-capable host.
>
> #568 (0xpatrickbot's broader gateway-bearing parallel attempt): left completely untouched per your call. Overlap for your decision: #608 is the docker-image slice only (deliberately defers gateway/bearer-token); #568 additionally carries the ws-gateway impl + test, chat main.js, package.json, and the design doc, based on `llm` and currently CONFLICTING. Closed-as-superseded / kept / reconciled is your call.

- `20260706T005030Z-330c22` — from watchdog:self-heal-claude, reply_to `?` · [open message](https://github.com/kriskowal/garden/blob/journal2/inbox/maintainer/unread/20260706T005030Z-330c22.md)

> self-heal: garden-mentor exited rc=1 with no scoped fix. Capture: 421a156c68fdcaf373fb08e99d8e80833c44d852 (git -C /home/kris/.garden-state/self-heal/journal cat-file -p 421a156c68fdcaf373fb08e99d8e80833c44d852). Diagnosis: You've hit your session limit · resets 2am (UTC)


## Board
### todo (0)
(none)

### doin (1)
- [`port-xs-to-rust-memory-safe-engine-s7`](https://github.com/kriskowal/garden/blob/journal2/jobs/doin/port-xs-to-rust-memory-safe-engine-s7.md) — Fable supervisor: drive the XS→Rust (Endor) port from design to maintainer-re...

### tada (1230)
- [`scholar-ingest-ocap-kernel-comment-fragments-6`](https://github.com/kriskowal/garden/blob/journal2/jobs/tada/scholar-ingest-ocap-kernel-comment-fragments-6.md) — Completion report
- [`endojs-endo-but-for-bots-pr608-gauntlet`](https://github.com/kriskowal/garden/blob/journal2/jobs/tada/endojs-endo-but-for-bots-pr608-gauntlet.md) — Completion report: endojs-endo-but-for-bots-pr608-gauntlet
- [`deadmail-20260706T003057Z-e87344`](https://github.com/kriskowal/garden/blob/journal2/jobs/tada/deadmail-20260706T003057Z-e87344.md) — Completion report
- [`xs2rust-endor-build-stage3b`](https://github.com/kriskowal/garden/blob/journal2/jobs/tada/xs2rust-endor-build-stage3b.md) — orchestration xs2rust-endor-build-stage3b — complete
- [`xs2rust-endor-build-stage3b-xsre-integration`](https://github.com/kriskowal/garden/blob/journal2/jobs/tada/xs2rust-endor-build-stage3b-xsre-integration.md) — Completion report
- … and 1225 more

## Plan queue (parked — not claimable until promoted)
### awaiting go-ahead (maintainer authorization)
- [`endojs-endo-but-for-bots-pr132-report-render-mode`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr132-report-render-mode.md) — _normal_ · re-port render-mode toggle onto @endo/space-chat InboxRoot (endojs/endo-but-f...
- [`foreman-budget-cross-host-weekly-token-aggregation`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/foreman-budget-cross-host-weekly-token-aggregation.md) — _normal_ · PLAN: deterministic cross-host weekly token-spend aggregation for the foreman...
- [`synth-and-deploy-minion-town-aws`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/synth-and-deploy-minion-town-aws.md) — _normal_ · Synth, wire custom domain, and live-deploy minion.town to AWS
- [`verify-ymax0-hex-fix-inquisitor`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/verify-ymax0-hex-fix-inquisitor.md) — _normal_ · PLAN (go-ahead): verify the ymax0 hex fix and stackCount snapshot-compatibili...

### deferred (top by priority; foreman auto-promotes when idle)
- [`scholar-clear-ocap-kernel-library-backfill-notes`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/scholar-clear-ocap-kernel-library-backfill-notes.md) — _normal_ · PLAN: scholar — clear the two carried ocap-kernel library backfill notes

### blocked (awaiting an artifact; unblock watcher auto-promotes on completion)
- [`build-daemon-rename-to-manager-phase2`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/build-daemon-rename-to-manager-phase2.md) — awaiting `https://github.com/endojs/endo-but-for-bots/pull/598` · Build: daemon→manager rename Phase 2 (identifier renames)
- [`build-daemon-rename-to-manager-phase3`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/build-daemon-rename-to-manager-phase3.md) — awaiting `build-daemon-rename-to-manager-phase2` · Build: daemon→manager rename Phase 3 (consumer sweep + CHANGELOG + docs)
- [`resume-lint-ceiling-shepherds`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/resume-lint-ceiling-shepherds.md) — awaiting `https://github.com/endojs/endo-but-for-bots/pull/594` · Resume shepherds for PRs blocked by the endo-but-for-bots lint projectService...
- [`xs2rust-endor-strings-utf16-arm`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/xs2rust-endor-strings-utf16-arm.md) — awaiting `port-xs-to-rust-memory-safe-engine-s7` · Arm the CESU-8→UTF-16 string-representation revisit (record its orchestration)

## Watch set
(none)

## Hosts
- [endolinbot](https://github.com/kriskowal/garden/blob/journal2/hosts/endolinbot): 20 gardeners
- [endolinbot2](https://github.com/kriskowal/garden/blob/journal2/hosts/endolinbot2): 20 gardeners
- [main-host](https://github.com/kriskowal/garden/blob/journal2/hosts/main-host): ? gardeners
