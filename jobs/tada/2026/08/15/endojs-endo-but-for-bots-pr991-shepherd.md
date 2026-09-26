All checks settled with zero failures. CI is fully green. The PR is a draft, but that's its intended state (per the job — this was an automatic red-CI shepherd dispatch, not a gauntlet/un-draft request), so I leave the draft status as-is.

## Completion report

**Job:** shepherd (auto: red CI) on endojs/endo-but-for-bots PR #991 — drive CI to green.

**Diagnosis:** Two completed failures, both localized to the PR's new reminder test files:
- **lint** (`yarn lint:prettier`): `packages/reminder/test/mail.test.js` and `plugin.test.js` were unformatted.
- **test** (TypeDoc/tsc type-check step): 157 TS errors, all from those two files — `coreMessage()`'s inferred `type: string` wasn't assignable to `ReminderMessage` (`TS2345`), and `decodeReminderPackage()` results (`ReminderEvent | undefined`) were dereferenced without a guard (`TS18048`).

Within shepherd scope (test-file-local type/format fixes) — no escalation to a fixer needed.

**Fix (1 commit, `29b8a0b5d`, pushed to head `feat/reminder-ordinary-guest-mail`):**
- Typed the `coreMessage` factory `@returns {ReminderMessage}` (added the `@import`) so `encodeReminderMessage` accepts it.
- Added `if (… === undefined) { t.fail(...); return; }` guards before reading decoded-event fields (three sites in `plugin.test.js`, one in `mail.test.js`), narrowing the `undefined` union.
- Reformatted both files with prettier.

**Local verification (in the isolated project worktree):** `tsc -p tsconfig.json --noEmit` → 0 errors project-wide; `prettier --check .github packages` → clean; `yarn test` (reminder) → 34 passing; eslint → 0 errors.

**CI result:** re-ran on the new head and fully settled — `lint` pass, `test` pass, and every other check green; **0 failures, 0 pending**.

**Follow-ups:** none. PR #991 remains a draft, which is its intended state (this was an automatic red-CI shepherd dispatch, not an un-draft/gauntlet request).
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr991-shepherd.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 91 tokens (3348151 cached reads)
- Output: 17123 tokens
- Cost: $2.8710935
- Wall-clock: 1216s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
