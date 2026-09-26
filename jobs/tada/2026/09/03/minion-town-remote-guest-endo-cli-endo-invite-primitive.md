The inbox holds only a system deadline-nudge (no action needed). PR #1125 is open (draft, base `llm`). Everything the job asked for is complete.

## Completion report

**Deliverable: step 1 of `designs/remote-guest-endo-cli.md` — the guest-safe invitation primitive — is implemented and opened as draft PR `endojs/endo-but-for-bots#1125` (base `llm`, head `kriscendobot:bot/build/endo-guest-invite-primitive`).**

### What I built (in the Endo daemon, `@endo/daemon`)
- **`EndoGuest.invite(guestName)`** now exists alongside `EndoHost.invite`, sharing one implementation. The invitation formula was generalized from `{ hostAgent, hostHandle, guestName }` to an inviting **`EndoAgent`** (host *or* guest) — fields renamed `invitingAgent`/`invitingHandle` — so the locator's `from` names the inviting guest's handle and an acceptor binds that guest, not the top host.
- **Internal network authority.** Network mediation (read this daemon's peer info; register the accepting peer) moved off the inviting agent onto a narrow broker resolved inside daemon-core code from the root `endo` bootstrap's network host. A guest inviter gets **no** `getPeerInfo`/`addPeerInfo`, host facet, peer enumeration, or outbound dialing — only the invitation's own `locate`/`cancel`/`accept`.
- **Lifecycle `cancel()`** on the invitation object — revokes exactly that pending invitation (frees its retaining slot precisely, then cancels the controller), leaving siblings and accepted bindings intact.
- **Deterministic, restart-durable single-use:** `accept` rejects before any side effect when the invitation's slot no longer names it, so replays fail cleanly regardless of GC timing (controller-cancel alone doesn't delete the record).
- **Guests gained their own guest-scoped `@pins`** (mirroring `@nets`) so the shared accept path can durably pin the local handle without conferring the daemon's root pins. `EndoHost.invite` is unchanged/source-compatible.

### Validation
Two-daemon tests added to the multiplayer suite, **passing over both tcp-netstring and OCapN/Noise**: guest (not host) invites; both pet stores get the opposite handle; locator `from` names the guest not host; neither handle carries host-only methods; guest holds no `getPeerInfo`/`addPeerInfo`; replay rejected; `cancel()` revokes exactly one of two pending invitations. Full multiplayer suite (host invite/accept, restart, three-party, sub-invitation, GC) stays green (11/11). `tsc` clean, `eslint` 0 errors. (endo.test.js daemon tests are unrunnable here — the long scratch worktree path blows the ~108-char Unix socket limit, affecting *all* those tests identically; environmental, not code.)

### Hard gate respected + reported back
I did **not** start or post any minion.town §§4–8 follow-ups. I sent the maintainer (via inbox) the actual implemented shape — it matches the design §3 sketch, no materially-different broker contract — plus four deltas the minion.town `RemoteInviteFacet` must re-verify against once #1125 merges: (1) `cancel()` is on the object, not by `inviteId`; (2) no Endo-level `expiresAt`/TTL; (3) guests need the new `@pins` (canonical `g-<hash>` guests must run a daemon with this change / migrate); (4) the invitation exo also exposes the wire-protocol `accept()`.

### Follow-ups (owned downstream, not by me)
- #1125 is draft, awaiting review/merge on `llm`; the minion.town chain stays gated until it lands. If review changes the contract I'll re-report (the maintainer message says so).
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/minion-town-remote-guest-endo-cli-endo-invite-primitive.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 2 on 1 host(s)
- Input: 314 tokens (28007518 cached reads)
- Output: 141218 tokens
- Cost: $21.479383749999997
- Wall-clock: 2119s
- Model(s): claude-opus-4-8 ×2

<!-- garden-usage-end -->
