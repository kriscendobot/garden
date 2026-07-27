Both parts of the job are complete and verified.

## Completion report

**Problem:** The `kriscendobot/garden` fork was deleted on GitHub (`gh api repos/kriscendobot/garden` → 404), but a stale bare clone `worktrees/kriscendobot-garden.git` kept `fork-watch-provisioner.sh` re-arming it into `repos/` + `comment-repos/`, so `garden-ci-watcher@`, `garden-comment-watcher@`, and `garden-triager@kriscendobot-garden` FATAL-flapped against a 404 repo every tick.

**Part 1 — durably unwatched the dead fork (operational, on `journal2`):**
- Landed one CAS commit on `origin/journal2`: added tombstone `watch-optout/kriscendobot-garden` (citing the 404 and this job) and deleted `comment-repos/kriscendobot-garden` + `repos/kriscendobot-garden`. Verified at tip: tombstone present, both arming records gone.
- Removed the stale bare clone `worktrees/kriscendobot-garden.git` on this host (other fork clones untouched).
- Stopped + disabled all three per-repo units (timers removed from `timers.target.wants`; the template `.service` "no [Install]" notices are benign — they're timer-launched). `0` `kriscendobot-garden` units now remain, and `repo-watcher.sh` won't recreate them since the slug is gone from both journal sets.

**Part 2 — hardened the provisioner (committed to `main2`, `7814c70655`):**
- `scripts/jobs/fork-watch-provisioner.sh`: before arming a not-yet-armed own fork, DISCOVER now confirms the upstream still exists via a cheap read-only `gh api repos/<owner>/<name>` (bot identity, guarded `if`-capture so a nonzero return doesn't trip `set -e`). A `404` skips arming and auto-lands a durable `watch-optout/<slug>` tombstone (dropping any stale arming records too); an inconclusive/transient check defers to a later tick. The check is overridable via `GARDEN_FORKWATCH_UPSTREAM_CHECK` for hermetic tests. Header docs updated.
- `scripts/jobs/test/fork-watch-provisioner-test.sh`: added a hermetic upstream-check fixture wired into `run_prov`, plus case **G** asserting a 404-upstream clone is NOT armed, IS auto-tombstoned (with the 404 reason), a live-upstream own fork still arms alongside it, and the tombstone isn't re-armed on re-run. **All 21 assertions pass** (A–G). Confirmed `endojs/endo-but-for-bots`-style non-own-forks are still never touched (owner-not-listed path) and live bot forks arm normally.

**Notes/follow-ups:**
- shellcheck shows only pre-existing style infos (SC1091/SC2034/SC2015) consistent with the rest of the tree — no new findings from these changes.
- A test-only latent bug surfaced and was fixed: case F leaves `config/fork-owners` as a single mangled entry (jpush space-joins args), so case G re-establishes a clean `kriscendobot` owner set before running.
- Deploy: the provisioner fix rides `main2` to every instance via the normal deliberate-deploy path; no separate action needed.
