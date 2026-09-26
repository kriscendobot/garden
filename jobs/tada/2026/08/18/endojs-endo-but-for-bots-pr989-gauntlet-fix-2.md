CI is green (rc 0). The fix is pushed and CI passed.

## Completion report

**Job:** FIX round 2 of the endojs/endo-but-for-bots PR #989 gauntlet (design PR: `designs/worker-quiescence-embargo.md`).

**What I did:** Applied the panel round-2 must-fix items (and the clear request-changes-driving should-fix/prose findings) across all seven seats, in one review-feedback commit pushed to the PR head. Grounded the flag fixes in the maintainer's *actual* review words (fetched from the PR: "It would be good for this option to **exist** in all captp variants…"), which the design had overstated.

**Changes to `designs/worker-quiescence-embargo.md`:**
- **The flag (critic/skeptic/decomplector/ergonomist/novice).** Renamed `quiescenceEmbargo` → `bufferOutboundUntilQuiescence` (names only what it gates). Replaced the false "one uniform value from one place / `capTpOptions`" claim with the maintainer's real request: the option must *exist* per-variant, each spelled in its own config surface (a dedicated pump parameter on the JS side following the `capTpConnectionRegistrar` precedent, not `capTpOptions`; a `{"quiescence_embargo": bool}` field on the Rust `meter-config` control envelope), all derived from one per-worker spawn value. Stated the default (**on**) and that "off" forfeits **both** byte-parity and pre-flush failure-atomicity; dropped the "latency tradeoff rather than a correctness requirement" framing. Kept crank exclusivity unconditional and noted it is separable from outbound buffering.
- **Failure-atomicity (skeptic/decomplector).** Scoped the claim to a *pre-flush* abort (a mid-flush crash needs a durable checkpoint this design does not adopt); Node uses an explicit per-crank **abort flag**, not stack unwinding, since the flush is a later `setImmediate` turn.
- **Purity invariant / timers (critic/decomplector/skeptic).** Stated conditionally (timer-free workers), naming wall-clock as a third input otherwise; a between-cranks due-now timer opens its own crank.
- **Definitions (novice).** Added **envelope**/**frame**, standardized "message," and named the three outbound classes once. Made step 3 name `setImmediate`; stated the sync reply is exempt (critic); added liveness and option-off test items and a deterministic-scheduler repro (skeptic).
- **Citation/prose (copyeditor/pedant).** `PR #N` form throughout, exact metering cross-ref heading, `Kris Kowal` author + `Updated` row + linked Source, title-case headings, single `Decision N` spelling, mermaid `N+1` fix, `PR #124` recorded as a blocking dependency, and **no em-dashes / no unicode ellipsis** (re-checked).

**Result:** Pushed `ad5ea849c5..74f9795be6` to `design/worker-quiescence-embargo` via `safe-push-pr-head.sh`. CI watched to terminal: **GREEN** (5/5 checks, 0 failed).

Per the stage contract, I did not re-run the panel; the driver re-posts panel-3.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr989-gauntlet-fix-2.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 59 tokens (2461943 cached reads)
- Output: 30771 tokens
- Cost: $2.9150595
- Wall-clock: 862s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
