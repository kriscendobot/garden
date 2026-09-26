CI is GREEN (rc 0). The fix is pushed and CI passes.

## Completion report

**Job:** endojs/endo-but-for-bots PR #935 gauntlet FIX round 6 — the design doc `designs/reminder-integration-chat.md` (Chat ↔ `@endo/reminder` integration).

**Panel verdict source:** The round-6 verdict on the PR was a *resumed/reconstructed* aggregate from durable record `3f75e5b99017` (head `fe5937d4`, the current head). Its per-seat findings were **truncated** in the durable record — only archivist, assessor, breaker, and changeset-auditor had recoverable text (with line citations); ~20 other must-fix seats' findings were lost to truncation. I applied every recoverable item, verifying each falsifiable claim against the actual daemon/reminder source.

**Fixes applied (commit `d5d11f5dd`, pushed to `design/reminder-integration-chat`):**
- **archivist:** `designs/README.md:1646` index contradicted the design's decided names — `getReminder(id)`→`reminder(id)`, `/reminders`→`/list-reminders`; fixed dangling `§ What changes` citation → `§ What has to change on each side`; added the missing `type` discriminant row and corrected the `annotation` row to the actual `{ kind, … }` object shape (verified against `computeAnnotation`, `scheduler.js:254`).
- **breaker — `introducedNames` inverted:** verified `introduceNamesToAgent` (`host.js:1860`) reads `{ hostOwnPetName: guestName }` and silently skips names the host doesn't hold; corrected the recipe direction and documented the silent-failure hazard.
- **breaker/assessor — courier↔scheduler cycle + authority widening:** removed the round-5 requirement that the courier fetch `messageTimeoutMs` via `E(scheduler).reminder(id).info()` (a provisioning cycle, since the scheduler is built against a namehub already binding the courier; and a breach of the notify-only attenuation). Reliability now rests solely on provisioning a wide `messageTimeoutMs` at `makeReminder` time, assigned to the scheduling affordance (which already holds the scheduler).
- **breaker — attenuation falsified by mint order:** the host also forgets its own store/courier-guest/courier-caplet seed pet names, not just `agentName`; disambiguated the courier *caplet* (seeded as `reminder-recipient`, notify-only) from the courier *guest* (held in the caplet's own `powersName` as `sender`, never seeded).
- **breaker — idempotency vs forget contradiction:** second run now early-exits on the retained `reminder-scheduler`/`@pins/reminder` (fae's `has()`→skip shape), minting nothing and needing no forgotten seed name.
- **breaker — closed-over guest unrealizable / `:82-84` send authority:** specified the confined caplet resolves `sender` from its own powers namehub; clarified the plugin holds no mailbox send power and that ambient Node authority is a separate axis.
- **assessor should-fix:** `reminder(id)` contract for a cancelled-but-resolvable id; folded `workerName` into the `makeUnconfined` recipe.

Updated the two mermaid diagrams accordingly and validated both parse (`mermaid.parse`). Both mermaid blocks OK; CI **GREEN** (5/5 checks, 0 failed).

**Follow-up (out of this job's scope):** the ~20 truncated must-fix seats couldn't be recovered from the durable record; the driver's re-posted panel-7 will fan out fresh and surface any still-open items with full text. Separately, kriskowal's 2026-09-03 PR comment requests a *new* job (experimentally inject an `@reminders` capability into minion.town guests) — not part of this design fix.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr935-gauntlet-fix-6.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 152 tokens (8818295 cached reads)
- Output: 68408 tokens
- Cost: $7.686750499999998
- Wall-clock: 1420s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
