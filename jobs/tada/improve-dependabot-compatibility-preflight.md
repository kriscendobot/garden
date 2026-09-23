Implemented and pushed commit `e6aeb2f9ab` to `main2`.

- Added bounded, deterministic peer-dependency and Node-engine compatibility checks.
- Proven incompatibilities now produce cheap reverify-and-close botanist jobs.
- Uncertain, unsupported, timed-out, or unavailable checks fall open to full review.
- Added coverage for Vite peer conflicts, Babel-style Node-floor conflicts, compatible cases, and fail-open behavior.
- Verification: 57 focused assertions passed; Bash, Node syntax, ShellCheck warning gate, and `git diff --check` passed.
- Follow-ups: none.
- Self-improvement: nothing this time.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/improve-dependabot-compatibility-preflight.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s) (1 unmetered)
- Input: 0 tokens (0 cached reads)
- Output: 0 tokens
- Cost: $0 (1 engagement(s) unpriced)
- Wall-clock: 513s

<!-- garden-usage-end -->
