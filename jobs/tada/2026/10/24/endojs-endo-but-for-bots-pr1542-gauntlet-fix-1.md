Fix round 1 for endojs/endo-but-for-bots PR #1542 is done: I fixed every failing style finding from the pre-pass, pushed, and CI on the PR head is green (34 checks, 0 failed).

**Fixes pushed to `fix/sandbox-ubuntu-2604-bwrap-tests`** (with `safe-push-pr-head.sh`, which only added commits on top of the existing head):
- **`690f6003ca`** — clears the two failing probes:
  - **no-inline-import-jsdoc:** `packages/sandbox/src/drivers/bwrap.js` now has a top-of-file `/** @import { Readable } from 'stream' */`. The `@param` near line 126 and the `@type` cast near line 938 now use plain `Readable`.
  - **spell-out-identifiers:** renamed `err` to `error` in `bwrap.js`'s `killSlice` ESRCH catch, and `dir` to `directory` in the temp-directory cleanup loop in `packages/sandbox/test/bwrap.test.js`.
- **`408c72d7cc`** — the first push turned the `lint` job red. Prettier wanted the now-shorter `Readable` cast on one line. I reformatted it and pushed again; that was the only lint warning.

**Pruner advisory (non-blocking):** I kept the comment on `INFO_REPORT_GRACE_MS` near line 109. It explains why the timeout only matters for a launcher that never reached `clone()`, which the code alone doesn't show.

**Checks:** before the first push, `tsc --noEmit` on `packages/sandbox` and eslint on both changed files showed no errors. I didn't run prettier locally until CI flagged it.

**CI:** `ci-wait-merge.sh` returned RED (`lint`) on `690f6003ca`, then PENDING (rc 4) on `408c72d7cc` before going GREEN (rc 0). I ran it in 540-second chunks rather than one 3600-second wait, because background commands here are cut off after 10 minutes.

No follow-ups. Panel-2 is up to the gauntlet driver.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1542-gauntlet-fix-1.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 48 tokens (1447833 cached reads)
- Output: 6240 tokens
- Cost: $0.8718386
- Wall-clock: 1427s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
