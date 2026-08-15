The build deliverable is complete and verified. PR #991 is open, draft, based on `llm`, with the durable job marker so the gauntlet's supervising gardener converges on this one PR.

## Completion report

**Job:** Builder — replace `@endo/reminder`'s subscriber-capability delivery with ordinary guest package mail, per the landed minion.town design (§2, §4 "Endo", §6 decisions 1–2).

**Re-run finding:** No prior attempt had committed or pushed anything — no branch, no PR, no `tada/` record. Clean start; implemented from scratch.

**PR:** [endojs/endo-but-for-bots#991](https://github.com/endojs/endo-but-for-bots/pull/991) — draft, base `llm`, head `feat/reminder-ordinary-guest-mail`. Registered via `ensure-pr.sh` (recorded on `work/…` in the journal) and carries the `<!-- garden-job: … -->` marker for cross-incarnation convergence.

**Package:** `@endo/reminder` only. minion.town untouched; no npm release cut.

**What changed:**
- `src/index.js` — delivery adapter now sends each firing through the guest's existing `send` method: `E(powers).send('@self', [payload], [], [])`, a capability-free JSON string with no attached values. The plugin drives the internal one-shot `ReminderResponse` from the send outcome — `resolve()` only after the send fulfills, `reschedule()` after a send failure. Dropped the `reminder-recipient` lookup; no recipient formula, `EndoHandle` unchanged, scheduler core untouched.
- `src/mail.js` (new) — `REMINDER_MESSAGE_SCHEMA = 'minion-reminder/v1'`, `encodeReminderMessage` (drops the ephemeral response + internal `type`), `decodeReminderPackage` (rejects malformed and capability-bearing mail), `projectReminderEvents` (dedupes by `{ reminderId, messageNumber }`).
- `src/types.d.ts` — added `ReminderEvent`.
- `src/interfaces.js`, `src/scheduler.js`, `README.md` — doc updates to reflect guest-mail delivery.

**Event identity:** `{ reminderId, messageNumber }` is stable across a reschedule (the scheduler already restores `messageNumber` on retry), so an ambiguous-send retry re-sends the same identity and the projection collapses the duplicate to one event.

**Tests (34 pass):** `test/plugin.test.js` (over an in-memory VFS store + a `send`-recording mailbox) proves capability-free mailbox delivery to `@self`, rescheduling on send failure, projection dedup across an ambiguous-send retry, and daemon revival by re-incarnating `make()` over the persisted store with per-policy coalesce (one catch-up, `messageNumber` advanced, `missedMessages` annotated) and skip (no catch-up, realigned to a future tick). `test/mail.test.js` covers the pure encoding/projection contract.

**Gates:** eslint clean (0 errors; the 5 remaining warnings are pre-existing in `scheduler.test.js`), pre-push-gates deterministic probes pass (fixed a spelled-out `remindersDirectory` and converted `mail.js` to top-of-file `@import` per the `no-inline-import-jsdoc` rule flagged for this exact package in #721). Package has no tsconfig, so no tsc gate.

**Follow-up:** none for this job. The gauntlet (panel → fixer → un-draft) runs on the draft PR under its supervising gardener.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endo-but-for-bots-reminder-ordinary-mail-b929585.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 3 on 2 host(s) (2 unmetered)
- Input: 143 tokens (9031075 cached reads)
- Output: 62235 tokens
- Cost: $7.6632055 (2 engagement(s) unpriced)
- Wall-clock: 956s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
