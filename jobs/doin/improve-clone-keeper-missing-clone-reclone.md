`scripts/jobs/clone-keeper.sh` (line ~79) logs `WARN: tracked clone worktrees/endojs-endo.git is missing or not a git repo ... skipping` and returns without recreating it. Clone-keeper exists specifically to kill silent staleness of the endo clone (its header cites the six-week stale pin); a tracked clone that is missing entirely is the worst case — it never gets recreated, so any endo work depending on the local bare clone silently has none. Harden the missing-clone path to self-heal: derive the upstream URL from the `<owner>-<repo>.git` dir name (`worktrees/endojs-endo.git` → `https://github.com/endojs/endo.git`), `git clone --bare` it to the tracked path with the same bounded-timeout discipline as `bounded_fetch`, and fall back to the current skip+WARN only if the clone fails. Guard it so it only recreates entries actually listed in `GARDEN_TRACKED_CLONES`, and add a clone-keeper-test case for the missing-clone reclone path.

---
claim:
  host: endolinbot2
  gardener: 19
  claimed_at: 2026-07-03T17:22:21Z
