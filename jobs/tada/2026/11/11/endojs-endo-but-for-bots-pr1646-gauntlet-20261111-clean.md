The clean stage for endojs/endo-but-for-bots#1646 ("chore(ci): pin .node-version to 24") needed no changes, and CI is green at the current head.

- **What the PR changes:** one line in `.node-version`, from `lts/*` to `24`. It still has `base` `llm-48d6f3e` and head `chore/pin-node-version-24` at `224852cb18ee`, and it is still a draft.
- **Coverage and dead code:** neither applies. The PR touches no package source, so there is nothing to run a coverage pass on and no code it could leave orphaned. I didn't make a project checkout and pushed nothing.
- **CI:** `ci-wait-merge.sh --no-merge` reported "CI GREEN": all 36 checks finished, 26 passed, 10 were skipped and none failed.
- **Follow-ups:** none. The gauntlet moves on to the panel stage.

<!-- gauntlet-stage-result: clean=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1646-gauntlet-20261111-clean.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 6 tokens (127492 cached reads)
- Output: 853 tokens
- Cost: $0.4009824
- Wall-clock: 27s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
