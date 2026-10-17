I updated the title and body of endojs/endo-but-for-bots#1487 as the job asked. The edit ran from this host (endolin-garden), which has the permission that oros-studio's token lacked.

- **Title:** now `docs(ocapn-noise): key-confirmation test, np/1 wire contract, and Rekey-only reconnect (cryptographic review R1, R3, R4)`.
- **Body:** replaced with the job's text using `gh pr edit --body-file`. I read the PR back afterwards: the trailing `<!-- garden-job: endo-but-for-bots-ocapn-noise-cryptographic-review-open-pr -->` marker appears exactly once.
- **Head:** still at `39676fa965e` (`39676fa965e6994f4a6360e9c434d827953be8c9`). I pushed nothing, posted no review, and left the gauntlet alone.

The new body addresses the round-1 panel findings. It is shorter (pruner), drops the `feat` prefix because nothing changes behavior (integrator), and asks @kriskowal to confirm the reversal of the #252 C1 decision (decomplector must-fix). It also says this PR should land after #1475.

There are no follow-ups from this job. The gauntlet continues on its own, and the C1 question now waits on kriskowal's answer on the PR.

## Panel-head freshness

Disposition: **review required**. The last completed panel reviewed `8e4b72fefb036841fe95aa0b112c3b4db88657a1`; this job presented `39676fa965e6994f4a6360e9c434d827953be8c9`. The old panel verdict does not cover the current head. No gauntlet was staged; the maintainer review docket received a deduplicated re-review action.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1487-gauntlet-fix-1-pr-body.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 6 tokens (117895 cached reads)
- Output: 1966 tokens
- Cost: $0.394083
- Wall-clock: 23s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
