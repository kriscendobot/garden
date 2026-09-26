Implemented and pushed commit `aff62c8e61` to `main2`.

- Durable findings now form a repair queue.
- Only one repair per standing PR generation is released at a time.
- Successors remain queued until the live predecessor reaches `tada/`.
- Failed posts retry from durable markers without rediscovering crashes.
- Updated design documentation and regression coverage.
- Verification: `ironhorse-fuzz-test.sh` — 32 passed, 0 failed; `git diff --check` passed.
- Follow-ups: none.
- Self-improvement: nothing this time.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/improve-ironhorse-fuzz-serialize-standing-repairs.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s) (1 unmetered)
- Input: 0 tokens (0 cached reads)
- Output: 0 tokens
- Cost: $0 (1 engagement(s) unpriced)
- Wall-clock: 307s

<!-- garden-usage-end -->
