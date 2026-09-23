Implemented and pushed `2157d82dd7` to `main2`.

- Added general `requires:` host-capability gating; `requires: aws` uses the canonical AWS verifier with per-boot local caching.
- Added fresh post-claim recheck and blocked completion reports.
- Added leader-only dwell watcher and maintainer escalation for unclaimable requirements.
- Added design and documentation, including capability/authorization separation.
- Verified with host-requirements, worker-spine, systemd enablement, and checks suites.

Follow-ups: none.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/job-host-requirements-gating.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 2 on 1 host(s) (1 unmetered)
- Input: 0 tokens (0 cached reads)
- Output: 0 tokens
- Cost: $0 (1 engagement(s) unpriced)
- Wall-clock: 477s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
