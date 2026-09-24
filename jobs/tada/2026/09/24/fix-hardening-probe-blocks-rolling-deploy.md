All work is complete and verified. The prior attempt fully committed and pushed the fix; nothing remains to do. Both required test suites pass, including the new advisory-classification and canary-forgiveness cases.

## Completion report

The job was **already completed and pushed** by a prior attempt — commit `d37833ab35` on `origin/main2` (HEAD of this worktree, 0 ahead / 0 behind). I re-derived the job state from committed history and verified the fix is genuine and the tests pass rather than redoing the work.

### What the landed fix does (all three parts of the ask)

1. **PENDING RECREATE vs REGRESSED** — `scripts/check-container-hardening.sh` now records a per-host marker (`.garden-state/container-hardening/hardened-verified`) on its first all-pass run. Before the marker exists, a failure of only the launcher-posture checks (caps, sudo, block devices, mount) exits **3** and posts **one coalesced `watchdog-notice.sh`** (re-sent at most weekly); the verified run closes that notice. After the marker exists, any failure exits **1** as a loud regression. Credential/guard checks (login, SSH agent, guard) always exit 1; `GARDEN_HARDENING_STRICT=1` forces the strict verdict. The systemd unit treats exit 3 as success (`SuccessExitStatus`, `self-heal-run.sh --expect 3`).

2. **Canary ignores advisory probes** — `common.sh` adds `garden_unit_is_advisory` / `GARDEN_ADVISORY_UNITS` (default: the hardening probe). `fleet_unit_health` excludes a failed advisory unit from `unit_failures`/`first_bad_unit`, counts it in a separate `advisory` field published as `advisory_failures`. `rolling-deploy.sh`'s `validate_canary` forgives a record whose only failed unit is advisory. Real service-unit failures stay strict.

3. **Tests** — verified passing here:
   - `tests/checks/test_container_hardening_probe.sh`: **28 passed, 0 failed** — covers pending/coalesced/strict/verified/regressed verdict matrix, marker recording, unit exit-code handling.
   - `scripts/jobs/test/rolling-deploy-test.sh`: **71 passed, 0 failed** — includes advisory-probe-alone → 0 failed units, empty advisory set stays strict, and a conductor roll where an advisory-only failure passes the canary without a drain, while real unit failures still fail it.

No follow-ups needed. The net effect: an unrecreated host no longer fails its unit or drains on every canary; a regressed hardened host fails loudly; a real service-unit failure still fails the canary.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/fix-hardening-probe-blocks-rolling-deploy.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 2 on 1 host(s)
- Input: 66 tokens (2369171 cached reads)
- Output: 24535 tokens
- Cost: $2.2614013
- Wall-clock: 297s
- Model(s): claude-opus-5-5 ×1, claude-opus-4-8 ×1

<!-- garden-usage-end -->
