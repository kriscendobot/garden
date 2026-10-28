**PR #1566 viability: overtaken.** I recommend closing it as superseded.

The PR is open, unmerged and a draft. Its head is `2696934af6`, on the frozen base `llm-204ecd1`, which is 4 commits behind `llm`. All its CI checks are green.

**Deciding question:** Without this PR, do the three Ubuntu 26.04 CI failures it was written to fix (`depcheck` failing because `tred` and `acyclic` are missing, the nproc test failing under dash, and the parent-death test recording no assertion) still happen on current `llm`?

**Evidence:** No. Two commits on `llm` dated 2026-10-28 already fix all three, in different ways:
- **`depcheck`:** `fc2b4719a3` pins the job to `runs-on: ubuntu-24.04`, with the comment "Ubuntu 26.04 Graphviz omits tred, which the cycle checker requires." So `tred` and `acyclic` are present again. That replaces this PR's step that installs `graphviz-tools`, and makes its switch from `acyclic` to `tsort` in `scripts/graph.sh` unnecessary.
- **nproc test:** `27705a4cdf` ("test(sandbox): fix Linux resource limit and cleanup assertions") runs `/bin/bash -c 'ulimit -u'`, which avoids the dash problem. This PR reads `/proc/self/limits` instead, which is a different fix for the same failure.
- **Parent-death test:** the same commit `27705a4cdf` adds the AVA-recorded `t.notThrowsAsync` cleanup assertion. The weave comment from 2026-10-28 already says this PR now keeps the base's version of that change.
- **Leftover changes:** what is still unique to this PR came in while CI was being fixed:
  - `waitForProcessGroupGone` raised from 3s to 10s, plus a `describeProcessGroup` diagnostic, to stop a timing flake in a different test (`bwrap timeout and repeated cancellation reap process groups`). `llm` still uses 3000ms.
  - A cherry-pick of the floot offline-test fix, which belongs to the still-open #1567.

  Neither of these was the PR's reason for existing.

Option: close as superseded

If the maintainer still wants the leftovers: the bwrap cleanup-bound flake fix could be saved as a small separate test-only PR, and the floot fix lands through #1567. I spent nothing on the clean, panel, fix, CI-wait or un-draft stages, and wrote no journal or garden changes.

<!-- gauntlet-stage-result: viability=overtaken -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1566-gauntlet-2696934-viability.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 12 tokens (304650 cached reads)
- Output: 3247 tokens
- Cost: $0.5347899999999999
- Wall-clock: 49s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
