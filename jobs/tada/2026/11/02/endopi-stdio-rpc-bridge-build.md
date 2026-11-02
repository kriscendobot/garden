I didn't open a new draft PR, because this design is already implemented in the open PR #667 and a second one would duplicate it. I changed no code. The only change is a fix to the stale plan record that caused this job to be re-issued.

**State of #667**
- **Implementation:** the bridge is in `packages/agentry/src/rpc/`, exported as `@endo/agentry/rpc`, and handles all six design commands. The PR is open, not a draft, and GitHub reports it mergeable.
- **Review:** kriskowal's 2026-07-13 changes-requested review still stands. It asked to move the code into agentry or agent-tools, which has been done, and a re-review was requested on 2026-10-30.
- **Gauntlet:** it halted on 2026-11-02 after 3 rounds, on the fix-3 stage, because CI is red.
- **CI:**
    - `test-xs` still fails after a rerun, on the `@endo/hardened262` baseline for `sesNode/module test/intrinsics/ThrowTypeError/intrinsic-metadata.js`.
    - The rerun job's evidence suggests the PR isn't the cause: the changes since the last green run only touch `packages/agentry/**` and `.gitignore`, and the task's turbo hash is unchanged. It isn't proven, and I didn't investigate it myself.
    - That job timed out with the macOS rerun still queued, so its result was unknown then. The Electron download failure on that leg looked like a network problem.

**What I changed**
- I updated the plan record `plan/designs/endo-but-for-bots/endopi-stdio-rpc-bridge.md` on `journal2`: status from `Proposed` to `In Progress`, added `pr: endo-but-for-bots#667`, and updated the date.
- This is the second re-issue. `build-endopi-stdio-rpc-bridge` hit the same duplicate on 2026-10-30 but left the record saying `Proposed`. The new status should stop the foreman re-issuing it, but I didn't confirm how the foreman uses these records.

**Needs the maintainer**
1. **`test-xs`:** someone needs to investigate the failure. Once it's green, resume the gauntlet from `panel --iteration 4`, as the rerun job's report says. The maintainer has already been messaged about this failure.
2. **Re-review:** #667 still needs kriskowal's re-review and a fresh approval before it can merge.
3. **Scope gaps in #667:**
    - **No launcher:** the design's `endo agent rpc` command doesn't exist, and nothing ships a process that can be spawned, because `packages/genie/rpc.js` went away when genie was retired.
    - **No multiplexing:** phase 5 is also deferred.
    - **Plan record:** it will flip to `Complete` automatically when #667 merges, even though the launcher is still missing. If the launcher is wanted, post a follow-up build for `packages/cli` stacked on #667. I didn't post one because nobody has asked for it and #667 is still unapproved.

The project checkout created for this job, `scratch/project-wt-endopi--a7875d691a06-f4d57e5d`, is unmodified and can be swept.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endopi-stdio-rpc-bridge-build.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 30 tokens (980624 cached reads)
- Output: 9745 tokens
- Cost: $1.0582328
- Wall-clock: 1041s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
