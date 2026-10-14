Implemented and pushed commit `460f0598b585` to `main2`.

- Captures HTTP status, attempt count, retryability, and bounded/sanitized provider error codes.
- Retries only transient transport errors and HTTP 408/429/5xx with bounded exponential backoff.
- Classifies other 4xx responses as `halt_api_contract` with exit 5, preventing blind host failover.
- Updated scholar/botanist guidance and classification documentation.
- Verified: 19 classifier tests passed; ShellCheck and `git diff --check` passed.
- Follow-ups: none.
- Self-improvement: updated `skills/foreign-content-preclassification/SKILL.md` with the reusable HTTP failure contract.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/improve-typesafe-http-classification.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s) (1 unmetered)
- Input: 0 tokens (0 cached reads)
- Output: 0 tokens
- Cost: $0 (1 engagement(s) unpriced)
- Wall-clock: 275s

<!-- garden-usage-end -->
