---
role: builder
tier: mentor
fallback-tier: minion
dispatch: automatic
handler-budget-role: builder
---

# Re-pin minion.town `main` to the post-#1329 Endo `llm` HEAD (registry migration now landed)

Re-pin `kriscendobot/minion.town` **`main`** from the stale
`f66505034aaa54ac46294347b2bf0e14655b088a` to the current Endo `llm` HEAD
**`f9cbcfc426f726858a671bcb09f7c2c774cc659e`**.

## Why this is now safe (and was not before)

The previous re-pin attempt — [kriscendobot/minion.town#110](https://github.com/kriscendobot/minion.town/pull/110),
pin `89481580…` — **merged to `main` 2026-09-22 14:07Z then was reverted 49 min
later by [#111](https://github.com/kriscendobot/minion.town/pull/111)**: `89481580`
made `registry` a **required** `HostFormula` field and added fail-fast guards, but
never shipped the one-shot on-start upgrade pass that
`designs/registry-capability.md` § *Migration for already-formulated hosts*
promised. minion.town's pre-existing prod host formulas (predating the `registry`
slot) crash-looped the daemon and the deploy stalled.

That upstream defect is **now fixed**: [endojs/endo-but-for-bots#1329](https://github.com/endojs/endo-but-for-bots/pull/1329)
(`fix(daemon): migrate persisted host formulas missing registry`) **merged to
`llm` 2026-09-23 04:40Z** — new `llm` HEAD `f9cbcfc426f726858a671bcb09f7c2c774cc659e`,
which carries **both** `EndoGuest.accept` (#1310) and the migration (#1329).

## Work

1. Bump **all synchronized pin copies** to `f9cbcfc426f726858a671bcb09f7c2c774cc659e`
   (the #104 refresh touched three copies — locate every occurrence of
   `PINNED_ENDO_COMMIT` / the pinned SHA, including `src/endo/captp-client.ts` and
   whatever the pin-drift test guards; the `test/endo-pin-drift.test.ts` guard must
   stay green).
2. **Gate on the exact defect that caused the #110→#111 revert.** Before proposing
   the merge, verify a daemon **built from `f9cbcfc4`** starts cleanly against a
   host DB shaped like minion.town's pre-existing prod (host formulas **missing**
   the `registry` slot) — i.e. the on-start migration runs and the daemon does NOT
   crash-loop. This is the hard precondition; do not hand off a pin that repeats
   the crash-loop. (See the #104 build for the "real daemon built from that pin +
   full `ENDO_CHECKOUT` suite" verification pattern.)
3. The base is **`main`** (not the frozen snapshot `main-45e43bb` — #104's mistake
   stranded the pin on the frozen base). Open the PR against `main`.
4. Open the PR via `scripts/jobs/gardening/ensure-pr.sh` (adopt any prior PR by the
   durable job marker). Leave it **draft**; the maintainer reviews + merges. Drive
   CI green and report the daemon-start verification evidence in the PR body.

## What this unblocks (downstream, do NOT do here)

Once this pin is on `main`, the parked
`minion-town-guest-web-invite-accept-fallback-fix-20260922`
(`gate: awaiting-maintainer`, keyed on
`git show origin/main:src/endo/captp-client.ts` showing the new pin) promotes →
readies [kriscendobot/minion.town#81](https://github.com/kriscendobot/minion.town/pull/81)
→ the CapTP eval half of arc item 7. **Note** the parked fallback fix's stored
observable still names `89481580`; whoever promotes it should treat the observable
as "the post-#1310 pin reached `main`", which `f9cbcfc4` satisfies (it is `89481580`
plus the migration).

----- ISSUE NOTE (copy this block VERBATIM into every follow-on job) -----
issue_spine: issue-kriscendobot-garden-89
issue_url: https://github.com/kriscendobot/garden/issues/89#issuecomment-5789182717
submitter: kriscendobot
----- END ISSUE NOTE -----

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 1
  worker_kind: cleric
  tier: 
  provider: openai
  model: 
  claimed_at: 2026-09-23T16:00:50Z
