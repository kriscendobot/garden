---
role: builder
tier: mentor
fallback-tier: minion
dispatch: automatic
---

# Land the refreshed Endo daemon pin `89481580` onto minion.town `main`

**Why this exists.** The Endo daemon pin refresh PR
[kriscendobot/minion.town#104](https://github.com/kriscendobot/minion.town/pull/104)
**merged 2026-09-22 05:31Z, but only onto its frozen base branch
`main-45e43bb`, not onto `main`.** `main-45e43bb` is now 1 ahead / 14 behind
`main` (diverged), so the pin never reached `main`. `origin/main`
(HEAD `287af35`) still pins the **stale**
`PINNED_ENDO_COMMIT = f66505034aaa54ac46294347b2bf0e14655b088a`, which lacks
`EndoGuest.accept`. The refreshed pin
`89481580a86c7ec3ec97bbde21bc2f9b5b7ec3dd` (carrying `EndoGuest.accept`, the
CapTP acceptance half — endojs/endo-but-for-bots#1310) is **stranded** on the
frozen base.

This blocks the entire CapTP critical path: the parked
`minion-town-guest-web-invite-accept-fallback-fix-20260922`
(gate=awaiting-maintainer) cannot verify PR
[kriscendobot/minion.town#81](https://github.com/kriscendobot/minion.town/pull/81)'s
guest `invite`/`accept` rewrite against a real daemon until the pin is on
`main`, and that in turn readies the CapTP eval half of arc item 7
(https://github.com/kriscendobot/garden/issues/89).

**Deliverable.** Re-apply the pin refresh onto **current `main`** via a fresh
gauntleted DRAFT PR (base = `main`, a new head branch off `main`). Under the
manual-gauntlet regime the PR stops at a green draft; the maintainer merges it.
Its merge lands the pin on `main` and satisfies the fallback-fix precondition.

## Procedure

1. Get an isolated project worktree for `kriscendobot/minion.town` off `main`
   via the job harness's `ensure-project-worktree.sh` (keyed by THIS job base).
2. Identify the pin-refresh delta that landed on `main-45e43bb` via #104. The
   #104 merge touched four files:
   `src/endo/captp-client.ts`, `deploy/aws/scripts/deploy-endo-daemon.sh`,
   `test/endo-daemon-integration.test.ts`, `.github/workflows/test.yml`. The
   authoritative content is on `origin/main-45e43bb`. Re-apply the pin change —
   all synchronized copies of `PINNED_ENDO_COMMIT` must become
   `89481580a86c7ec3ec97bbde21bc2f9b5b7ec3dd` — onto current `main`, preserving
   any unrelated changes `main` has made in those files across its 14-commit
   drift (resolve by keeping main's other edits and only moving the pin).
   Confirm no copy of the stale `f66505034…` pin remains anywhere in the tree
   (grep the repo).
3. Verify: typecheck green; run the `test/endo-daemon-integration.test.ts`
   suite against a daemon built from the new pin if feasible in the worktree
   (see the memory-noted long-socket-path and yarn-install workarounds if
   needed). If a full local daemon build is infeasible, rely on CI — do NOT push
   a pin you could not at least typecheck.
4. Open the DRAFT PR via the job harness's `ensure-pr.sh` (base `main`), title
   like `chore(endo): land daemon pin 89481580 (EndoGuest.accept) on main`,
   body explaining it re-lands #104's pin onto `main` (which #104 left on the
   frozen base) and citing endojs/endo-but-for-bots#1310. Leave it draft.
5. Run the gauntlet to green is the maintainer's trigger — do not un-draft.
   Report the PR URL.

## Scope
`kriscendobot/minion.town` only. No `endojs/endo-but-for-bots` push, no upstream
`agoric/agoric-sdk`, no identity switch, no ferry. If re-applying the pin surfaces
a genuine incompatibility with current `main` (e.g. a daemon-client contract that
changed), STOP and report it as a blocker rather than forcing the pin.

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 1
  worker_kind: monk
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-09-22T06:44:00Z
