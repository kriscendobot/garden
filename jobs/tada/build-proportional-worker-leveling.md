Implemented proportional worker leveling.

- Monk ceilings now use bounded fleet-wide apportionment; 143M:64M yields 4:2.
- Added separate demand/eligibility-based cleric allocation, active-claim grandfathering, sparse-unit shrink protection, and independent dwell records.
- Preserved drain, provenance, missing-signal, confirmation, and step-clamp safeguards.
- Added validated journal-backed configuration and setter; activated fleet ceilings of 6 monks and 5 clerics with per-host physical caps of 4.
- Added focused regression coverage and updated existing admission tests.
- Verification: focused tests 4/4, live-budget tests 29/29, full suite 383/383.
- Pushed commits `d563d96499` and `1110195c4f` to `main2`; journal configuration landed at `a545583099`.
- Follow-up: routine garden deployment will activate the new controller.
- Self-improvement: nothing this time.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/build-proportional-worker-leveling.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s) (1 unmetered)
- Input: 0 tokens (0 cached reads)
- Output: 0 tokens
- Cost: $0 (1 engagement(s) unpriced)
- Wall-clock: 1280s

<!-- garden-usage-end -->
