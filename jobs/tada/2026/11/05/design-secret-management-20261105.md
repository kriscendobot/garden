Completed `design-secret-management-20261105`.

- Added `designs/secret-management.md` with concrete storage, placement, wrappers, ledgering, fleet capability, migration, rotation, threat model, and verification requirements.
- Surveyed current value-free fleet credential posture and host differences.
- Marked `designs/host-key-injection-proxy.md` superseded.
- No open questions; landed directly on `main2` at `d95e2b59ba0`.
- Checks: `git diff --check` passed; ownership sensor found the required map with no fused-name candidates; remote `main2` matches local HEAD.
- Follow-up: the existing orchestration owns `build-secret-management-20261105`.
- Self-improvement: nothing this time.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/design-secret-management-20261105.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s) (1 unmetered)
- Input: 0 tokens (0 cached reads)
- Output: 0 tokens
- Cost: $0 (1 engagement(s) unpriced)
- Wall-clock: 517s

<!-- garden-usage-end -->
