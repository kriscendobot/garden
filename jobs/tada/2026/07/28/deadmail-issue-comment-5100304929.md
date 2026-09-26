# Completion report — `deadmail-issue-comment-5100304929`

## What the job actually was

A dead-lettered notification for `issue-kriskowal-garden-51`. The maintainer's 2026-07-28 comment on https://github.com/kriscendobot/garden/issues/51 asked for a report on their *previous* comment (2026-07-27, https://github.com/kriscendobot/garden/issues/51#issuecomment-5087337713): *"Choose the better solution or integrate the best aspects of both"*, referring to the two competing xsnap pending-jobs pull requests flagged in the 07-27 daily status.

## What I found

**The 07-27 directive was never executed.** It routed to the daily-status doer, which had already exited, so it dead-lettered without a promotion of its own. I confirmed no job anywhere on the board or in the journal ever picked it up: a `grep` for `5087337713` across `jobs/` and `msgs/` hits only this job's own body. Both pull requests are still open drafts on their 2026-07-26 heads, merge state CLEAN, unmoved.

**The two pull requests are the same fix, not a design fork.** https://github.com/endojs/endo-but-for-bots/pull/861 and https://github.com/endojs/endo-but-for-bots/pull/864 both delete the process-global `gHasPendingJobs` latch in `rust/endo/xsnap/xsnap-platform.c`, replace it with a check-and-reset of `the->promiseJobs`, and thread the machine pointer through the same three Rust call sites. Same three files; the C bodies are equivalent line for line. The size delta (`+12/-15` vs `+23/-22`) is comments plus one identifier rename.

**Decision: keep 864, close 861.** Grounds: it renames the entry point to `fxMachineHasPendingJobs` rather than silently changing `fxHasPendingJobs`'s arity (which would let a future C declaration link a zero-arg call against a one-arg definition); its evidence is a 3-of-5 reproduction with four rotating named victims plus an `endor run` end-to-end check, which is what establishes a cross-machine steal rather than a generic flake; and it names the unsynchronized global as a data race in its own right. 861's one distinct asset is a verification caveat (`cargo test -p xsnap` unrunnable in-checkout, generated XS bootstrap bundles absent) that should be carried onto 864 rather than closed away.

**Two residuals neither pull request covers**, both found by inspection rather than claimed from the descriptions:
- `designs/daemon-rust-xs-performance.md` L127-L147 reproduces the removed `gHasPendingJobs` body verbatim and names the removed symbol. Wrong under either fix.
- Both fixes point the Rust latch at `the->promiseJobs`, which `fxRunLoop` also clears (`xsnap-platform.c` L214-L217). Two consumers of one flag within a machine now. Looks benign (quiesce calls `fxRunPromiseJobs` before every check, so a taken signal was already serviced) and is strictly narrower than the cross-machine steal it replaces, but the whole bug class here is one consumer eating another's latch, so it warrants a comment rather than staying implicit.

## What changed

- Posted the report as an issue comment: https://github.com/kriscendobot/garden/issues/51#issuecomment-5101133951. Did not close the issue.
- Posted the execution job `ebfb-reconcile-xsnap-pending-jobs-861-864` (identity `endojs/endo-but-for-bots:reconcile:861-864`) to carry out the decision: graft 861's caveat onto 864, fix the design doc, add the shared-flag comment, close 861 with a pointer, run the gauntlet on 864.
- No garden repository changes; nothing to push to `main2`.

## Follow-ups

- The reconciliation job is queued but unclaimed as of this report. The technical work on the two pull requests has not been done, only decided and specified.
- The delivery gap is the more general finding: a direct maintainer instruction on this issue sat undelivered for roughly 25 hours because its addressee had exited, and only surfaced via dead-letter promotion. The mechanism recovered it, but the latency on a direct instruction is worth tightening. I flagged this to the maintainer in the comment; I did not attempt a fix, as it is outside this job's scope.
