I parked this job instead of driving endojs/endo-but-for-bots#1594 to green, because neither base fix it waits on has landed yet.

**What I checked** (2026-11-15, about 18:17Z):
- endojs/endo-but-for-bots#1646 (`chore(ci): pin .node-version to 24`), the `test-xs` / Node 26 baseline fix: still OPEN and not merged, on base `llm-48d6f3e`, head `224852cb`.
- endojs/endo-but-for-bots#1659 (`ci: correct peter-evans/create-pull-request pin comment to v8.1.1`), the `zizmor` fix: still OPEN and not merged, on base `llm-48d6f3e`, head `7c100929`.
- endojs/endo-but-for-bots#1594 itself is still draft on frozen base `llm-48d6f3e`, head `d43ee2e4`.

**What I did:**
- Ran `block-job.sh shepherd-endojs-endo-but-for-bots-pr1594-ci-followup-20261115 https://github.com/endojs/endo-but-for-bots/pull/1646`, which parks the job behind #1646, the first PR still open. The blocking message reached the maintainer inbox as `20261115T181856Z-16ebd3`. The first attempt was rejected because the message used short `#N` references; I rewrote them as `owner/repo#N` and the retry went through.
- The body of the parked job is the original spec plus a note: when it resumes, re-check endojs/endo-but-for-bots#1659 and park again behind it if it is still open.
- I didn't change #1594 and didn't copy either fix into it. No CI was rerun.

**Follow-up:** once #1646 merges or closes, the unblock watcher puts this job back on the board. The next claimant then gates on #1659, waits for CI to run on the updated base, and drives #1594 to green.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/shepherd-endojs-endo-but-for-bots-pr1594-ci-followup-20261115.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 10 tokens (241633 cached reads)
- Output: 2065 tokens
- Cost: $0.4818106
- Wall-clock: 134s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
