---
handler-budget-role: fixer
tier: mentor
dispatch: automatic
fallback-tier: minion
---

# fix endojs/endo-but-for-bots PR #1125 — guest-facing read-only hub: bare `Far` → guarded `makeExo`

Maintainer directive (kriskowal, verified re-run then pass to a fixer):
https://github.com/endojs/endo-but-for-bots/pull/1125#discussion_r4040732326
Thread root: https://github.com/endojs/endo-but-for-bots/pull/1125#discussion_r4040218737

PR: endojs/endo-but-for-bots #1125 "feat(daemon): guest-owned invitation
primitive", head branch `bot/build/endo-guest-invite-primitive`, base `llm`.

## What to fix (the one required change)

`packages/daemon/src/directory.js` — `readOnlyDirectorySource` (the eval source
string, around line 39-48) builds the guest-facing read-only view with a **bare
`Far('ReadableNameHub', { help, has, list, lookup, maybeLookup })`**. This object
is the guest-facing attenuation returned by `EndoDirectory.readOnly()` and is
handed across a worker/vat boundary to a **less-trusted holder** (a lower-authority
guest's `@nets`, via `isReadOnlyDirectoryFormula` / `getAgentDirectoryId`). Bare
`Far` gives passability + `harden` but **no InterfaceGuard**: a hostile caller's
malformed / extra / wrong-typed arguments are only rejected downstream at the
backing `DirectoryInterface`, never at this boundary. `harden`/`Far` is not a
substitute for an interface guard.

**Required:** mint the read-only view as
`makeExo('ReadableNameHub', ReadableNameHubInterface, { ... })` so the exo — not
each method body — rejects malformed arguments at the boundary.

The matching guard already exists but is currently unused for exo construction:
`ReadableNameHubInterface = M.interface('ReadableNameHub', { ...readableNameHubMethodGuards })`
at `packages/daemon/src/interfaces.js:89` (its comment even says "not used to
build an exo directly"). It names exactly this contract
(help / has / list / lookup / maybeLookup).

## The real implementation constraint (do not skip)

The `Far(...)` sits inside the `readOnlyDirectorySource` **eval source string**,
which runs in a worker compartment whose endowments are narrow: today it has
`Far`, `E`, and the `hub` value — it does **not** have `makeExo`, `M`, or the
`ReadableNameHubInterface` record in scope. So you cannot simply s/Far/makeExo/ in
the string. Two viable shapes; pick per the codebase's grain and justify briefly:

1. **Endow into the eval compartment.** Make `makeExo` and a serializable
   `ReadableNameHubInterface` (an `M.interface(...)` guard is a passable record)
   reachable inside the eval source, then build the exo there. Verify the eval
   formula's endowment/name plumbing (`isReadOnlyDirectoryFormula` checks
   `formula.names` / `formula.values` — keep that recognizer in sync with any new
   endowment, or the daemon-internal network-discovery recognizer breaks).
2. **Incarnate daemon-side, like the sibling read-only hubs.** The mail/message
   read-only hubs are already built as daemon-side exos (see `manager.js` around
   lines 2823 / 3216). If the read-only directory view can be minted the same way
   rather than as a worker-eval `Far`, prefer matching that established pattern.

Whichever you choose, the durable-identity / recognizer invariants of
`readOnlyDirectorySource` + `isReadOnlyDirectoryFormula` must stay intact (they key
daemon-internal network discovery), and any existing persisted read-only formula
must still incarnate. If option 1 changes the source string, that changes the
formula's durable identity — check whether that is acceptable (a fresh formula
type/version) or whether the recognizer must tolerate both.

## Verification & landing

- `cd` into the daemon package; run `tsc` (`yarn build:types:gen` first if a dep
  changed — composite-tsconfig drift check), `eslint`, and the relevant tests
  (`packages/daemon/test/endo.test.js`, the multiplayer suite, and any
  `readOnly()` / directory tests). Add or extend a test that a malformed argument
  to the read-only hub is now rejected **at the exo boundary** (this is the
  behavioural proof the guard is live), if one does not already exist.
- Push to the PR head branch `bot/build/endo-guest-invite-primitive` (rebase CAS).
- Reply on review thread 4040218737 / the r4040732326 comment with the fixing
  commit SHA and a one-line note that the guest-facing view now carries
  `ReadableNameHubInterface` via `makeExo`.

## Secondary findings (context only — not the required deliverable)

Both re-run seats (locksmith, warden) additionally noted, comment-only:
- The read-only view is a **shallow** attenuation: `lookup`/`maybeLookup` return
  live, fully-writable nested directories, so "read-only" over-promises. It is
  documented, so it is disclosed not hidden. Surface it to the maintainer (a
  one-line caveat at the untrusted hand-off sites, or a recursively-attenuating
  variant) rather than silently expanding scope — do not fix without a go-ahead.
- A guest inviter can now drive root-level `addPeerInfo` on an accepted
  invitation (via the internal broker; the broker itself is correctly withheld
  from the guest). Same trust shape as host invitations; deliberate surface
  expansion, maintainer's call. Note only.

Keep the required change tight: `Far` → guarded `makeExo` on the guest-facing
read-only hub. Everything else is a note for the maintainer.
