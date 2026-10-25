PR #1546 is now pinned to the frozen base `llm-d5ac419`. No rebase or force-push was needed, and its CI is green.

- **The head was already current:** commit `edf2713ff7`, "fix(ci): pin dependency check to Ubuntu 24.04", sits directly on `d5ac41980a`, which is the live `llm` tip. The frozen branch `llm-d5ac419` already existed on `endojs/endo-but-for-bots` at that same commit.
- **What changed:** I ran `gh pr edit 1546 --base llm-d5ac419`, moving the PR off the floating `llm` base. The head ref was not touched, so nothing was pushed.
- **Checks after the move:** `git diff --stat llm-d5ac419..HEAD` shows only `.github/workflows/depcheck.yml` (+3/−1). GitHub reports the PR as MERGEABLE, and `assert-pinned-base.sh pr endojs/endo-but-for-bots 1546` exits 0.
- **CI on `edf2713ff7`:** all 9 checks that ran passed (lint, check-action-pins, zizmor, and the change-detection jobs). That includes the Ubuntu 24.04 "Build" job from `depcheck.yml`, which is the runner failure this PR fixes. The other 23 checks were skipped by change detection, which is expected for a workflow-only diff. Every workflow run on the head concluded successfully.
- **No conflicts and no dropped commits.** I didn't comment on the PR, since the job didn't authorise it.

The PR is still a draft. Its gauntlet (review, then un-draft) carries on from here; this job adds no new work.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1546-weave.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 16 tokens (440211 cached reads)
- Output: 2449 tokens
- Cost: $0.5639582000000001
- Wall-clock: 85s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
