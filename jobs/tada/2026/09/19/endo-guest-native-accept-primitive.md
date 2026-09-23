Only a routine deadline-nudge (well within deadline). The job is complete.

---

## Completion report

**Job:** Build guest-native invitation **acceptance** (`EndoGuest.accept`) for Endo.

**Outcome:** Implemented and shipped as **draft PR endojs/endo-but-for-bots#1310** (base `llm-301e2ba`, head `bot/build/guest-native-accept`, 1 commit, 9 files, +496/−107). The #1305 stack had already merged to `llm`, so I built on `llm` as the spec instructed.

### What I did
- Added **`EndoGuest.accept(invitationLocator, correspondentName)`** — a guest redeems an invitation **into itself**, no replacement guest minted, binding the inviter's handle reciprocally under an independently-chosen pet name.
- Factored the acceptor-side sequence into **one daemon-core `acceptInvitation` helper** (`manager.js`) that **both** facets share; **converged `EndoHost.accept`** onto it (removing its inlined `addPeerInfo`/`getPeerInfo`/`writeRemoteAgentKey`), so the contract can't fork by facet.
- **Attenuation preserved:** peer registration / agent-key routing stay behind the internal broker + daemon-core persistence powers, reachable only lexically — a guest acceptor gains no dialing or peer-registration surface.
- Acceptor handle addresses come from the accepting agent's **own `@nets`**; added the **self-node skip** (both the helper and inviter-side `Invitation.accept`) so **same-daemon** acceptance (minion.town's shape) works without spurious peer/agent-key writes.
- `GuestInterface` guard, `EndoGuest`/`DaemonCore` types, and help.md/help-text-data.js (guest invite+accept; corrected the stale host `accept` arity).

### Tests (all green)
- Same-daemon guest→guest round trip + **transitive I→J→K** chain (`endo.test.js`).
- Cross-daemon guest→guest with **bidirectional mail over tcp + ocapn** (`_multiplayer-suite.js`, run by both `invite-retention*.test.js` — 14/14).
- All existing host and cross-daemon invitation suites retained and passing.
- `endo.test.js` sockets moved under `os.tmpdir()` (matching the multiplayer suite) so the suite runs on long checkout paths.
- Gates: `lint:types`, `test:types`, `eslint` (0 errors), `prettier --check` all clean.

### Consciously deferred (noted in the PR body for the gauntlet)
These design sections predate #1305's chosen mechanics (serial-queue consume-once, no-mint host path) and are **not** needed to unblock the downstream: the returned `{ status }` record contract (terminal states still throw, the existing host contract), `remove`/`rename` reject-on-pending, insert-only peer-registration narrowing, and the repo-wide `guestName`→`correspondentName` host rename. Consume-once/cancellation/crash-recovery are preserved unchanged via the existing per-invitation serial queue.

### Follow-ups
- The build stops at an open DRAFT PR per the manual-gauntlet regime — promote with **run the gauntlet #1310** when ready.
- `build-minion-town-invitation-onboarding` (parked, blocked on this) can now proceed once #1310 lands: Endo can accept into the calling guest.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endo-guest-native-accept-primitive.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 288 tokens (27729534 cached reads)
- Output: 103969 tokens
- Cost: $20.94624325
- Wall-clock: 1929s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
