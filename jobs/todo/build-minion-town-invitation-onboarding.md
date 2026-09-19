<!-- garden-promoted-from-plan: gate=blocked priority=normal at=2026-09-19T15:56:05Z cleared=none -->

# Build invitation-only guest onboarding for minion.town — STILL BLOCKED (gate re-verified 2026-09-17)

Re-run the capability-first invitation-only guest onboarding build from
`kriscendobot/minion.town:designs/invitation-only-guest-onboarding.md` once the
Endo prerequisite actually lands. Do **not** implement or emulate an app-mediated
or host-authority fallback — the design forbids it (§ 3.1, § 3.2).

## The gate predicate (check this first; ~60 seconds)

The gate is open only when **both** methods are callable by a guest on
`endojs/endo-but-for-bots@llm`:

    gh api "repos/endojs/endo-but-for-bots/contents/packages/daemon/src/interfaces.js?ref=llm" \
      --jq .content | base64 -d > /tmp/i.js
    # then confirm BOTH `invite:` and `accept:` appear inside the
    # `export const GuestInterface = M.interface('EndoGuest', {...})` block
    # (NOT merely inside the later `HostInterface` block — that has always had them)

Reading the whole file and grepping `invite|accept` is the trap that costs 20
minutes: both names match at lines ~551/553, which are inside `HostInterface`.
Bound the search to the `GuestInterface` block.

## Why the previous promotion was a false clear

Promoted to `todo/` at 2026-09-17T21:51:10Z, 41 seconds after PR endojs/endo-but-for-bots#1125 was
**closed** at 21:50:29Z. `unblock.sh` treats merge and plain close alike (a
closed blocker means "come look again"), so the park on endojs/endo-but-for-bots#1125 cleared even though
endojs/endo-but-for-bots#1125 never merged — it was **retired and split** into endojs/endo-but-for-bots#1304 → endojs/endo-but-for-bots#1306 → endojs/endo-but-for-bots#1305.
This is the second such wake for this job; the first (2026-09-04) was the
job-basename edge clearing on the invite-half builder's `tada/`.

## Gate evidence captured 2026-09-17

Against `llm` (`packages/daemon/src/interfaces.js`): `GuestInterface` spans lines
236–336 and ends at `evaluate` with **no** `invite` and **no** `accept`; both
appear only in `HostInterface` (lines 551/553). `guest.js` defines neither.

Against the **full successor stack** at endojs/endo-but-for-bots#1305's head
`bot/build/1125-guest-invitation-primitive` (byte-identical in source and tests to
endojs/endo-but-for-bots#1125's retired head `9fad002`): `GuestInterface` gains `invite` but **still has
no `accept`**, and no `adoptFromLocator` or `locateWithHints` either. So even
after the entire stack merges, a guest has no way to redeem an invitation locator.

Successor stack state at park time — all three OPEN, all draft, none merged, and
the base of the stack targets the pinned branch `llm-387ea66`, not `llm`:

| PR | Slice | Base |
| --- | --- | --- |
| [endojs/endo-but-for-bots#1304](https://github.com/endojs/endo-but-for-bots/pull/1304) | read-only directory attenuation | `llm-387ea66` |
| [endojs/endo-but-for-bots#1306](https://github.com/endojs/endo-but-for-bots/pull/1306) | caller-elected pins, networks, names | `bot/build/1125-readonly-directory-attenuation` |
| [endojs/endo-but-for-bots#1305](https://github.com/endojs/endo-but-for-bots/pull/1305) | guest-owned invitation primitive | `bot/build/1125-guest-provisioning` |

Note that **no single PR merge implies the gate is open**: the stack merges
bottom-up into its own branches off a pinned base. Treat any wake as a signal to
re-run the gate predicate above, never as proof.

## What this is now blocked on

`endo-guest-native-accept-primitive` — the builder job posted 2026-09-17 that owns
the missing acceptance half (`EndoGuest.accept`), itself parked behind endojs/endo-but-for-bots#1305. Until
that lands, the acceptance half of this design has no implementation anywhere:
design PR endojs/endo-but-for-bots#1116 specified both halves, but the invite-half builder
(`minion-town-remote-guest-endo-cli-endo-invite-primitive`) scoped itself to
`invite` only, and nothing owned `accept`.

When that job reaches `tada/` this job will wake again. Expect its deliverable to
be a **draft PR**, not a merge to `llm` — re-run the gate predicate, and if it is
still closed, re-park on the specific artifact that remains outstanding rather
than starting the build.

## Contract deltas to re-verify for the minion.town `RemoteInviteFacet`

The invite-half stack changed the invitation contract from what
`designs/invitation-only-guest-onboarding.md` was written against:

1. Invitation objects gain `cancel()`, revoking exactly that pending invitation.
2. There is **no TTL** on an invitation; single-use consumption plus `cancel()`
   are the only terminations.
3. A new guest's guest-visible pin namespace is `@pins` (distinct from the
   host-only pin directory); `provideGuest` takes caller-elected
   `pins`/`networks` options.
4. Persisted invitation fields renamed `hostAgent`/`hostHandle` →
   `invitingAgent`/`invitingHandle` (read-coerced from the legacy names, no data
   migration), and an invitation's **result name is the connection root** — the
   synthetic locally-pinned guest formerly minted on each side is gone.
