---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
handler-timeout: 10800
---
Address the CHANGES_REQUESTED review on endojs/endo-but-for-bots#1125
(`feat(daemon): guest-owned invitation primitive`, head branch
`bot/build/endo-guest-invite-primitive`). This is the named blocker in
minion.town's `designs/remote-guest-endo-cli.md`: "the invitation is currently
owned by the minion.town daemon host. The missing piece is an invitation owned by
one OAuth guest." MAINTAINER DIRECTIVE (kriskowal, 2026-09-16): fix it now.

Use skills/pr-review-thread-replies and skills/review-feedback-followup-commits:
reply thread-by-thread, and land follow-up commits rather than rewriting history
under a live maintainer review.

## The 15 unresolved threads (kriskowal)

FORMULA SHAPE / MIGRATION
- `formula-record.js`: "Let's avoid modifying the shape of existing formulas going
  forward, to avoid needing to purge production databases. If we do change the
  shape, we should tolerate and coerce records on read."
- `formula-record.js`: "Let's make the decision of whether to migrate from a prior
  formula version based on what exists on master. No deployed guest formulas have
  a pins or heldPins property. These are artifacts of our own work."
- `manager.js`: "Just omit the pins if they don't exist on a legacy formula. We
  should never infer a pet-name from structure. Pet names are *as implied by their
  name* chosen by the user."
- `formula-record.js:85`: "I note that we've added planes. That suggests a latent
  defect. Please ensure we have coverage."

AGENT OPTIONS / SYMMETRY — the largest structural item
- `guest.js`: rename to `guestPins` (visible and mutable to the guest) and
  `hostPins` (visible and mutable only to the host, through its internal formula).
  "We should actually allow the caller of `makeGuest` to specify a given `pins`
  directory as an option, so the parent agent can elect to retain it, or not,
  without having to traverse into the formula inspector."
- `manager.js:6852`: let the caller of `makeGuest` specify the `nets` or a
  read-only view of a `nets` directory, so the parent can enact policies:
  (A) guest has no networks by default but can obtain them and add to its own
  `@nets` by introduction; (B) guest has the given networks; (C) guest has no
  networks and cannot obtain them; (D) guest has the given networks.
- `host.js:84`: "This is not an intentional asymmetry. Guests and hosts should both
  have host and guest pins and networks, as well as introduced names and introduced
  special names. It may be possible to fully converge the guest and host options
  into a single MakeAgentOptions, provided parallel implementations of nets and
  guests, as well as tests that are parameterized on host and guest when they
  should have parity."

NAMING
- `formula-type.js`: "Let's make these consistent. `readable-directory` to go with
  `readable-tree` and `readable-blob`."

CAPABILITY DISCIPLINE — treat as a security requirement, not a style note
- `mail.js`: "We need to avoid relying on `listIdentifiers` going forward, in
  anticipation of removal of that method. Hosts may see identifiers and locators,
  but guests must not, because an AI agent might exfiltrate these and they are
  cryptographic information. In the fullness of time, we need to make more use of
  sturdy refs to enable a guest to communicate about a formula by identity without
  stating the formula identifier."

TESTS REQUESTED
- `formula-record.test.js`: "Please add a test in the form of `endo.test.js` that
  exercises the creation of a guest from within a guest and validates that they can
  communicate." (This is the capability that minion.town's web invite/accept slice
  depends on — treat it as the PR's acceptance test.)
- `endo.test.js`: integration test for this story: "A guest is created with a
  host-pinned agent that responds to any message the agent receives and then
  dismisses the message. The worker containing the agent is cancelled or the daemon
  is restarted (test BOTH). The guest continues to respond to messages after the
  restart."

HOUSEKEEPING
- `manager.js`: "No banners." (skills/no-comment-banners) — and the thread adds
  "Please adjust existing automation to trigger a juror on this", which is a
  separate follow-up, not part of this fix.

## Three threads ask for SEPARATE jobs — do NOT do these here

Report them in your completion summary so they are posted deliberately; do not
expand this PR's scope to cover them:
1. `formula-type.js:37` — propose `blob` / `file` / `block-storage` as the mutable
   variant of `readable-blob`, threading separate filesystem powers for range reads
   and writes; a ranged write must not extend the file in the middle but may append.
2. `endo.test.js` — a designer to propose guest-owned diagnostics, attenuated to
   formulas the guest created (requires partitioning formulas by creator or marking
   them by creator).
3. `manager.js` — a MENTAT-tier adversarial review of the reasoning behind a
   retention pin ("I have the barest understanding of why this pin needs to
   exist"), weighing the temporarily-unique retention path against a hash over
   stable components (guaranteed unique, converges on retry, but illegible).

## Context

endojs/endo-but-for-bots#340 (OCapN-Noise daemon-to-daemon transport) MERGED
2026-08-25, so the transport this primitive's invitations ride is live.

If the work does not fit one handler even at 10800s, SPLIT it: the formula-shape/
migration threads, the MakeAgentOptions symmetry convergence, and the two
integration tests are three natural stages. Say so rather than overrunning.
