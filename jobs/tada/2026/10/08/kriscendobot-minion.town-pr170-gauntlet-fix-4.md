I applied all three of the round-4 panel's must-fix items to kriscendobot/minion.town#170 and pushed them. CI is green (3/3, `ci-wait-merge` rc 0).

**What changed** (two commits pushed to the PR head, `fa8973b..5e32e67`):

- **decomplector (must-fix):** `pending-guest` is now a one-time value instead of a stored slot.
  - In `deploy/aws/www/guest.js`, the shell reads the link guest once at start, deletes the stored copy, and keeps it in memory.
  - The switch prompt now acts on the guest it was shown for, so a second tab can't swap in a different one. Forget can no longer adopt a link the user left unanswered.
  - A reload, a failed check or a dismissed prompt now drops the link. `adoptPendingGuestAtStart`, `adoptPendingGuest`, `verifyPendingGuest` and the keep/drop retry policy are gone.
  - `invitation` is still stored, so an interrupted acceptance survives. Design § 4.1 is rewritten to match, including the "survives reloads" sentence.
- **integrator (must-fix):** the Caddy comment above `handle /` and the design § 2.1 `GET /` row now say `/` serves the bootstrap, not the guest shell.
- **pruner (must-fix):** I trimmed the PR description: the second "Why" paragraph, the hedge in the parser-move bullet, the reconnect detail in the credential-errors bullet, and the itemized verification paragraph.
- **One should-fix from saboteur, spec-keeper and corner-prober:** `captureLocatorFragment` now reads `localStorage` inside the migration `try`, so blocked site data no longer breaks the capture.
- **Tests:** I updated the switch-prompt browser test for the new reload behavior and added a test that Forget does not adopt an unanswered link. The old code would fail that test.

**Verification:**
- The local browser suite passes 14/14, and the typecheck is clean.
- Vitest passes 944 tests and fails one, `test/git-remote/capability.test.ts`. That failure was already known on this host and has nothing to do with this change.
- I posted a summary comment for this push on the PR, which the scribe seat asked for.

**Follow-ups:** the remaining should-fix items are not done:
- `isGuest` checks only method names, so a daemon host passes as a guest.
- The envelope constants are defined twice.
- `render` still mixes the consent check, storage and painting (the `selectGuest` split).
- The pattern matching unknown-credential errors is unanchored.
- The browser tests run on Chromium only.

The panel-5 stage will re-review.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr170-gauntlet-fix-4.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 50 tokens (1806981 cached reads)
- Output: 13738 tokens
- Cost: $1.3011082
- Wall-clock: 510s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
