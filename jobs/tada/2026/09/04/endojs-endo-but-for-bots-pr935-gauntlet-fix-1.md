FIX round 1 complete for endojs/endo-but-for-bots PR #935 (`design(reminder): integrate @endo/reminder into Chat`) — a design-only PR (`designs/reminder-integration-chat.md`).

**What I did**
- Pulled the panel-1 must-fix verdict (`<!-- garden-panel-verdict: must-fix round=1 -->`, 11 seats, all request-changes) and verified each cited fact against the in-tree sources before editing.
- Applied the consolidated must-fix items as prose corrections in one commit (`988c2eb01`), pushed to the fork head `design/reminder-integration-chat` via `safe-push-pr-head.sh` (advance mode).
- Validated both mermaid diagrams parse (sequence + flowchart-v2 OK) after edits.
- Watched CI to terminal, bounded: **rc 0 — CI GREEN** (5/5 checks, 0 failed).

**What changed in the design**
- **Delivery target `@self` → `@host`**: `@self` is the *sender's* own handle (`guest.js:96`), so the courier must send to `@host`; corrected the misquoted endoclaw precedent (`send('@host', …)`, `endoclaw-proactive-messages.md:31`), the sequence diagram, and the 4-arg `send` guard (`interfaces.js:203-210`).
- **"Reminders" space is not auto-derived**: `setup-reminder.js` must provision the space config (`spaces-gutter.js:410`); self-to-self is filtered, so the courier must be a distinct party.
- **Structural attenuation**: the courier is a hardened exo closing over a guest privately (the guest is the trust boundary), not "a guest that only sends to self" — a bare `GuestInterface` carries the whole namehub/mail/request surface.
- **Opaque label**: the `/remind` label is delivered as one opaque `strings` element (empty edge/pet names), not re-parsed by `message-parse.js` (which would lift `@name` and throw `Unknown pet name` at every firing).
- **Snooze semantics**: `reschedule()` is failure-retry (backoff), not user snooze; response auto-resolves at `messageTimeoutMs`; retain by `(reminderId, messageNumber)`; hand the UI a per-message facet (capability, not the `Math.random` id token); split recipient/control facets.
- **Resolved open question 3**: the store consumes the `@endo/platform/fs/extended` `Directory` cursor contract (not `EndoMount.list()`); tighten the `ReminderStoreDirectory = any` alias as named work.
- **Should-fixes folded in**: dedicated worker for `makeUnconfined`; store reachable only via the powers namehub (limits-bypass); mailbox-retention follow-up; cadence band 1s–24h + chat-bar validation feedback; corrected clock-seam and dropped the stale test count in the test strategy; ASCII ellipses in code spans.

**Follow-ups (not this stage)**
- Driver re-posts panel-2 to re-review the revised design.
- kriskowal left a standing comment asking for a job to experimentally inject an `@reminders` capability into new guests on minion.town and validate in production — a separate downstream task, not part of this gauntlet stage.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr935-gauntlet-fix-1.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 3 on 1 host(s)
- Input: 126 tokens (5792978 cached reads)
- Output: 37050 tokens
- Cost: $7.819429749999999
- Wall-clock: 1480s
- Model(s): claude-opus-4-8 ×3

<!-- garden-usage-end -->
