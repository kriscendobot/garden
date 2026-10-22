---
orchestration-failed: true
---
orchestration-failed: true

# PR #774 conduct (endolin): un-drafted and rebased, but not merged — CI is red

PR #774 is not merged. CI failed on the rebased head, so I stopped with `ci red: needs shepherd`. The failures look like a change in GitHub's runner image, not anything in the PR.

**What I did**
1. **Re-checked the PR:** it was OPEN, still DRAFT, and mergeable. kriskowal's APPROVED review still stands: it was not dismissed, and there is no CHANGES_REQUESTED.
2. **Un-drafted it:** `gh pr ready 774` worked from this host, so the bot token here has the PR write access the oros host lacked.
3. **Ran the merge script** (`ci-wait-merge.sh endojs/endo-but-for-bots 774`) from the isolated project worktree:
   - It moved the base from the frozen `llm-863a995` to `llm` and rebased the PR onto `llm` at 54d3d2a682e.
   - It force-pushed the head, which moved from dbd2b003e68 to **ef1ae4f9d76**.
   - The first run exited 4 because GitHub was still reporting the old head. The re-run then watched CI on ef1ae4f9.
4. **Stopped the watch early:** three checks had already failed with final results, so the run could not come out green. Nothing was merged, and the PR is OPEN, ready for review, based on `llm`, with the approval still in place.

**CI failures on ef1ae4f9**
All three look like the runner image changed underneath CI:
- **Browser Tests / `browser-tests`:** `Playwright does not support chromium on ubuntu26.04-x64`. `ubuntu-latest` now points to Ubuntu 26.04.
- **Test project mutual dependency versions / `build`:** `scripts/graph.sh: line 32: tred: command not found` (exit 127). The graphviz `tred` tool is missing from the new image.
- **CI / `sandbox-drivers`:** failed. Its log wasn't available yet because the run was still going.

`llm` passed these same workflows (CI, Browser Tests, mutual-dependency versions) at this same base commit 54d3d2a68 at 01:44Z today. So these failures probably hit every PR, not just #774. The likely fix is to pin `runs-on` to `ubuntu-24.04` or install graphviz, and to pin a Playwright-supported OS.

**Follow-ups (for the triager or maintainer)**
- A shepherd job is needed for #774. The runner-image problem probably needs a separate fix on `llm` for all PRs, and the maintainer should hear about it.
- After that is fixed, re-post a conduct job. The approval stays valid across the rebase.
- The parked Parcel layer-2 plan (`ebfb-parcel-layer2-build-20261022`, which rebases #1391) should stay parked until #774 merges.
- The merge script left the frozen `llm-863a995` branch in place because one other PR is still based on it. There are no dependent stacks on #774.

<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr774-conduct-endolin.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 36 tokens (1011252 cached reads)
- Output: 5006 tokens
- Cost: $0.7787303999999999
- Wall-clock: 2472s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
