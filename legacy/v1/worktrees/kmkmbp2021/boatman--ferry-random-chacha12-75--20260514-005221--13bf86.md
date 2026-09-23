---
hostname: kmkmbp2021
worktree: boatman--ferry-random-chacha12-75--20260514-005221--13bf86
path: /Users/kris/garden/dispatches/boatman--ferry-random-chacha12-75--20260514-005221--13bf86
repo: endojs/endo-but-for-bots
branch: kriskowal-random-chacha12
role: boatman
status: collected
created_at: 2026-05-14T00:52:21Z
last_heartbeat: 2026-05-14T02:18:00Z
task: "Ferry endojs/endo-but-for-bots#75 (@endo/random + @endo/chacha12) to endojs/endo:kriskowal-random-chacha20 (force-push update of #3232)"
prs:
  - repo: endojs/endo-but-for-bots
    pr: 75
    role: source
    title: "feat(random,chacha12): factor @endo/random from @endo/chacha12 [resync to actual/kriskowal-random-chacha20]"
  - repo: endojs/endo
    pr: 3232
    role: target
    title: "feat(chacha12): Consolidate PRNG for fuzzing"
---

Per-dispatch worktree triple for the boatman handoff dispatched at journal commit `c83daf7`. Source is `kriskowal-random-chacha12` on `endojs/endo-but-for-bots` at head `836928335`. Target is `endojs/endo:master`. Identity authorization staged. Dispatched concurrently with the #223 and #228 boatmen.

**BLOCKED, awaiting user direction.** The boatman discovered an overlapping open upstream PR (`endojs/endo#3232`, kriskowal-authored, active recent maintainer review) and stopped before any commit rewrite or push. Project worktree at source HEAD `836928335` with commits unmodified. See the boatman's message-to-liaison at `entries/2026/05/14/010000Z-message-boatman-176fd1.md` for the three options the user can choose between, and the liaison-side result at `entries/2026/05/14/011215Z-result-liaison-1f8b30.md`. **Do not teardown** until the user picks a direction.
