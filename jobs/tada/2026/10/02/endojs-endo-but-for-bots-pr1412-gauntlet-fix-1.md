# Fix round 1 for endojs/endo-but-for-bots PR #1412: fixes pushed, CI green

I applied the panel's in-scope must-fix items and pushed them to `build/endo-claude-backends-1357` (40a7369819 → 7aafcd7d2d). CI finished green: `ci-wait-merge` returned rc 0 with 33 of 33 checks passing and none failing. Two must-fix items, both in #1403's code, were left alone; see "Not done here" below.

**Commits pushed:**
- **dee2c8eb79 (integrator):** Merged #1403's current head `ef660bd` into the branch with a `--no-ff` stack merge. That brings in its fixes to `classify` (the `harden()` throw on a hostile response is now inside the `try`), `limits` and `usage-recorder`. #1403's version of `.changeset/add-endo-inference.md` also arrives already rewrapped one sentence per line.
- **fb690a4ddf (saboteur):** A CLI turn now settles after the process's `exit` event when a descendant keeps the pipes open. It waits a 1-second drain grace period, then kills the process group and resolves with the real exit. Before, such a turn would only end at the wall-clock limit and be misreported as `limit-exceeded`. The test fixture can now simulate this case (a `lingers` option), and a new test covers it.
- **be49fc48c9 (prover, corner-prober #2):**
  - The ring-buffer test now checks the exact 4096-character stderr tail using a marker per chunk, so a trim that drops the wrong end would fail it.
  - The stderr tail can no longer start with half of a split surrogate pair, and there is a test for it.
  - The constant is renamed `STDERR_TAIL_CODE_UNITS`, since it counts code units, not bytes.
  - Deleting the trim loop entirely still passes the tests. Its only effect is bounding memory, which nothing a test can observe depends on.
- **aa68588bf1 (corner-prober #1):** `serializedByteCount` used to count a message `JSON.stringify` rejected as 0 bytes. It now uses a replacer: a bigint counts as its digits and a repeated object as a short marker, so the output-bytes limit still applies. The new test shows a message with a large bigint now trips that limit.
- **40926b3ed6 (purist #2):** The CLI backend now takes `maxBudgetUsd` and passes it as `--max-budget-usd`, matching the SDK option. I confirmed the flag exists in `claude` 2.1.280. Invalid values are rejected, and there are tests for both.
- **7aafcd7d2d (changeset-auditor):** Rewrapped `.changeset/endo-claude-inference-backends.md` to one sentence per line.

**PR body (pruner, integrator #2):** I trimmed it moderately rather than making every cut the pruner asked for:
- Cut the "Differences from the prototypes" section, keeping one line saying the response-shape table ships empty.
- Collapsed the phase ledger to one sentence, which also removes the contradictory "#1403" wording.
- Updated the stack note to `ef660bd`.
- Replaced the per-file test tour with a short summary.

The module table and the considerations sections are still there.

**Checks run locally:** the `packages/claude` tests pass (134), `yarn lint` gives 0 errors (only the existing `safe-await-separator` warnings), the root `tsc -p tsconfig.json` shows nothing for claude or inference, and prettier is clean.

**Not done here:** two must-fix items are in `packages/inference`, which belongs to #1403. Changing them in this PR would make it drift from #1403 and conflict when the stack is woven. They should be fixed on #1403, after which a re-merge of the stack picks them up:
- **Stylist:** rename `CredentialGrant.env` to `environment` in `packages/inference/src/types.ts` and `guards.js`.
- **Purist #1:** `utf8ByteLength` in `usage-recorder.js` reimplements `@endo/utf8`.

The other items were advisory and left for the maintainer: the changeset-auditor's question about `@endo/claude`'s release shape, and corner-prober findings 3–5 (extra boundary tests in `classify` and `scratch-directory`).

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1412-gauntlet-fix-1.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 76 tokens (3264307 cached reads)
- Output: 20215 tokens
- Cost: $1.8551534000000003
- Wall-clock: 2414s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
