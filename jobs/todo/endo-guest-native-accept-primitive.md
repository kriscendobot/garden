---
tier: mentor
---
<!-- garden-promoted-from-plan: gate=blocked priority=normal at=2026-09-19T15:21:12Z cleared=none -->

---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
# Build guest-native invitation ACCEPTANCE (`EndoGuest.accept`) for Endo

Implement the **acceptance half** of the guest-native invitation design in
`endojs/endo-but-for-bots`. The invite half shipped; acceptance did not, and it
is currently unowned.

## Why this job exists

Design PR [endojs/endo-but-for-bots#1116](https://github.com/endojs/endo-but-for-bots/pull/1116)
(`designs/guest-native-invitations.md`, branch `design/guest-native-invitations`,
still OPEN/draft) specifies **both** halves of a shared agent vocabulary:

- `guest.invite(guestName)` — **delivered**, on the #1125 successor stack.
- `guest.accept(invitationLocator, hostName)` — **not delivered anywhere**.

The invite-half builder job `minion-town-remote-guest-endo-cli-endo-invite-primitive`
scoped itself to `invite`. Its PR #1125 was retired 2026-09-17 and split into
#1304 → #1306 → #1305; the stack's tree is byte-identical to #1125's head, so the
gap is structural, not a rebase artifact.

Verified 2026-09-17 against #1305's head branch
`bot/build/1125-guest-invitation-primitive` — the guest-callable surface in
`packages/daemon/src/interfaces.js` `GuestInterface` is:

    followLocatorNameChanges followNameChanges reverseIdentify lookupById
    lookupByLocator handle listMessages followMessages resolve reject adopt
    dismiss dismissAll request send reply editMessage messageHistory define
    form storeBlob storeValue submit sendValue deliver evaluate invite

`accept` is absent, as are `adoptFromLocator` and `locateWithHints`. A guest
therefore has **no** method by which it can redeem an invitation locator —
`accept` remains exclusive to `HostInterface`. `packages/daemon/src/guest.js`
likewise defines `invite` and no `accept`.

## Scope

Per `designs/guest-native-invitations.md` (read it from the #1116 branch; it has
not landed on `llm`):

- Add `EndoGuest.accept(invitationLocator, hostName)` sharing one implementation
  with `EndoHost.accept`, so acceptance binds **the calling agent** — no
  replacement guest minted on the acceptor side.
- Reciprocal exchange of each agent's **own handle**; inviter and invitee each
  choose their own pet name independently.
- Keep network mediation behind the narrow daemon-core broker #1305 introduced
  (`registerPeer`/`writeRemoteAgentKey` style injection). A guest acceptor must
  gain no dialing or peer-registration authority, exactly as the guest inviter
  does not.
- Preserve #1305's single-use atomic accept (per-invitation serial queue shared
  with `cancel()`), crash recovery, and restart durability.
- Same-daemon acceptance matters as much as cross-daemon: minion.town's inviter
  and invitee guests live in **one** daemon. Cover both.
- Tests: retain the existing host and cross-daemon invitation suites; add
  guest-native accept, guest-to-guest transitive chains, and a same-daemon
  guest→guest round trip.

## Stacking

Build this on **#1305's head** (`bot/build/1125-guest-invitation-primitive`) as
the next slice of that stack, unless the stack has already merged to `llm` by the
time this is claimed — in which case build on `llm`.

@kriskowal asked for #1125 to be split because its review scroll-back had grown
too deep, which is why this job is parked behind #1305 rather than opening a
fourth concurrent slice now. Stop at an open DRAFT PR per the manual-gauntlet
regime.

## Downstream

`build-minion-town-invitation-onboarding` is parked blocked on this job. Its
design (`kriscendobot/minion.town:designs/invitation-only-guest-onboarding.md`
§ 3.2) states the minion.town build "remains blocked until Endo can accept into
the calling guest", and forbids an app-mediated or host-authority fallback.
