---
gate: go-ahead
priority: normal
doomed: true
doom_signature: deadline-overrun
doom_count: 1
requeue_cycles: 1
deadline_overruns: 1
doomed_at: 2026-07-28T08:23:35Z
doomed_on: endolin-garden2-5bcdff64
posted_by: reaper:endolin-garden2-5bcdff64
posted_at: 2026-07-28T08:23:35Z
tier: mentor
fallback-tier: minion
dispatch: automatic
---

# Reconcile the two xsnap pending-jobs fixes: adopt #864, close #861

Repo: `endojs/endo-but-for-bots` (base branch `llm`).

Two open draft pull requests implement the SAME fix (replace the process-global
`gHasPendingJobs` latch in `rust/endo/xsnap/xsnap-platform.c` with a check-and-reset
of the machine's own `the->promiseJobs`, and thread the machine pointer through the
three Rust call sites):

- https://github.com/endojs/endo-but-for-bots/pull/861 (`ebfb/rust-endo-xs-test-flakiness`, opened 2026-07-25, +12/-15)
- https://github.com/endojs/endo-but-for-bots/pull/864 (`fix/xsnap-quiesce-per-machine`, opened 2026-07-26, +23/-22)

Maintainer directive (kriskowal, https://github.com/kriscendobot/garden/issues/51#issuecomment-5087337713):
"Choose the better solution or integrate the best aspects of both."

The analysis and the decision were reported at
https://github.com/kriscendobot/garden/issues/51 . The decision: **keep 864**
(it renames the entry point to `fxMachineHasPendingJobs` instead of silently changing
`fxHasPendingJobs`'s arity, its evidence names four rotating victims across a 3-of-5
reproduction plus an `endor run` end-to-end check, and it states the unsynchronized
global as a data race in its own right), and **close 861**.

## Tasks

1. On https://github.com/endojs/endo-but-for-bots/pull/864, graft the one asset 861
   holds: its verification caveat that `cargo test -p xsnap` cannot be run in the
   checkout, because the crate's generated XS bootstrap bundles are absent and the
   daemon bundle generator cannot resolve the branch's Node-only dependencies. Record
   it in 864's description as a known coverage gap over the crate being changed.
2. Update `designs/daemon-rust-xs-performance.md`, whose section "Critical insight:
   fxHasPendingJobs is check-and-reset" (around L127-L147) reproduces the removed
   `gHasPendingJobs` body verbatim and names the removed symbol. It becomes wrong
   under this change.
3. Add a comment on `the->promiseJobs` in `rust/endo/xsnap/xsnap-platform.c` noting
   that the flag now has two consumers within one machine: `fxRunLoop` (which clears
   it in its own drain loop) and the Rust quiesce path via
   `fxMachineHasPendingJobs`. The sharing is believed benign, because the quiesce loop
   calls `fxRunPromiseJobs` before every check so a taken signal has already been
   serviced, but the whole bug class here is one consumer eating another's latch, so
   it should not stay implicit.
4. Close https://github.com/endojs/endo-but-for-bots/pull/861 with a comment pointing
   at 864 and summarizing why 864 was chosen, so 861's reasoning is not orphaned.
5. Run the gauntlet on 864 (clean, panel review, fix loop, un-draft).

Do not close https://github.com/kriscendobot/garden/issues/51; it is a standing
tracker and the submitter closes it.

----- ISSUE NOTE (copy this block VERBATIM into every follow-on job) -----
issue_spine: issue-kriskowal-garden-51
issue_url: https://github.com/kriscendobot/garden/issues/51#issuecomment-5100304929
submitter: kriscendobot
----- END ISSUE NOTE -----

<!-- garden-deadline-overrun: 1 -->
