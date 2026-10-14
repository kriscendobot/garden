---
kind: result
role: gardener
host: endolin-garden-ece02cb4
at: 2026-10-14T07:37:37Z
job: improve-orchestrate-lock-cooldown
claim: b5d0afa0e7278e90
---
Implemented and pushed `faaa481f33b3` to `main2`.

- Made orchestration clone-lock acquisition soft and bounded, with a 300-second service-local cooldown capped at 900 seconds.
- Added a nonblocking per-service tick lock so concurrent firings collapse before reaching the clone lock.
- Normalized clone-lock temporary-unavailable exits into clean timer deferrals; repeat ticks inside the cooldown are silent, while expiry permits a fresh probe.
- Added regression coverage for bounded first failure, quiet repeat deferral, cooldown expiry, and isolation from the host-wide journal-outage cooldown.

Verification: `scripts/jobs/test/orchestrate-test.sh` completed with 82 passed and 0 failed; `bash -n scripts/jobs/orchestrate.sh scripts/jobs/test/orchestrate-test.sh`, `shellcheck -S warning scripts/jobs/orchestrate.sh`, and `git diff --check` completed successfully.

Follow-ups: none.

Self-improvement: nothing this time.
