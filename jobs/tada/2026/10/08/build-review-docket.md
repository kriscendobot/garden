Implemented and pushed commit `eccba52c692` to `main2`.

- Added deterministic review-docket intake, retirement, reconciliation, priority generation, dated archives, and concurrency-safe journal CAS.
- Switched all current review-request producers; added proxy exemptions, foreman integration, native GitHub request polling, and leader-only systemd units.
- Added operator documentation and comprehensive regression tests.
- Verified core docket, producer, watcher, accountant, systemd, gauntlet, and concurrency tests. Modified bulletin checks pass; the umbrella suite retains unrelated pre-existing scaler/plan-queue failures.
- Left maintainer inbox contents untouched. Child 3 must migrate legacy requests/documents and send the stable `PRIORITIES.md` URL.
- Applied `skills/self-improvement/SKILL.md` and `skills/library-lookup/SKILL.md`; added a durable stale-panel/auto-gauntlet regression guard.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/build-review-docket.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s) (1 unmetered)
- Input: 0 tokens (0 cached reads)
- Output: 0 tokens
- Cost: $0 (1 engagement(s) unpriced)
- Wall-clock: 2914s

<!-- garden-usage-end -->
