Completion receipt generated deterministically for the merged PR.

## What I did

Ran the deterministic receipt generator:
```
scripts/jobs/pr-receipt.sh endojs/endo-but-for-bots 1285
```

It priced the per-engagement rows + maintainer-review heuristic, archived the full receipt to the journal, and posted the identity-pinned PR comment — all idempotently.

## Results

- **Journal archive:** `receipts/endojs-endo-but-for-bots/2026/09/pr1285.md` (committed/pushed to `journal2`; absolute path `/home/kris/garden2/.garden-state/receipts/journal/receipts/endojs-endo-but-for-bots/2026/09/pr1285.md`)
- **Posted comment:** https://github.com/endojs/endo-but-for-bots/pull/1285#issuecomment-5768490660

Both steps reported success (`archived`, `posted completion receipt comment`), script exited 0. The generator's three idempotency guards (archive file, comment marker, basename CAS) mean a re-run is a clean no-op.

## Follow-ups

None. The job is complete.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1285-receipt.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 24 tokens (539078 cached reads)
- Output: 3068 tokens
- Cost: $0.8116819999999999
- Wall-clock: 314s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
