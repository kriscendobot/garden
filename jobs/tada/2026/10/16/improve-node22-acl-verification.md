Implemented and pushed commit `50ab9a5` to `fix/node-install-root-ownership` for kriscendobot/minion.town#192.

- Node deployments now provision ACL tooling before verification.
- Node installation fails closed if `getfacl` or `setfacl` is unavailable or ACL inspection fails.
- Added missing-tool and inspection-failure coverage.
- Verification: targeted Node installer tests passed (30 passed, 1 skipped); typecheck passed.
- Full suite: 1,132 passed, 12 skipped; 21 unrelated PATH-stub tests failed on this host. GitHub CI remained queued after bounded polling.
- Self-improvement: nothing this time.

## Panel-head freshness

Disposition: **review required**. The last completed panel reviewed `e27801be2599bfd68f83f2bc0bd387c6bbc933e4`; this job presented `50ab9a57c36235f21f80c53bb5833832e05b1328`. The old panel verdict does not cover the current head. No gauntlet was staged; the maintainer review docket received a deduplicated re-review action.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/improve-node22-acl-verification.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s) (1 unmetered)
- Input: 0 tokens (0 cached reads)
- Output: 0 tokens
- Cost: $0 (1 engagement(s) unpriced)
- Wall-clock: 866s

<!-- garden-usage-end -->
