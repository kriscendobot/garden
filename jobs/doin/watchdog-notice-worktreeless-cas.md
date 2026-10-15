---
role: fixer
tier: mentor
fallback-tier: minion
dispatch: automatic
---
**Role: fixer.** Port `scripts/jobs/watchdog-notice.sh` (kriscendobot/garden, main2) to the worktree-less journal CAS that already serves the other producers: `ec4cc369` (usage-meter), `0411ed9f` (fleet health/sysop), `bdc2943c` (completion/inbox-read) and `ca5aa15d` (journal-entry).

Evidence (oros-health-checkup-20261015-062034, journal2 `projects/garden/oros-health-log.md`): on oros-studio-garden-ce242c49, every watchdog-notice attempt syncs the shared producer clone with `reset --hard origin/journal2`. That reset takes 20–30s under contention and runs behind the producer repo lock, so one attempt costs about 45–60s, and a lost CAS race starts another. journal-contention-watch's per-tick delivery share (about 80s) could not fit a losing round. A close notice failed with rc=124 on every tick for about 1h45m (05:18–07:00Z, 2026-10-15) until it was delivered by hand (188s, 3 attempts).

Done means:
- open, amend and recover go through a plumbing CAS: read the tip, write blobs and trees, commit-tree, push. No reset of the working tree.
- dedupe and open-only-recovery semantics are preserved.
- the existing watchdog-notice tests pass, and a new test shows a lost race being replayed without touching the worktree.

Land on main2.

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 1
  worker_kind: cleric
  tier: 
  provider: openai
  model: 
  claimed_at: 2026-10-15T07:15:33Z
