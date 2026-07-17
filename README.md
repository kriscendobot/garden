# Garden bulletin

_As of 2026-07-17T00:15:28Z_

## Latest

The board is nearly frozen — only one job completed this window: a self-heal fix to the garden issue-inbox source handler (main2 `4ff7ca2e66`). The reason for the stall dominates everything else a maintainer should read: the fleet is throttled against the **weekly Claude limit (resets Jul 18, 3am UTC)**, which is what every `garden-mentor` self-heal failure, the dropped follow-up action blocks, and the triage circuit-breakers opening on `kriscendobot-minion.town` and `kriscendobot-agoric-sdk` trace back to. Compounding it, a relay incident has left **55 + 83 maintainer/liaison messages undelivered since ~07-14**; draining that backlog needs a liaison session on the leader host (`endolin-garden2-5bcdff64`) — the sturdyref press and other lanes are stalled in the channel, not the work.

Two substantive engineering blockers surfaced. First, `endojs/endo-but-for-bots` **master is red** from an incomplete `packages/cbor` landing (missing LICENSE/SECURITY.md, unresolved `@endo/eventual-send` in `cbor.test.js`, plus a zizmor pin mismatch); this is not PR-attributable, so shepherds like [#475](https://github.com/endojs/endo-but-for-bots/pull/475) inherit red until master is fixed and PRs rebased. Second, the foreman is repeatedly flagging **Milestone M2** as one merge decision from done — the two vetted-shim PRs [#259](https://github.com/endojs/endo-but-for-bots/pull/259) and [#719](https://github.com/endojs/endo-but-for-bots/pull/719) are green/mergeable and awaiting a merge/ferry call (with the redundant [#263](https://github.com/endojs/endo-but-for-bots/pull/263) to close), and **M3** needs a package-home ruling between [#671](https://github.com/endojs/endo-but-for-bots/pull/671) and [#403](https://github.com/endojs/endo-but-for-bots/pull/403). The SturdyRef effort is fully gated on first review of [#737](https://github.com/endojs/endo-but-for-bots/pull/737) plus two re-reviews ([#695](https://github.com/endojs/endo-but-for-bots/pull/695), [#697](https://github.com/endojs/endo-but-for-bots/pull/697)), and the esheets tree remains dammed behind [#621](https://github.com/endojs/endo-but-for-bots/pull/621). Meanwhile four comment-watchers (`kriscendobot-endo`, `-agoric-3-proposals`, `-cosgov`, `-finbot`) self-tested as **silently blind** (the jq-outage signature) and want a jq/gh check on the leader host.

## Parked for maintainer feedback

- [endojs/endo-but-for-bots#594](https://github.com/endojs/endo-but-for-bots/pull/594) — chore(lint): lint per package to avoid the typescript-eslint project-service ceiling (waiting 56m)
- [endojs/endo-but-for-bots#671](https://github.com/endojs/endo-but-for-bots/pull/671) — feat(daemon): EndoRegistry capability and required @registry host name (waiting 1d)
- [endojs/endo-but-for-bots#670](https://github.com/endojs/endo-but-for-bots/pull/670) — feat(lal): subscription OAuth flow and encrypted auth store (M3) (waiting 3d)
- [endojs/endo-but-for-bots#166](https://github.com/endojs/endo-but-for-bots/pull/166) — feat(endor): add rust/endor TUI skeleton (re-opened from #31 under the bot) (waiting 4d)
- [endojs/endo-but-for-bots#101](https://github.com/endojs/endo-but-for-bots/pull/101) — feat(chat): voice input via Web Speech API (waiting 14d)
- [endojs/endo-but-for-bots#503](https://github.com/endojs/endo-but-for-bots/pull/503) — feat(immutable-arraybuffer,pass-style): passable byte arrays (freezable TypedArray emulation + byteArray brand check) (waiting 16d)
- [endojs/endo-but-for-bots#403](https://github.com/endojs/endo-but-for-bots/pull/403) — feat(registry-capability): EndoRegistry capability + @registry special name (#358 layer 1) (waiting 17d)
- [endojs/endo-but-for-bots#379](https://github.com/endojs/endo-but-for-bots/pull/379) — fix(ses): cyclic star export with renaming reexport (issue #59) - refresh for #3276 feedback (waiting 20d)
- [endojs/endo#3137](https://github.com/endojs/endo/pull/3137) — feat: support .ts runtime modules via erasable type syntax (waiting 31d)
- [endojs/endo-but-for-bots#182](https://github.com/endojs/endo-but-for-bots/pull/182) — test(ses): isImmutableDataProperty regression for iOS Safari fix (closes #947) (waiting 55d)

_Showing top 10 of 26 parked PRs (ranked by recency + roadmap relevance)._
## Messages to the maintainer

- `20260710T184827Z-0e34e9` — from triager:kriscendobot-finbot, reply_to `?` · [open message](https://github.com/kriskowal/garden/blob/journal2/inbox/maintainer/unread/20260710T184827Z-0e34e9.md)

> kind: error
>
> # triage circuit-breaker OPENED for `kriscendobot-finbot`
>
> The triage handler (`/home/kris/garden/scripts/jobs/handlers/triager-claude.sh`) FAILED 5 consecutive times on the SAME change
> and hit the threshold (`GARDEN_TRIAGE_FAIL_THRESHOLD=5`).
>
> - Repo slug: `kriscendobot-finbot`  (watched ref `main`)
> - Failing range: `bf7ebf4aa290c4f09b8a6adf3d3682f46d11d3a0` → `a35add1ee0aadf5fb833fd67eaa1a48316237f22`
>
> Because the transition is deterministic (same old→new SHAs, same diff), retrying
> cannot help — it only crash-loops the `garden-triager@kriscendobot-finbot` unit and fills the
> journal. The breaker is now OPEN: this sha will NOT be re-triaged until a NEW
> change appears on `kriscendobot-finbot:main`, which clears the breaker automatically.
>
> Investigate the handler failure (reproduce by hand:
> `/home/kris/garden/scripts/jobs/handlers/triager-claude.sh kriscendobot-finbot bf7ebf4aa290c4f09b8a6adf3d3682f46d11d3a0 a35add1ee0aadf5fb833fd67eaa1a48316237f22 <bare>`), or, if this repo should not be watched
> at all, remove it from the watch set. Note: under CLAUDE.md § Monitoring safety
> constraint only `endojs/endo-but-for-bots` is currently authorized for watching —
> worth confirming `kriscendobot-finbot` belongs in the set.

- `20260711T075741Z-0634c1` — from watchdog:gardener/3, reply_to `?` · [open message](https://github.com/kriskowal/garden/blob/journal2/inbox/maintainer/unread/20260711T075741Z-0634c1.md)

> gardener job 'endojs-endo-but-for-bots-pr688-shepherd' DETERMINISTICALLY overran its handler budget (rc=124 at the wall, elapsed=2400s ≈ handler-budget=2400s). It does not fit in a single claim-scoped handler and will be POISONED after GARDEN_REAP_OVERRUN_THRESHOLD (2) cycles without completing. Same root cause as an over-large declared handler-timeout, but under the default budget it gets no early signal — surfaced here so you don't have to reverse-engineer it from the reaper's generic poison report. Remedy: SPLIT it into claim-sized stages, or run it DETACHED outside the claim-scoped handler.

- `20260711T091845Z-3e2d4d` — from watchdog:gardener/3, reply_to `?` · [open message](https://github.com/kriskowal/garden/blob/journal2/inbox/maintainer/unread/20260711T091845Z-3e2d4d.md)

> gardener job 'ocapn-pet-daemon-dockerfile-minion' DETERMINISTICALLY overran its handler budget (rc=124 at the wall, elapsed=2400s ≈ handler-budget=2400s). It does not fit in a single claim-scoped handler and will be POISONED after GARDEN_REAP_OVERRUN_THRESHOLD (2) cycles without completing. Same root cause as an over-large declared handler-timeout, but under the default budget it gets no early signal — surfaced here so you don't have to reverse-engineer it from the reaper's generic poison report. Remedy: SPLIT it into claim-sized stages, or run it DETACHED outside the claim-scoped handler.

- `20260712T002630Z-463ac5` — from watchdog:gardener/11, reply_to `?` · [open message](https://github.com/kriskowal/garden/blob/journal2/inbox/maintainer/unread/20260712T002630Z-463ac5.md)

> gardener job 'ebfb-sturdyref-bridge-cut3-daemon-mint-export' DETERMINISTICALLY overran its handler budget (rc=124 at the wall, elapsed=2400s ≈ handler-budget=2400s). It does not fit in a single claim-scoped handler and will be POISONED after GARDEN_REAP_OVERRUN_THRESHOLD (2) cycles without completing. Same root cause as an over-large declared handler-timeout, but under the default budget it gets no early signal — surfaced here so you don't have to reverse-engineer it from the reaper's generic poison report. Remedy: SPLIT it into claim-sized stages, or run it DETACHED outside the claim-scoped handler.

- `20260712T012932Z-eed149` — from watchdog:gardener/18, reply_to `?` · [open message](https://github.com/kriskowal/garden/blob/journal2/inbox/maintainer/unread/20260712T012932Z-eed149.md)

> gardener job 'ebfb-sturdyref-bridge-cut4-ocapn-singleton' DETERMINISTICALLY overran its handler budget (rc=124 at the wall, elapsed=2400s ≈ handler-budget=2400s). It does not fit in a single claim-scoped handler and will be POISONED after GARDEN_REAP_OVERRUN_THRESHOLD (2) cycles without completing. Same root cause as an over-large declared handler-timeout, but under the default budget it gets no early signal — surfaced here so you don't have to reverse-engineer it from the reaper's generic poison report. Remedy: SPLIT it into claim-sized stages, or run it DETACHED outside the claim-scoped handler.

- `20260712T024130Z-6193a7` — from watchdog:gardener/12, reply_to `?` · [open message](https://github.com/kriskowal/garden/blob/journal2/inbox/maintainer/unread/20260712T024130Z-6193a7.md)

> gardener job 'ebfb-sturdyref-bridge-cut5-foreign-internalization' DETERMINISTICALLY overran its handler budget (rc=124 at the wall, elapsed=2400s ≈ handler-budget=2400s). It does not fit in a single claim-scoped handler and will be POISONED after GARDEN_REAP_OVERRUN_THRESHOLD (2) cycles without completing. Same root cause as an over-large declared handler-timeout, but under the default budget it gets no early signal — surfaced here so you don't have to reverse-engineer it from the reaper's generic poison report. Remedy: SPLIT it into claim-sized stages, or run it DETACHED outside the claim-scoped handler.

- `20260712T024609Z-00cf7a` — from watchdog:gardener/8, reply_to `?` · [open message](https://github.com/kriskowal/garden/blob/journal2/inbox/maintainer/unread/20260712T024609Z-00cf7a.md)

> gardener job 'endojs-endo-but-for-bots-pr702-shepherd' DETERMINISTICALLY overran its handler budget (rc=124 at the wall, elapsed=2400s ≈ handler-budget=2400s). It does not fit in a single claim-scoped handler and will be POISONED after GARDEN_REAP_OVERRUN_THRESHOLD (2) cycles without completing. Same root cause as an over-large declared handler-timeout, but under the default budget it gets no early signal — surfaced here so you don't have to reverse-engineer it from the reaper's generic poison report. Remedy: SPLIT it into claim-sized stages, or run it DETACHED outside the claim-scoped handler.

- `20260712T132326Z-2b59d3` — from watchdog:gardener/10, reply_to `?` · [open message](https://github.com/kriskowal/garden/blob/journal2/inbox/maintainer/unread/20260712T132326Z-2b59d3.md)

> gardener job 'gauntlet-endojs-endo-but-for-bots-pr706-git-capability-phase-two-commit-identity-boundary' DETERMINISTICALLY overran its handler budget (rc=124 at the wall, elapsed=2405s ≈ handler-budget=2400s). It does not fit in a single claim-scoped handler and will be POISONED after GARDEN_REAP_OVERRUN_THRESHOLD (2) cycles without completing. Same root cause as an over-large declared handler-timeout, but under the default budget it gets no early signal — surfaced here so you don't have to reverse-engineer it from the reaper's generic poison report. Remedy: SPLIT it into claim-sized stages, or run it DETACHED outside the claim-scoped handler.

- `20260712T161711Z-341200` — from watchdog:gardener/11, reply_to `?` · [open message](https://github.com/kriskowal/garden/blob/journal2/inbox/maintainer/unread/20260712T161711Z-341200.md)

> gardener job 'endojs-endo-but-for-bots-pr124-shepherd' DETERMINISTICALLY overran its handler budget (rc=124 at the wall, elapsed=2400s ≈ handler-budget=2400s). It does not fit in a single claim-scoped handler and will be POISONED after GARDEN_REAP_OVERRUN_THRESHOLD (2) cycles without completing. Same root cause as an over-large declared handler-timeout, but under the default budget it gets no early signal — surfaced here so you don't have to reverse-engineer it from the reaper's generic poison report. Remedy: SPLIT it into claim-sized stages, or run it DETACHED outside the claim-scoped handler.

- `20260712T171006Z-eb67a2` — from orchestrator:orch-endo-inspect-halted, reply_to `?` · [open message](https://github.com/kriskowal/garden/blob/journal2/inbox/maintainer/unread/20260712T171006Z-eb67a2.md)

> Orchestration orch-endo-inspect HALTED: child conduct-endo-inspect-design failed (serial, on-child-failure=halt). 1/3 done before halt; swept: build-endo-inspect

- `20260712T223050Z-e3d803` — from watchdog:gardener/17, reply_to `?` · [open message](https://github.com/kriskowal/garden/blob/journal2/inbox/maintainer/unread/20260712T223050Z-e3d803.md)

> gardener job 'kriscendobot-agoric-sdk-pr15-shepherd' DETERMINISTICALLY overran its handler budget (rc=124 at the wall, elapsed=2617s ≈ handler-budget=2400s). It does not fit in a single claim-scoped handler and will be POISONED after GARDEN_REAP_OVERRUN_THRESHOLD (2) cycles without completing. Same root cause as an over-large declared handler-timeout, but under the default budget it gets no early signal — surfaced here so you don't have to reverse-engineer it from the reaper's generic poison report. Remedy: SPLIT it into claim-sized stages, or run it DETACHED outside the claim-scoped handler.

- `20260713T144418Z-fe48a8` — from watchdog:foreman, reply_to `?` · [open message](https://github.com/kriskowal/garden/blob/journal2/inbox/maintainer/unread/20260713T144418Z-fe48a8.md)

> garden-foreman's pump handler (/home/kris/garden/scripts/jobs/handlers/foreman-claude.sh) failed rc=143 on endolin-garden-ece02cb4; the board pump is starving. stderr tail: <6>14:44:18 [foreman-claude] usage-meter: claude exited rc=143; usage not recorded

- `20260714T211818Z-a9c76a` — from liaison:follow-up, reply_to `?` · [open message](https://github.com/kriskowal/garden/blob/journal2/inbox/maintainer/unread/20260714T211818Z-a9c76a.md)

> A garden-follow-up action block was REJECTED and dropped (not retried):
>   inner claude -p failure (rc=1)
>
> Producer output:
> rc=1
> stderr:
> <empty>
>
> stdout:
> You've hit your weekly limit · resets Jul 18, 3am (UTC)

- `20260714T212404Z-eef1a3` — from watchdog:self-heal-claude, reply_to `?` · [open message](https://github.com/kriskowal/garden/blob/journal2/inbox/maintainer/unread/20260714T212404Z-eef1a3.md)

> self-heal: garden-triager@kriscendobot-minion.town exited rc=1 with no scoped fix. Capture: 68d8c6045fcd005541a33f50644640e07c21644b (git -C /home/kris/garden2/.garden-state/self-heal/journal cat-file -p 68d8c6045fcd005541a33f50644640e07c21644b). Diagnosis: You've hit your weekly limit · resets Jul 18, 3am (UTC)

- `20260714T213148Z-41f129` — from triager:kriscendobot-minion.town, reply_to `?` · [open message](https://github.com/kriskowal/garden/blob/journal2/inbox/maintainer/unread/20260714T213148Z-41f129.md)

> kind: error
>
> # triage circuit-breaker OPENED for `kriscendobot-minion.town`
>
> The triage handler (`/home/kris/garden2/scripts/jobs/handlers/triager-claude.sh`) FAILED 5 consecutive times on the SAME change
> and hit the threshold (`GARDEN_TRIAGE_FAIL_THRESHOLD=5`).
>
> - Repo slug: `kriscendobot-minion.town`  (watched ref `main`)
> - Failing range: `0ff042bc0b595ce801c803abb90c138860f66db9` → `7cf4a624eddf1a5690853eeeb4a54dcffa47d1e2`
>
> Because the transition is deterministic (same old→new SHAs, same diff), retrying
> cannot help — it only crash-loops the `garden-triager@kriscendobot-minion.town` unit and fills the
> journal. The breaker is now OPEN: this sha will NOT be re-triaged until a NEW
> change appears on `kriscendobot-minion.town:main`, which clears the breaker automatically.
>
> Investigate the handler failure (reproduce by hand:
> `/home/kris/garden2/scripts/jobs/handlers/triager-claude.sh kriscendobot-minion.town 0ff042bc0b595ce801c803abb90c138860f66db9 7cf4a624eddf1a5690853eeeb4a54dcffa47d1e2 <bare>`), or, if this repo should not be watched
> at all, remove it from the watch set. Note: under CLAUDE.md § Monitoring safety
> constraint only `endojs/endo-but-for-bots` is currently authorized for watching —
> worth confirming `kriscendobot-minion.town` belongs in the set.

- `20260714T224228Z-866b52` — from watchdog:self-heal-claude, reply_to `?` · [open message](https://github.com/kriskowal/garden/blob/journal2/inbox/maintainer/unread/20260714T224228Z-866b52.md)

> self-heal: garden-triager@kriscendobot-agoric-sdk exited rc=1 with no scoped fix. Capture: 34a4c24dca86ee4954a56309657c0fca5fa2a919 (git -C /home/kris/garden2/.garden-state/self-heal/journal cat-file -p 34a4c24dca86ee4954a56309657c0fca5fa2a919). Diagnosis: You've hit your weekly limit · resets Jul 18, 3am (UTC)

- `20260714T225019Z-8a3c3c` — from triager:kriscendobot-agoric-sdk, reply_to `?` · [open message](https://github.com/kriskowal/garden/blob/journal2/inbox/maintainer/unread/20260714T225019Z-8a3c3c.md)

> kind: error
>
> # triage circuit-breaker OPENED for `kriscendobot-agoric-sdk`
>
> The triage handler (`/home/kris/garden2/scripts/jobs/handlers/triager-claude.sh`) FAILED 5 consecutive times on the SAME change
> and hit the threshold (`GARDEN_TRIAGE_FAIL_THRESHOLD=5`).
>
> - Repo slug: `kriscendobot-agoric-sdk`  (watched ref `master`)
> - Failing range: `ef8eb1c17454c5d3166f72e16f57fdb2b7614637` → `57db88d91b0e5c85c85f58ce77cd471131b44c48`
>
> Because the transition is deterministic (same old→new SHAs, same diff), retrying
> cannot help — it only crash-loops the `garden-triager@kriscendobot-agoric-sdk` unit and fills the
> journal. The breaker is now OPEN: this sha will NOT be re-triaged until a NEW
> change appears on `kriscendobot-agoric-sdk:master`, which clears the breaker automatically.
>
> Investigate the handler failure (reproduce by hand:
> `/home/kris/garden2/scripts/jobs/handlers/triager-claude.sh kriscendobot-agoric-sdk ef8eb1c17454c5d3166f72e16f57fdb2b7614637 57db88d91b0e5c85c85f58ce77cd471131b44c48 <bare>`), or, if this repo should not be watched
> at all, remove it from the watch set. Note: under CLAUDE.md § Monitoring safety
> constraint only `endojs/endo-but-for-bots` is currently authorized for watching —
> worth confirming `kriscendobot-agoric-sdk` belongs in the set.

- `20260715T002008Z-5fc86f` — from watchdog:self-heal-claude, reply_to `?` · [open message](https://github.com/kriskowal/garden/blob/journal2/inbox/maintainer/unread/20260715T002008Z-5fc86f.md)

> self-heal: garden-mentor exited rc=1 with no scoped fix. Capture: c08278b5f5b6c0eaf954dd946c45b5d062078fa9 (git -C /home/kris/garden2/.garden-state/self-heal/journal cat-file -p c08278b5f5b6c0eaf954dd946c45b5d062078fa9). Diagnosis: You've hit your weekly limit · resets Jul 18, 3am (UTC)

- `20260715T012018Z-a71fc8` — from watchdog:self-heal-claude, reply_to `?` · [open message](https://github.com/kriskowal/garden/blob/journal2/inbox/maintainer/unread/20260715T012018Z-a71fc8.md)

> self-heal: garden-mentor exited rc=1 with no scoped fix. Capture: 7f66a900eecfd345bc105de5a262d81d4f242942 (git -C /home/kris/garden2/.garden-state/self-heal/journal cat-file -p 7f66a900eecfd345bc105de5a262d81d4f242942). Diagnosis: You've hit your weekly limit · resets Jul 18, 3am (UTC)

- `20260715T022037Z-9a7e18` — from watchdog:self-heal-claude, reply_to `?` · [open message](https://github.com/kriskowal/garden/blob/journal2/inbox/maintainer/unread/20260715T022037Z-9a7e18.md)

> self-heal: garden-mentor exited rc=1 with no scoped fix. Capture: e212d87af444096f8480218617027dcc0ec8bc0c (git -C /home/kris/garden2/.garden-state/self-heal/journal cat-file -p e212d87af444096f8480218617027dcc0ec8bc0c). Diagnosis: You've hit your weekly limit · resets Jul 18, 3am (UTC)

- `20260715T035009Z-f98bc5` — from watchdog:self-heal-claude, reply_to `?` · [open message](https://github.com/kriskowal/garden/blob/journal2/inbox/maintainer/unread/20260715T035009Z-f98bc5.md)

> self-heal: garden-mentor exited rc=1 with no scoped fix. Capture: 9d2bd08a52b79f8300ba8689d5ac774ccd9e32ca (git -C /home/kris/garden2/.garden-state/self-heal/journal cat-file -p 9d2bd08a52b79f8300ba8689d5ac774ccd9e32ca). Diagnosis: You've hit your weekly limit · resets Jul 18, 3am (UTC)

- `20260715T045022Z-4e28e6` — from watchdog:self-heal-claude, reply_to `?` · [open message](https://github.com/kriskowal/garden/blob/journal2/inbox/maintainer/unread/20260715T045022Z-4e28e6.md)

> self-heal: garden-mentor exited rc=1 with no scoped fix. Capture: 8207cff0393579baf29aa3f52e34cdd2f60c060a (git -C /home/kris/garden2/.garden-state/self-heal/journal cat-file -p 8207cff0393579baf29aa3f52e34cdd2f60c060a). Diagnosis: You've hit your weekly limit · resets Jul 18, 3am (UTC)

- `20260715T054413Z-5a5452` — from gardener:endojs-endo-but-for-bots-pr710-ce2a6fe9, reply_to `endojs-endo-but-for-bots-pr710-ce2a6fe9` · [open message](https://github.com/kriskowal/garden/blob/journal2/inbox/maintainer/unread/20260715T054413Z-5a5452.md)

> Attention directive on [endojs/endo-but-for-bots#710](https://github.com/endojs/endo-but-for-bots/issues/710) ("Please note the PR for the build") routed:
>
> The design "shared canonical CBOR primitives (@endo/cbor)" merged in [endojs/endo-but-for-bots#710](https://github.com/endojs/endo-but-for-bots/issues/710). I read the directive as "post the build follow-up, noting that PR as the landed design," so I parked a build job in the plan queue:
>
>   jobs/plan/build-endo-cbor-package.md  (gate: go-ahead, role: builder)
>
> Scope is PHASE 1 ONLY per the design's phased migration: create packages/cbor/ (the hardened functional primitive codec + shared golden-vector fixture prepared for Rust mirroring). It deliberately does NOT migrate the ocapn/slots/daemon consumers — phase 3 (slots) is gated on [endojs/endo-but-for-bots#124](https://github.com/endojs/endo-but-for-bots/issues/124) landing, so those stay separate later steps.
>
> It's parked (go-ahead) rather than live so promotion is your/the foreman's call. Say "promote build-endo-cbor-package" (or "build @endo/cbor") to send it to the builder now; correct me if you meant something narrower by "note the PR."

- `20260715T054804Z-93f534` — from liaison:follow-up, reply_to `?` · [open message](https://github.com/kriskowal/garden/blob/journal2/inbox/maintainer/unread/20260715T054804Z-93f534.md)

> A garden-follow-up action block was REJECTED and dropped (not retried):
>   inner claude -p failure (rc=1)
>
> Producer output:
> rc=1
> stderr:
> <empty>
>
> stdout:
> You've hit your weekly limit · resets Jul 18, 3am (UTC)

- `20260715T065009Z-948cd7` — from watchdog:self-heal-claude, reply_to `?` · [open message](https://github.com/kriskowal/garden/blob/journal2/inbox/maintainer/unread/20260715T065009Z-948cd7.md)

> self-heal: garden-mentor exited rc=1 with no scoped fix. Capture: e1e7e43a412be8e6e9fb93f829952698f895adae (git -C /home/kris/garden2/.garden-state/self-heal/journal cat-file -p e1e7e43a412be8e6e9fb93f829952698f895adae). Diagnosis: You've hit your weekly limit · resets Jul 18, 3am (UTC)

- `20260716T002028Z-ac956c` — from watchdog:self-heal-claude, reply_to `?` · [open message](https://github.com/kriskowal/garden/blob/journal2/inbox/maintainer/unread/20260716T002028Z-ac956c.md)

> self-heal: garden-mentor exited rc=1 with no scoped fix. Capture: 352fc2e068007d920c2f30291468bd076fa15c69 (git -C /home/kris/garden2/.garden-state/self-heal/journal cat-file -p 352fc2e068007d920c2f30291468bd076fa15c69). Diagnosis: You've hit your weekly limit · resets Jul 18, 3am (UTC)

- `20260716T015011Z-ac58f5` — from watchdog:self-heal-claude, reply_to `?` · [open message](https://github.com/kriskowal/garden/blob/journal2/inbox/maintainer/unread/20260716T015011Z-ac58f5.md)

> self-heal: garden-mentor exited rc=1 with no scoped fix. Capture: 1c57a158d4435a63cd28f8cca7c9cb5b9ecb4628 (git -C /home/kris/garden2/.garden-state/self-heal/journal cat-file -p 1c57a158d4435a63cd28f8cca7c9cb5b9ecb4628). Diagnosis: You've hit your weekly limit · resets Jul 18, 3am (UTC)

- `20260716T025012Z-8736cc` — from watchdog:self-heal-claude, reply_to `?` · [open message](https://github.com/kriskowal/garden/blob/journal2/inbox/maintainer/unread/20260716T025012Z-8736cc.md)

> self-heal: garden-mentor exited rc=1 with no scoped fix. Capture: f9a25ed5e3d66568371e5a3a0b83e9a7ccd53eea (git -C /home/kris/garden2/.garden-state/self-heal/journal cat-file -p f9a25ed5e3d66568371e5a3a0b83e9a7ccd53eea). Diagnosis: You've hit your weekly limit · resets Jul 18, 3am (UTC)

- `20260716T043343Z-508cfd` — from gardener:endojs-endo-but-for-bots-pr671-review-3fa7398f-retro, reply_to `endojs-endo-but-for-bots-pr671-review-3fa7398f-retro` · [open message](https://github.com/kriskowal/garden/blob/journal2/inbox/maintainer/unread/20260716T043343Z-508cfd.md)

> Review-retrospective escalation — avoid-name-abbreviations cluster RECURRED (needs your call)
>
> The abbreviation improvement (spell-out-identifiers pre-push gate + stylist
> never-abbreviate brief, closed on main2 aa2da527e5) has RECURRED on
> [endojs/endo-but-for-bots#671](https://github.com/endojs/endo-but-for-bots/issues/671): your "Avoid abbreviation" on `fetchImpl`
> (registry-node-backend.js). Cluster reopened, count=4, prs={650,609,671}.
>
> Why it slipped despite the gate being deployed:
>   1. The `fetchImpl` line was authored ~3h BEFORE the gate existed, and the gate
>      scans only NEWLY-ADDED diff lines per push. On every later push the line is
>      unchanged, so the deterministic gate never scanned it — even though `impl`
>      IS on its blocklist (I verified it fails when scanned directly). This is a
>      structural blind spot: any abbreviation predating the gate's deployment (or a
>      branch's first gated push) escapes the deterministic net permanently.
>   2. The panel's stylist seat (the only backstop for pre-existing lines) ran with
>      the never-abbreviate brief deployed and still missed this one identifier —
>      LLM seats are probabilistic.
>
> Per the skill I did NOT auto-dispatch a second improvement round — the right fix is
> your judgment call: widen the gate to re-scan whole changed/new files (catches
> pre-existing + pre-deployment stragglers, at the cost of more false positives),
> accept the stylist seat as the sole net for pre-existing lines, or treat this
> single pre-deployment straggler as expected fallout needing no change. The gate is
> not broken for the lines it is designed to see. Miss recorded either way. Your call
> on whether/how to widen.

- `20260716T122710Z-780091` — from foreman, reply_to `?` · [open message](https://github.com/kriskowal/garden/blob/journal2/inbox/maintainer/unread/20260716T122710Z-780091.md)

> Milestone M2 (Project Hygiene) is at 6/8; its only two remaining designs — `hardened-url-shim` and `hardened-text-codecs-shim` — are already delivered as PRs [endojs/endo-but-for-bots#719](https://github.com/endojs/endo-but-for-bots/issues/719) and #259, both OPEN, un-drafted, CI-clean/MERGEABLE, with #719's `CHANGES_REQUESTED` (update lockdown docs) already addressed at head and 0 unresolved threads on either. The next step to close out M2 is merging both PRs, which is a maintainer/authority decision (merge) outside the foreman's work-job bounds.

- `20260716T123404Z-946eaf` — from foreman, reply_to `?` · [open message](https://github.com/kriskowal/garden/blob/journal2/inbox/maintainer/unread/20260716T123404Z-946eaf.md)

> Milestone M3's remaining buildable work — the tail of the module-loading four-layer stack (`snapshot-mapper` and `daemon-worker-import-from-mount`, both `endojs/endo-but-for-bots`) — is blocked on a package-home decision the fleet cannot make itself: the MVS resolver now exists in two competing open PRs, `@endo/daemon/registry.js` (#671) and a dedicated `@endo/exo-npm` package (#403, which superseded the closed #564). Please rule which home wins so the loser can be closed and the snapshot-mapper / worker-import layers can be built against the chosen one; every other M3 step is either merged or an in-flight PR awaiting merge.

- `20260716T141047Z-042f83` — from foreman, reply_to `?` · [open message](https://github.com/kriskowal/garden/blob/journal2/inbox/maintainer/unread/20260716T141047Z-042f83.md)

> M2 (Project Hygiene) is one merge decision from complete: its two remaining rows — `hardened-text-codecs-shim` (PR [endojs/endo-but-for-bots#259](https://github.com/endojs/endo-but-for-bots/issues/259)) and `hardened-url-shim` (PR [endojs/endo-but-for-bots#719](https://github.com/endojs/endo-but-for-bots/issues/719)) — are both built to merge-ready state (non-draft, MERGEABLE/CLEAN, CI all-green; #719's gauntlet is complete). No unblocked work job remains; landing #259 and #719 (and closing the superseded, CONFLICTING alternative #263) is a merge/ferry authority decision. Please authorize the merge/ferry to close M2 (plan design-record statuses for both are stale at "Not Started" and want advancing).

- `20260716T162359Z-d9c132` — from gardener:esheets-supervisor-20260716-162017, reply_to `esheets-supervisor-20260716-162017` · [open message](https://github.com/kriskowal/garden/blob/journal2/inbox/maintainer/unread/20260716T162359Z-d9c132.md)

> **esheets tree — daily standup (2026-07-16).** Still dammed behind one node.
>
> - **MERGED:** `endoclaw-network-fetch` (HttpClient allowlist floor); base designs `endoclaw-oauth.md` + `exo-google-sheets.md` on `llm`.
> - **THE BLOCKER — PR [endojs/endo-but-for-bots#621](https://github.com/endojs/endo-but-for-bots/issues/621)** ("refine endoclaw-oauth… settle first-mint flow"): OPEN, un-drafted, **all 5 CI checks GREEN**. The design round you asked for on 2026-07-10 — recursive partition/delegation with narrowing, plus the named composite **caretaker-attenuation** pattern — **landed on the head (commits 2026-07-13)**. It has re-drifted to `CONFLICTING`; I posted a weave today to make it one-click mergeable again. It has now sat **6 days awaiting your re-review + merge**, still showing the stale `CHANGES_REQUESTED`.
> - **NOTHING else can start** until [endojs/endo-but-for-bots#621](https://github.com/endojs/endo-but-for-bots/issues/621) lands: OAuth exo → `@endo/google-sheets` → `@endo/exo-google-sheets` are all downstream of it, no impl packages exist yet.
>
> **Decision needed:** please re-review + merge [endojs/endo-but-for-bots#621](https://github.com/endojs/endo-but-for-bots/issues/621) (or tell me to proceed building the OAuth exo on the merged base `endoclaw-oauth.md` and land [endojs/endo-but-for-bots#621](https://github.com/endojs/endo-but-for-bots/issues/621)'s refinements later). This is the sole thing gating the whole tree.

- `20260716T162635Z-cd21da` — from gardener:--help, reply_to `--help` · [open message](https://github.com/kriskowal/garden/blob/journal2/inbox/maintainer/unread/20260716T162635Z-cd21da.md)

> (empty message)

- `20260716T162654Z-ade774` — from gardener:finbot-progress-20260716-162017, reply_to `finbot-progress-20260716-162017` · [open message](https://github.com/kriskowal/garden/blob/journal2/inbox/maintainer/unread/20260716T162654Z-ade774.md)

> Advanced finbot main to efa6454: regime-aware position sizing. Adaptive-vol OODA cycles now default persistent assets to half-size targets (overrideable), while direct analyzer use remains unchanged by default. Verified npm test (all workspace tests green) and dry-run MLE fit: ATOM target 21.50%% -> 10.75%% at persistence 0.98; audit approved, wallet untouched. Next unblocked step: choose one remaining forecast-model extension (asymmetric MLE or EGARCH); live paper-wallet work still needs explicit authorization and a CapTP transport decision.

- `20260716T164754Z-3ad37e` — from foreman, reply_to `?` · [open message](https://github.com/kriskowal/garden/blob/journal2/inbox/maintainer/unread/20260716T164754Z-3ad37e.md)

> Milestone M2 (Project Hygiene) has only two members left, and both are built and merge-ready in endojs/endo-but-for-bots: PR #259 (hardened text-codecs vetted shim, fully green/CLEAN) and PR #263 (hardened URL/URLSearchParams vetted shim, green except a pre-existing repo-wide `zizmor` check that also passes on #259). Both expand the SES universal-permit surface, so completing M2 needs your decision to merge/conduct #259 and #263 — an authority action outside the foreman's work-job bounds.

- `20260716T165104Z-5f08c8` — from foreman, reply_to `?` · [open message](https://github.com/kriskowal/garden/blob/journal2/inbox/maintainer/unread/20260716T165104Z-5f08c8.md)

> Milestone **M2 (Project Hygiene)** is one decision away from complete: its only two remaining designs are built and review-ready — `hardened-text-codecs-shim` (PR #259, green/CLEAN) and `hardened-url-shim` (PR #719, green/CLEAN, gauntlet-passed). Please decide whether to adopt #719's `%URL%`/`%SharedURL%` split for the URL shim and **close the redundant, CI-failing #263** (universal-permits alternative), then review + merge/ferry #259 and #719 to close out M2 — all remaining actions are merge/ferry authority the fleet cannot take.

- `20260716T165737Z-ed87f2` — from foreman, reply_to `?` · [open message](https://github.com/kriskowal/garden/blob/journal2/inbox/maintainer/unread/20260716T165737Z-ed87f2.md)

> Milestone M2 (Project Hygiene) is complete except for its two vetted-shim designs, whose PRs are built, gauntleted, and `MERGEABLE`/ready-for-review: `endojs/endo-but-for-bots` **#259** (hardened text-codecs shim) and **#719** (hardened URL/URLSearchParams shim). M2 completion — and the M3 phase work stacked behind these — is blocked on your decision to merge/ferry #259 and #719.

- `20260716T184058Z-404cd3` — from gardener:endojs-endo-but-for-bots-pr475-shepherd, reply_to `endojs-endo-but-for-bots-pr475-shepherd` · [open message](https://github.com/kriskowal/garden/blob/journal2/inbox/maintainer/unread/20260716T184058Z-404cd3.md)

> shepherd [endojs/endo-but-for-bots#475](https://github.com/endojs/endo-but-for-bots/issues/475) (feat/narrow-bytearray-to-uint8): red CI is NOT PR-attributable — master itself is red.
>
> The PR's failing checks (lint, test x4, zizmor) are an exact subset of master's own failing checks. Root cause is on master, from an incomplete `packages/cbor` landing (the PR does not touch cbor, workflow pins, or the uniformity script):
>
>   • lint (check-package-uniformity): packages/cbor missing LICENSE + SECURITY.md, and package.json missing .author/.repository/.bugs/.publishConfig.
>   • test (all matrices): test/cbor.test.js -> ERR_MODULE_NOT_FOUND '@endo/eventual-send' (cbor package.json/install doesn't resolve it via ses-ava's generated import).
>   • zizmor: workflow action-pin version-comment mismatch (points to 249970729cb0) across ci.yml et al — also present on master.
>
> Branch is 52 ahead / 5 behind master. Fix belongs on MASTER (a cbor-package fix job), not on this feature branch — pushing it to the PR head would be out-of-scope and wrong home. After master is green, rebase/weave the PR onto master to clear the inherited red and re-run CI.
>
> Not pushing anything to the PR. next: liaison (fix broken master cbor package, then rebase the PR).

- `20260716T200737Z-72c74a` — from gardener:endo-sturdyref-press-20260716-200513, reply_to `endo-sturdyref-press-20260716-200513` · [open message](https://github.com/kriskowal/garden/blob/journal2/inbox/maintainer/unread/20260716T200737Z-72c74a.md)

> # SturdyRef effort: three maintainer gates open, all forward work is blocked on them
>
> One consolidated nudge from the hourly sturdyref press-driver (3rd consecutive
> fully-gated tick; last sturdyref-set touch by you was 2026-07-15 ~05:40Z, ~39h ago).
> Everything on the critical path is waiting on one of these:
>
> 1. **First review of [endojs/endo-but-for-bots#737](https://github.com/endojs/endo-but-for-bots/issues/737)**
>    (`build/sturdyref-pass-style-ocapn-single`) — the single-squashed-commit
>    replacement for closed [endojs/endo-but-for-bots#521](https://github.com/endojs/endo-but-for-bots/issues/521). DRAFT, CI green 25/25
>    on head `ce7341b47d` (the `sturdyRef` rename), zero reviews so far.
>    [https://github.com/endojs/endo-but-for-bots/pull/737](https://github.com/endojs/endo-but-for-bots/pull/737)
> 2. **Two decisions**, re-surfaced in
>    [https://github.com/endojs/endo-but-for-bots/pull/737](https://github.com/endojs/endo-but-for-bots/pull/737)#issuecomment-4994276944:
>    - marshal rank-prefix pick: A/`q` vs B/`t` vs C/`w` — gates the marshal
>      encode/decode arms + `encodeSturdyRef`/`decodeSturdyRef` hooks;
>    - stack-collapse preference — fold [endojs/endo-but-for-bots#541](https://github.com/endojs/endo-but-for-bots/issues/541) + the
>      bridge cuts ([endojs/endo-but-for-bots#698](https://github.com/endojs/endo-but-for-bots/issues/698) through
>      [endojs/endo-but-for-bots#704](https://github.com/endojs/endo-but-for-bots/issues/704)) into [endojs/endo-but-for-bots#737](https://github.com/endojs/endo-but-for-bots/issues/737), or
>      restack them onto its branch.
> 3. **Re-reviews of the two designs** you marked CHANGES_REQUESTED on 07-15
>    (both addressed the same hour):
>    - [endojs/endo-but-for-bots#695](https://github.com/endojs/endo-but-for-bots/issues/695) agent provide/accept design — gates the
>      Lal/Fae/Genie provide/accept build (the "throughout" bar);
>    - [endojs/endo-but-for-bots#697](https://github.com/endojs/endo-but-for-bots/issues/697) cross-peer bridge design.
>
> Until any of these opens, the hourly driver holds (no pushes) rather than
> diluting the single-commit review shape of [endojs/endo-but-for-bots#737](https://github.com/endojs/endo-but-for-bots/issues/737).
> Any one answer unblocks a lane.

- `20260716T211440Z-c78e4b` — from gardener:xs2rust-endor-press-20260716-210915, reply_to `xs2rust-endor-press-20260716-210915` · [open message](https://github.com/kriskowal/garden/blob/journal2/inbox/maintainer/unread/20260716T211440Z-c78e4b.md)

> xs2rust-endor ([endojs/endo-but-for-bots#600](https://github.com/endojs/endo-but-for-bots/issues/600)) press check-in: found the chain
> silently stalled 5 days — the s19 supervisor (stage-5 acceptance + stage-6
> dispatch) was parked behind a blocker that had already completed, because the
> leader's garden-unblock.timer still had the monotonic-timer starvation bug the
> 2026-07-03 fix missed (it never fired; LastTrigger empty for days). Fixed on
> main2 (`6012296908`, OnCalendar+Persistent like the other four timers),
> installed on the leader, fired the watcher: s19 promoted and already claimed
> by a gardener. Chain is moving again; no branch pushes by me. Note:
> proxy/watchman/mention-watcher/scaler/repo-watcher timers still carry the same
> monotonic pattern — worth a sweep job if you want it.

- `20260716T224153Z-8c9201` — from gardener:finbot-progress-20260716-223502, reply_to `finbot-progress-20260716-223502` · [open message](https://github.com/kriskowal/garden/blob/journal2/inbox/maintainer/unread/20260716T224153Z-8c9201.md)

> finbot progress (asymmetric/leverage MLE): advanced main efa6454 -> df2a164.
>
> This cycle lifted the longest-standing forecasting-axis deferral — live estimation
> of the GJR-GARCH leverage parameter gamma. The GJR surface already models the
> leverage effect but its from-history fit *supplied* gamma from config; the new
> `gjrGarchMleFromPriceHistory` estimates (alpha, gamma, beta) per asset from the
> realized down/up asymmetry, via the same deterministic nested-grid MLE as the
> symmetric fitter (variance-targeting omega out of the search, no RNG, no optimizer
> lib). Routed through makeVolSurface (kind gjr-garch + estimate mle, formerly a
> "deferred" throw) and exported from the simulator index.
>
> Evidence: new gjr-garch-mle.test.js proves recovery (a leverage DGP fits gamma
> > 0.05 with downWeight > upWeight; a symmetric DGP through the same seed fits
> gamma < 0.05), determinism, short-window/constant-price fallback, and factory
> routing. Full suite 538 pass / 0 fail (was 528); finbot-ooda --seed=7 green,
> WALLET TOUCHED: false. No CI workflows on the repo, so nothing to shepherd.
>
> Next unblocked step: feed the fitted asymmetry into the *live regime read* the
> pipeline cites — conditionalVolFromPriceHistory still rolls the symmetric surface
> even when the world is GJR, so the auditor's tail floor and analyzer's sizing see
> magnitude-conditional vol, not down-move-conditional vol. A `gjr-mle` roll-forward
> would close that. Deferred behind that: EGARCH, implied-vol surfaces, PNG raster,
> far-ref vending.
>
> Maintainer decision still pending (unchanged): live execution stays blocked on an
> explicit paper-wallet/test-net authorization and a chosen CapTP transport.

- `20260716T224817Z-d54ddc` — from liaison:follow-up, reply_to `?` · [open message](https://github.com/kriskowal/garden/blob/journal2/inbox/maintainer/unread/20260716T224817Z-d54ddc.md)

> The endo-sturdyref-press job (report endo-sturdyref-press-20260716-223502) is blocked on you: a message (`72c74a`) is sitting in your inbox unread, and the job's decisions cannot proceed until you drain it. Please review your maintainer inbox — the stall is in the channel, not the work.

- `20260716T230255Z-350ad2` — from gardener:reconstruct-ebfb-pr720-patterns-literal-inference, reply_to `reconstruct-ebfb-pr720-patterns-literal-inference` · [open message](https://github.com/kriskowal/garden/blob/journal2/inbox/maintainer/unread/20260716T230255Z-350ad2.md)

> Blocked: the current `endojs/endo-but-for-bots` `master` already contains the original merge commit `91c6718851e4cb40e5679678e117b6aec2884fa3` as an ancestor. The requested patch is therefore already present byte-for-byte (all three target blobs match), and applying `git diff 91c671885^1 91c671885` to a fresh `master` branch yields no diff. I have not opened a misleading empty DRAFT PR. Please direct whether to wait for the next mirror that drops the merge or take another action.

- `20260716T230307Z-8abd89` — from gardener:reconstruct-ebfb-pr545-stream-flatmapreader, reply_to `reconstruct-ebfb-pr545-stream-flatmapreader` · [open message](https://github.com/kriskowal/garden/blob/journal2/inbox/maintainer/unread/20260716T230307Z-8abd89.md)

> Blocked: current endojs/endo-but-for-bots master (fcbb540ed, fetched 2026-07-15) already contains merge commit 364d69ba1 (git merge-base --is-ancestor returned 0), and all five reconstructed paths have zero diff versus master. Applying the original first-parent diff fails because the added files/content already exist. A fresh master-based PR cannot carry this diff. Please advise whether to close/cancel this reconstruction or identify a different base/revision.

- `20260716T230343Z-e82271` — from gardener:reconstruct-ebfb-pr69-pass-style-document-all, reply_to `reconstruct-ebfb-pr69-pass-style-document-all` · [open message](https://github.com/kriskowal/garden/blob/journal2/inbox/maintainer/unread/20260716T230343Z-e82271.md)

> Blocked on current base state: origin/master already contains the complete [endojs/endo-but-for-bots#69](https://github.com/endojs/endo-but-for-bots/issues/69) merge commit eecc68394ba5a95304871c4fdcd9656df6fa527a as an ancestor. The surviving branch rebases to an empty diff; each of its five commits is already upstream, and `git diff origin/master...HEAD` is empty. I also compared the pre-rebase original merge diff with the surviving branch diff byte-for-byte: SHA-256 501f799e602cbe77684f8669758f5f932a9646ed6b2580af62de5dec83f47aa7 for both. A fresh master-based PR cannot carry that diff until a fork master re-mirror drops it. Please direct whether to open an empty draft provenance PR now or wait for the remirror.

- `20260716T230510Z-32d838` — from gardener:audit-garden-endo-master-recreation, reply_to `audit-garden-endo-master-recreation` · [open message](https://github.com/kriskowal/garden/blob/journal2/inbox/maintainer/unread/20260716T230510Z-32d838.md)

> Branch protection was maintainer-gated: gh auth status reports the active kriscendobot token is invalid, so no GitHub API write was attempted. Please run this as a repository admin (or renew the bot token and rerun it):
>
> printf '%s\n' '{"required_status_checks":null,"enforce_admins":true,"required_pull_request_reviews":{"dismissal_restrictions":{},"dismiss_stale_reviews":false,"require_code_owner_reviews":false,"required_approving_review_count":1,"require_last_push_approval":false},"restrictions":null,"required_linear_history":false,"allow_force_pushes":false,"allow_deletions":false,"block_creations":false,"required_conversation_resolution":false,"lock_branch":false,"allow_fork_syncing":false}' | gh api -X PUT repos/endojs/endo-but-for-bots/branches/master/protection --input -

- `20260716T231446Z-5ea245` — from gardener:reconstruct-ebfb-pr720-patterns-literal-inference, reply_to `reconstruct-ebfb-pr720-patterns-literal-inference` · [open message](https://github.com/kriskowal/garden/blob/journal2/inbox/maintainer/unread/20260716T231446Z-5ea245.md)

> Blocker: current endojs/endo-but-for-bots master (fcbb540ed) already contains merge commit 91c6718851e4cb40e5679678e117b6aec2884fa3 for [https://github.com/endojs/endo-but-for-bots/pull/720](https://github.com/endojs/endo-but-for-bots/pull/720). GitHub compare reports this recovered change is behind master by one commit and has zero files, so a master-based fresh PR cannot carry the requested diff faithfully. Please advise whether to wait for the expected hard mirror or use a different base.

- `20260716T234249Z-aef697` — from watchdog:comment-watcher/kriscendobot-endo, reply_to `?` · [open message](https://github.com/kriskowal/garden/blob/journal2/inbox/maintainer/unread/20260716T234249Z-aef697.md)

> ANOMALY: comment-watcher/kriscendobot-endo self-test FAILED on kriscendobot/endo — the comment source path could not fetch a known-existing comment, so the watcher is likely silently BLIND (the 2026-06-24 jq-outage signature). Check jq/gh on endolin-garden2-5bcdff64 and the comment-source handler. This is a POSITIVE proof the source path is broken, NOT a report that the repo is quiet.

- `20260716T234254Z-b293b0` — from watchdog:comment-watcher/kriscendobot-agoric-3-proposals, reply_to `?` · [open message](https://github.com/kriskowal/garden/blob/journal2/inbox/maintainer/unread/20260716T234254Z-b293b0.md)

> ANOMALY: comment-watcher/kriscendobot-agoric-3-proposals self-test FAILED on kriscendobot/agoric-3-proposals — the comment source path could not fetch a known-existing comment, so the watcher is likely silently BLIND (the 2026-06-24 jq-outage signature). Check jq/gh on endolin-garden2-5bcdff64 and the comment-source handler. This is a POSITIVE proof the source path is broken, NOT a report that the repo is quiet.

- `20260716T234424Z-69317f` — from watchdog:comment-watcher/kriscendobot-cosgov, reply_to `?` · [open message](https://github.com/kriskowal/garden/blob/journal2/inbox/maintainer/unread/20260716T234424Z-69317f.md)

> ANOMALY: comment-watcher/kriscendobot-cosgov self-test FAILED on kriscendobot/cosgov — the comment source path could not fetch a known-existing comment, so the watcher is likely silently BLIND (the 2026-06-24 jq-outage signature). Check jq/gh on endolin-garden2-5bcdff64 and the comment-source handler. This is a POSITIVE proof the source path is broken, NOT a report that the repo is quiet.

- `20260716T234437Z-12323e` — from watchdog:comment-watcher/kriscendobot-finbot, reply_to `?` · [open message](https://github.com/kriskowal/garden/blob/journal2/inbox/maintainer/unread/20260716T234437Z-12323e.md)

> ANOMALY: comment-watcher/kriscendobot-finbot self-test FAILED on kriscendobot/finbot — the comment source path could not fetch a known-existing comment, so the watcher is likely silently BLIND (the 2026-06-24 jq-outage signature). Check jq/gh on endolin-garden2-5bcdff64 and the comment-source handler. This is a POSITIVE proof the source path is broken, NOT a report that the repo is quiet.

- `20260716T234816Z-4b4784` — from liaison:follow-up, reply_to `?` · [open message](https://github.com/kriskowal/garden/blob/journal2/inbox/maintainer/unread/20260716T234816Z-4b4784.md)

> Report endo-sturdyref-press-20260716-233503 flags a garden-wide relay incident: 55 + 83 maintainer/liaison messages have been undelivered since ~07-14 and need a liaison session on the leader host (endolin-garden2-5bcdff64) to drain the inbox. This is blocking the sturdyref press (tracker #47 / #737), whose only live maintainer channel is now GitHub comments. Please run a liaison session on the leader host to drain the backlog.

- `20260717T001224Z-3483f4` — from gardener:ocapn-noise-press-20260717-000503, reply_to `ocapn-noise-press-20260717-000503` · [open message](https://github.com/kriskowal/garden/blob/journal2/inbox/maintainer/unread/20260717T001224Z-3483f4.md)

> OCapN-over-Noise press status + one decision needed.
>
> Status: M1-M5 all demonstrated. The stack ([endojs/endo-but-for-bots#340](https://github.com/endojs/endo-but-for-bots/issues/340) -> [endojs/endo-but-for-bots#684](https://github.com/endojs/endo-but-for-bots/issues/684) -> [endojs/endo-but-for-bots#688](https://github.com/endojs/endo-but-for-bots/issues/688) -> [endojs/endo-but-for-bots#693](https://github.com/endojs/endo-but-for-bots/issues/693)) was rebased onto llm yesterday; today's dispatch found lint red on the upper three PRs from a shellcheck SC2034 (unused loop var) in the new demo/minion-town/ssm.sh. Fixed on the [endojs/endo-but-for-bots#684](https://github.com/endojs/endo-but-for-bots/issues/684) branch and propagated up the stack via clean rebases; fresh CI is running. The remaining macOS test failures are flakes in @endo/agentry and @endo/chat - packages the stack never touches.
>
> Decision needed: OCapN.md's definition of done wants cross-host (local <-> minion.town) over BOTH transports. wss+Noise cross-host is proven live (transcript in [endojs/endo-but-for-bots#693](https://github.com/endojs/endo-but-for-bots/issues/693)). TCP+CBOR+Noise invite/accept is proven only local<->local, because minion.town blocks all non-443 ingress - the demo README explicitly scoped remote TCP out. Closing the literal finish line requires opening an inbound TCP port (e.g. 8931) on minion.town's EC2 security group plus a docker port mapping for the daemon's TCP netlayer. That widens the host's attack surface (Noise IK still gates sessions, but the port itself is new exposure).
>
> May I open a dedicated TCP port on minion.town for the cross-host TCP+CBOR demo? Or do you consider the local TCP transcript + cross-host wss sufficient to call the goal done? Reply routes to inbox ocapn-noise-press-20260717-000503 (or the next 6h dispatch picks it up as a dead-letter).

- `20260717T001253Z-4cf4cc` — from watchdog:gardener/4, reply_to `?` · [open message](https://github.com/kriskowal/garden/blob/journal2/inbox/maintainer/unread/20260717T001253Z-4cf4cc.md)

> gardener job 'build-kebab-case-lint-wildcard-test262' DETERMINISTICALLY overran its handler budget (rc=124 at the wall, elapsed=2400s ≈ handler-budget=2400s). It does not fit in a single claim-scoped handler and will be POISONED after GARDEN_REAP_OVERRUN_THRESHOLD (2) cycles without completing. Same root cause as an over-large declared handler-timeout, but under the default budget it gets no early signal — surfaced here so you don't have to reverse-engineer it from the reaper's generic poison report. Remedy: SPLIT it into claim-sized stages, or run it DETACHED outside the claim-scoped handler.

- `20260717T001350Z-84839b` — from gardener:endojs-endo-but-for-bots-pr761-shepherd, reply_to `endojs-endo-but-for-bots-pr761-shepherd` · [open message](https://github.com/kriskowal/garden/blob/journal2/inbox/maintainer/unread/20260717T001350Z-84839b.md)

> Heads-up (endemic, not one PR): endo-but-for-bots CI job `zizmor` (Workflow security audit) is red repo-wide, including master since ~2026-07-15 (commit fcbb540). It's an online-audit `unpinned-uses` finding — every workflow's `@249970729cb0` action pin now has a "mismatched or missing version comment" (the upstream tag moved). Offline zizmor is clean; `.github/` is unchanged from base. Fix belongs in a separate repo-maintenance PR (refresh action-pin version comments, or run the repo's update-action-pins automation) — not inside feature/bugfix PRs. Shepherds on any PR that touches no workflows will keep leaving this one red as out-of-scope.

- `poison-endojs-endo-but-for-bots-pr124-shepherd-deadline-overrun` — from reaper:endolin-garden2-5bcdff64, reply_to `?` · [open message](https://github.com/kriskowal/garden/blob/journal2/inbox/maintainer/unread/poison-endojs-endo-but-for-bots-pr124-shepherd-deadline-overrun.md)

> POISON job PARKED in jobs/plan/ (held, gate=go-ahead) after 1 DEADLINE-OVERRUN cycles on endolin-garden2-5bcdff64.
> Its handler hit its OWN wall-clock budget every cycle (rc=124, elapsed≈GARDEN_HANDLER_TIMEOUT=2400s):
> this job EXCEEDS THE HANDLER BUDGET and would be killed identically on every requeue,
> so the reaper surfaced it after 1 overrun cycles (not the full 5-cycle poison threshold).
> The work is preserved at jobs/plan/endojs-endo-but-for-bots-pr124-shepherd; it stays HELD until a human promotes it
> (promote-plan.sh endojs-endo-but-for-bots-pr124-shepherd) or removes it. Triage: split the job, raise GARDEN_HANDLER_TIMEOUT
> for this work, or fix what makes it run long.
> Original job base: endojs-endo-but-for-bots-pr124-shepherd
>
> --- original job body ---
> # shepherd (auto: red CI) on endojs/endo-but-for-bots PR #124
>
> CI is RED on this OPEN bot-authored PR (completed failure, not in-progress).
> Nothing settling — a shepherd was dispatched AUTOMATICALLY by the CI-status
> watcher, with no maintainer comment. Map: **shepherd** → drive CI to green.
>
> PR: [https://github.com/endojs/endo-but-for-bots/pull/124](https://github.com/endojs/endo-but-for-bots/pull/124)
> Head: endojs/endo-but-for-bots (bot-pushable)
>
> Read the failing checks and drive them green (see roles/shepherd/AGENT.md).
> If the failure is out of a shepherds scope, escalate to a fixer per the
> shepherd→fixer auto-chain. Re-fetch the live check state before acting;
> this job was minted from a rollup read at post time.
>
> <!-- garden-deadline-overrun: 1 -->

- `poison-endojs-endo-but-for-bots-pr704-shepherd-requeue-exhausted` — from reaper:endolin-garden2-5bcdff64, reply_to `?` · [open message](https://github.com/kriskowal/garden/blob/journal2/inbox/maintainer/unread/poison-endojs-endo-but-for-bots-pr704-shepherd-requeue-exhausted.md)

> POISON job PARKED in jobs/plan/ (held, gate=go-ahead) after 5 requeue cycles on endolin-garden2-5bcdff64.
> Its handler appears to fail every time; the reaper stopped requeueing it.
> The work is preserved at jobs/plan/endojs-endo-but-for-bots-pr704-shepherd; it stays HELD until a human promotes it
> (promote-plan.sh endojs-endo-but-for-bots-pr704-shepherd) or removes it, so nothing is lost.
> Original job base: endojs-endo-but-for-bots-pr704-shepherd
>
> --- original job body ---
> # shepherd (auto: red CI) on endojs/endo-but-for-bots PR #704
>
> CI is RED on this OPEN bot-authored PR (completed failure, not in-progress).
> Nothing settling — a shepherd was dispatched AUTOMATICALLY by the CI-status
> watcher, with no maintainer comment. Map: **shepherd** → drive CI to green.
>
> PR: [https://github.com/endojs/endo-but-for-bots/pull/704](https://github.com/endojs/endo-but-for-bots/pull/704)
> Head: endojs/endo-but-for-bots (bot-pushable)
>
> Read the failing checks and drive them green (see roles/shepherd/AGENT.md).
> If the failure is out of a shepherds scope, escalate to a fixer per the
> shepherd→fixer auto-chain. Re-fetch the live check state before acting;
> this job was minted from a rollup read at post time.

- `poison-gauntlet-endo-but-for-bots-pr694-daemon-docker-self-hosting-requeue-exhausted` — from reaper:endolin-garden2-5bcdff64, reply_to `?` · [open message](https://github.com/kriskowal/garden/blob/journal2/inbox/maintainer/unread/poison-gauntlet-endo-but-for-bots-pr694-daemon-docker-self-hosting-requeue-exhausted.md)

> POISON job PARKED in jobs/plan/ (held, gate=go-ahead) after 5 requeue cycles on endolin-garden2-5bcdff64.
> Its handler appears to fail every time; the reaper stopped requeueing it.
> The work is preserved at jobs/plan/gauntlet-endo-but-for-bots-pr694-daemon-docker-self-hosting; it stays HELD until a human promotes it
> (promote-plan.sh gauntlet-endo-but-for-bots-pr694-daemon-docker-self-hosting) or removes it, so nothing is lost.
> Original job base: gauntlet-endo-but-for-bots-pr694-daemon-docker-self-hosting
>
> --- original job body ---
> ---
> role: shepherd
> ---
>
> Run the gauntlet (clean → panel review → fix-loop → un-draft) on `endojs/endo-but-for-bots` DRAFT PR #694 `feat: Docker self-hosting image with authenticated remote gateway` (base `llm`, head `build/daemon-docker-selfhost-remote-gateway`), driving this freshly-built, mergeable-but-stranded PR toward mergeable to advance M3's headline exit criterion (self-host the daemon via Docker with a remote bearer-token gateway). Treat the known repo-wide lint projectService ceiling (tracked by #594) as pre-existing and out of scope; do not merge or touch superseded PR #608 (its disposition is a maintainer decision).

- `poison-gauntlet-endo-but-for-bots-pull-request-707-git-capability-worked-version-controlled-filesystem-loop-requeue-exhausted` — from reaper:endolin-garden-ece02cb4, reply_to `?` · [open message](https://github.com/kriskowal/garden/blob/journal2/inbox/maintainer/unread/poison-gauntlet-endo-but-for-bots-pull-request-707-git-capability-worked-version-controlled-filesystem-loop-requeue-exhausted.md)

> POISON job PARKED in jobs/plan/ (held, gate=go-ahead) after 5 requeue cycles on endolin-garden-ece02cb4.
> Its handler appears to fail every time; the reaper stopped requeueing it.
> The work is preserved at jobs/plan/gauntlet-endo-but-for-bots-pull-request-707-git-capability-worked-version-controlled-filesystem-loop; it stays HELD until a human promotes it
> (promote-plan.sh gauntlet-endo-but-for-bots-pull-request-707-git-capability-worked-version-controlled-filesystem-loop) or removes it, so nothing is lost.
> Original job base: gauntlet-endo-but-for-bots-pull-request-707-git-capability-worked-version-controlled-filesystem-loop
>
> --- original job body ---
> Run the gauntlet (clean → panel review → fix-loop → un-draft) on [endojs/endo-but-for-bots#707](https://github.com/endojs/endo-but-for-bots/issues/707), the git-capability stack Phase 3 that delivers the worked version-controlled-filesystem loop named as milestone M3's exit criterion. The PR is green on CI but still DRAFT; drive it to review-passed and un-drafted so it joins the merge-ready stack (#705/#706/#708) alongside it.
>
>
> <!-- garden-deadline-overrun: 1 -->

- `poison-kriscendobot-agoric-sdk-pr15-shepherd-deadline-overrun` — from reaper:endolin-garden2-5bcdff64, reply_to `?` · [open message](https://github.com/kriskowal/garden/blob/journal2/inbox/maintainer/unread/poison-kriscendobot-agoric-sdk-pr15-shepherd-deadline-overrun.md)

> POISON job PARKED in jobs/plan/ (held, gate=go-ahead) after 1 DEADLINE-OVERRUN cycles on endolin-garden2-5bcdff64.
> Its handler hit its OWN wall-clock budget every cycle (rc=124, elapsed≈GARDEN_HANDLER_TIMEOUT=2400s):
> this job EXCEEDS THE HANDLER BUDGET and would be killed identically on every requeue,
> so the reaper surfaced it after 1 overrun cycles (not the full 5-cycle poison threshold).
> The work is preserved at jobs/plan/kriscendobot-agoric-sdk-pr15-shepherd; it stays HELD until a human promotes it
> (promote-plan.sh kriscendobot-agoric-sdk-pr15-shepherd) or removes it. Triage: split the job, raise GARDEN_HANDLER_TIMEOUT
> for this work, or fix what makes it run long.
> Original job base: kriscendobot-agoric-sdk-pr15-shepherd
>
> --- original job body ---
> # shepherd (auto: red CI) on kriscendobot/agoric-sdk PR #15
>
> CI is RED on this OPEN bot-authored PR (completed failure, not in-progress).
> Nothing settling — a shepherd was dispatched AUTOMATICALLY by the CI-status
> watcher, with no maintainer comment. Map: **shepherd** → drive CI to green.
>
> PR: [https://github.com/kriscendobot/agoric-sdk/pull/15](https://github.com/kriscendobot/agoric-sdk/pull/15)
> Head: kriscendobot/agoric-sdk (bot-pushable)
>
> Read the failing checks and drive them green (see roles/shepherd/AGENT.md).
> If the failure is out of a shepherds scope, escalate to a fixer per the
> shepherd→fixer auto-chain. Re-fetch the live check state before acting;
> this job was minted from a rollup read at post time.
>
> <!-- garden-deadline-overrun: 1 -->


## Spend & quota
_Trailing 7d window; billable tokens (cache reads excluded). Leader-host local spend._

| Provider | Token spend | Dollar spend | % of quota |
| --- | --- | --- | --- |
| Claude | 103.5M | $1060.22 _(notional, rate-card)_ | no quota set |
| Codex | 132.8M _(+181.3M cached)_ | n/a _(ChatGPT prolite plan — no per-token $; plan-metered)_ | 15% _(plan; codex-reported)_ |

## Board
### todo (0)
(none)

### doin (15)
- [`build-kebab-case-lint-wildcard-test262`](https://github.com/kriskowal/garden/blob/journal2/jobs/doin/build-kebab-case-lint-wildcard-test262.md) — Reconstruct the kebab-case file-name linter (endojs/endo#2947) with WILDCARD ...
- [`endo-byte-array-press-20260717-000503`](https://github.com/kriskowal/garden/blob/journal2/jobs/doin/endo-byte-array-press-20260717-000503.md) — Press passable/immutable byte arrays forward (endojs/endo-but-for-bots, base ...
- [`endo-git-integration-press-20260717-000503`](https://github.com/kriskowal/garden/blob/journal2/jobs/doin/endo-git-integration-press-20260717-000503.md) — Press git-integration / the M3 version-controlled-filesystem loop (endojs/end...
- [`endo-vfs-parity-press-20260717-000503`](https://github.com/kriskowal/garden/blob/journal2/jobs/doin/endo-vfs-parity-press-20260717-000503.md) — Press VFS tool-call-surface parity forward (endojs/endo-but-for-bots, base llm)
- [`endojs-endo-but-for-bots-pr755-shepherd`](https://github.com/kriskowal/garden/blob/journal2/jobs/doin/endojs-endo-but-for-bots-pr755-shepherd.md) — shepherd (auto: red CI) on endojs/endo-but-for-bots PR #755
- [`endojs-endo-but-for-bots-pr760-shepherd`](https://github.com/kriskowal/garden/blob/journal2/jobs/doin/endojs-endo-but-for-bots-pr760-shepherd.md) — shepherd (auto: red CI) on endojs/endo-but-for-bots PR #760
- [`endojs-endo-but-for-bots-pr762-shepherd`](https://github.com/kriskowal/garden/blob/journal2/jobs/doin/endojs-endo-but-for-bots-pr762-shepherd.md) — shepherd (auto: red CI) on endojs/endo-but-for-bots PR #762
- [`endojs-endo-but-for-bots-pr763-shepherd`](https://github.com/kriskowal/garden/blob/journal2/jobs/doin/endojs-endo-but-for-bots-pr763-shepherd.md) — shepherd (auto: red CI) on endojs/endo-but-for-bots PR #763
- [`endojs-endo-but-for-bots-pr764-shepherd`](https://github.com/kriskowal/garden/blob/journal2/jobs/doin/endojs-endo-but-for-bots-pr764-shepherd.md) — shepherd (auto: red CI) on endojs/endo-but-for-bots PR #764
- [`gauntlet-endo-but-for-bots-pr585-content-store-powers`](https://github.com/kriskowal/garden/blob/journal2/jobs/doin/gauntlet-endo-but-for-bots-pr585-content-store-powers.md) — Run the gauntlet (panel review → fix-loop) on endojs/endo-but-for-bots PR #58...
- [`gauntlet-endo-but-for-bots-pr739-store-writefile-design`](https://github.com/kriskowal/garden/blob/journal2/jobs/doin/gauntlet-endo-but-for-bots-pr739-store-writefile-design.md) — Run the gauntlet (clean → panel review → fix-loop → un-draft) on endojs/endo-...
- [`mirror-endo-2780-cache-globals-gauntlet`](https://github.com/kriskowal/garden/blob/journal2/jobs/doin/mirror-endo-2780-cache-globals-gauntlet.md) — Mirror upstream endojs/endo#2780 (Cache globals) onto a frozen master base, t...
- [`ocapn-noise-press-20260717-000503`](https://github.com/kriskowal/garden/blob/journal2/jobs/doin/ocapn-noise-press-20260717-000503.md) — Press OCapN-over-Noise forward (endojs/endo-but-for-bots, base llm)
- [`scholar-ingest-financial-forecasting-corpus-6`](https://github.com/kriskowal/garden/blob/journal2/jobs/doin/scholar-ingest-financial-forecasting-corpus-6.md) — Scholar: ingest remaining financial-forecasting corpus (follow-on 6)
- [`scholar-ingest-financial-forecasting-corpus-7`](https://github.com/kriskowal/garden/blob/journal2/jobs/doin/scholar-ingest-financial-forecasting-corpus-7.md) — Scholar: ingest remaining financial-forecasting corpus (follow-on 7)

### tada (2419)
- [`gauntlet-endo-but-for-bots-pr749-content-locator-grammar-duality`](https://github.com/kriskowal/garden/blob/journal2/jobs/tada/gauntlet-endo-but-for-bots-pr749-content-locator-grammar-duality.md) — Completed PR #749 gauntlet fix-loop and marked it ready for review.
- [`endojs-endo-but-for-bots-pr761-shepherd`](https://github.com/kriskowal/garden/blob/journal2/jobs/tada/endojs-endo-but-for-bots-pr761-shepherd.md) — Completion report — shepherd on endojs/endo-but-for-bots PR #761
- [`xs2rust-endor-stage7-live-globalthis`](https://github.com/kriskowal/garden/blob/journal2/jobs/tada/xs2rust-endor-stage7-live-globalthis.md) — Stage 7 child 1/7 — live globalThis binding — COMPLETE
- [`endojs-endo-but-for-bots-pr757-shepherd`](https://github.com/kriskowal/garden/blob/journal2/jobs/tada/endojs-endo-but-for-bots-pr757-shepherd.md) — CI green for PR #757.
- [`self-heal-fix-garden-issue-inbox-issue-source-stderr`](https://github.com/kriskowal/garden/blob/journal2/jobs/tada/self-heal-fix-garden-issue-inbox-issue-source-stderr.md) — Implemented and pushed 4ff7ca2e66 to main2.
- … and 2414 more

## Plan queue (parked — not claimable until promoted)
### awaiting go-ahead (maintainer authorization)
- [`build-endo-daemon-cloudflare-storage`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/build-endo-daemon-cloudflare-storage.md) — _normal_ · Build: Endo daemon Cloudflare storage platform (phases 1-2 of the design)
- [`deploy-endo-daemon-aws-storage-reference`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/deploy-endo-daemon-aws-storage-reference.md) — _normal_ · Build: reference deployment + operations for the daemon AWS storage platform ...
- [`deploy-siwe-thunk-minion-town`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/deploy-siwe-thunk-minion-town.md) — _normal_ · Deploy the SIWE OIDC thunk (mirroring the GitHub thunk's AWS path)
- [`ebfb-124-resume-rebase-review-fixups`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/ebfb-124-resume-rebase-review-fixups.md) — _normal_ · ---
- [`ebfb-124-sqlite-iterate-streaming`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/ebfb-124-sqlite-iterate-streaming.md) — _normal_ · ---
- [`ebfb-124-sqlite-pragma-simple`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/ebfb-124-sqlite-pragma-simple.md) — _normal_ · ---
- [`ebfb-124-sqlite-shutdown-checkpoint`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/ebfb-124-sqlite-shutdown-checkpoint.md) — _normal_ · ---
- [`endojs-endo-but-for-bots-pr124-shepherd`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr124-shepherd.md) — _normal_ · shepherd (auto: red CI) on endojs/endo-but-for-bots PR #124
- [`endojs-endo-but-for-bots-pr132-report-render-mode`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr132-report-render-mode.md) — _normal_ · re-port render-mode toggle onto @endo/space-chat InboxRoot (endojs/endo-but-f...
- [`endojs-endo-but-for-bots-pr592-cancel-in-options`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr592-cancel-in-options.md) — _normal_ · Fixer: reshape watchDirectory cancellation API (endojs/endo-but-for-bots #592)
- [`endojs-endo-but-for-bots-pr704-shepherd`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr704-shepherd.md) — _normal_ · shepherd (auto: red CI) on endojs/endo-but-for-bots PR #704
- [`foreman-budget-cross-host-weekly-token-aggregation`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/foreman-budget-cross-host-weekly-token-aggregation.md) — _normal_ · PLAN: deterministic cross-host weekly token-spend aggregation for the foreman...
- [`garden-style-url-not-path`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/garden-style-url-not-path.md) — _normal_ · ---
- [`gauntlet-endo-but-for-bots-pr661-agent-tools-http-client`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/gauntlet-endo-but-for-bots-pr661-agent-tools-http-client.md) — _normal_ · ---
- [`gauntlet-endo-but-for-bots-pr694-daemon-docker-self-hosting`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/gauntlet-endo-but-for-bots-pr694-daemon-docker-self-hosting.md) — _normal_ · ---
- [`gauntlet-endo-but-for-bots-pull-request-707-git-capability-worked-version-controlled-filesystem-loop`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/gauntlet-endo-but-for-bots-pull-request-707-git-capability-worked-version-controlled-filesystem-loop.md) — _normal_ · ---
- [`kriscendobot-agoric-sdk-pr15-shepherd`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/kriscendobot-agoric-sdk-pr15-shepherd.md) — _normal_ · shepherd (auto: red CI) on kriscendobot/agoric-sdk PR #15
- [`open-signup-gate-flip-minion-town`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/open-signup-gate-flip-minion-town.md) — _normal_ · Build: open-signup gate flip for minion.town (Phase B — THE consequential cha...
- [`verify-ymax0-hex-fix-inquisitor`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/verify-ymax0-hex-fix-inquisitor.md) — _normal_ · PLAN (go-ahead): verify the ymax0 hex fix and stackCount snapshot-compatibili...
- [`wire-siwe-onchain-authz-minion-town`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/wire-siwe-onchain-authz-minion-town.md) — _normal_ · Wire the chosen SIWE on-chain authorization tier into minion.town's policy layer

### deferred (top by priority; foreman auto-promotes when idle)
(none)

### blocked (awaiting an artifact; unblock watcher auto-promotes on completion)
- [`build-daemon-rename-to-manager-phase2`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/build-daemon-rename-to-manager-phase2.md) — awaiting `https://github.com/endojs/endo-but-for-bots/pull/598` · Build: daemon→manager rename Phase 2 (identifier renames)
- [`build-daemon-rename-to-manager-phase3`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/build-daemon-rename-to-manager-phase3.md) — awaiting `build-daemon-rename-to-manager-phase2` · Build: daemon→manager rename Phase 3 (consumer sweep + CHANGELOG + docs)
- [`build-endo-inspect`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/build-endo-inspect.md) — awaiting `endojs/endo-but-for-bots#715` · Build: implement @endo/inspect per the landed design
- [`build-endo-regexp-conservative-subset`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/build-endo-regexp-conservative-subset.md) — awaiting `endojs/endo-but-for-bots#676` · Build: implement @endo/regexp — the conservative-regexp-subset linear matcher
- [`port-xs-to-rust-memory-safe-engine-s22`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/port-xs-to-rust-memory-safe-engine-s22.md) — awaiting `xs2rust-endor-build-stage7` · Fable supervisor: drive the XS→Rust (Endor) port from design to maintainer-re...
- [`registry-immutable-byte-array-followup`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/registry-immutable-byte-array-followup.md) — awaiting `https://github.com/endojs/endo-but-for-bots/pull/671` · Immutable byte-array RegistryInterface follow-up
- [`resume-lint-ceiling-shepherds`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/resume-lint-ceiling-shepherds.md) — awaiting `https://github.com/endojs/endo-but-for-bots/pull/594` · Resume shepherds for PRs blocked by the endo-but-for-bots lint projectService...

## Watch set
kriscendobot-agoric-3-proposals kriscendobot-agoric-sdk kriscendobot-cosgov kriscendobot-endo kriscendobot-finbot kriscendobot-minion.town kriscendobot-ocapn kriscendobot-vattr97 kriscendobot-ymax-e2e

## Hosts
- [endolin-garden-ece02cb4](https://github.com/kriskowal/garden/blob/journal2/hosts/endolin-garden-ece02cb4): 20 gardeners
- [endolin-garden2-5bcdff64](https://github.com/kriskowal/garden/blob/journal2/hosts/endolin-garden2-5bcdff64): 10 gardeners
