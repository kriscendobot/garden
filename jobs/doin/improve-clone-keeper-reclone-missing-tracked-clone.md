`scripts/jobs/clone-keeper.sh` keep_clone() (line ~78) currently logs `WARN: tracked clone <dir> is missing or not a git repo … skipping` and returns 0 whenever a tracked bare clone is absent — so `worktrees/endojs-endo.git` has been re-warned every ~30 min all day (10:30–19:00) and will forever, never self-healing. This defeats the script's stated reason for existing (the "endo clone pinned at master for six weeks" incident in its own header). Change the missing-clone path to re-create the bare clone deterministically instead of skipping: extend the `GARDEN_TRACKED_CLONES` tuple from `<dir>|<remote>|<branch>` to `<dir>|<remote>|<branch>|<url>` (endo's url is `https://github.com/endojs/endo`), and on a missing/non-git `abs`, `git clone --bare <url> <abs>` (then set the branch/refspec the fast-forward path expects) before falling through to the normal fetch/ff. Keep it bounded/logged like the other paths (one WARN if the re-clone itself fails, return 0, never wedge the loop). Net effect: a tracked clone that vanishes is restored on the next tick rather than skipped in perpetuity.

---
claim:
  host: endolinbot2
  gardener: 1
  claimed_at: 2026-07-02T19:14:50Z
