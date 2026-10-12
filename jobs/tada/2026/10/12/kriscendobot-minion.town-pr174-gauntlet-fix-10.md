# Gauntlet fix round 10: kriscendobot/minion.town PR #174

All three panel-10 must-fix items are fixed and pushed to `build/credit-metering-no-ertp` as `08a0f45`. CI is green (`ci-wait-merge` rc=0, 3 of 3 checks passed, 0 failed).

**Must-fix items**
1. **`AccountCharge.charge` is removed.** It had no production caller and could overdraw an account. It is gone from the interface and the facet in `src/endo/credit-ledger.ts`, along with the `post` helper. `grant` now goes through `serialize(postNow)`, so `reserve().settle()` is the only way to debit an account. `designs/ertp-credits.md` now lists the facet as `reserve` and `balance` only.
2. **The `PaymentProcessor` breaking change is now in the PR description.** A new "Breaking change (interface)" section states that `chargeForPublish` became `reservePublish`, that `PublishMeasure.contentRoot` is now required, and why there is no adapter or version bump (the package is private at 0.1.0). It also explains that the in-memory reservation is lost on restart, and why that is acceptable.
3. **DEPLOYMENT.md wording.** The sentence now reads "any other corrupt line makes every metered publish fail closed …".

**Should-fix items folded in**
- The unclear `CREDIT_LEDGER_DIRECTORY` sentence in DEPLOYMENT.md is reworded.
- The two non-ASCII characters typists can't easily enter (`…` and `−` in code spans) are now ASCII.
- The "charges nothing when site registration fails" test now probes that the hold was released.

**Test changes**
- Tests now debit through a `debit()` helper that reserves and settles in one step.
- The facet-keys test expects only `balance` and `reserve`.
- The overdraw test now checks that a second debit is refused while a publish's reservation is open, instead of recording an overdraw. That overdraw can no longer happen.
- The mock processor no longer has a `charge` method.

**Checks:** `npm run typecheck` passes. `npm test` gives 985 passed and 1 failed. The failure is `test/git-remote/capability.test.ts`, which this PR doesn't touch. I didn't confirm the cause, but I think it is this machine's local setup rather than the code; CI ran green on the same head.

**Not done (should-fix, left for later):**
- Simplifying the reservation bookkeeping (the refcounted map of open reservations).
- Merging the two near-identical `Reservation` and `PublishReservation` types.
- A `createApp` test of the `CLIP_METERING` wiring.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr174-gauntlet-fix-10.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 40 tokens (1520944 cached reads)
- Output: 8508 tokens
- Cost: $1.1239648000000002
- Wall-clock: 917s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
