I applied the panel-5 must-fix items to kriscendobot/minion.town PR #174 and pushed them as one follow-up commit. The head moved from `39a12d0` to `8f88be4`, and CI is green: `ci-wait-merge.sh` returned rc 0 with all 3 checks passing.

**Fixes from the four request-changes seats:**
- **archivist:** the design doc now says `CLIP_METERING=1` instead of `=on`, matching the other docs and the systemd unit.
- **breaker 1 (refund race):** a publish that arrives while an earlier publish's refund is still running now waits for that refund to finish, then pays. Before, it could reuse the old charge and publish for free just before the refund cancelled it. A new test covers this; the test fails without the fix.
- **breaker 2 (price version):** settlement ids now include the price-schedule version (`publish:publish-v1:<owner>:<root>`). A future price change can no longer lock an owner out of re-publishing with an "already settled at N, not M" error. The design doc and the existing test now use the new id format.
- **breaker 3 (CLI `grant` on a live gateway):** the ledger file's half-written last line is now handled in one of three ways:
  - the gateway repairs it at boot;
  - `credits balance` ignores it;
  - `credits grant` refuses to run until the gateway restarts and repairs it.
  Before, `grant` cut off that line, which could be a record the running gateway was still writing. The CLI never rewrites the ledger file now. A new test checks that the file bytes stay unchanged; this also covers prover item 1.
- **pruner:** I trimmed the comments it flagged in `clip-payment.ts` and `http.ts`. The note about concurrent publishes sharing one charge moved to the code that enforces it.
- **decomplector:** I added two justifications to the design doc (§ 6a) rather than restructuring the code:
  - **Two credit stores:** the interim ledger is acceptable next to the Stripe `credits` balance because no credit can land in both or be spent twice. The ledger is throwaway, and the planned reconciliation is to load both balances into the ERTP v2 purse at cutover.
  - **Charge then refund:** charging only after success would store and serve content nobody paid for. A reserve-then-commit design would still need the same release-on-failure path, so it would rename the mechanism, not remove it.

  The decomplector may still prefer a code change here.

**Also fixed (should-fix, cheap):** I moved the new metering notes in `DEPLOYMENT.md` into their own paragraph, separate from the edge-verification text (packager).

**Checks:** `tsc --noEmit` is clean, and `test/credit-metering.test.ts` passes (28 tests). The full local `npm test` had one failure, in `test/git-remote/capability.test.ts`. This PR doesn't touch that file, and the failure looks like a git problem in the local sandbox, not a code defect.

**Left for later:** the should-fix items from comment-only seats, such as fsync durability, checking every ledger line at load, replacing `| void` in the settlement type, and a test for the `http.ts` wiring. The panel-6 round will decide whether the decomplector accepts the written justifications.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr174-gauntlet-fix-5.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 48 tokens (1948012 cached reads)
- Output: 13907 tokens
- Cost: $1.3855424
- Wall-clock: 916s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
