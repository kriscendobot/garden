Inbox is empty. The job is complete: design authored, prior design superseded, plan synchronized, draft PR open.

## Completion report

**Job:** `endo-reminder-plugin-design` (designer) — redraft the EndoClaw interval scheduler as a design for the new unconfined plugin `@endo/reminder` in endojs/endo-but-for-bots, per kriskowal's CHANGES_REQUESTED review on PR #609.

**What I did:**
- Wrote `designs/endo-reminder.md` (slug `endo-reminder`), metadata table per `designs/AGENTS.md` conventions, dates absolute, review quoted verbatim under `## Prompt`. The design resolves all four review directives plus the two inline nits:
  1. **Message-scheduler framing** — named and documented as a message scheduler that produces messages on various schedules; vocabulary map interval→reminder, tick→reminder message, `TickResponse`→`ReminderResponse`.
  2. **Unconfined plugin** — new `packages/reminder` exporting the standard caplet maker `make(powers, context)`, provisioned via the existing generic `makeUnconfined` pathway; all of #609's daemon-formula integration drops.
  3. **Platform persistence** — durable tracking is a writable virtual-file-system directory (`@endo/platform/fs/extended`, reconciled tree verbs), backing-agnostic (node-fs, in-memory, daemon mount, database-backed); no `node:fs`, no `filePowers`.
  4. **Wake-on-restart narrative** — integration-owned retention: the provisioning integration (Familiar app or online Gateway) pins the caplet; the daemon's existing `revivePins()` provides pinned identifiers at boot, so daemon core gains no reminder-specific revival logic. Unpinning decommissions. Mermaid sequence diagram included.
  5/6. **Naming rules as binding build constraints** — no `Cmd` suffix on any maker; no `@module` JSDoc tags.
- Behavioral mechanics (start-to-start timing, resolve/reschedule backoff, tick-timeout auto-resolve, `maxActive`/`minPeriodMs`, pause/resume/revoke, missed-tick coalescing) carry over normative-by-reference, keeping the new document to ~3 screens per designer norms.
- Marked `designs/endoclaw-timer.md` **Superseded by endo-reminder** (note + status; not deleted).
- Synchronized `designs/README.md` per project convention: summary-table rows (endoclaw-timer → Superseded; endo-reminder added), dependency-graph node/edge (`ereminder` → `eproactive`), M3 design list, strategic-rationale and milestone tables, and the S-M/3-day estimate row.
- Package-name check: no `exo-` prefix rule exists in the project's style guides, so the maintainer's chosen name `@endo/reminder` stands with no conflict (recorded as design decision 7).
- Committed on `design/endo-reminder` (573b6c141, bot identity) and opened **draft PR #682** against `llm`: https://github.com/endojs/endo-but-for-bots/pull/682, body citing the originating review and listing the four open questions (durable-store contract/atomic-replace idiom, which integration owns retention, mail verb for delivery with attached response, id discipline).

**Follow-ups:**
- **PR #609** is superseded by this design and should be closed or have its head redrafted onto a build of `endo-reminder` once the design lands; disposition is left to the maintainer/liaison as the job specified.
- A later `build` job implements the design (Phase 1: package + core scheduler ported from #609's head onto the VFS store, in-memory-backed tests).
- A dedicated `endo reminder` CLI verb was scoped out; noted in the design as "follow-up to be filed if wanted."

**Not verified:** nothing executable was produced (design-stage job); the PR diff was verified by inspection of the pushed commit (3 files, +331/−9).

Self-improvement: nothing this time.
