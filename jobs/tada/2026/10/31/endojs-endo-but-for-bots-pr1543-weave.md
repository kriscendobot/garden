I wove PR #1543 onto the current `llm` tip. It's now based on `llm-9a14ddf` and GitHub reports it as mergeable.

- **Rebase:** I moved the 8 commits from the old frozen base `llm-d5ac419` onto the current `llm` tip `9a14ddf`, which is 31 commits newer. It applied with no conflicts and no commits were dropped. A commit-by-commit comparison shows all 8 commits unchanged. None of the 31 new `llm` commits touch the 5 design files this PR changes.
- **Diff check:** the diff against the new base is still only the PR's 5 files under `designs/`. The script that checks the PR targets a pinned base, not a moving branch, passed.
- **Refs:**
  - The frozen base branch `llm-9a14ddf` already existed at exactly `9a14ddf`, so pushing it changed nothing.
  - I force-pushed the head branch `design/claude-api-key-agents` from `069b429c16` to `2866a26dbf`, guarded against overwriting anyone else's push.
  - I moved the PR's base from `llm-d5ac419` to `llm-9a14ddf`.
- **Tests:** none run. The PR only changes design docs and their content is identical after the rebase.
- **Not done:** I left no summary comment on the PR because the job didn't authorize commenting. The old `llm-d5ac419` branch stays until the PR closes.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1543-weave.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 14 tokens (379924 cached reads)
- Output: 2520 tokens
- Cost: $0.5489607999999999
- Wall-clock: 66s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
