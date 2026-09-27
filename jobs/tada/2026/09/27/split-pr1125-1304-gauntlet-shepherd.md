I've closed out this job: PR #1304 is merged, but not through a clean gauntlet. The gauntlet halted after its sixth review round, and kriskowal (the maintainer) then took the PR out of draft and merged it with CI green.

**What I did**
- **Base branch:** `llm-387ea66` is the bottom of the stack, so no rebase was needed.
- **Gauntlet:** I started `endojs-endo-but-for-bots-pr1304-gauntlet` on 2026-09-17 at 21:59Z. The job spec gives the path as `scripts/jobs/gardening/post-gauntlet.sh`, but the script actually lives at `scripts/jobs/post-gauntlet.sh`. This host is the leader, so its timer drove the stages; I watched them across several requeues of this job.
- **This session:** the gauntlet record had already finished, so I rebuilt the outcome from the journal history and the PR itself.

**Outcome**
- **Rounds:**
  - The viability and clean stages passed. The clean stage added a unit test for the read-only recognizer (commit `672ed33721`), with CI green at that head.
  - Then came six review panels (panel-1 … panel-6) with five fix rounds between them (fix-1 … fix-5).
  - Panels 1 through 5 each returned a real **must-fix** verdict, not a tooling failure. Fix-2, fix-3 and fix-5 each needed at least one retry.
- **Must-fix never cleared.** Panel-6 was the last round the gauntlet allows (6 of 6). That stage job was reaped and parked as "requeue-exhausted", and it wasn't retried because the failure cause wasn't known to be transient. The gauntlet stopped with state `halted` at 2026-09-18 11:05Z. A clean panel verdict was never reached.
- **Final CI:** all checks pass or are skipped, with no failures, at the final head `4d2aaa8e40`.
- **Draft status and merge:** kriskowal took the PR out of draft and **merged it on 2026-09-18 at 21:05Z**, overriding the halted gauntlet. The work has landed on the base.

**What changed:** nothing on `main2` and no commits from me to the project. My only write was the gauntlet record on the journal.

**Follow-ups**
- #1304 was slice 1 of the #1125 stack (#1304 → #1306 → #1305). Since it has merged, the next slice, #1306, can proceed; the orchestration `split-pr1125-stack-gauntlets` should move to it.
- The gauntlet's own terminal state is **halted**, not clean. Anything that checks that state instead of the merge will see a failure. It would help if the gauntlet driver noticed when a maintainer merges a PR mid-gauntlet and closed it out as superseded rather than halted.
- Five retro jobs (`endojs-endo-but-for-bots-pr1304-*-retro`) are parked in `plan/`. Their review-round lessons (five must-fix rounds that never converged) are worth promoting.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/split-pr1125-1304-gauntlet-shepherd.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 7 on 2 host(s)
- Input: 126 tokens (3487247 cached reads)
- Output: 26188 tokens
- Cost: $5.8652426
- Wall-clock: 496s
- Model(s): claude-opus-4-8 ×6, claude-opus-5-5 ×1

<!-- garden-usage-end -->
