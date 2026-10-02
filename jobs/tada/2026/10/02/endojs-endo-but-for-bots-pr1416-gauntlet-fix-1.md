Fix round 1 for PR #1416 is pushed and CI is green: all 30 checks passed and `ci-wait-merge` returned rc 0.

**Must-fix items from the panel's round-1 review, all in `designs/guest-native-invitations.md`:**
- **Copyeditor:** the sentence fragment at line 594 now reads "On a cold cache, which is the post-restart path section 7 requires, `provideController` reaches…".
- **Orthographer:** changed British spellings to American. `cancelled` → `canceled` at lines 217 and 918, `judgement` → `judgment` at 236, `Cancelling` → `Canceling` at 516. The fourth finding was cut off when I read the review, so I applied a file-wide sed for those three words rather than finding by finding. Line 918 was changed by that sweep; I don't know whether it was the orthographer's fourth item.
- The critic and skeptic seats approved with comment-only findings, so I changed nothing for them.

**What changed:** one review-feedback follow-up commit, `2f8506cd85`, pushed with `safe-push-pr-head.sh`. The PR head `design/guest-native-invitations-editorial` moved from `6306845e2c` to `2f8506cd85`.

**Follow-ups:** none. The driver re-posts panel-2.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1416-gauntlet-fix-1.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 14 tokens (340788 cached reads)
- Output: 2000 tokens
- Cost: $0.4739736
- Wall-clock: 48s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
