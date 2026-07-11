# Garden bulletin

_As of 2026-07-11T05:58:57Z_

## Latest

The headline for kriscendobot is a fleet-wide triager crash-loop: every `garden-triager@*` unit is still FATAL-looping because the deployed root (`/home/kris/garden2`, ~56 commits behind `origin/main2`) predates the `GARDEN_REPOS` `/repos`→`/worktrees` fix. The code fix and its regression tests are already landed and green on `main2` (through `4c0e275b0b`), and all eight own-fork bare clones now exist under `worktrees/`, so a single drained `deploy-garden.sh` should clear the storm — that deploy is the one remaining human/leader step, and several self-heal reports and one circuit-breaker (`kriscendobot-finbot`, now OPEN) trace back to it.

On the project side, finbot advanced four green increments direct-to-`main` over the last day — SES-compartments (the capability-attenuation cornerstone), multi-instrument/yield portfolios, a cyclical (seasonal + residual-GBM) forecaster, and GARCH(1,1) conditional volatility — clearing its stranded-branch backlog to zero (435 tests, safety gate holding, no live wallet). The gardener re-flags an open decision: finbot's no-self-PR/fast-forward convention keeps stranding branches, so either let builders land on `main` directly or stand up a weaver/conductor sweep.

The [kriscendobot/agoric-sdk PR #9](https://github.com/kriscendobot/agoric-sdk/pull/9) 6-hourly drive completed: a peer's new head `71cb13f9` introduced two fresh reds (lint-rest, test-boot), so a shepherd was commissioned to fix the PR-attributable failures. It still needs your call on rebase-onto-master + un-draft + SwingSet review vs. keeping it a frozen-base prototype — approval can't proceed while it's a draft with no review. Elsewhere on endo-but-for-bots, PR #683's shepherd landed all 24 checks green while [#660](https://github.com/endojs/endo-but-for-bots/pull/660)'s red-CI shepherd is still in flight.

## Parked for maintainer feedback

- [endojs/endo-but-for-bots#594](https://github.com/endojs/endo-but-for-bots/pull/594) — chore(lint): lint per package to avoid the typescript-eslint project-service ceiling (waiting 13h)
- [endojs/endo-but-for-bots#113](https://github.com/endojs/endo-but-for-bots/pull/113) — test(ocapn-noise): integration + transport tests (#59 stack 3/3) (waiting 1d)
- [endojs/endo-but-for-bots#101](https://github.com/endojs/endo-but-for-bots/pull/101) — feat(chat): voice input via Web Speech API (waiting 8d)
- [endojs/endo-but-for-bots#503](https://github.com/endojs/endo-but-for-bots/pull/503) — feat(immutable-arraybuffer,pass-style): passable byte arrays (freezable TypedArray emulation + byteArray brand check) (waiting 11d)
- [endojs/endo-but-for-bots#403](https://github.com/endojs/endo-but-for-bots/pull/403) — feat(registry-capability): EndoRegistry capability + @registry special name (#358 layer 1) (waiting 11d)
- [endojs/endo-but-for-bots#379](https://github.com/endojs/endo-but-for-bots/pull/379) — fix(ses): cyclic star export with renaming reexport (issue #59) - refresh for #3276 feedback (waiting 15d)
- [endojs/endo#3137](https://github.com/endojs/endo/pull/3137) — feat: support .ts runtime modules via erasable type syntax (waiting 25d)
- [endojs/endo-but-for-bots#182](https://github.com/endojs/endo-but-for-bots/pull/182) — test(ses): isImmutableDataProperty regression for iOS Safari fix (closes #947) (waiting 50d)
- [endojs/endo-but-for-bots#186](https://github.com/endojs/endo-but-for-bots/pull/186) — feat(eventual-send): eager-shim/lazy-main delegate ponyfill (per #175) (waiting 50d)
- [endojs/endo-but-for-bots#266](https://github.com/endojs/endo-but-for-bots/pull/266) — design: opencode comparative analysis + gap-closing raft (endopen) (waiting 51d)

_Showing top 10 of 26 parked PRs (ranked by recency + roadmap relevance)._
## Messages to the maintainer

- `20260709T212252Z-402b49` — from foreman, reply_to `?` · [open message](https://github.com/kriskowal/garden/blob/journal2/inbox/maintainer/unread/20260709T212252Z-402b49.md)

> foreman: next step 'endojs-endo-but-for-bots-endoclaw-timer-phase4-host-integration' recurred after the previous post drained without milestone progress. Holding the re-post pending review; it may be stuck.

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

- `20260710T080657Z-b2a12b` — from watchdog:self-heal-claude, reply_to `?` · [open message](https://github.com/kriskowal/garden/blob/journal2/inbox/maintainer/unread/20260710T080657Z-b2a12b.md)

> self-heal: garden-triager@kriscendobot-agoric-sdk exited rc=1 with no scoped fix. Capture: 2f131b35374b9b62693863cfc7998cf9bcbfdfba (git -C /home/kris/garden/.garden-state/self-heal/journal cat-file -p 2f131b35374b9b62693863cfc7998cf9bcbfdfba). Diagnosis: You've hit your session limit · resets 9:10am (UTC)

- `20260710T083558Z-403210` — from watchdog:self-heal-claude, reply_to `?` · [open message](https://github.com/kriskowal/garden/blob/journal2/inbox/maintainer/unread/20260710T083558Z-403210.md)

> self-heal: garden-triager@kriscendobot-endo exited rc=1 with no scoped fix. Capture: 0c1602929aab473ba431caa511022045f934b02b (git -C /home/kris/garden/.garden-state/self-heal/journal cat-file -p 0c1602929aab473ba431caa511022045f934b02b). Diagnosis: You've hit your session limit · resets 9:10am (UTC)

- `20260710T123828Z-7aca43` — from gardener:finbot-progress-20260710-123501, reply_to `finbot-progress-20260710-123501` · [open message](https://github.com/kriskowal/garden/blob/journal2/inbox/maintainer/unread/20260710T123828Z-7aca43.md)

> finbot progress (cycle 20260710-123501):
>
> ADVANCED: Landed the **multi-instrument portfolios + yield-bearing instruments**
> increment on kriscendobot/finbot@main (071c58f..bf7ebf4). Rebased the stranded
> feat/additional-instruments stack onto current main — the rebase revealed 5 of its
> 6 commits were already patch-equivalent on main (driver, richer-forecasting,
> forecast-eval, volatility-tolerance, richer-instrument-models, llm-role-dispatch,
> substrate-adapters all previously landed), leaving exactly ONE genuinely-new
> commit: multi-asset target allocation with per-tick yield/APR accrual (DRIP),
> correlation-cluster penalty in the analyzer, carried through clone()/forecaster
> forks. Verified GREEN: 410 tests pass, all six auditor invariants PASS,
> finbot-ooda --seed=7 reports walletTouched: false (safety gate holds; no live
> wallet, no key/funds wired). Deleted the now-merged feat/additional-instruments.
>
> NEXT UNBLOCKED: rebase + land feat/cyclical-forecaster (1 unique commit:
> seasonal + residual-GBM cyclical-structure-aware forecaster). One increment,
> deferred to next cycle per the one-increment-per-dispatch guardrail.
>
> DECISION STILL OPEN (re-flagged from prior cycle): finbot's "no self-PR,
> fast-forward main" convention keeps stranding builder branches behind a diverging
> main, so every cycle pays rebase cost. Options: (a) let builders land finbot
> increments directly on main; (b) stand up a weaver/conductor sweep to
> fast-forward promptly. No action needed from you if the current per-cycle rebase
> cadence is acceptable — it is small so far.

- `20260710T183818Z-56d084` — from gardener:finbot-progress-20260710-183515, reply_to `finbot-progress-20260710-183515` · [open message](https://github.com/kriskowal/garden/blob/journal2/inbox/maintainer/unread/20260710T183818Z-56d084.md)

> finbot progress (cycle 20260710-183515): landed the **cyclical-structure-aware forecaster** (seasonal + residual GBM) on kriscendobot/finbot@main (bf7ebf4..a35add1). This was the last stranded feature branch.
>
> - Cherry-picked the single `feat/cyclical-forecaster` commit cleanly onto current main (adds packages/simulator/harmonic.js + price-feed harmonic model + 213-line harmonic.test.js).
> - GREEN: 424 tests pass, 0 fail (+14 from the harmonic suite vs last cycle's 410).
> - Safety gate holds: `finbot-ooda --seed=7` → all 6 auditor invariants PASS, WALLET TOUCHED: false.
> - Fast-forwarded fork main and deleted feat/cyclical-forecaster. **Only main + journal remain — no stranded branches.**
>
> Next unblocked increment (next cycle): pick a fresh design axis, since the branch backlog is now empty. Cleanest pure-build candidate is the **ensemble-forecasting open axis** — GARCH / implied-vol forecasting (designs/ensemble-forecasting.md:118) or the histogram-projection-render skill stub (line 72). Both are simulator-side and safe (no wallet).
>
> Needs a maintainer decision: the cap-attenuation next step — choosing the CapTP transport to replace the `spawnSigningWorker` gated stub and doing a first live paper-wallet/test-net run — is security-weighted and gated behind `live_authorized`. That is the deepest remaining axis but I will NOT advance it without explicit maintainer authorization.

- `20260710T184026Z-a5d76c` — from watchdog:self-heal-claude, reply_to `?` · [open message](https://github.com/kriskowal/garden/blob/journal2/inbox/maintainer/unread/20260710T184026Z-a5d76c.md)

> self-heal: garden-triager@kriscendobot-finbot exited rc=1 with no scoped fix. Capture: 9866e3fecbdeea6afd69aecb76069d7aa26acadc (git -C /home/kris/garden/.garden-state/self-heal/journal cat-file -p 9866e3fecbdeea6afd69aecb76069d7aa26acadc). Diagnosis: You've hit your session limit · resets 7:10pm (UTC)

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

- `20260710T203829Z-915af0` — from watchdog:gardener/16, reply_to `?` · [open message](https://github.com/kriskowal/garden/blob/journal2/inbox/maintainer/unread/20260710T203829Z-915af0.md)

> gardener job 'build-endo-glob-grep-pushdown' DETERMINISTICALLY overran its handler budget (rc=124 at the wall, elapsed=2400s ≈ handler-budget=2400s). It does not fit in a single claim-scoped handler and will be POISONED after GARDEN_REAP_OVERRUN_THRESHOLD (2) cycles without completing. Same root cause as an over-large declared handler-timeout, but under the default budget it gets no early signal — surfaced here so you don't have to reverse-engineer it from the reaper's generic poison report. Remedy: SPLIT it into claim-sized stages, or run it DETACHED outside the claim-scoped handler.

- `20260710T232127Z-0bf7e8` — from watchdog:self-heal-claude, reply_to `?` · [open message](https://github.com/kriskowal/garden/blob/journal2/inbox/maintainer/unread/20260710T232127Z-0bf7e8.md)

> self-heal: garden-triager@kriscendobot-agoric-sdk exited rc=1 with no scoped fix. Capture: 0f5f7366b605f0932b0079aabb72fa1724bc7ea3 (git -C /home/kris/garden2/.garden-state/self-heal/journal cat-file -p 0f5f7366b605f0932b0079aabb72fa1724bc7ea3). Diagnosis: You've hit your session limit · resets 12:30am (UTC)

- `20260710T232133Z-a22307` — from watchdog:self-heal-claude, reply_to `?` · [open message](https://github.com/kriskowal/garden/blob/journal2/inbox/maintainer/unread/20260710T232133Z-a22307.md)

> self-heal: garden-triager@kriscendobot-cosgov exited rc=1 with no scoped fix. Capture: 014fb3bfe31c0c9d8de45fe8ac9da0113c043600 (git -C /home/kris/garden2/.garden-state/self-heal/journal cat-file -p 014fb3bfe31c0c9d8de45fe8ac9da0113c043600). Diagnosis: You've hit your session limit · resets 12:30am (UTC)

- `20260710T232133Z-edb78b` — from watchdog:self-heal-claude, reply_to `?` · [open message](https://github.com/kriskowal/garden/blob/journal2/inbox/maintainer/unread/20260710T232133Z-edb78b.md)

> self-heal: garden-triager@kriscendobot-endo exited rc=1 with no scoped fix. Capture: 00348948455e75d369c3be8e10003f6e35b20ac2 (git -C /home/kris/garden2/.garden-state/self-heal/journal cat-file -p 00348948455e75d369c3be8e10003f6e35b20ac2). Diagnosis: You've hit your session limit · resets 12:30am (UTC)

- `20260710T232133Z-f114e0` — from watchdog:self-heal-claude, reply_to `?` · [open message](https://github.com/kriskowal/garden/blob/journal2/inbox/maintainer/unread/20260710T232133Z-f114e0.md)

> self-heal: garden-triager@kriscendobot-finbot exited rc=1 with no scoped fix. Capture: 980f2d6ef4e84d709f0877f977c3411c46f36e2b (git -C /home/kris/garden2/.garden-state/self-heal/journal cat-file -p 980f2d6ef4e84d709f0877f977c3411c46f36e2b). Diagnosis: You've hit your session limit · resets 12:30am (UTC)

- `20260710T232147Z-ba14cb` — from watchdog:self-heal-claude, reply_to `?` · [open message](https://github.com/kriskowal/garden/blob/journal2/inbox/maintainer/unread/20260710T232147Z-ba14cb.md)

> self-heal: garden-triager@kriscendobot-minion.town exited rc=1 with no scoped fix. Capture: fe43f5de97a9b9472a538aba15034db093bd5678 (git -C /home/kris/garden2/.garden-state/self-heal/journal cat-file -p fe43f5de97a9b9472a538aba15034db093bd5678). Diagnosis: You've hit your session limit · resets 12:30am (UTC)

- `20260710T232203Z-e21cb9` — from watchdog:self-heal-claude, reply_to `?` · [open message](https://github.com/kriskowal/garden/blob/journal2/inbox/maintainer/unread/20260710T232203Z-e21cb9.md)

> self-heal: garden-triager@kriscendobot-vattr97 exited rc=1 with no scoped fix. Capture: 676eadfd0a3c48450f670461b8d7a462cd0882a6 (git -C /home/kris/garden2/.garden-state/self-heal/journal cat-file -p 676eadfd0a3c48450f670461b8d7a462cd0882a6). Diagnosis: You've hit your session limit · resets 12:30am (UTC)

- `20260710T232210Z-73cde5` — from watchdog:self-heal-claude, reply_to `?` · [open message](https://github.com/kriskowal/garden/blob/journal2/inbox/maintainer/unread/20260710T232210Z-73cde5.md)

> self-heal: garden-triager@kriscendobot-agoric-3-proposals exited rc=1 with no scoped fix. Capture: 5b3292878419027c1f87821065824206cf90b4b2 (git -C /home/kris/garden2/.garden-state/self-heal/journal cat-file -p 5b3292878419027c1f87821065824206cf90b4b2). Diagnosis: You've hit your session limit · resets 12:30am (UTC)

- `20260710T232229Z-6ab1ec` — from watchdog:self-heal-claude, reply_to `?` · [open message](https://github.com/kriskowal/garden/blob/journal2/inbox/maintainer/unread/20260710T232229Z-6ab1ec.md)

> self-heal: garden-triager@kriscendobot-ocapn exited rc=1 with no scoped fix. Capture: b1b74a55328df794e77aba81bb9722a4cf047fd9 (git -C /home/kris/garden2/.garden-state/self-heal/journal cat-file -p b1b74a55328df794e77aba81bb9722a4cf047fd9). Diagnosis: You've hit your session limit · resets 12:30am (UTC)

- `20260711T002142Z-ea2a76` — from watchdog:self-heal-claude, reply_to `?` · [open message](https://github.com/kriskowal/garden/blob/journal2/inbox/maintainer/unread/20260711T002142Z-ea2a76.md)

> self-heal: garden-triager@kriscendobot-cosgov exited rc=1 with no scoped fix. Capture: 306e082af9c0535203893b4537f73612cf616dac (git -C /home/kris/garden2/.garden-state/self-heal/journal cat-file -p 306e082af9c0535203893b4537f73612cf616dac). Diagnosis: You've hit your session limit · resets 12:30am (UTC)

- `20260711T002148Z-4b4278` — from watchdog:self-heal-claude, reply_to `?` · [open message](https://github.com/kriskowal/garden/blob/journal2/inbox/maintainer/unread/20260711T002148Z-4b4278.md)

> self-heal: garden-triager@kriscendobot-agoric-sdk exited rc=1 with no scoped fix. Capture: f0f3dbc26265e46eed5d6913dcde451fd68a6c9f (git -C /home/kris/garden2/.garden-state/self-heal/journal cat-file -p f0f3dbc26265e46eed5d6913dcde451fd68a6c9f). Diagnosis: You've hit your session limit · resets 12:30am (UTC)

- `20260711T002148Z-5dc824` — from watchdog:self-heal-claude, reply_to `?` · [open message](https://github.com/kriskowal/garden/blob/journal2/inbox/maintainer/unread/20260711T002148Z-5dc824.md)

> self-heal: garden-triager@kriscendobot-endo exited rc=1 with no scoped fix. Capture: 7ef6157d0f19577352bc9dc1d090bf1ece050232 (git -C /home/kris/garden2/.garden-state/self-heal/journal cat-file -p 7ef6157d0f19577352bc9dc1d090bf1ece050232). Diagnosis: You've hit your session limit · resets 12:30am (UTC)

- `20260711T002148Z-81a085` — from watchdog:self-heal-claude, reply_to `?` · [open message](https://github.com/kriskowal/garden/blob/journal2/inbox/maintainer/unread/20260711T002148Z-81a085.md)

> self-heal: garden-triager@kriscendobot-finbot exited rc=1 with no scoped fix. Capture: 093ea9f1fca5e4c0ff887c8b7fe6f53ffbdb368c (git -C /home/kris/garden2/.garden-state/self-heal/journal cat-file -p 093ea9f1fca5e4c0ff887c8b7fe6f53ffbdb368c). Diagnosis: You've hit your session limit · resets 12:30am (UTC)

- `20260711T002204Z-53b84c` — from watchdog:self-heal-claude, reply_to `?` · [open message](https://github.com/kriskowal/garden/blob/journal2/inbox/maintainer/unread/20260711T002204Z-53b84c.md)

> self-heal: garden-triager@kriscendobot-minion.town exited rc=1 with no scoped fix. Capture: 6afbd6b796722014c2fc6ca9878b6475309595fe (git -C /home/kris/garden2/.garden-state/self-heal/journal cat-file -p 6afbd6b796722014c2fc6ca9878b6475309595fe). Diagnosis: You've hit your session limit · resets 12:30am (UTC)

- `20260711T002231Z-6b48c7` — from watchdog:self-heal-claude, reply_to `?` · [open message](https://github.com/kriskowal/garden/blob/journal2/inbox/maintainer/unread/20260711T002231Z-6b48c7.md)

> self-heal: garden-triager@kriscendobot-agoric-3-proposals exited rc=1 with no scoped fix. Capture: bfdca708bc8263279fc342c9ed02450af6247ca8 (git -C /home/kris/garden2/.garden-state/self-heal/journal cat-file -p bfdca708bc8263279fc342c9ed02450af6247ca8). Diagnosis: You've hit your session limit · resets 12:30am (UTC)

- `20260711T002236Z-47b86d` — from watchdog:self-heal-claude, reply_to `?` · [open message](https://github.com/kriskowal/garden/blob/journal2/inbox/maintainer/unread/20260711T002236Z-47b86d.md)

> self-heal: garden-triager@kriscendobot-vattr97 exited rc=1 with no scoped fix. Capture: a948e966b5599ffd07ab2db6d6d699e8aa449da4 (git -C /home/kris/garden2/.garden-state/self-heal/journal cat-file -p a948e966b5599ffd07ab2db6d6d699e8aa449da4). Diagnosis: You've hit your session limit · resets 12:30am (UTC)

- `20260711T002301Z-75dc0f` — from watchdog:self-heal-claude, reply_to `?` · [open message](https://github.com/kriskowal/garden/blob/journal2/inbox/maintainer/unread/20260711T002301Z-75dc0f.md)

> self-heal: garden-triager@kriscendobot-ocapn exited rc=1 with no scoped fix. Capture: 9be24a3defac01ef901cdb39a0d9b2308807a869 (git -C /home/kris/garden2/.garden-state/self-heal/journal cat-file -p 9be24a3defac01ef901cdb39a0d9b2308807a869). Diagnosis: You've hit your session limit · resets 12:30am (UTC)

- `20260711T003523Z-afed25` — from gardener:self-heal-fix-garden-triager-kriscendobot-ocapn-missing-bare-clone-die, reply_to `self-heal-fix-garden-triager-kriscendobot-ocapn-missing-bare-clone-die` · [open message](https://github.com/kriskowal/garden/blob/journal2/inbox/maintainer/unread/20260711T003523Z-afed25.md)

> Triager crash-loop fix landed on main2 (4c0e275b0b). Two peers had already
> un-wedged the every-tick crash: GARDEN_REPOS now defaults to worktrees/ and the
> hard die became a clean skip. But that skip leaves the three watched repos with
> NO clone on any host — kriscendobot-{ocapn,agoric-3-proposals,cosgov} — UN-TRIAGED
> (they're no longer crashing, just silently unwatched).
>
> I added an OPT-IN self-provision path (GARDEN_TRIAGE_SELF_PROVISION=1): a triager
> tick with a missing clone derives the fork URL from the slug and does a bounded
> atomic bare clone (reusing clone-keeper's logic, now shared in common.sh), then
> triages; unreachable/underivable sources skip+retry and escalate once. It's
> DEFAULT-OFF so it doesn't fight the just-landed skip-model or auto-clone on every
> host. FOLLOW-UP / your call: to actually triage those 3 repos, either create their
> bare clones under worktrees/, or arm GARDEN_TRIAGE_SELF_PROVISION=1 on one host
> after confirming the forks exist.

- `20260711T005455Z-1261bb` — from gardener:self-heal-fix-garden-triager-kriscendobot-agoric-sdk-repos-default-path, reply_to `self-heal-fix-garden-triager-kriscendobot-agoric-sdk-repos-default-path` · [open message](https://github.com/kriskowal/garden/blob/journal2/inbox/maintainer/unread/20260711T005455Z-1261bb.md)

> Self-heal job (triager repos→worktrees default): the SOURCE fix is already landed in origin/main2 — triager.sh:38 and comment-watcher.sh:191 both default GARDEN_REPOS to $GARDEN_ROOT/worktrees (commit 118f7384fc, extended by 2c76c8cd92 / 4c0e275b0b), and the triager test suite passes 62/62 including case I which locks the default to worktrees/. Nothing to commit.
>
> But the DEPLOYED garden root (/home/kris/garden2) is still at 688e6174c8, BEHIND main2, so its triager.sh:25 / comment-watcher.sh:179 still carry the stale /repos default — that is why agoric-sdk / ocapn / vattr97 / agoric-3-proposals triagers keep failing. A deliberate deploy (deploy-garden.sh, via the deploy-on-upgrade Monitor) will clear those failing units. Redeploying the root is outside a gardener's mandate, so flagging for you.

- `20260711T005732Z-31c24e` — from gardener:self-heal-fix-garden-triager-kriscendobot-cosgov-repos-clone-path, reply_to `self-heal-fix-garden-triager-kriscendobot-cosgov-repos-clone-path` · [open message](https://github.com/kriskowal/garden/blob/journal2/inbox/maintainer/unread/20260711T005732Z-31c24e.md)

> Job self-heal-fix-garden-triager (GARDEN_REPOS /repos→/worktrees) — the code fix is ALREADY on origin/main2 (commit 118f7384fc + follow-ons 9ad9c72931, 54156852da, 1628b0995e, self-provision 2c76c8cd92/4c0e275b0b). Both triager.sh and comment-watcher.sh already default to $GARDEN_ROOT/worktrees; the buggy /repos default is gone from the tree; the header comment is updated; comment-watcher tests pass (211/1, the 1 fail is an unrelated sandbox subprocess-spawn artifact). Nothing to commit — this job was authored against the pre-fix tree.
>
> TWO things need a human, though:
>
> 1) DEPLOY GAP (why the fleet is STILL down at runtime): the deployed root /home/kris/garden2 is at 688e6174c8, which PREDATES the fix — its triager.sh:25 still reads /repos, so every garden-triager@* is still crash-looping with the /repos FATAL (confirmed live in journalctl as of 00:55Z, even for repos that HAVE a worktrees/ clone like kriscendobot-endo). The deployed root is ~10 commits behind origin/main2. A deliberate drained deploy (deploy-garden.sh) is needed to actually restore the fleet; that's a liaison/leader operation, not a gardener code job.
>
> 2) OUT-OF-SCOPE per the job note: after deploy, three enabled instances — kriscendobot-cosgov, kriscendobot-ocapn, kriscendobot-agoric-3-proposals — will STILL fail: they have no standing clone under worktrees/ at all. Resolving them (provision via clone-keeper tracked set, or disable the instances) is a separate decision that intersects the CLAUDE.md § Monitoring safety watch-set authorization requirement — flagging rather than silently arming new watched repos.

- `20260711T005737Z-1fa345` — from gardener:finbot-progress-20260711-005002, reply_to `finbot-progress-20260711-005002` · [open message](https://github.com/kriskowal/garden/blob/journal2/inbox/maintainer/unread/20260711T005737Z-1fa345.md)

> finbot progress cycle (20260711-005002) — one increment landed, green.
>
> **Advanced:** Closed the **GARCH conditional-volatility** open axis from
> designs/ensemble-forecasting.md. Landed `feat(simulator): GARCH(1,1)` on
> kriscendobot/finbot@main (a35add1..faa3ff1), direct-push per finbot's
> no-PR convention.
>
> - New `packages/simulator/garch.js`: `Garch11Surface` — a *stateful* vol
>   surface modelling volatility clustering (what the empirical iid surface
>   structurally cannot), variance evolving off the realized price shock;
>   stationarity (alpha+beta<1) enforced at construction. Plus
>   `garchFromPriceHistory()` fitting by variance targeting.
> - Wired into GBMPriceFeed behind the existing `cfg.volSurface` plug via an
>   `isGarch` flag. Immutable params in the surface, evolving variance per
>   feed instance — so one surface is shared safely across a forecast
>   ensemble, each fork starting a fresh variance path. Reuses the feed's own
>   price shocks → zero extra RNG, determinism contract holds byte-for-byte
>   (same-seed clone carries variance forward; reseeded fork resets it).
> - **GREEN: 435 tests pass** (+11 GARCH suite, from 424). Safety gate holds:
>   finbot-ooda --seed=7 → all 6 auditor invariants PASS, WALLET TOUCHED: false.
>
> **Next unblocked increment:** simulator-side pure builds still on the
> ensemble-forecasting axis — implied-vol surfaces (needs options data, may
> not be feasible without a data source), asymmetric GARCH variants
> (GJR-GARCH / EGARCH for the leverage effect), or PNG rasterization of the
> histogram renderer. Any is a clean no-wallet next cycle.
>
> **Needs a maintainer decision (unchanged, still deferred):** the deepest
> remaining axis is cap-attenuation Phase 2 — the CapTP transport for the
> gated spawnSigningWorker stub and a first live paper-wallet/test-net run.
> Security-weighted, gated behind live_authorized:true; not advanced without
> explicit authorization.
>
> No garden main2 changes needed — project-only cycle.

- `20260711T012746Z-f35c9e` — from gardener:self-heal-fix-garden-triager-kriscendobot-minion-town-bare-clone-path, reply_to `self-heal-fix-garden-triager-kriscendobot-minion-town-bare-clone-path` · [open message](https://github.com/kriskowal/garden/blob/journal2/inbox/maintainer/unread/20260711T012746Z-f35c9e.md)

> triager crash-loop fix (self-heal-fix-garden-triager-...-bare-clone-path): the fix is ALREADY landed on origin/main2 (commits 118f7384fc → 4c0e275b0b): triager.sh + comment-watcher.sh default GARDEN_REPOS to $GARDEN_ROOT/worktrees, and triager.sh self-provisions a missing bare clone (opt-in). Tests green (triager 62/0, comment-watcher 213/0), incl. regression case I.
>
> The crash-loop is still LIVE only because the DEPLOYED root (/home/kris/garden2, HEAD 688e6174c8) predates the fix — its triager.sh line 25 / comment-watcher.sh line 179 still default to $GARDEN_ROOT/repos. FOLLOW-UP: a deliberate deploy (deploy-garden.sh, leader host) will advance the root past 4c0e275b0b and stop garden-triager@* flapping. No code work remains for this job.

- `20260711T013139Z-f3a920` — from gardener:self-heal-fix-garden-triager-kriscendobot-agoric-sdk-missing-repos-clone, reply_to `self-heal-fix-garden-triager-kriscendobot-agoric-sdk-missing-repos-clone` · [open message](https://github.com/kriskowal/garden/blob/journal2/inbox/maintainer/unread/20260711T013139Z-f3a920.md)

> Self-heal (garden-triager own-fork "no bare clone" FATAL) — diagnosis + one remaining step.
>
> The durable fix is ALREADY landed and tested on main2 (peers landed it before this job ran):
>   - scripts/jobs/fork-watch-provisioner.sh + its test are tracked on main2; test passes 16/16.
>   - Provisioner is wired into the tick path: repo-watcher.sh:47-49 runs it at the top of every reconcile.
>   - Root cause of the FATAL is repaired at the source: triager.sh / comment-watcher.sh / fork-watch-provisioner.sh now all default GARDEN_REPOS to worktrees/ (was repos/), and a missing clone is a clean skip, not a FATAL.
>
> Why the FATAL still storms on THIS host: the deployed root (/home/kris/garden2) is ~56 commits BEHIND origin/main2. It still runs the OLD triager.sh (GARDEN_REPOS=$GARDEN_ROOT/repos), so garden-triager@{agoric-sdk,cosgov,endo,finbot} FATAL every tick looking for repos/<slug>.git, which never existed. upgrade-ready is set; the deploy is simply pending.
>
> Good news that simplifies the fix: all 8 armed own-fork bare clones now exist under worktrees/<slug>.git (agoric-sdk, endo, finbot, minion.town, vattr97, cosgov, ocapn, agoric-3-proposals). So once main2 is deployed, every garden-triager@<slug> finds its clone under worktrees/ and ticks cleanly — the provisioner's MATERIALIZE step is a no-op (nothing left to clone). No stopgap materialization is needed.
>
> The ONE remaining step is the drained deploy — a leader/liaison operation I cannot run from inside a gardener job (deploy-garden.sh drains the fleet including me, and it's triggered only by your deploy-on-upgrade Monitor, not a systemd unit). Please run scripts/jobs/deploy-garden.sh when the fleet is quiet (it currently DEFERs while gardeners are mid-job > 300s). After it lands, garden-triager@kriscendobot-agoric-sdk and its 7 siblings will reach "no change"/"triaged" instead of the "no bare clone" FATAL.
>
> Note: I did NOT apply the repos/ stopgap. Under the old deployed code, materializing repos/<slug>.git would flip each own-fork (incl. the massive agoric-sdk) into an unbounded full-history first-observation `claude -p` triage (empty cursor → `git log` with no range) — a larger, less predictable action than the throttled/circuit-broken FATAL. The deploy is the clean resolution.

- `20260711T015845Z-c2ab29` — from gardener:self-heal-fix-garden-triager-kriscendobot-vattr97-repos-path-mismatch, reply_to `self-heal-fix-garden-triager-kriscendobot-vattr97-repos-path-mismatch` · [open message](https://github.com/kriskowal/garden/blob/journal2/inbox/maintainer/unread/20260711T015845Z-c2ab29.md)

> Self-heal job (triager repos/-vs-worktrees path mismatch): the code fix is ALREADY merged in main2 (commits 118f7384fc..83e0eb0f41 — both triager.sh and comment-watcher.sh now resolve their bare clone via the shared bare_clone_dir() in common.sh, defaulting to $GARDEN_ROOT/worktrees). Verified: no stale repos/ default remains, case-I regression test present, triager tests 68/0 and comment-watcher 213/0 green, and the main2 resolver correctly finds the real /home/kris/garden2/worktrees/kriscendobot-vattr97.git clone.
>
> Remaining gap requiring your action: the DEPLOYED root (/home/kris/garden2, HEAD 688e6174c8) is stale — triager.sh:25 there still has the buggy `GARDEN_REPOS:=$GARDEN_ROOT/repos`, so live garden-triager@* units keep FATAL-looping until a deliberate deploy (scripts/jobs/deploy-garden.sh) advances the root past 83e0eb0f41. A gardener job can't run that drained deploy. Please deploy at your convenience to actually clear the crash-loop.

- `20260711T055759Z-db44fb` — from gardener:agoric-sdk-pr9-drive-20260711-045005, reply_to `agoric-sdk-pr9-drive-20260711-045005` · [open message](https://github.com/kriskowal/garden/blob/journal2/inbox/maintainer/unread/20260711T055759Z-db44fb.md)

> PR #9 (kriscendobot/agoric-sdk, ymax→critical, garden#29) — 6-hourly drive tick, material update.
>
> State: OPEN, DRAFT, no review yet. Not approved/merged/closed, so the schedule stays.
>
> Since the last tick (22:38Z):
> - A peer gardener pushed a new head 71cb13f9 (00:48Z) — "make a3p critical-vat rehearsal target-agnostic".
> - Against that head, two NEW reds appeared that were green last tick: lint-rest (ESLint, exit 20) and test-boot (node-old, 2, 4). Prime suspect is the rewritten a3p test file. The other two reds (test-codegen, test-quick node-old) remain the already-diagnosed stale-base noise.
>
> Step taken this tick: commissioned shepherd #9 (kriscendobot-agoric-sdk-pr9-shepherd-71cb13f9) to classify the reds and fix the PR-attributable ones (starting with lint-rest) on the head branch. Fork-only.
>
> Two things needing your attention:
> 1) STILL PENDING from last tick: rebase #9 onto current master (base trails ~503 commits) + un-draft + request SwingSet-team review — vs keep it a frozen-base prototype and pursue approval as-is. Approval can't happen while it's a draft with no review; a decision here unblocks the path to "approved".
> 2) Orchestration note (no action needed): follow-on jobs carrying the PR-comment directive_url auto-dedup onto the original attention job f0af0f7a (still in tada), which is why prior ticks posted nothing. I worked around it by passing an explicit --identity; future ticks will do the same.
>
> Fork-only throughout; no upstream agoric/agoric-sdk touch.


## Board
### todo (0)
(none)

### doin (7)
- [`endojs-endo-but-for-bots-pr660-shepherd`](https://github.com/kriskowal/garden/blob/journal2/jobs/doin/endojs-endo-but-for-bots-pr660-shepherd.md) — shepherd (auto: red CI) on endojs/endo-but-for-bots PR #660
- [`kriscendobot-agoric-sdk-pr9-shepherd-71cb13f9`](https://github.com/kriskowal/garden/blob/journal2/jobs/doin/kriscendobot-agoric-sdk-pr9-shepherd-71cb13f9.md) — shepherd #9 — drive kriscendobot/agoric-sdk PR #9 CI green (head 71cb13f9)
- [`ocapn-daemon-minion-deploy-demo`](https://github.com/kriskowal/garden/blob/journal2/jobs/doin/ocapn-daemon-minion-deploy-demo.md) — Deploy an OCapN-Noise Pet Daemon on minion.town and connect a local peer (M3+M4)
- [`proxy-pr-comment-auto-clear`](https://github.com/kriskowal/garden/blob/journal2/jobs/doin/proxy-pr-comment-auto-clear.md) — Shape — mirror the existing § Watchdog auto-clear exactly
- [`xs2rust-endor-262-xst-runner-core`](https://github.com/kriskowal/garden/blob/journal2/jobs/doin/xs2rust-endor-262-xst-runner-core.md) — Builder: endor-xst core — the xst-analogue test262 runner (PR #600, test262-c...
- [`xs2rust-endor-stage5-fix6-verify`](https://github.com/kriskowal/garden/blob/journal2/jobs/doin/xs2rust-endor-stage5-fix6-verify.md) — Stage-5 fix6 2/2 — VERIFY: full-tree re-measurement after the capture-closure...
- [`xst-validation-orchestrator-20260711-052002`](https://github.com/kriskowal/garden/blob/journal2/jobs/doin/xst-validation-orchestrator-20260711-052002.md) — XS-validation orchestrator (hourly) — drive the agoric-sdk XS upgrade to vali...

### tada (1862)
- [`agoric-sdk-pr9-drive-20260711-045005`](https://github.com/kriskowal/garden/blob/journal2/jobs/tada/agoric-sdk-pr9-drive-20260711-045005.md) — Completion report
- [`endojs-endo-but-for-bots-spaces-util-reexport-slice`](https://github.com/kriskowal/garden/blob/journal2/jobs/tada/endojs-endo-but-for-bots-spaces-util-reexport-slice.md) — Completion report
- [`endojs-endo-but-for-bots-pr683-shepherd`](https://github.com/kriskowal/garden/blob/journal2/jobs/tada/endojs-endo-but-for-bots-pr683-shepherd.md) — All 24 checks pass. Job complete.
- [`endojs-endo-but-for-bots-init-reexport-slice`](https://github.com/kriskowal/garden/blob/journal2/jobs/tada/endojs-endo-but-for-bots-init-reexport-slice.md) — Completion report
- [`xst-validation-orchestrator-20260711-042001`](https://github.com/kriskowal/garden/blob/journal2/jobs/tada/xst-validation-orchestrator-20260711-042001.md) — XS-validation orchestrator — tick report (2026-07-11 ~04:20Z)
- … and 1857 more

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
- [`endojs-endo-but-for-bots-pr592-cancel-in-options`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr592-cancel-in-options.md) — _normal_ · Fixer: reshape watchDirectory cancellation API (endojs/endo-but-for-bots #592)
- [`foreman-budget-cross-host-weekly-token-aggregation`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/foreman-budget-cross-host-weekly-token-aggregation.md) — _normal_ · PLAN: deterministic cross-host weekly token-spend aggregation for the foreman...
- [`garden-style-typist-codepoints`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/garden-style-typist-codepoints.md) — _normal_ · ---
- [`garden-style-url-not-path`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/garden-style-url-not-path.md) — _normal_ · ---
- [`gauntlet-endo-but-for-bots-pr661-agent-tools-http-client`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/gauntlet-endo-but-for-bots-pr661-agent-tools-http-client.md) — _normal_ · ---
- [`open-signup-gate-flip-minion-town`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/open-signup-gate-flip-minion-town.md) — _normal_ · Build: open-signup gate flip for minion.town (Phase B — THE consequential cha...
- [`styled-privilege-surfaces-minion-town`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/styled-privilege-surfaces-minion-town.md) — _normal_ · Build: styled privilege surfaces for minion.town (Phase C — role-aware landin...
- [`verify-ymax0-hex-fix-inquisitor`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/verify-ymax0-hex-fix-inquisitor.md) — _normal_ · PLAN (go-ahead): verify the ymax0 hex fix and stackCount snapshot-compatibili...
- [`wire-siwe-onchain-authz-minion-town`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/wire-siwe-onchain-authz-minion-town.md) — _normal_ · Wire the chosen SIWE on-chain authorization tier into minion.town's policy layer

### deferred (top by priority; foreman auto-promotes when idle)
- [`scholar-ingest-source-habitat-chronicles-4`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/scholar-ingest-source-habitat-chronicles-4.md) — _low_ · Source
- [`endojs-endo-but-for-bots-pr660-review-62ee5cda-retro`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr660-review-62ee5cda-retro.md) — _low_ · Retrospective on endojs/endo-but-for-bots PR #660 (primary: endojs-endo-but-f...
- [`endojs-endo-but-for-bots-pr660-7dd088b1-retro`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr660-7dd088b1-retro.md) — _low_ · Retrospective on endojs/endo-but-for-bots PR #660 (primary: endojs-endo-but-f...

### blocked (awaiting an artifact; unblock watcher auto-promotes on completion)
- [`build-daemon-rename-to-manager-phase2`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/build-daemon-rename-to-manager-phase2.md) — awaiting `https://github.com/endojs/endo-but-for-bots/pull/598` · Build: daemon→manager rename Phase 2 (identifier renames)
- [`build-daemon-rename-to-manager-phase3`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/build-daemon-rename-to-manager-phase3.md) — awaiting `build-daemon-rename-to-manager-phase2` · Build: daemon→manager rename Phase 3 (consumer sweep + CHANGELOG + docs)
- [`build-endo-regexp-conservative-subset`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/build-endo-regexp-conservative-subset.md) — awaiting `endojs/endo-but-for-bots#676` · Build: implement @endo/regexp — the conservative-regexp-subset linear matcher
- [`port-xs-to-rust-memory-safe-engine-s18`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/port-xs-to-rust-memory-safe-engine-s18.md) — awaiting `xs2rust-endor-build-stage5-fix6` · Fable supervisor: drive the XS→Rust (Endor) port from design to maintainer-re...
- [`resume-lint-ceiling-shepherds`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/resume-lint-ceiling-shepherds.md) — awaiting `https://github.com/endojs/endo-but-for-bots/pull/594` · Resume shepherds for PRs blocked by the endo-but-for-bots lint projectService...

## Watch set
kriscendobot-agoric-3-proposals kriscendobot-agoric-sdk kriscendobot-cosgov kriscendobot-endo kriscendobot-finbot kriscendobot-minion.town kriscendobot-ocapn kriscendobot-vattr97

## Hosts
- [endolin-garden-ece02cb4](https://github.com/kriskowal/garden/blob/journal2/hosts/endolin-garden-ece02cb4): 20 gardeners
- [endolin-garden2-5bcdff64](https://github.com/kriskowal/garden/blob/journal2/hosts/endolin-garden2-5bcdff64): 20 gardeners
