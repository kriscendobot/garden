I rebased PR #1357 onto a snapshot of current `llm` and CI is green on the new head. The PR is now mergeable and the merge state is `CLEAN`; kriskowal's approval still shows.

**What changed:**
- **Base:** `llm`'s tip was `825c598bc6`, and a frozen branch `llm-825c598` already existed at exactly that commit. I used it as the new base rather than creating another.
- **Rebase:** all 10 PR commits were replayed onto `llm-825c598`. Head moved from `3a9c6be603` to `09caec7200`, pushed with `--force-with-lease` against the old head. The PR's base field now points to `llm-825c598`. No commits were dropped or emptied.
- **Conflicts:** only `designs/README.md` conflicted, on three commits (`17ea5d465c`, `7a6d4259cf`, `d53fa42dff`). In each case I kept `llm`'s newer roadmap content, including its updated statuses (for example `endo-claude` is now "In Progress" there). I then applied only the PR's own edits on top: the `endo-claude-inference-backends` index row, its node and edge in the diagram, its milestone row and its estimate row.
- **Design unchanged:** `designs/endo-claude-inference-backends.md` is byte-identical to the pre-weave head. Against the new base, the PR is still just 2 files and 1016 insertions, the same as before the rebase.

**CI:** "Detect CI changes", `lint` and `zizmor` passed, nothing failed, and the remaining jobs were skipped because the PR only touches docs.

I didn't post a PR comment, since the job didn't authorize commenting. The PR is ready for the stalled conduct (`endojs-endo-but-for-bots-pr1357-conduct-20260930`) to be resumed or re-posted so it can merge.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1357-weave-20261001.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 32 tokens (1036804 cached reads)
- Output: 5205 tokens
- Cost: $0.8540368
- Wall-clock: 909s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
