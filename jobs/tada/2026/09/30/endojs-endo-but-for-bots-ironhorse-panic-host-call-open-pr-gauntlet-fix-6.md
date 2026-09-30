Fix round 6 on endojs/endo-but-for-bots#1379 is pushed and CI is green, but one must-fix is still open: the integrator's block waits on a maintainer review of #1370. No code change can clear it.

The fix is commit `8999df6f19` on `llm-ironhorse-panic-host-call`, pushed with `safe-push-pr-head.sh` on top of `4cffd6fea4`.

**Must-fix items applied:**
- **assessor:** once a crank has refused a barrier's reply, every later non-pure call in that crank is refused with a new error, `HostCallError::MustAbort(crank)`, before the adapter runs. The refused barrier now also counts toward the per-crank call bound (the should-fix).
- **locksmith / wire-watcher:** the SQLite authorizer that confines transactional writes now denies anything it doesn't explicitly allow. `REINDEX`, virtual tables and unknown actions are now denied. It allows plain reads, built-in functions, views, and table reads and writes that don't touch the transcript's own tables.
- **prover:** the authorizer test now checks each statement's denial inside the write, across 10 statements. I confirmed it fails when only the authorizer is replaced by one that allows everything. A separate new test checks that a denied write fails the commit.

**Other items applied:**
- **breaker:** each recorded escape now counts toward the crank's call bound. Once a crank has an escape, its pure calls are bounded too. New test: `misclassified_escapes_per_crank_are_bounded`.
- **purist:** the `host_call.class` values now all come from `HostClass::tag()`, and the column has a `CHECK` constraint.
- **wire-watcher:** added a test that an uppercase-hex blob name is rejected.
- **pruner:** removed the feature tour and test list from the PR body, and cut the crate manifest comment to two lines.
- **scribe:** posted a round summary on the PR that gives the test and CI results and the loop status.

**Declined, with reasons in the PR comment:**
- **breaker (should not start a crank while recovery is stopped):** recovering a lost handle has to happen inside a crank, so blocking crank start would make that recovery impossible.
- **packager (split the rename changes out of earlier commits):** that would rewrite history that has already been reviewed.
- **integrator (phase evidence):** the PR's acceptance rests on answers to open design questions Q3, Q6 and Q7, proposed in #1370. That PR is still a draft with no maintainer review, so panel round 7 will probably flag this again.

**Verification:** locally, all 63 crate tests pass and `cargo clippy --all-targets` and `cargo fmt --check` are clean. `ci-wait-merge` returned rc 0, with 35 of 35 checks green on `8999df6f19`.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-ironhorse-panic-host-call-open-pr-gauntlet-fix-6.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 58 tokens (2659131 cached reads)
- Output: 20538 tokens
- Cost: $1.8024822000000003
- Wall-clock: 2507s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
