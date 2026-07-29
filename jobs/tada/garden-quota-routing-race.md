Landed `main2` commit `3e5959f9d45b60c02bc3c5d8094ba335dbdc16cb`.

- Endolin `market: bid` work now races via journal CAS; ps23 retains auction behavior.
- Provider/capability gates remain unchanged.
- `gardeners: 0` requires the active quota route plus a configured, probe-qualified non-Claude pool.
- Added rollback and operational documentation plus regression coverage.

Verified: auction tests 63/0, scaler tests 15/0, full suite 368/0.

Fleet deployment: deploy this `main2` SHA on all hosts. On endolin, configure/probe a non-Claude pool first, then set `gardeners: 0`; ps23 needs no routing change. Roll back by restore `gardeners` >0 and set `GARDEN_QUOTA_ROUTING=auction` in endolin gardener-unit environment before restarting that pool.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/garden-quota-routing-race.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s) (1 unmetered)
- Input: 0 tokens (0 cached reads)
- Output: 0 tokens
- Cost: $0 (1 engagement(s) unpriced)
- Wall-clock: 861s

<!-- garden-usage-end -->
