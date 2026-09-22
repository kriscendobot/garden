---
gate: awaiting-maintainer
maintainer_question: 'Land the refreshed Endo daemon pin 89481580… (EndoGuest.accept) onto minion.town main. It is MERGED into frozen base main-45e43bb via PR #104 but main (HEAD 287af35) still pins the stale f66505034…. Promote this job only once git show origin/main:src/endo/captp-client.ts shows PINNED_ENDO_COMMIT = 89481580….'
asked_at: https://github.com/kriscendobot/minion.town/pull/104
priority: normal
role: builder
posted_by: minion-town-guest-web-invite-accept-fallback-fix-post104
posted_at: 2026-09-22T05:25:20Z
---

---
role: builder
tier: mentor
fallback-tier: minion
dispatch: automatic
---

# Replace PR #81's app-mediated guest-pairing fallback with real guest.invite/accept

**RE-PARK NOTE (2026-09-22):** Awaiting-maintainer successor to
`minion-town-guest-web-invite-accept-fallback-fix-post104`, which correctly
re-parked itself because its promotion precondition is still unmet. The
predecessor confirmed:

- `kriscendobot/minion.town` PR
  [#104](https://github.com/kriscendobot/minion.town/pull/104) (pin refresh to
  `89481580…`, carrying `EndoGuest.accept`) is **MERGED**, but only into its
  **frozen base branch `main-45e43bb`** (base `main-45e43bb`, head
  `endo-daemon-pin-89481580`). `origin/main-45e43bb:src/endo/captp-client.ts`
  now shows `PINNED_ENDO_COMMIT = 89481580a86c7ec3ec97bbde21bc2f9b5b7ec3dd`.
- **`origin/main` (HEAD `287af35`) still pins the STALE
  `f66505034aaa54ac46294347b2bf0e14655b088a`** — `EndoGuest.accept` is not
  reachable from a daemon `main` builds against. No open PR carries the refreshed
  pin onto `main`.

The pin is therefore **stranded on the frozen base**, not on `main`. This work
cannot be verified against a real daemon with `EndoGuest.accept` until the pin
lands on `main`.

**Precondition for promoting this job (unchanged observable):** `main` must
actually carry the refreshed pin `89481580a86c7ec3ec97bbde21bc2f9b5b7ec3dd`. The
maintainer must land it on `main` — e.g. fast-forward/merge `main-45e43bb`'s pin
change onto `main`, or open+gauntlet+merge a fresh PR that re-applies the pin to
`main`. Promote this job only after
`git show origin/main:src/endo/captp-client.ts` shows `PINNED_ENDO_COMMIT` =
`89481580…`. Any vehicle that lands the same pin on `main` is equally fine — the
observable is the pin on `main`.

## Context

