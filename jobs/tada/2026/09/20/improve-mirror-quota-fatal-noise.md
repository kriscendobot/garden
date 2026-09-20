Empty inbox. Work is complete.

## Completion report

**Job:** `improve-mirror-quota-fatal-noise` — stop `mirror-pr-state-gh.sh` from emitting a FATAL "no usable PR state" on GitHub primary-quota exhaustion.

**What I changed:**

- **`scripts/jobs/handlers/mirror-pr-state-gh.sh`** — The handler previously ran `gh_api_retry … || die "…no usable PR state for the closer"`, so *any* failed read — including a GitHub primary-quota refusal — died at FATAL (`<3>` err) priority. But a quota refusal is a self-resolving throttle that `mirror-closer.sh` already handles gracefully: its circuit breaker classifies the trip from the handler's stderr, breaks the loop, arms a cooldown, and emits **one** aggregate degraded WARN. The FATAL double-reported that quota window at error priority — noise triage misreads as a real outage.

  The fix captures `gh_api_retry`'s stderr into a temp file, re-emits it (journald keeps the original cause; the closer's `count_handler_failure` / `is_gh_primary_rate_limit_text` still classifies the quota trip from it), and then branches: on a primary-quota signature it exits **nonzero with empty stdout** — preserving the closer's no-state circuit-breaker contract — but **without** a FATAL line. Every other failure (auth, bad node id, exhausted transient retries, malformed/null/unavailable state) still `die`s LOUD exactly as before, and the empty-output "refusing to guess" guard is untouched. "Never guess a state" is unchanged.

- **`scripts/jobs/test/mirror-closer-test.sh`** — Added handler-level coverage in section J: a quota stub `gh` (primary rate-limit wording) proves the refusal (1) keeps the nonzero+empty no-state contract, (2) emits no FATAL / no "no usable PR state" line, and (3) still carries the rate-limit signature on stderr so the closer can classify it.

**Verification:** Full test suite passes — `RESULT: 64 passed, 0 failed` (`--no-e2e`). Handler passes `bash -n`; shellcheck shows only pre-existing benign notes. Committed and pushed to `main2` (`c66038fb38..e9b5062474`, clean fast-forward). Inbox empty.

**Follow-ups:** None.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/improve-mirror-quota-fatal-noise.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 44 tokens (1431886 cached reads)
- Output: 13676 tokens
- Cost: $2.0895499999999996
- Wall-clock: 198s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
