Completion report:

---

**Job: improve-endo-bare-clone-freshness-keeper — DONE**

**What I did**

Built a deterministic cadence keeper that moves standing-bare-clone freshness off the scholar agent and onto a systemd timer, so the endo upstream-drift re-ingestion block (root cause: `worktrees/endojs-endo.git` master pinned at `052b0487` for six weeks) can never re-form.

**What changed** (committed `cb3c2e0d7`, pushed to `origin/main2`):

- `scripts/jobs/clone-keeper.sh` — per tick, for each tracked clone (`worktrees/endojs-endo.git|origin|master` by default, `GARDEN_TRACKED_CLONES`-overridable): a **bounded fetch** of `origin master` wrapped in `timeout GARDEN_FETCH_TIMEOUT` with backoff/retry (reusing common.sh's `GARDEN_FETCH_TIMEOUT`/`GARDEN_FETCH_RETRIES`/`backoff`; reaper.sh's stuck-fetch janitor is the reap backstop since it kills any `git fetch` past `GARDEN_FETCH_REAP_AGE`), then a **strict fast-forward** of the local `refs/heads/master`. Because the endo clone's `origin` carries no fetch refspec, the fetch only advances `FETCH_HEAD` and the branch ref is moved explicitly via a compare-and-swap `update-ref <new> <old>`. A **diverged** clone (local tip not an ancestor of upstream) is surfaced loudly (`STALE: … cannot fast-forward`) instead of clobbered; a **failed/offline** fetch leaves the ref in place and never wedges. Each failure path returns 0 so one bad clone can't abort the rest.
- `scripts/systemd/garden-clone-keeper.service` + `.timer` — oneshot under the standard `self-heal-run.sh` wrapper, `OnUnitActiveSec=30m`. `install-units.sh`'s `intended_units` auto-derives the enable set from present units, so the new timer is covered by `enable-services` on every host.
- `scripts/jobs/test/clone-keeper-test.sh` — hermetic test (throwaway upstream + bare clone with the refspec removed to mirror the real endo clone). 13 assertions across fresh / fast-forward / diverged / offline; **all pass**. `bash -n` clean (CI's enforced check for these paths).

**Verification**: ran the keeper against the real clone (no-op, already fresh at `090175b2`); armed and triggered the service on `endolinbot` end-to-end through the self-heal wrapper → `Result=success, ExecMainStatus=0`, logged `master already fresh`. Timer is `enabled` and next-scheduled. Built in an isolated worktree off `origin/main2` (explicit-pathspec commit), which is now torn down.

**Follow-up worth noting** (not blocking, out of this job's scope): `deploy-sync.sh` *renders* newly-added unit files but never runs `enable-services`, so a brand-new timer is rendered-but-not-armed on other hosts until a maintainer runs `install-units.sh enable-services` (the `enable-services --verify` drift check exists to surface exactly this). I armed it by hand on this host; other hosts will pick it up on their next enable-services pass. Closing that auto-enable gap in deploy-sync could be a small future infra job.

The two shellcheck warnings (`SC2034` on `GARDEN_TAG`, `SC2046` on the `unset $(compgen…)` scrub line) are pre-existing conventions copied verbatim from sibling scripts (deploy-sync.sh / deploy-sync-test.sh) and neither new file is in CI's shellcheck scope.
