Implemented and pushed commit d6f456acc3 to main2.

- Reserved runner rc=2 for shared checkout/toolchain failures; target-specific failures now return rc=1.
- Stops target fan-out after the first shared failure, emits one warning, and persists a 15-minute retry cooldown capped at one hour.
- Active cooldown ticks skip all runners without repeating the warning; expired cooldowns retry once.
- Added regression coverage for fan-out suppression, warning deduplication, cooldown persistence/expiry/bounds, and exit-code classification.
- Verification: `ironhorse-fuzz-test.sh` passed 39/39; integration rehearsal passed; Bash syntax and `git diff --check` passed.
- Follow-ups: none.
- Self-improvement: nothing this time.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/improve-ironhorse-fuzz-shared-runner-backoff.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s) (1 unmetered)
- Input: 0 tokens (0 cached reads)
- Output: 0 tokens
- Cost: $0 (1 engagement(s) unpriced)
- Wall-clock: 284s

<!-- garden-usage-end -->
