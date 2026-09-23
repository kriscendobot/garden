Fixed and pushed to `main2` as `ab7984ae0d`.

**Diagnosis: the test was wrong, the probe was right.**

`scripts/jobs/test/hermit-capability-probe-test.sh` wrote its fake `claude` under `$TMPDIR` (`/tmp`), which this container mounts **noexec**. `GARDEN_CLAUDE_BIN` is an authoritative, fail-closed override in `agent_bin_probe` (`scripts/jobs/common.sh:749`), and its runnability check is `[ -x ]` — which honors a mount's noexec flag. So `claude_bin` refused to fall back to another binary (exactly as designed and as its comment already anticipates), and `hermit-capability-probe.sh:146` recorded `claude=unavailable`.

Consequence: *every* subtest was measuring "no capable agent was available", not the behavior it named. SUCCESS silently degraded into a second copy of the capable-fail case, so `capable_succeeded` was 0 and no demerit was ever written.

**Changes (test-only; no production script touched):**
- Added the `pick_exec_base` probe — the same idiom `claude-bin-resolver-test.sh`, `worker-health-gate-test.sh`, `gardener-worktree-test.sh` and `kimi-opus-fallback-test.sh` already use — and rooted all five subtests' scratch there. Cleanly `SKIP`s if no candidate can exec. `/var/tmp` is the one that wins here.
- Hardened the DEDUP demerit count: `ls <missing> | wc -l` fails the pipeline under `set -euo pipefail`, so the suite was **aborting** at that line with rc=2 and swallowing the GUARDS and REDUCER subtests entirely rather than reporting one FAIL. Counting with `find` makes a regression report instead of truncate.

**Result:** `19 passed, 0 failed` (baseline: 2 failed, then aborted mid-suite with GUARDS/REDUCER never run). `bash -n` clean; shellcheck shows only the two pre-existing warnings (SC2046 on the deliberate env scrub, SC2034 on `seed_board`'s unused `tr`), no new ones.

**Follow-up worth noting:** this class of bug is recurring — five test files now carry their own copy of `pick_exec_base` plus a paragraph explaining noexec `/tmp`. A shared helper (a `scripts/jobs/test/lib.sh`, or an `exec_capable_base` in `common.sh` guarded to test context) would collapse the duplication and stop the next fake-CLI test from silently measuring "unavailable". I did not do that here — it is a wider refactor than this job's scope.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/fu-wallclock-cost-proxy-for-censored-arms-4.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 61 tokens (2235550 cached reads)
- Output: 14762 tokens
- Cost: $2.2653879999999997
- Wall-clock: 327s

<!-- garden-usage-end -->
