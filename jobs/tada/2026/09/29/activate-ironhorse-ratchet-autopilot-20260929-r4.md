---
handed-off: verify-ironhorse-press-first-engagement-20260929
deliverable-complete: false
---
## Completion report: activate-ironhorse-ratchet-autopilot-20260929-r4 (requeued attempt)

The foreman-woken press is deployed and its first engagement is parked. It can't run until the maintainer names an arc-budget cap on https://github.com/kriscendobot/garden/issues/51. So the live mentat run could not be observed, and I've handed that step to a parked successor.

This attempt was a requeue. Oros claimed r4 at 17:03Z and failed. Meanwhile the successor r5, a one-time scheduled job, already did most of the remaining work by 17:53Z: it checked the deployed gates, seeded the press, and reported on #51. I re-checked all of it:

- **Deploy:** the leader (endolin-garden-ece02cb4) runs `36def9fd9e8` and this host (endolin-garden2-5bcdff64) runs `622ac410f43`. Both include the ratchet commit `c3aae0b2c0c` and the press commit `9bf25f4362f`.
- **Gates in the deployed code:**
  - `scheduler.sh` skips `ironhorse-ratchet.md`.
  - `policy.py` only accepts `ironhorse-test262-press-<stamp>`.
  - `claim-job.sh`, `monk-claude.sh` and `cleric-codex.sh` check that the delegation is active.
  - The foreman's budget gate is in `common.sh` and `arc-spend.sh`.
- **Legacy schedule:** removed at 13:03Z (journal `d9292d72173`).
- **Budget:** `config/arc-budgets/ironhorse-test262-ratchet` is still absent. There is no cap reply on #51 (checked just now), so I installed nothing.
- **Press plan:** exactly one exists, `ironhorse-test262-press-20260929-173306`. It is parked with `gate: deferred`, `foreman_only`, `tier: mentat`, `dispatch: ratchet-delegated`, and the #51 issue link. It was posted by the seed script, not the scheduler.
- **PR #1359, the floor and schedules:** untouched. No merge, no attestation, the enforced floor unchanged, no sysop deploy op, no schedule change.

**Correction to r5's #51 comment:** it said oros-studio-garden-ce242c49 is offline. It is not. It is still on `e036bb8e`, which predates the ratchet, and its health record stopped updating at 06:41Z, but its workers are still claiming jobs: gardener-3 finished a job at 18:23Z. This can't reach the press. That old `claim-job.sh` and monk handler refuse any `tier: mentat` job not marked `dispatch: manual`. It is still a host doing live work on old code, and the rolling deploy keeps skipping it.

**What I did:**
1. Parked a successor, `verify-ironhorse-press-first-engagement-20260929` (`gate: blocked`, `blocked_on: ironhorse-test262-press-20260929-173306`), confirmed on `origin/journal2`. When the press completes, it will:
   - check the actual mentat claim, model and usage evidence;
   - check that the driver recorded exactly one step, or a properly evidenced failure or halt;
   - confirm PR #1359 is safe and exactly one continuation press was parked;
   - report on #51.
2. Messaged the maintainer (`msg-activate-ironhorse-ratchet-autopilot-20260929-r4-af81f298394b`) with the oros correction and the current press status.

I made no code changes or commits.

**Follow-ups:**
- **Budget cap (maintainer):** name the cap, window and interval on #51. Then run `scripts/jobs/set-arc-budget.sh ironhorse-test262-ratchet <cap> <window> <interval>` and the foreman will promote the press on its own.
- **Oros (maintainer, on that box):** it needs hands-on attention there.
- **Risk:** if the press ends as a failed job, the successor stays parked, and someone would need to promote it by hand.

<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/activate-ironhorse-ratchet-autopilot-20260929-r4.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 3 on 3 host(s)
- Input: 266 tokens (14203714 cached reads)
- Output: 66413 tokens
- Cost: $6.4436348
- Wall-clock: 12623s
- Model(s): claude-opus-5-5 ×3

<!-- garden-usage-end -->
