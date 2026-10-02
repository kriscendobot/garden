---
role: fixer
requires: host=oros-studio-garden-ce242c49
tier: mentor
fallback-tier: minion
dispatch: automatic
---
**Role: fixer.** Diagnose and fix **oros-studio-garden-ce242c49**'s reporting and deploy health. You are running *on* oros (host-pinned); inspect its local journalctl, units and `$GARDEN_STATE`.

Maintainer ask (kriskowal, liaison session 2026-10-01): check in on oros-studio, then "Go ahead" on a diagnosis job.

**Symptoms (from the journal, 2026-10-01 ~19:56Z):**
1. **Budget heartbeat stopped.** The last `budget/live/claude-oros/oros-studio-garden-ce242c49` snapshot was at 18:07:16Z. Earlier ones came every 10–30 min. Because it went stale, the leader derotated oros at 19:05Z (worker caps 4 → 0, marker `journal2:worker-derotate/oros-studio-garden-ce242c49`). The rolling deploy reports the host offline, with 100+ "host-offline" notices.
   - Find out why the usage-meter / budget-refresh publication stopped. Candidate causes:
     - the 2026-09-30 change "stagger live budget snapshot publication per host" (`cfc49a7a`);
     - a wedged or bloated producer clone (see "state-clone bloat" history; a "journal-clone-oversized" watchdog fired today);
     - a failing timer.
2. **Deploy test (canary) keeps failing.** Validation failed after all 3 retries for `c810e1e6` (13:02Z) and `697976e7` (16:17Z). Health was last published 12:25Z at `e036bb8e`, roll-drained. Determine what the validation saw: did the probe job reach tada, did units stay healthy, or did the regression watch trip? (See `scripts/jobs/rolling-deploy.sh` and `self-deploy.sh`.) Check whether oros actually deployed the target sha, and whether its fleet/health publication is also failing (the same root cause as #1?).
3. **Claims under a drain.** Oros's sysop acked and applied a rolling-deploy **drain on** at 16:36:54Z. Yet oros monks claimed jobs at 19:10, 19:32 and 19:53Z. Find out whether the drain marker was removed, and by what: a local operator, `deploy-garden.sh` lifting the drain after a deploy, or something else. If a garden script clears a roll-drain it does not own, that is a bug: fix it or report it precisely.

**Do:**
- Diagnose with evidence (log lines, timestamps).
- Fix what is safely fixable on-host: restart or repair the meter publication, gc or re-clone a bloated state clone, and so on.
- Land garden code fixes to `main2` with tests where the root cause is in the scripts.
- Do **not** lift or alter drains yourself, and do not change worker leveling or derotation markers. Once the heartbeat resumes, the derotation self-restores.

**Report:** the root cause for each symptom; what you fixed; what still needs the maintainer, or a person at the oros machine, to act; and whether oros is now fit to serve as a deploy canary again. The leader has been held at `878c5d52` since 2026-09-30, because endolin-garden2 is operator-drained (claude2 at its 90% policy stop) and oros keeps failing as the canary.

---
claim:
  host: oros-studio-garden-ce242c49
  gardener: 2
  worker_kind: monk
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-10-02T00:57:56Z
