The build is complete and verified. Writing the completion report.

---

## Completion report: `build-endo-but-for-bots-endo-reminder-plugin-from-design-682`

**Delivered:** the unconfined `@endo/reminder` message-scheduler plugin implementing `designs/endo-reminder.md` (design PR #682), Phases 1–3.

**Draft PR:** [endojs/endo-but-for-bots#721](https://github.com/endojs/endo-but-for-bots/pull/721) — `feat(reminder): @endo/reminder message-scheduler plugin`, draft, base `llm-7d0d56c` (frozen snapshot of `llm`), head `build/endo-reminder-plugin`.

**Affected package:** `packages/reminder` (new — `@endo/reminder`).

### What I built
- **New package `packages/reminder`** provisioned as an unconfined caplet: `make(powers, context, { env })` via the generic `make-unconfined` pathway. No formula type / `daemon.js` / `host.js` / `interfaces.js` / `extractDeps` changes (all of #609's daemon integration dropped).
- **`src/scheduler.js`** — the interval-scheduler core ported from #609's head with the vocabulary map applied (interval→reminder, tick→reminder message, `TickResponse`→`ReminderResponse`, facet renames), carrying start-to-start timing, one-shot response, reschedule-with-backoff, message-timeout auto-resolve, host limits, pause/resume/revoke, and startup recovery with missed-message coalescing. No `Cmd` suffix, no `@module` tags.
- **`src/store.js`** — VFS-backed durable store over `@endo/platform/fs/extended`'s reconciled writable-tree verbs, write-then-`move` atomic replacement (store contract, design decision 9). No `node:fs`, no `filePowers`.
- **`src/index.js`** — Phase 2 delivery baseline: eventual-send to the subscriber capability resolved by name (`reminder-recipient`), carrying the one-shot `ReminderResponse`. No SturdyRef gate; Phase 4 `send`+`storeValue` deliberately not built.
- **`src/backoff.js`** — named/persisted backoff params (`initialMs`/`maxMs`/`multiplier`/`jitterFraction`) with full jitter and persisted `consecutiveFailures`; plus per-reminder `catchUpPolicy` (coalesce/skip) and coalesced-message `annotation` (count/timestamps) — the #165 richness recovered per the #682 design review.
- **`README.md`** — the `@pins` wake-on-restart recipe (Phase 3); **`src/types.d.ts`** hand-written type module; changeset; LICENSE/SECURITY.md.

### Verification (real-execution evidence)
- **Tests: 21 passed** (`yarn test`), run on the in-memory VFS backing — covers create/persist/list/fire, guarded `ReminderResponse` exo, limits, cancel + `onReminderCancel`, pause/resume, revoke, startup recovery + coalescing across two incarnations over one store, `skip` catch-up, timestamps annotation, reschedule/backoff/fixed-deadline/no-drift, deadline auto-resolve, `stop()` permanence, config persistence across incarnations, corrupt-entry skip, the backoff function, and an end-to-end `make()` delivery to a subscriber capability.
- **Lint: 0 errors** (`yarn lint`; 17 warnings, the `any`/nested-await class tolerated repo-wide).
- **Prettier: clean.** **Composite-tsconfig drift check: passes.**
- **Pre-push probes: pass** — `spell-out-identifiers`, `typedefs-belong-in-dts`, no ASCII banners, no non-ASCII in `src/`. `typist-friendly-code-points` flags only `SECURITY.md`'s apostrophe, which is byte-identical to every other package's canonical file (the `security-md-hash-uniform` requirement is authoritative there).
- Two commits per builder discipline: the feature, then a separate `chore: Update yarn.lock`.

### Follow-ups
- **Gauntlet is the next stage.** Per builder DoD, the builder stage ends at the verified open draft PR; the panel → fix-loop → un-draft chain (`scripts/jobs/gardening/panel.sh`, 27-seat code panel) is the supervised next stage and can be run with `run the gauntlet #721`. I did not spawn it from this build job.
- **Design PR #682** should merge to land `designs/endo-reminder.md` (the README links to it); this PR is the implementation and does not duplicate the design.
- **Restart-survival** is demonstrated at the unit level (two `makeReminderService` incarnations recovering over one shared VFS store); a live daemon `makeUnconfined` + `@pins` boot demo (Phase 3's "one worked integration" leg) is documented via the README recipe but not wired to a running daemon here.
- **Phase 4** (`send` + `storeValue` mailbox delivery) remains gated on SturdyRef modelling and is not built.
- Design open question 1 resolved toward random-hex ids (matching #609's injected id generator).
