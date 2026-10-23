I restarted the halted gauntlet for endojs/endo-but-for-bots PR #1538 at its clean stage; the remaining stages will run automatically from here.

**Starting point:**
- The gauntlet halted on 2026-10-22 at the clean stage because CI was red (`orchestration-failed: true`). Two things caused that:
  - The PR's own `provideGitClone` tests hung. Job `pr1538-fix-git-clone-test-hang` fixed that.
  - The ubuntu-26.04 sandbox tests broke on every PR, not just this one. Job `shepherd-endojs-endo-but-for-bots-pr1538-ci-failures` fixed that.
- Because CI was red, the earlier clean attempt pushed nothing and skipped the coverage tests, so the clean stage is still owed.
- I checked GitHub directly: the head is `cdddbb0dedd0a6b12244a9bc0be089329e9bbeb8`, and the PR is open, a draft, MERGEABLE, with no reviews. All 5 workflow runs on that head (CI, IronHorse oracle sanitizers, mutual dependency versions, workflow security audit, OCapN Guile interop) concluded `success`.

**What I did:**
- Ran the restart command `scripts/jobs/gauntlet.sh --resume-from-stage endojs-endo-but-for-bots-pr1538-gauntlet clean`. It exited 0 and logged "accepted resume at clean (iteration 0)" and "restarted at clean".
- Checked the result on `origin/journal2`:
  - `jobs/gauntlet/endojs-endo-but-for-bots-pr1538-gauntlet.md` is active again (`state: running`, `stage: clean`, `current_child: endojs-endo-but-for-bots-pr1538-gauntlet-clean`, `max_iterations: 6`).
  - `jobs/todo/endojs-endo-but-for-bots-pr1538-gauntlet-clean.md` is posted for the fleet to claim.
- I made no garden code changes and pushed nothing to the PR.

**Follow-ups:** None needed. The gauntlet timer runs the rest one stage at a time: clean, then panel and fix rounds, then un-draft. I did not run those stages myself, so they have not happened yet.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1538-gauntlet-restage.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 20 tokens (525089 cached reads)
- Output: 3247 tokens
- Cost: $0.6004778
- Wall-clock: 158s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