`kriscendobot/minion.town` PR [#81](https://github.com/kriscendobot/minion.town/pull/81)
("Build: web bearer guest invite and accept workflow", branch
`build/invitation-only-guest-onboarding`, open DRAFT, currently `CONFLICTING`
against `main`) implements most of `designs/invitation-only-guest-onboarding.md`:
the fragment-URL envelope, browser shell, session handling, DB schema, and
deployment policy. But its same-daemon pairing path violates the design's core
authority rule.

`src/web/guest-web-socket-service.ts`, `connectLocal` (around line 116):

```ts
// Same-daemon fast path: bind the two already-local formulas directly.
// No locator, network dial, or introduction protocol is involved.
await E(inviter).storeIdentifier([inviterPetName], inviteeId);
try {
  await E(invitee).storeIdentifier([inviteePetName], inviterId);
} catch (error) {
  await E(inviter).remove(inviterPetName).catch(() => undefined);
  throw error;
}
```

This is the app directly writing into each guest's pet-name directory via
host-authority `storeIdentifier` calls — exactly the "app-mediated or
host-authority fallback" `designs/invitation-only-guest-onboarding.md` § 3.1
and § 3.2 forbid: "The minion.town build must not emulate guest authority by
calling the host method on a guest's behalf... There is no app-mediated or
host-authority fallback." It was a deliberate, explicitly-labeled stopgap
because `EndoGuest.accept` did not exist yet. It now does
(`endojs/endo-but-for-bots#1310`, merged 2026-09-21, self-node-skip logic makes
same-daemon acceptance efficient with no spurious peer/agent-key writes — see
that PR's `tada/` report for the mechanism).

## What to do

1. `ensure-project-worktree.sh <your-job-base> kriscendobot/minion.town
   build/invitation-only-guest-onboarding`. Do NOT create a new project
   worktree keyed by "81" or by the design name — key it by your own unique
   job base per `roles/gardener/AGENT.md`.
2. **Confirm the precondition FIRST:** `git show origin/main:src/endo/captp-client.ts`
   must show `PINNED_ENDO_COMMIT` = `89481580…`. If it still shows `f66505034…`,
   the pin has NOT reached `main` — re-park yourself awaiting-maintainer again
   rather than proceeding against the stale pin. Then rebase the branch onto
   current `main` (it's `CONFLICTING`).
3. Replace `connectLocal`'s two `storeIdentifier` calls with the real
   guest-native invitation flow:

   ```ts
   const invitation = await E(inviter).invite(inviterPetName);
   const locator = await E(invitation as { locate(): Promise<string> }).locate();
   await E(invitee).accept(locator, inviteePetName);
   ```

   Keep the existing `has()` pre-checks (fail fast with `GuestNameConflictError`
   before minting an invitation). Add `accept(locator: unknown, name: string):
   Promise<unknown>` to the local `DaemonGuest` TypeScript interface (currently
   only declares `invite`). Confirm error-path behavior: if `accept` throws (name
   conflict, invalid/expired/spent invitation), the inviter's pending invitation
   should not leave the inviter's directory in a half-bound state — check what
   the daemon itself guarantees here (per the design, the invitation is
   consume-once and a failed accept should not consume it) before adding any
   compensating cleanup, and only add one if the daemon does not already make
   this atomic.
4. Update `test/web/guest-web-daemon.test.ts`'s header comment (lines ~11-24)
   and the inline comment near its accept assertion (~line 173) — both
   currently describe the OLD mechanism ("binds BOTH pet-name edges in place
   via the daemon's `storeIdentifier`"). Describe the real invite/accept flow
   instead. The externally-observed HTTP behavior (alice invites bob, bob
   accepts, bidirectional mail works) should be unchanged — this test runs
   against a real daemon, so it will genuinely exercise the new code path.
5. Reconcile against the contract deltas the real #1305/#1310 stack shipped
   with, which postdate PR #81's original authorship (early September) — see
   `designs/invitation-only-guest-onboarding.md`'s current state (PR #81 already
   touched it, +98/-2) and cross-check against the merged Endo contract:
   - Invitation objects now have `cancel()`; there is **no TTL** — single-use
     consumption + `cancel()` are the only terminations. Grep PR #81's diff for
     any invented expiry/TTL logic in `invitation-session.ts` /
     `invitation-envelope.ts` and remove it if present; it would contradict the
     real primitive's semantics.
   - A new guest's guest-visible pin namespace is `@pins` (distinct from the
     host-only pin directory), and `provideGuest` now takes caller-elected
     `pins`/`networks` options. Check `createGuest`'s `E(host).provideGuest(name,
     {agentName})` call — confirm the current `provideGuest` signature on the
     pinned Endo daemon still accepts this shape, or needs the new options.
   - Persisted invitation fields are `invitingAgent`/`invitingHandle` (not
     `hostAgent`/`hostHandle`), and there is no synthetic locally-pinned guest
     minted per invitation. `grep -rn 'hostAgent\|hostHandle'` across PR #81's
     diff; fix any direct dependence on the old field names.
6. Full verification against the (now-refreshed) real pinned daemon:
   `npm run typecheck`, `npm test`, `npx vitest run
   test/endo-daemon-integration.test.ts`, `npx vitest run
   test/web/guest-web-daemon.test.ts`. All green, with real command output in
   your completion report (not just "should pass").
7. Push your fix commits to the EXISTING branch
   `build/invitation-only-guest-onboarding` (rebase-and-push CAS loop against
   `origin`) — do not open a second PR. Confirm via
   `scripts/jobs/gardening/ensure-pr.sh <your-job-base> kriscendobot/minion.town
   build/invitation-only-guest-onboarding main` that it adopts PR #81 (it will
   match on the head-branch-name rule even without a marker match). Leave the
   PR draft — manual-gauntlet regime, do not run the gauntlet yourself.

## Definition of done

PR #81 no longer calls `storeIdentifier` to bind two guests directly; the
same-daemon pairing path goes through genuine `EndoGuest.invite` /
`EndoGuest.accept`, verified against a real pinned daemon with evidence in your
report. The contract-delta greps above are resolved or explicitly confirmed
not applicable.
