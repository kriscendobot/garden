---
role: fixer
tier: mentor
fallback-tier: minion
dispatch: automatic
---
**Role: fixer.** **Put oros-studio's per-worker journal clones on container-local disk, or make the claim path worktree-free.** Repo: kriscendobot/garden (land on main2 with tests).

Evidence (oros-health-checkup-20261013-012006; see `journal2:projects/garden/oros-health-log.md`, 2026-10-13T10:10Z):
- On oros-studio-garden-ce242c49, `$GARDEN_STATE` lives on the virtiofs share of the macOS home. A read-only `git status` over the ~68.5k-file journal tree takes about 13.5s there.
- `sync_clone`'s `reset --hard` takes about 100s per call. So each claim attempt costs 100–120s, and oros loses nearly every claim race: at 10:00Z, 6 of 8 monks were inside claim-job/usage-append resets, and the host had one `claude -p` running.
- The shared `producer/journal` clone's lock was held continuously (several `journal-entry.sh` writers), so land-journal-edit failed after 3×60s waits.
- The same edit through a fresh clone on `/var/tmp` (container-local) landed in 10s.
- `614437c2` already moved the deploy gate to `GARDEN_DEPLOY_GATE_LOCAL_BASE` (/var/tmp) for the same reason.

Pick one of these and justify the choice:
- (a) A per-host knob, for example `GARDEN_JOURNAL_CLONE_BASE` (default unchanged). It would place the reconstructible per-worker and producer journal clones on a container-local base. Locks stay where they are. Clones get reseeded when the base is empty, for example after a container recreate.
- (b) A worktree-free claim: graft or replay the todo→doin move (like `journal_graft_push` / `journal_replay_head`), so the claim CAS does not pay a full worktree reset.

Do not change drains, worker leveling or budget pools.
