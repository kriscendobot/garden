Pushed to `main2` as `428a030131`. Job complete.

## Completion report

**Job:** `improve-mirror-closer-primary-quota-circuit-breaker` — add a primary-quota circuit breaker to `scripts/jobs/mirror-closer.sh`.

**What was wrong:** On a GitHub primary-quota refusal the tick loop counted it and `continue`d to the next mapping — issuing a fresh, equally-doomed API call per remaining mapping and logging a fatal-per-mapping WARN for each (a doomed-call storm + log noise), since the account-wide hourly quota can't recover until reset.

**What I changed (`scripts/jobs/mirror-closer.sh`):**
- `count_handler_failure` now arms a `quota_break` flag on the *first* primary-quota refusal (via the existing `is_gh_primary_rate_limit_text` predicate).
- All three per-mapping failure sites (upstream read, mirror read, close) `break` the loop when `quota_break` is set, instead of continuing.
- Final reporting emits **one aggregate degraded warning** naming the total mappings left unresolved (`N quota-refused + M unqueried`) and exits `0` (degraded, healthy). A non-quota failure seen *before* the break still exits `1`, so a real 404/etc. failure is never masked by the degrade.
- All affected mappings are preserved unstamped (no `closed_at`) and retried on a future tick after quota resets — the durable per-mapping cursor is untouched.
- Updated the header block comment to document the circuit breaker.

**Test coverage (`scripts/jobs/test/mirror-closer-test.sh`, all hermetic):**
- New **H1c**: three all-quota-blocked mappings prove the state handler is called exactly **once** (not 3×), one aggregate WARN accounts for all three (`1 quota-refused + 2 unqueried`), exactly one per-mapping WARN (no storm), no mirror closed, and all three left unresolved.
- Reordered **H1b** so the non-quota 404 precedes the quota wall (mappings process alphabetically), preserving the mixed-tick-unhealthy invariant under the new break semantics.
- Updated **H1**'s WARN grep to the new aggregate message.

**Verification:** `mirror-closer-test.sh --no-e2e` → 49 passed, 0 failed. `bash -n` clean; shellcheck clean on `mirror-closer.sh` (the two shellcheck warnings in the test file are pre-existing, on lines I didn't touch).

**Follow-ups:** none. (PART 2 real-`gh` E2E was not run here — it's gated on a bot-authenticated `gh` and unaffected by this change; the circuit-breaker path is exercised hermetically.)

Pushed to `main2` as `428a030131`.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/improve-mirror-closer-primary-quota-circuit-breaker.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 40 tokens (1427788 cached reads)
- Output: 19672 tokens
- Cost: $1.9711629999999998
- Wall-clock: 262s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
