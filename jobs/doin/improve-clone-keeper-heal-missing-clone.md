Change `scripts/jobs/clone-keeper.sh`'s `keep_clone()` so a tracked bare clone that is missing / not-a-git-repo is HEALED or ESCALATED, not silently skipped every tick. Right now the "is missing or not a git repo … skipping" branch just logs a `WARN` and returns 0, so a vanished clone (confirmed live: `worktrees/endojs-endo.git` is absent on this host) re-forms the endo re-ingestion block the keeper header says it exists to prevent — and does so indefinitely at 30-minute cadence with no distress signal beyond a repeating quiet warning. Preferred fix: on a missing tracked clone, re-create it with a bounded `git clone --bare <upstream-url> <abs>` (extend the `GARDEN_TRACKED_CLONES` line format `<dir>|<remote>|<branch>` with an optional `|<url>` field so the clone URL is explicit rather than guessed from the dir name; default the endo entry to its known upstream). If a re-clone is out of scope or fails, escalate once (post to the maintainer inbox / a job) instead of a silently-repeating WARN so a human heals it. Cover both the re-clone-succeeds and re-clone-fails-then-escalates paths in `scripts/jobs/test/clone-keeper-test.sh`.

---
claim:
  host: endolinbot2
  gardener: 12
  claimed_at: 2026-07-03T13:51:56Z
