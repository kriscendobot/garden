Pushed to main2 as `cc168f101`.

## Completion report

**Job:** Align `garden-comment-watcher@.service` `TimeoutStopSec=20s` with the worst-case source-fetch budget in `comment-watcher.sh`.

**Root cause confirmed.** The 09:40:35 SIGKILL was caused by the *source-path self-test* probe (`comment-watcher.sh:257`), not the main source fetch. That probe ran a **foreground** `timeout --signal=TERM --kill-after=10s 30s gh api …` inside a `$( … )` command substitution — a 40s worst case when api.github.com is unreachable. Because bash defers the EXIT/TERM trap until a running foreground child returns, a stop landing mid-probe could not drain within `TimeoutStopSec=20s`, so systemd's cgroup-wide SIGKILL backstop fired (`status=9/KILL` → `Failed`) — exactly the orphaned-git-in-cgroup outcome `KillMode=mixed` was written to avoid.

**Changes:**
- `scripts/jobs/comment-watcher.sh`: shortened the self-test probe to `--kill-after=5s 10s` (15s worst case < 20s, 5s margin), and added a comment explaining why this foreground fetch's budget is a hard floor on stop latency. Chose to shrink the fetch rather than raise the stop timeout so restarts stay fast, per the job's guidance.
- `scripts/systemd/garden-comment-watcher@.service`: documented the invariant next to `TimeoutStopSec=20s` — every blocking fetch a stop can land mid-flight must fit inside 20s; the main source fetch is trap-reaped (bounded by its 10s kill-after) while the foreground self-test is the one path that must be capped directly.

**CI-watcher audit (per the job's "same audit" ask):** No change needed. `garden-ci-watcher@.service` is also `TimeoutStopSec=20s`, but `ci-watcher.sh`'s only source fetch is backgrounded + trap-reaped (stop-drain bounded by `GARDEN_CI_KILL_AFTER=10s`), and it has no foreground self-test probe. Its per-PR rollup reads (`gh pr view`, unbounded) are foreground and not trap-wrapped — a latent but distinct concern outside this job's "source-fetch budget" scope; noting it as a possible follow-up.

**Verification:** `bash -n` clean; comment-watcher test suite 182/182 pass, ci-watcher 19/19 pass (the self-test is stubbed via `GARDEN_COMMENT_SELFTEST` in tests, so the change is behavior-preserving there).

**Follow-up (optional):** consider wrapping `ci-rollup-gh.sh`'s `gh pr view` in a bounded `timeout` so a per-PR rollup can't block a ci-watcher stop past 20s during an outage.
