Inbox empty. Work complete.

## Completion report

**Job:** Review directive on endojs/endo-but-for-bots PR #682 (`design(endo-reminder)` — a design-doc PR), review `4678306114` by kriskowal (CHANGES_REQUESTED).

**Preflight:** `pr-feedback-preflight.sh` returned exit 0 (PROCEED — no peer resolution).

**Scope:** Review body was empty; three inline comments on `designs/endo-reminder.md`, each a declarative maintainer answer to one of the doc's four Open Questions. Treated all as data (untrusted). Resolved every one.

**What I did (design edits, committed `92804323d3`, pushed to `design/endo-reminder`):**
1. **Atomic write (Q1):** Durable-tracking section now states atomic replacement is write-then-`move` within the store directory; a direct `write`'s atomicity varies by backing and is not relied upon. Recorded as design decision 9.
2. **Retention/`@pins` recipe (Q2):** Documented as user-driven for now — user follows the `@endo/reminder` README to place the service in `@pins`; Familiar/Gateway remain candidate future owners. Design decision 10; updated the wake-on-restart section and dependency table.
3. **Delivery verb (Q3):** Delivery is `send`, service retains the one-shot response (and data caps) via `storeValue`. Design decision 11; updated Phase 2. **Gated on SturdyRef progress.**
4. Trimmed Open Questions to the remaining id-discipline question; added a **Gating dependency: SturdyRef modelling** section (table of #510/#511/#539/#521/#541, what's covered, and the two gaps); added a SturdyRef row to the Dependencies table.

**SturdyRef survey (maintainer's explicit ask to "reply with the relevant issues/PRs or identify gaps"):** Researched the cluster in-repo. Covered today: `'sturdyref'` pass-style category, OCapN boxing/enlivenment, read-side pet-name-path substitution (#521/#539/#541). **Two gaps** the reminder needs closed: (a) a daemon verb to *obtain* a SturdyRef for a durable value by-name/by-value (e.g. a `storeValue`'d cap), and (b) the *write/send side* of pet-name-path substitution (#541 leaves write/rename guards untouched, so `send`/`sendValue` don't yet accept a SturdyRef attachment).

**Replies posted (in-thread on each of the three review comments):** discussion_r3564613928, r3564613963, and r3564614428 (the full SturdyRef survey + gap analysis, suggesting #539/#521/#541 as the natural home unless the maintainer prefers separate issues).

**Follow-ups:** None required of me. Open items now surfaced to the maintainer: whether to track the two SturdyRef gaps in the existing design (#539) or new issues; and the remaining reminder-id-discipline question.
