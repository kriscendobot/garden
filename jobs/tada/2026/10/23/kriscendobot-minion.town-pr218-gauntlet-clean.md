**Clean stage report: kriscendobot/minion.town PR #218 (`split/pr216-ledger`)**

I added two tests that cover the last untested new statements in `closeGuestBonds`, and CI is green at the new head `ac3599a6`. No dead code needed removing.

**Starting state:** the PR was a draft with one commit, `cb05552c`, and CI was already green there. I still ran the coverage pass, because nothing showed that coverage had been checked.

**Coverage pass:**
- I ran the four test files the PR touches, with coverage measured on `src/auth/accounts.ts` and `src/auth/stores/dynamodb.ts`.
- The repo doesn't have `@vitest/coverage-v8` as a dependency. I installed version 2.1.9 in a temporary directory outside the repo and linked it in, then removed both afterwards. `package.json` and the lockfile are unchanged.
- Two new code paths had no tests:
  - **`dynamodb.ts:170`:** a ledger entry that is valid JSON but doesn't name an account should be skipped.
  - **`dynamodb.ts:137`:** if removing a bond from an account row fails for any reason other than `ConditionalCheckFailedException`, the error should be passed up.

**Change:** commit `ac3599a6`, pushed with `safe-push-pr-head.sh` (fast-forward from `cb05552c`). It adds two tests to `test/accounts-dynamodb-bonds.test.ts`:
- Entries that parse but have the wrong shape (an object, a one-element array, a non-string `sub`, `null`) are skipped without touching any row, and the real bond is still removed.
- An `AccessDeniedException` while removing a bond makes both `closeGuestBonds` and `unbondGuest` fail instead of counting the row as a stale bond.

**Results:**
- After the change, every new statement in the PR's code is covered. The lines still uncovered in `dynamodb.ts` (77-78, 105-117, 245-246) and `accounts.ts` (327-366) are older code the PR doesn't touch.
- One branch stays uncovered on purpose: the `String(error)` fallback at line 164 can't be reached, because `JSON.parse` always throws an `Error`. It's harmless defensive code, so I left it.
- All 51 tests in the four files pass and `tsc --noEmit` is clean.

**CI:** `ci-wait-merge.sh --no-merge` returned rc 0 (green) for the one Actions run at `ac3599a6`. The bot token can't read the PR's combined check status, so the script used the Actions runs API instead; any status that doesn't come from GitHub Actions isn't visible to it. I waited in two bounded rounds because the run took about 15 minutes.

**For future runs:** `test/deploy-accounts-store-backfill.test.ts` fails when `TMPDIR` is `/tmp`, because its fake `aws` script can't run there ("Permission denied"). Run it with `TMPDIR` set to a directory on the scratch mount. This matches the existing memory note about choosing `TMPDIR` on this host.

<!-- gauntlet-stage-result: clean=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr218-gauntlet-clean.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 48 tokens (1460840 cached reads)
- Output: 9422 tokens
- Cost: $0.983184
- Wall-clock: 1069s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
