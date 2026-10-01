I edited the body of endojs/endo-but-for-bots#1406 as asked. I did not touch the branch.

- **Documentation Considerations:** deleted the sentence "The `pre-push-gates` typist fixer rewrote two pre-existing `…` to `...` in that design."
- **Testing Considerations:**
  - "unit tests pass (80)" now reads "unit tests pass (81)".
  - "refusal when either is missing, altered, or repeated," now reads "refusal when any of `--tools`, `--setting-sources`, `--permission-mode`, or `--permission-prompts` is missing, altered, or repeated (including a trailing `--tools Bash`),".

I fetched the body again after `gh pr edit` and it matches the intended text exactly. The rest of the body is unchanged byte-for-byte, including the `<!-- garden-job: build-endo-claude-pinned-cli-bump -->` marker. There are no garden commits for this job and no follow-ups.

## Panel-head freshness

Disposition: **review required**. The last completed panel reviewed `4a6d91527eacbfc9ff5df3e9307ef32754b19245`; this job presented `68fb89bf1aef248f18025a74650ca31849412670`. The old panel verdict does not cover the current head. No gauntlet was staged; the maintainer received a deduplicated stale-review action.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/pr1406-body-edit-panel1.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 8 tokens (163763 cached reads)
- Output: 1310 tokens
- Cost: $0.3868726
- Wall-clock: 20s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
