PR #721 is now **ready for review** (`isDraft: false`). The gauntlet is complete.

## Completion report

**Job:** Run the gauntlet on `endojs/endo-but-for-bots` draft PR #721 — `@endo/reminder` message-scheduler plugin (supersedes endoclaw-timer, design #682).

**Outcome:** PR #721 driven through clean → panel → fix-loop → un-draft; now **ready for review**, all CI green, formal panel verdict on record.

### Clean (CI to green)
The `test`/`Build TypeDoc site` and `lint`/`build API docs` jobs were failing on real TypeScript errors in the PR's own code (`yarn docs` typecheck), not the pre-existing #594 ceiling:
- `computeAnnotation` return literals widened `kind` to `string` → annotated `@returns {ReminderAnnotation}`.
- `makeReminder` opts `catchUpPolicy`/`annotation` typed `string`, not the `ReminderEntry` literal unions → narrowed the opts JSDoc.
- `store.js` `isEnoent` passed a possibly-non-string to `RegExp.test` → `String(...)` wrap.

### Panel (code panel: correctness/concurrency, ocap-security/hardening, packaging/types/tests) + fix-loop
Verdict: **must-fix items found and all resolved**, with regression tests:
1. **[must-fix] Recovery clobbered the coalesced catch-up's message deadline** — `recover()` called `armReminder()` right after delivering the catch-up, whose `disarmReminder()` cleared the just-armed deadline, leaving the one-shot latch open so a late `reschedule()` could rewind `nextTickAt` and double-deliver. Fixed by letting the resolve/auto-resolve path arm the next tick (as in a live delivery).
2. **[must-fix] Unbounded allocation on recovery from an untrusted store** — a far-past/corrupt `nextTickAt` with `timestamps` annotation built an OOM-sized array. Capped at `MAX_COALESCED_MESSAGES` (10 000).
3. **[must-fix] `normaliseEntry` under-validation** — now enforces `[ABSOLUTE_MIN_PERIOD_MS, MAX_PERIOD_MS]` period bounds (a sub-floor period armed a tight-loop timer) and rejects an unsafe `id` before it becomes a `<id>.json` filename (path-traversal).
4–7. **[should-fix]** post-`persist` guard re-check in `onReminderFire`; `setPeriod` re-arm guarded on no outstanding message; serialized config writes (pause/resume race); dropped unused deps `@endo/errors`/`@endo/far` (+ separate `chore: Update yarn.lock`).

**Verified in an isolated worktree:** scoped `tsc --noEmit` clean; `ava --serial` **24 pass** (21 original + 3 new regression tests); `eslint` **0 errors**; `prettier --check` clean; full **CI green** on head `bee451effb`. Added `@copilot` as reviewer.

### Commits pushed to `build/endo-reminder-plugin`
`a3ea4ef` docgen type fix · `ffb20eb` recovery/config hardening (panel fixes) · `abbab11` yarn.lock · `bee451e` prettier format.

### Follow-ups (non-blocking, flagged in the verdict)
- **Cancelled-reminder growth:** `removeReminder` is implemented but unwired; `cancel()`/`revoke()` only flip status, so tombstones + the `entries` Map grow under churn and `recover()` re-reads them. Prune vs. keep-as-tombstone (`listAll()` lists cancelled) is a maintainer design call.
- Nits: `deliverMessage` retry comment overstates deadline anchoring; `setPeriod` resets `messageTimeoutMs` silently and is untested; `writeReminder` type loosened to `{ id: string }`; `exports` `./src/types.js → .d.ts` would throw if imported at runtime (types-only today).

Note: repeated reaper requeues occurred while waiting on the ~10-min API-docs CI job; each resume advanced state idempotently (no duplicate commits or reviews).
