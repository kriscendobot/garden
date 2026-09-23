Assessed byte-array front: #572 fully supersedes bare immutable-ArrayBuffer byteArrays; #475 is the stale view-model prototype, while #503 still overlaps the obsolete model. No active byte-array worker was present.

Next artifact is a fresh draft implementation against `llm`, not retargeting #475: it is 117 commits ahead of its old upstream-reflection base and 2,434 commits behind `llm`. `llm` still throws for CapData and Smallcaps byteArray marshalling. #671 is merged; per instruction, I did not start the registry follow-up.

Evidence: `git ls-remote`, `gh pr view/checks`, and local source inspection. Attempted `yarn workspace @endo/pass-style test && yarn workspace @endo/bytes test`; not verified because the checkout lacks `ses-ava` (`permission denied: ses-ava`). No files changed.

Self-improvement: nothing this time.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endo-byte-array-press-20260729-195004.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s) (1 unmetered)
- Input: 0 tokens (0 cached reads)
- Output: 0 tokens
- Cost: $0 (1 engagement(s) unpriced)
- Wall-clock: 163s

<!-- garden-usage-end -->
