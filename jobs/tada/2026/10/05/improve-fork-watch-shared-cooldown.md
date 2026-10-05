Fixed and pushed to `main2` as `de654e29609`. When the host-shared gh-api latch is live, the fork-watch provisioner now skips its fork probes quietly until the latch clears, instead of warning every five minutes. The provisioner test suite passes (105 passed, 0 failed); the fix has not yet run on a live host.

**Cause:** when the latch is live, `gh_api_retry` refuses the request without sending it. Its refusal message deliberately contains "rate limit" so other callers stop querying. The provisioner read that as a new rate-limit, warned, and opened its own 300s window. That repeated for the whole 3600s latch (2026-10-05T01:55:23Z–02:15:30Z).

**What changed (`scripts/jobs/fork-watch-provisioner.sh`):**
- `upstream_exists` now recognizes the "admission refused: host-shared gh-api cooldown live (Ns left" message. It puts it in its own quiet class, `gh-api-cooldown`, with no WARN, and leaves the silent-failure escalation counter alone.
- The provisioner's window now lasts for the latch's remaining time instead of 300s, capped at the provisioner's own 3600s limit. A cooldown setting of 0 still records no window.
- The tick that opens the window logs one informational line, not a WARN; later ticks log nothing. Only the latch owner warns, which is the existing once-per-latch warning in `gh_api_retry`.
- A real rate-limit or other failure that isn't this refusal is handled exactly as before.

**Tests (`scripts/jobs/test/fork-watch-provisioner-test.sh`, new section P):**
- Probing stops after one fork and a `gh-api-cooldown` window is opened, not a `rate-limit` one.
- The window takes the latch's remaining 1234s, and a 99999s latch is capped at 3600.
- There is no WARN and no escalation, and the next tick neither probes nor logs.
- A genuine rate-limit message still warns.

No follow-ups needed.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/improve-fork-watch-shared-cooldown.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 24 tokens (727089 cached reads)
- Output: 7344 tokens
- Cost: $0.8450497999999999
- Wall-clock: 161s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
