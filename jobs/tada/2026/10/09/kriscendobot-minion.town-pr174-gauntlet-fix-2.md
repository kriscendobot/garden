Fix round 2 for kriscendobot/minion.town PR #174 is pushed (`4c257ff` → `f7dfa80`, `fix(credits): refund across the whole publish, read-only CLI loads, name and design fixes`) and CI is green. `ci-wait-merge.sh` returned 0 with 3 of 3 checks passing.

**The six must-fix items from the round-2 panel review:**
1. **Refunds (assessor):** a failed publish or upgrade now gets its charge back even when the failure comes after storage. Before, the refund only covered storing the blobs. Now it also covers `evaluateRegister` in `publish` and `writeDirectory` in `upgrade`. On a publish failure the prepared directory is still discarded as before.
2. **Name (stylist):** renamed the `Config` field `creditLedgerDir` to `creditLedgerDirectory` in `src/config.ts` and `src/http.ts`.
3. **CLI rewriting the live file:** `makeFsLedgerLog` takes a new `{ readOnly }` option. In read-only mode it ignores a torn final line instead of truncating or appending to the file. `src/credits-cli.ts` now loads read-only for every command except `grant`, so `balance` no longer rewrites the ledger.
4. **Record kinds:** `designs/ertp-credits.md` § 6a now lists `refund` records alongside `grant` and `charge`, and says what a refund does.
5. **Wrong citation:** § 6a and the headers of `clip-payment.ts` and `credit-ledger.ts` now say this PR defines the `publish-v1` prices. They fit the abstract `PriceSchedule` shape in `clip-usage-metering.md` § 3, which sets no prices itself.
6. **Skipped build order:** § 6a now says outright that this PR does not follow `clip-usage-metering.md` § 8 and § 9. There is a second credit store, `ledger.jsonl`, not yet joined to the Stripe-funded balance. `CLIP_METERING` switches straight from the free stub to real charges. The zero-price trial period is left to the operator: keep `CLIP_METERING` off until the maintainer decides to turn on real charges.

**Checks:** `tsc --noEmit` is clean. One vitest test fails: `test/git-remote/capability.test.ts > projectPartition > propagates a git failure rather than reporting the ref absent`. It is in code this commit doesn't touch, and CI passed. Two `tools/claude-harness` suites also fail, but `npm test` excludes them.

**Follow-ups:**
- The panel's should-fix items were not applied:
  - Concurrent publishes of the same content can go free after a refund.
  - The charge key is the content root only, so it covers neither `powers` nor the schedule version.
  - A replay at a different price throws.
  - `ChargeResult.charged` is also used for grants.
  - The ledger load does not check record shape.
  - The `clip-payment.ts` header still calls the module a stub.
  - `CLIP_METERING=on` in the design vs `=1` in the runbook.
  - The design docs contradict each other: § 7 phasing and the Status line in `clip-usage-metering.md`.
- I also did not add tests for the new refund paths or the read-only load.
- Joining `ledger.jsonl` to the Stripe-funded balance, and deciding when to turn on real charges, are recorded in the design as follow-up work and a maintainer call.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr174-gauntlet-fix-2.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 26 tokens (761176 cached reads)
- Output: 7117 tokens
- Cost: $0.7759272000000002
- Wall-clock: 91s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
