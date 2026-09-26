Implemented and pushed commit `8d84dd06ce` to `main2`.

- Authentication and transport failures now retry with jittered backoff and escalate only after a configurable five-tick persistence window.
- Persistent auth notices say authentication is failing, never that the upstream is gone.
- Upstream-gone notices require both a matching git diagnostic and `gh api` confirmation; an existing repository vetoes the notice.
- Added 30-second timer jitter to damp restart herds.
- No watches were disarmed or tombstoned.
- Verification: triager tests passed 119/119; fetch tests 16/16; GitHub API retry tests 39/39; timer tests 6/6; checks suites 7/7; pre-push probes passed.
- Follow-ups: none.
- Self-improvement: nothing this time.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/garden-triager-transient-auth-misclassified-as-upstream-gone.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s) (1 unmetered)
- Input: 0 tokens (0 cached reads)
- Output: 0 tokens
- Cost: $0 (1 engagement(s) unpriced)
- Wall-clock: 492s

<!-- garden-usage-end -->
