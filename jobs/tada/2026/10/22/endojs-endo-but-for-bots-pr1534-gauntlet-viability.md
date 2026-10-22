**Viability verdict: proceed.** PR #1534 is open, unmerged and still a draft. Nothing newer has replaced it, and the coverage gap it fills is still there on the base. I spent no clean, panel, fix, CI-wait or un-draft budget.

**Deciding question:** Does the current base, or any other open or merged PR, already run the endo crate's `cas_archive::` and `run_input::` unit tests in CI?

**Evidence:** No.
- **PR state:** It was opened 2026-10-22 from the #1531 gauntlet's clean stage, with head `a2157494c7f` against base `llm-54d3d2a`. It has no reviews or comments yet.
- **Base is current:** `llm-54d3d2a` is the current `llm` tip (compare shows 0 commits ahead).
- **The gap still holds:** In `.github/workflows/ci.yml` at `llm`, the `build-xsnap` job's only `--lib` run is still limited to `ironhorse_engine::`. Its comment explains why: a bare `--lib` run segfaults in the `inproc` tests. No step runs `cas_archive::` or `run_input::`.
- **Targets exist:** `rust/endo/src/cas_archive.rs` and `rust/endo/src/run_input.rs` are both on `llm`, so the new filter selects real tests.
- **Not overtaken:** #1531, the source PR, is still open and unmerged (the PR body says the step was reverted there before this PR was opened). A search of all PRs for `cas_archive run_input` returns only #1534 and #1521. #1521 is open and does not touch `ci.yml`. No newer change adds the step.
- **Fits the base's own reasoning:** These two modules drive no xsnap machine, so adding them doesn't run into the `txJump`/`c_setjmp` segfault that keeps the filter narrow.

<!-- gauntlet-stage-result: viability=proceed -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1534-gauntlet-viability.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 12 tokens (256007 cached reads)
- Output: 2057 tokens
- Cost: $0.3978694000000001
- Wall-clock: 42s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
