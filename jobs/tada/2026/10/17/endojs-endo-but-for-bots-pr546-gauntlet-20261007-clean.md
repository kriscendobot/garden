Clean stage: endojs/endo-but-for-bots PR #546 (`feat: support .ts runtime modules via erasable type syntax`). Nothing was changed; this stage was a no-op.

- **State:** the PR is open, not a draft, and GitHub reports it as mergeable. Base is `master-5be15cb` and head is `mirror/endo-3137-build-ts` at commit `2f2c0a3bf5`.
- **CI:** all 16 checks passed at the current head, including the `cover` coverage check. I read this from the PR's check list and did not run `ci-wait-merge.sh`, since every check was already finished.
- **Why I made no changes:** this PR is a mirror of upstream endojs/endo#3137, and its body says the head carries that PR's commits verbatim. Pushing coverage tests or dead-code removal here would break that match with upstream. Coverage work belongs on the upstream PR or in a separate follow-up.
- **Follow-ups:** none.

<!-- gauntlet-stage-result: clean=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr546-gauntlet-20261007-clean.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 8 tokens (176606 cached reads)
- Output: 1354 tokens
- Cost: $0.4187932000000001
- Wall-clock: 26s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
