# Gauntlet fix round 13: kriscendobot/minion.town #218

I applied the round-13 panel findings, pushed three follow-up commits (PR head `ab7b627d` → `4a2bef5f`), and CI is green: `ci-wait-merge.sh --no-merge` returned rc=0 with all 4 checks passing.

No pre-pass block came with this job, so I worked from the latest panel review (5637251243, `Must-fix before merge`). I replied to each finding in a PR comment: https://github.com/kriscendobot/minion.town/pull/218#issuecomment-6381262167

**Code fixes (`0f0953f5`)**
- **Concurrent bonds (saboteur 1):** every bond used to write one shared key-version row, so simultaneous bonds could cancel each other. Now each serving process writes that row only with its first bond. `bondGuest` also retries a `TransactionConflict` cancellation, up to 5 attempts with a short random delay.
- **Unbond after key rotation (saboteur 3):** `unbondGuest` used to report success without removing a bond made under an older key. It now rejects with `GuestRecoveryKeyVersionUnknownError`, as `recoverGuest` already does.
- **Tests:** new ones cover the first-bond-only write, a retried conflict, giving up after 5 attempts, and the rotated unbond. I also removed the redundant comments the pruner flagged in `dynamodb.ts` and the tests.

**Docs (`d82ac7dd`)**
- **Rotation repair (saboteur 2):** documented, not automated. DEPLOYMENT.md now says a retried guest deletion keeps failing until the old key-version row is deleted, and that the row may only be deleted once no app holding the old key still serves. The error message points to that section. The store can't tell when old-key apps have stopped, so it can't safely clean up the row itself.
- **Design doc (pruner 6):** the compromised-app paragraph moved out of § 2 into § 8 *Store tampering*, and § 2 now links there. I also described the first-bond-only key-version write.

**Refactor (`4a2bef5f`)**
- **In-memory store facets (decomplector 3):** the new `makeInMemoryAccountStoreFacets()` lives in `accounts.ts` next to the interfaces, and `http.ts` calls it instead of copying each method.
- **`accountKey` comment (purist 3):** it now says why `accountKey` uses a JSON encoding while the sibling modules join with a space: it keys the cache in front of every store, whose callers may not have verified the pair.
- **Comment trims (pruner 1, 5):** removed the `http.ts` "unused until deletion lands" note and cut the IAM test comment to a pointer at the design doc.

**Not changed, with reasons given on the PR**
- **`@endo/sha256` (purist 1):** I only reworded the exemption to give the real reason: the encryption and HMAC need `node:crypto`. Swapping it in would mean adding a git or registry dependency across 7 other files, which is a separate change.
- **Duplicated constants (purist 2):** the `.mjs` is copied to the instance on its own and the image ships only `src/`, so a single shared source isn't possible. The existing parity test keeps the copies in agreement.
- **Decomplector 1 and 2:** the PR body's *Decision* section already records that the arc supervisor accepted the IAM widening and kept the ledger in this PR, under the 2026-10-07 inverted-review order. I left that decision alone.

**Checks:** `npm run typecheck` is clean. `npm test` had 1507 passing and 1 failing. The failure is `test/git-remote/capability.test.ts`, a git-wrapper test that fails locally in this environment and is unrelated to this diff.

**Follow-up:** moving the repo to `@endo/sha256` could be its own job if the maintainer wants it.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr218-gauntlet-fix-13.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 66 tokens (3116509 cached reads)
- Output: 20762 tokens
- Cost: $1.9505257999999999
- Wall-clock: 1187s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
