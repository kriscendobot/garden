---
tier: minion
model-burned: mentor
fallback-tier: 
dispatch: automatic
---
Repo: endojs/endo-but-for-bots (branch `llm`). Builder job derived from the landed minion.town design `designs/endo-reminder-minion-town.md` (kriscendobot/minion.town PR #28, head cfe78b8), which records the maintainer's 2026-08-13 decisions and names this Endo-side change as the serial prerequisite for every consumer (minion.town, Chat, Familiar). It is NOT blocked by that design's §1 gates — those gate the minion.town integration, not this work.

Read `designs/endo-reminder-minion-town.md` §2, §4 "Endo", and §6 decisions 1–2 at kriscendobot/minion.town cfe78b8044e2bf0b0203504406944dd4af5070c9 for the contract, then implement in the `@endo/reminder` workspace package:

1. Replace the subscriber-only `E(recipient).notify(message)` delivery adapter with ordinary guest package mail: the plugin sends reminder data through the tenant guest's existing `send` method addressed to `@self`. Resolve the internal one-shot `ReminderResponse` only after the send fulfills; `.reschedule()` after a send failure. Do not add a recipient formula and do not modify `EndoHandle`.
2. Define the reminder package-message encoding: a single capability-free JSON string `{ schema: "minion-reminder/v1", reminderId, label, periodMs, messageNumber, scheduledAt, actualAt, missedMessages, annotation }`. The ephemeral scheduler response must never enter the mailbox.
3. Make `{ reminderId, messageNumber }` the event identity so a retry after an ambiguous send outcome yields exactly one projected event.
4. Tests proving: mailbox delivery of the package message; rescheduling on send failure; projection deduplication across an ambiguous-send retry; and daemon restart/revival from the `@pins` result name with the VFS store reread and per-policy coalesce/skip of missed messages.

Keep operator-only controls (`setMaxActive`, `setMinPeriodMs`, `pause`, `resume`, `revoke`) on `ReminderControl`; tenant surface stays create/list/set-period/cancel. Open a draft PR against `llm` and let the gauntlet run. Do not cut an npm release off `llm` (design §6 decision 4) and do not touch minion.town in this job.

<!-- garden-reaped: 0 -->
