Both suites green. The job is complete.

## Completion report

**State on resume:** The working tree was clean and two prior attempts of this job had already landed on main2 (`68b98daa9c` degrade + `6f340d0457` preflight-recognition), so most of the deliverable was in place. I verified each piece against the spec rather than re-doing it.

**Fix 1 (misclassification) — verified already landed & correct.** `common.sh:3546` now reads `GARDEN_GH_PRIMARY_RATE_LIMIT_SIGNATURES:=API rate limit (already )?exceeded for user([[:space:]]+ID)?|x-ratelimit-remaining:[[:space:]]*0` — exactly the spec's optional-`already` widening, strictly narrower than the transient set (secondary-rate/abuse/429 still classify transient). `gh-api-retry-test.sh` asserts both wordings (plain "exceeded" + "already exceeded"), exercises the real `GARDEN_GH` seam, and proves the transient-retry branch is never entered on a quota refusal. All 48 assertions pass.

**Fix 2 (tick-level degrade) — verified already landed, with a gap I closed.** `mirror-closer.sh` captures each handler's stderr (`run_handler_captured`), classifies quota vs. genuine failure (`count_handler_failure` via `is_gh_primary_rate_limit_text`), and exits 0 with a loud WARN only when *every* failure was a primary-quota refusal, exit 1 otherwise. I confirmed this stderr-based channel is sound in production (the landed approach differs from the spec's suggested "exit code 75" but is functionally equivalent): the real handler's `gh_api_retry` WARN and `die` both write the quota wording to stderr via `log`/`die` (`>&2`), so the captured stderr genuinely carries "API rate limit already exceeded" on a real refusal. Every quota-blocked mapping is left unresolved (no `closed_at` stamped) — "never guess a state" preserved.

**What I added:** the spec's required **mixed quota+404 → exit 1** test, which was the one missing piece. New `MIXEDSTATE` stub returns the primary-quota preflight wording for one ref and a 404 for the rest; new `H1b` case asserts the mixed tick exits nonzero, the final WARN counts the non-quota failure separately, and both mappings are left unresolved. All 46 mirror-closer assertions pass (incl. the real-`gh` end-to-end).

**Lint/syntax:** `mirror-closer-test.sh` is in the shellcheck-excluded `test/` tree; it passes `bash -n`. No production entrypoints were changed by me.

**Pushed:** `test(jobs): pin mirror-closer mixed quota+404 tick exits 1` → main2 (`db4186085a..8d9cd08b58`), via rebase-CAS.

**Follow-ups:** none. Fix 1 is fleet-wide (shared helpers), so ci-watcher and the comment/mention watchers that were failing the same way during the quota window are covered by the same signature change.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/self-heal-fix-garden-mirror-closer-gh-primary-quota-already-exceeded-misclassified.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 3 on 1 host(s)
- Input: 54 tokens (1875947 cached reads)
- Output: 13116 tokens
- Cost: $1.74507475
- Wall-clock: 333s
- Model(s): claude-opus-4-8 ×3

<!-- garden-usage-end -->
