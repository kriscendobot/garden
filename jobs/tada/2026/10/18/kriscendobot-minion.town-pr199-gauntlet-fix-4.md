I applied the round-4 panel's must-fix items to PR #199 and pushed them, but CI never started. All 3 checks sat queued for the whole ~57-minute window, so this stage ends still-pending.

**Pushed:** 4 follow-up commits via `safe-push-pr-head.sh` (fast-forward, no rewind), taking the head from `fc8d73bf` to `478fb7f9`.

**Must-fix items applied:**
- **assessor:** resuming an air-drop no longer sends coupons that expired before delivery, and doesn't count them toward the target. The book stays `pending` and gets topped up.
- **typist:** `BookRow` is now a discriminated union of `BatchBookRow` and `AirdropBookRow`.
- **breaker #1:** `ledger.issue` reserves the unit and adds the serial to its book in one write (a three-item DynamoDB transaction). `appendBookSerials` is gone.
- **breaker #2, saboteur, wire-watcher:** every book write is now conditioned on the book as read and retried on conflict. An air-drop run also holds a single-writer lease (`RUN#<runId>`), so a second concurrent resume is refused with `run-busy` instead of overwriting the book or sending a coupon twice.
- **engine-realist #1:** the daemon connection now reconnects after it closes or a call fails. Effects that are safe to repeat retry once; `sendBook` and `placeBook` never retry. The new test in `test/coupon-wiring.test.ts` uses a fake connection, not a live daemon restart as the juror asked.
- **corner-prober:** two redemptions racing on the same nonce now share one in-flight guest creation. Capacity must be a non-negative whole number in both ledger adapters, with boundary tests.
- **prover:** the envelope test now checks the coupon is in `url.hash`. The open-admission test now takes its value from the config default (`parseCouponAdmission`).

**Summary-fix and should-fix items also done:**
- **fast-checker:** two randomized (fast-check) tests — one checks that the pool counters always match the coupon statuses and the book over random operation sequences; one round-trips the invitation fragment.
- **integrator:** deletion protection is reasserted when an existing table is reused.
- **spec-keeper:** the browser parser in `guest.js` now rejects a duplicated or malformed coupon the same way the server does. The remote `list()` result is copied and type-checked before filtering.
- **stylist:** partly done (`COMPARE_AND_SWAP_ATTEMPTS`, `endoCheckout`/`temporaryDaemon`, `runRootControl`/`commandLineArguments`).
- **pruner:** removed the step-by-step test comments.
- **README:** documented `run-busy` and the expired-coupon top-up behavior.
- **scribe:** posted the top-level summary comment, which maps rounds 1–4 to their commits: https://github.com/kriscendobot/minion.town/pull/199#issuecomment-6250666807

**Declined, with reasons given in that comment:**
- **releaser's changeset (must-fix):** minion.town has no changeset or changelog tooling. Activation steps are in `deploy/aws/README.md`. The next panel may raise this again.
- **engine-realist #2 and benchmarker (scan cost, row expiry, per-coupon heap):** deferred, since the feature is off by default and the beta ledger is small. No benchmark was run.
- **Not done:** renaming `ttlMs`/`parseTtl` (it would change the operator command grammar), switching to `@endo/hex` (not a dependency here), and a property test comparing the memory and DynamoDB ledgers (the DynamoDB fake doesn't model conditions).
- **pruner's PR-body trims:** not made.

**Local verification:** `tsc --noEmit` is clean, and 109 tests pass across the coupon, wiring, envelope and config suites. The live-daemon coupon suite is skipped locally, so my issuer changes have not been run against a real daemon yet; it runs in CI. The full `npm test` has one failure, in `test/git-remote/capability.test.ts`, which this PR doesn't touch; I believe it's a known local git-wrapper false-fail.

**CI:** `ci-wait-merge.sh` returned rc 4 (still pending) at the deadline. My first, backgrounded wait was stopped by the harness at about 29 minutes (its log had stopped updating at 14:06); three more foreground waits of 540 s each ran it to about 57 minutes. The checks (`test`, `Claude harness` amd64 and arm64) never left the queue, and the repo showed 5 queued runs and 0 in progress throughout. That matches the known ci.minion.town stall where the runner token hits GitHub's rate limit and recovers on the hourly reset. The driver should re-post this stage.

<!-- gauntlet-stage-result: fix=still-pending -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr199-gauntlet-fix-4.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 100 tokens (6586015 cached reads)
- Output: 45005 tokens
- Cost: $3.494319000000001
- Wall-clock: 3872s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
