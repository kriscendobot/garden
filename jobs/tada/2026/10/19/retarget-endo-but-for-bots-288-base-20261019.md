I moved the base of https://github.com/endojs/endo-but-for-bots/pull/288 (`feat/cbors-package`) from `llm` to the frozen base `llm-330cf99`.

- **Base branch:** before the edit I checked that `llm-330cf99` exists and points at `330cf996c0b9b3a2cd8a9c007751499286bb8a80`, which matches the job's `330cf996c`. The PR was open and still based on `llm`.
- **Edit:** `gh pr edit 288 -R endojs/endo-but-for-bots --base llm-330cf99` worked under this host's bot identity, with no 403.
- **Check:** `gh pr view 288 --json baseRefName` now reports `llm-330cf99`.
- **Head branch:** not touched. It is still at `3ee08149e7727ee259dd5d6b37ebb63f929b1024`, the commit the shepherd job wove and force-pushed.

No garden or project files changed and nothing was committed. Follow-up: the oros-studio bot PAT still gets a 403 on PR writes to endojs, so the next weave that runs on that host will hit the same wall.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/retarget-endo-but-for-bots-288-base-20261019.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 6 tokens (118004 cached reads)
- Output: 738 tokens
- Cost: $0.3663128
- Wall-clock: 19s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
