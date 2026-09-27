Implemented and pushed `18f02975bc8` to `main2`.

- Isolated `triager-pacing-test.sh` from ambient cgroups via its test-only cgroup seam.
- Verified: 14/14 passing normally and inside a `systemd-run --user --scope`.
- Follow-ups: none.
- Self-improvement: nothing this time.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/fix-triager-pacing-rolling-deploy-cgroup-leak.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 2 on 2 host(s) (1 unmetered)
- Input: 0 tokens (0 cached reads)
- Output: 0 tokens
- Cost: $0 (1 engagement(s) unpriced)
- Wall-clock: 147s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
