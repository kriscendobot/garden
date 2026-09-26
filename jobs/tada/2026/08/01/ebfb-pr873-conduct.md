Done. PR #873 verified and merged.

**What I did**
- Verified current PR state: head `51a9d46f0`, OPEN, not draft, `mergeable=MERGEABLE`, `mergeStateStatus=CLEAN`.
- Confirmed the approval matches the exact head: **kriskowal APPROVED 2026-08-01T09:53:51Z on `51a9d46f08ea30375c0671a018964586516297dd`** (= current head). The stale earlier approval on `eacb5723c` was disregarded.
- Confirmed all 26 CI checks pass.
- Head had not moved since 09:53Z, so the approval was still valid — merged with `gh pr merge --merge`.

**What changed**
- PR #873 merged into `llm` as merge commit `3ec55851d12d13b6d6619507fcdbb6946ba08003` at 2026-08-01T09:58:24Z (by kriscendobot).
- Posted a provenance comment (#issuecomment-5150928300) recording head, approval, CI, and the note that the earlier `lint` failure was a pre-existing `no-redeclare` error already fixed on `llm` (`25de6e28d`), not in this PR's diff.

**Follow-ups**
- None. This was bot-repo work, not a ferry; no identity switch involved.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/ebfb-pr873-conduct.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 15 tokens (293609 cached reads)
- Output: 2587 tokens
- Cost: $0.4837885
- Wall-clock: 54s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
