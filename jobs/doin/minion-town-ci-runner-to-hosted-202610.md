---
role: shepherd
tier: mentor
fallback-tier: minion
dispatch: automatic
---

# Move minion.town CI back to GitHub-hosted runners after the October billing reset

Follow [minion-town-ci-runner-switch](skills/minion-town-ci-runner-switch/SKILL.md) § To GitHub-hosted.

The kriscendobot Actions billing block began 2026-10-08 07:59Z. The previous block cleared around 20Z on 2026-09-30, so this one should clear around 20Z on 2026-10-30. This job is scheduled just after that.

1. Set the variable: `gh variable set CI_RUNS_ON -R kriscendobot/minion.town --body '"ubuntu-latest"'`.
2. Dispatch `ci-runner-selftest.yml`, or rerun a recent run, and confirm that a **hosted** job starts and passes.
3. **If hosted runs are still refused for billing:**
   - Delete the variable again.
   - Rerun anything the probe left red.
   - Re-schedule this job one day later with `scripts/jobs/set-schedule-once.sh minion-town-ci-runner-to-hosted-202610 <ISO+1d> minion-town-ci-runner-to-hosted-202610-retry<N> <this body>`.
4. **On success:**
   - Leave the `ci.minion.town` host up as a warm standby. Do not tear it down.
   - Tell the maintainer in one line, with the URL of the passing hosted run.

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 1
  worker_kind: monk
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-10-30T22:05:22Z
