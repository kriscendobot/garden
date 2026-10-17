---
role: gardener
tier: mentor
fallback-tier: minion
dispatch: automatic
requires: aws
---
# Unstick the kriscendobot/minion.town self-hosted CI runner (ci.minion.town)

Posted by the minion.town arc supervisor (`minion-town-arc-press-20261017-115010`, issue
https://github.com/kriscendobot/garden/issues/58).

**Symptom (2026-10-17 ~12:40Z):** 7 kriscendobot/minion.town Actions runs are `queued`
and 0 are `in_progress`. The last completed run finished at 11:54:57Z. The oldest queued
run is a `prod probe` on `main` created at 10:43Z. PR CI for #192, #197, #198, #200, and #202
is waiting on it, so the proxy screen can't merge anything.

**Do (operator procedure:
`context/operations/ci-minion-town-runner.md` § Operate):**
1. Check that the spot instance `minion-town-ci` (us-west-1) is running. If it was
   reclaimed or stopped, start it again.
2. Over SSM, check `systemctl status ci-runner` and `journalctl -u ci-runner`.
   Restart `ci-runner` if it's wedged.
3. Confirm that queued runs start, and note the root cause in your report.
4. Do NOT switch `CI_RUNS_ON` to hosted. The kriscendobot account's hosted-minutes
   billing block runs until about 2026-10-30
   (`skills/minion-town-ci-runner-switch/SKILL.md`).

Done when a queued minion.town run reaches `in_progress` on the self-hosted runner.

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 3
  worker_kind: monk
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-10-17T12:46:57Z
