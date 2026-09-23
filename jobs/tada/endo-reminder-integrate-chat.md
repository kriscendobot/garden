The design is delivered as a draft PR against `llm`. Job complete.

---

## Completion report

**Job:** designer — plan integrating `@endo/reminder` (PR #721) into Chat. Plan only, no implementation.

**Deliverable:** `designs/reminder-integration-chat.md` (294 lines) on branch `design/reminder-integration-chat` in the `kriscendobot` fork → **draft PR [endojs/endo-but-for-bots#935](https://github.com/endojs/endo-but-for-bots/pull/935)** against roadmap branch `llm`. Both mermaid diagrams parse-validated (sequence + flowchart-v2); all six referenced designs confirmed to exist (no broken links).

**Disambiguation (the job flagged this as plan-invalidating if wrong):** "Chat" = **`@endo/chat`** (the web app shell) plus its default view `@endo/space-chat`. Explicitly **not** `@endo/goblin-chat` (a separate OCapN/Goblins protocol + Ink TUI that never touches the daemon mailbox), and `chat-network-view` **does not exist** as a package (the review's parenthetical named a non-existent directory).

**Load-bearing findings, verified against source:**
- The plugin delivers via `E(recipient).notify(message)`, but Chat/daemon has **no `notify` surface** — inbound messages arrive through the daemon mailbox (`send`/`receive`/`deliver` in `daemon/src/mail.js`), and capabilities travel by *stored* `FormulaIdentifier`, not live exos. Bridge: a small **reminder-courier** caplet (`notify` → `E(host).send('@self', …)` as a "Reminders" party). Delivery then surfaces **for free** through `followMessages`/`InboxRoot` (chime + single-sender space); no front-end change needed for delivery.
- Provisioning is `E(host).makeUnconfined('@endo/reminder', …)` (host.js:1387) with a two-name powers namehub: `reminder-store` = a `provideScratchMount` VFS directory (host.js:567, satisfying the store's `@endo/platform/fs/extended` verbs) and `reminder-recipient` = the courier; pinned into `@pins/reminder`; scheduler facet stored for the UI, control facet retained. Follows the `setup-lal.js` `endo run --UNCONFINED --powers @agent` precedent.

**Two premise corrections surfaced to the maintainer in the plan:**
1. **#721 is now MERGED** (the job spec said "open, CHANGES_REQUESTED"), so the plan no longer waits on it landing.
2. The *native in-message snooze* leg depends on reminder **Phase 4** (`send`+`storeValue`, SturdyRef-gated) — **not built** on #721. So the plan sequences: auto-ack baseline (ships now) → live in-memory snooze (now, Chat-side only) → native actions (deferred to Phase 4). Named per the job's "say so plainly if the plan depends on #721 changing shape" instruction.

**Ordering:** the store-mount + provisioning + `@pins` retention substrate belongs to the Familiar/Gateway deployment layer (the sibling plans); Chat's courier + `/remind` affordance build in parallel. Shared cross-cutting blocker across all three integrations: making `@endo/reminder` resolvable in the daemon deployment (currently a dependency of nothing) — flagged "to be filed" as one task, not duplicated per plan.

**Open questions left explicit** (not guessed): deployment-ownership of provisioning, self-vs-other-party recipients, exact `provideMount` verb-parity with the store contract (the one thing to verify against a live daemon before building), and the scheduling-affordance shape.

**Follow-ups:** the sibling Familiar and minion.town integration plans (the other two the #721 review asked for) remain to be posted; and the shared `@endo/reminder`-in-daemon dependency task to be filed.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endo-reminder-integrate-chat.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 72 tokens (3105104 cached reads)
- Output: 37063 tokens
- Cost: $4.946282999999999
- Wall-clock: 645s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
