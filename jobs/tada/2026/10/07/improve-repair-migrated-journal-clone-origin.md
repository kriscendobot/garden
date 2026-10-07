Implemented and pushed commit `27b560aeb4c` to `main2`.

- Existing journal clones now rewrite only recognized migration-alias origins to the canonical repository before preflight, fetch, or push.
- Explicit local and non-production remotes remain unchanged.
- Added regression coverage proving an alias-origin clone repairs, fetches, and pushes successfully.
- Targeted regression suite: 12/12 passed.
- Broader harness exposed unrelated existing failures in scaler logging, plan-queue rendering, and reference-clone expectations; no follow-up is required for this change.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/improve-repair-migrated-journal-clone-origin.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s) (1 unmetered)
- Input: 0 tokens (0 cached reads)
- Output: 0 tokens
- Cost: $0 (1 engagement(s) unpriced)
- Wall-clock: 554s

<!-- garden-usage-end -->
