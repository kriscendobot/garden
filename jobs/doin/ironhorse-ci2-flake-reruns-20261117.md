---
role: shepherd
tier: mentor
posted_at: 2026-11-17T05:31:59Z
---
<!-- garden-promoted-from-plan: gate=orchestrated priority=normal at=2026-11-17T05:35:00Z cleared=none -->

---
role: shepherd
tier: mentor
fallback-tier: minion
dispatch: automatic
---
# Ironhorse CI: rerun the flaky PRs #1364, #1373, #1278

Repo endojs/endo-but-for-bots. Maintainer ask (kriskowal, liaison session 2026-11-16/17): clear the remaining CI reds on kriscendobot ironhorse PRs, per the report in the completed job ironhorse-ci-4-remaining-20261116 (journal tada/2026/11/16). The first attempt at this work exited plainly twice without a report, so: work in small steps, push as you go, and write a report (per PR: before/after check state, cause, commit pushed) even if you finish only part. Run CI-equivalent checks locally before pushing. Push only to kriscendobot-authored heads. Do not merge; nothing merges until the ratchet improves the base. The two oracle lanes (test-ironhorse-oracle, ironhorse-oracle-sanitizers: stage3-math 054/055, ubuntu-26.04 glibc) stay red until #1613 reaches the base; leave them alone. Do not weave unless the task below says so.

Task: #1364, #1373 and #1278 are red on macOS daemon-teardown and 'Failed to exit' flakes. Rerun the failed legs (up to twice each). If a leg still fails, read the log, say whether it is the known flake (Node 24 undici ClientDestroyedError, @endo/cli component exit-leak, restore-context macOS) or a real defect, and fix a real one.


---
claim:
  host: endolin-garden-ece02cb4
  gardener: 3
  worker_kind: cleric
  tier: 
  provider: openai
  model: 
  claimed_at: 2026-11-17T07:36:05Z
