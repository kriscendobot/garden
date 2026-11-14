The failing `sandbox-drivers` check was a flake, not caused by this PR. After one rerun, CI on PR #1590 is fully green: 26 checks pass and 10 are skipped, with no failures, on head `9f0a7a65c0a2eddeebd1fa7bd1791f5f61bc562f`.

**What failed:** The original run (run 41195268283, 2026-10-31) runs the sandbox-driver suite four times in a row. Three of those passes were clean. One failed in the bwrap test "timeout and repeated cancellation reap process groups" with `Error: process group 7484 survived bounded cleanup`, which is a timing problem on the runner.

**Why it's not this PR:** The PR changes only `packages/cli`, `packages/daemon`, the designs, the changesets and `yarn.lock`. It does not touch the sandbox drivers or their tests. The bwrap tests have unrelated runner-portability problems that open PR #1566 is meant to fix.

**What I did:** I reran only the failed job (`gh run rerun --failed`), and run attempt 2 completed with success. I pushed no code and left no PR comments, since the job didn't authorize commenting.

**Next:** none. The halted gauntlet for #1590 can resume. If this bwrap test keeps failing on PRs, the place to fix it is PR #1566, not the PRs where it shows up.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/shepherd-endojs-endo-but-for-bots-pr1590.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 22 tokens (669262 cached reads)
- Output: 3295 tokens
- Cost: $0.6718563999999999
- Wall-clock: 668s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
