CI is GREEN (rc 0, all 5 checks pass). The fix stage is complete.

## Completion report

**Job:** Gauntlet FIX round 4 — endojs/endo-but-for-bots PR #935 (`design(reminder): integrate @endo/reminder into Chat`), a design-only PR on head `kriscendobot:design/reminder-integration-chat`.

**What I did:** Read the round-4 panel verdict (7 seats, all request-changes, disposition must-fix), verified every load-bearing technical claim against the actual merged source, applied the must-fix items in one commit (`e847901428f`), pushed to the PR head via `safe-push-pr-head.sh`, and watched CI to terminal.

**Must-fix items applied (files: `designs/reminder-integration-chat.md`, `designs/README.md`, `designs/endo-reminder.md`):**
- **critic-1 (premise false):** Re-derived the § Provisioning fork on the accurate premise — a `--powers @agent` recipe *can* mint a second principal in its own body (`provideGuest` + `makeUnconfined … powersName`), as `packages/fae/setup.js:20-42` already does. `setup-reminder.js` now provisions under a dedicated guest, so the baseline is **attenuated** (not attenuation-free); the config-corruption brick risk is closed, not accepted. Updated the flowchart, § What has to change, § Ordering, § Open questions, and the negative test accordingly.
- **critic-2 (mis-scoped blocker):** Courier provisioning is a build-and-store-an-archive step (`makeArchive`/`makeFromTree` take a stored pet name, not a specifier; `makeCaplet` is not a host verb), so the shared blocker is one specifier + one archive, not a "pair of specifiers."
- **skeptic-1 (inert retry deadline):** Stated the numeric margin — `reschedule()` needs the first backoff delay `min(1000, periodMs/10)` to fit before `scheduledAt + messageTimeoutMs` — and the coalesced-catch-up case where the deadline is already expired at delivery (verified against `scheduler.js:420-434,557,584`).
- **ergonomist-1/2 + decomplector + critic-4:** Collapsed the id-keyed `cancelReminder`/`retune` pair to a single `getReminder(id)` getter (idempotent cancel via the re-derived handle; plain `Error`, not `TypeError`, for an unresolvable id, matching the package's error vocabulary) plus a `limits()` getter; added a `/reminders` listing+cancel affordance so the user path no longer dead-ends at create.
- **copyeditor-1:** Fixed the self-contradictory "Live snooze" bullet label.
- **novice-1 / copyeditor:** Swept review-round residue ("round-1", "corrected from", "downgraded") to design voice.
- **pedant-1 / copyeditor:** Fixed the README `→`/`…` code points to `->`/`...` and added the missing `Updated` row to `designs/endo-reminder.md`.

Also re-verified the whole design file is em-dash-free (the house style; the original had zero — I converted every dash I introduced to parens/colon/comma) and the mermaid flowchart uses quoted labels.

**Result:** Pushed `011ed670d..e847901428f`. CI terminal GREEN — all 5 checks pass (build, lint, test, browser-tests, zizmor). Panel re-run (panel-5) is the driver's responsibility, not this stage.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr935-gauntlet-fix-4.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 3 on 2 host(s)
- Input: 180 tokens (11204010 cached reads)
- Output: 67015 tokens
- Cost: $10.467092000000001
- Wall-clock: 1033s
- Model(s): claude-opus-4-8 ×3

<!-- garden-usage-end -->
