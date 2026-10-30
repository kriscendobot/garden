once: 2026-10-31T22:10:00Z
job_basename_prefix: minion-town-ci-runner-to-hosted-202610-retry1
---
---
role: shepherd
tier: mentor
fallback-tier: minion
dispatch: automatic
---

# Move minion.town CI back to GitHub-hosted runners after the October billing reset (retry 1)

Follow [minion-town-ci-runner-switch](skills/minion-town-ci-runner-switch/SKILL.md) § To GitHub-hosted.

The kriscendobot Actions billing block began 2026-10-08 07:59Z and was expected to clear about 20Z on 2026-10-30. The first probe (2026-10-30T22:06Z, job minion-town-ci-runner-to-hosted-202610) was still refused: "The job was not started because recent account payments have failed or your spending limit needs to be increased." This retry runs one day later.

1. Set the variable: `gh variable set CI_RUNS_ON -R kriscendobot/minion.town --body '"ubuntu-latest"'`.
2. Rerun a recent `test.yml` run (`gh run list -R kriscendobot/minion.town -w test.yml -L 1`, then `gh run rerun <id>`). Confirm that its jobs carry the `ubuntu-latest` label and that they start and pass. Do NOT use `ci-runner-selftest.yml` as the probe: its jobs hard-code `[self-hosted, ci-minion-town]` and ignore `CI_RUNS_ON`. A failed hosted job's annotations (`gh api repos/kriscendobot/minion.town/check-runs/<job-id>/annotations`) show the billing refusal.
3. **If hosted runs are still refused for billing:**
   - Delete the variable again.
   - Rerun anything the probe left red.
   - Re-schedule one day later with `scripts/jobs/set-schedule-once.sh minion-town-ci-runner-to-hosted-202610-retry<N+1> <ISO+1d> minion-town-ci-runner-to-hosted-202610-retry<N+1> <this body>`. Update the retry number and the record of the last probe.
4. **On success:**
   - Leave the `ci.minion.town` host up as a warm standby. Do not tear it down.
   - Tell the maintainer in one line, with the URL of the passing hosted run.
