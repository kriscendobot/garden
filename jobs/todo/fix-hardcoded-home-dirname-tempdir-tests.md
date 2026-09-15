---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
# Fix: hardcoded `$(dirname "$HOME")` temp-dir base breaks on non-standard $HOME layouts

Diagnosed via `diagnose-oros-studio-policy-refusal-test-20260915` (see its tada
report for full detail): 7 standalone tests hardcode their temp-dir base as
`$(dirname "$HOME")`, assuming a stock Linux `$HOME=/home/<user>` layout where
`dirname` is writable. On a host where `$HOME` is relocated to mirror a macOS
Docker Desktop path (e.g. `/Users/dom/garden`), `dirname` resolves to
`/Users/dom` — root-owned, unwritable — so `mktemp -d` fails and the test
aborts rc=1 before its real assertions run, one of them
(`policy-refusal-quarantine-test.sh`) inside the deploy test gate, blocking
that host's deploys entirely.

Affected files (all use the same antipattern):
- scripts/jobs/test/policy-refusal-quarantine-test.sh
- scripts/jobs/test/comment-watcher-test.sh
- scripts/jobs/test/detect-quota-resets-test.sh
- scripts/jobs/test/inbox-coalesce-test.sh
- scripts/jobs/test/provider-quota-backoff-test.sh
- scripts/jobs/test/triager-test.sh
- scripts/jobs/test/watchdog-notice-dedup-test.sh

Fix: extract the writable+exec-capable temp-base probe `run-test.sh` already
implements (~lines 50-58: try `GARDEN_TEST_TMPDIR`, then `TMPDIR`, then
`/var/tmp`, then `/tmp`, then fall back to `$HOME` — first candidate that is
both writable AND exec-capable) into a small shared helper, and have all 7
tests above source it instead of hardcoding `$(dirname "$HOME")`. Do NOT
default to plain `/tmp` — several of these write executable fixtures, and
`/tmp` is noexec in at least one deployed container (documented in
run-test.sh already).

The deploy gate (deploy-garden.sh:345) invokes gate suites directly via
`bash "$gate_root/$suite"`, bypassing run-test.sh, which is why they don't
already inherit its safe-base logic — confirm the fix is self-contained in
each test (or a sourced helper) rather than relying on the gate's invocation
path.

Verify: run all 7 tests locally (should be unaffected/still green on a
standard host), and if possible re-run `policy-refusal-quarantine-test.sh` on
oros-studio-garden-ce242c49 (requires: host=oros-studio-garden-ce242c49 for a
follow-up canary-style verification job) to confirm it now passes there.
