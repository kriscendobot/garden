---
role: shepherd
tier: mentor
handler-timeout: 10800
---
<!-- garden-promoted-from-plan: gate=orchestrated priority=normal at=2026-10-03T03:43:45Z cleared=none -->

---
role: shepherd
handler-timeout: 10800
tier: mentor
fallback-tier: minion
dispatch: automatic
---
# Resume the six gauntlets halted on red CI (endojs/endo-but-for-bots)

Maintainer (kriskowal, liaison muster 2026-10-03): "Fix the red-CI gauntlets."

PRs: https://github.com/endojs/endo-but-for-bots/pull/1417,
https://github.com/endojs/endo-but-for-bots/pull/1412,
https://github.com/endojs/endo-but-for-bots/pull/1408,
https://github.com/endojs/endo-but-for-bots/pull/1404,
https://github.com/endojs/endo-but-for-bots/pull/1392,
https://github.com/endojs/endo-but-for-bots/pull/1396.

Each halted (orchestration-failed / ci-wait-merge rc 3) on `@endo/daemon#test`
failures unrelated to the PR's diff. For each PR:
1. Check its current state (gauntlet record under jobs/gauntlet[-archived]/ or the
   owning orchestration under jobs/orch/; #1412's gauntlet may already be running
   again — leave a live run alone).
2. Confirm the red cells are only in `@endo/daemon` tests outside the PR's diff. If a
   failure IS caused by the PR, fix it on the branch (safe-push-pr-head.sh).
3. Re-run the failed CI jobs (`gh run rerun --failed`), up to 2 tries, to drive CI green.
4. Once green, resume the halted gauntlet/orchestration from where it stopped
   (unarchive-gauntlet.sh, or re-post the halted orchestration child) so it reaches
   its un-draft stage. Do not restart a gauntlet from round 1 when it can resume.
A sibling job (ebfb-daemon-test-flakes-20261003) is fixing the flakes at the root; if
a PR stays red after reruns, note which signature, and leave it for that fix rather
than burning more CI. Report per-PR outcome.

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 4
  worker_kind: monk
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-10-03T03:59:38Z
