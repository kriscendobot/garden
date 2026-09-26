Done. All work is committed, pushed, verified, and the worktree is torn down.

---

## Completion report — `harden-git-fetch-timeout`

**Pushed to `origin/main2` as `1d8c46ee`** (bot identity `endolinbot`, built in an isolated worktree off `origin/main2`, rebased cleanly onto a concurrent comment-watcher commit before push).

### What changed

**1. Every journal git fetch is now timeout-bounded with retry** (`scripts/jobs/common.sh`)
- New `journal_fetch()` helper wraps each fetch in `timeout "$GARDEN_FETCH_TIMEOUT"` and treats a timeout (exit 124) or any transient failure as **backoff + retry**, never a hang. Returns the last non-zero rc after the retry budget.
- Rewired all journal-fetch call sites to use it: `sync_clone`, `_verify_pushed` (common.sh), plus `comment-watcher.sh` (×2) and `mention-watcher.sh` (×2).
- **Belt** (git's own stall detection): exported `GIT_HTTP_LOW_SPEED_LIMIT=1000` / `GIT_HTTP_LOW_SPEED_TIME=$GARDEN_FETCH_TIMEOUT` for https, and `GIT_SSH_COMMAND="ssh -o ConnectTimeout=10 -o ServerAliveInterval=10 -o ServerAliveCountMax=3"` (only if unset) for `git@github.com`.

**2. Clone-lock wait is bounded** (`clone_lock` in common.sh)
- Changed the blocking `flock "$fd"` to `flock -w "$GARDEN_LOCK_WAIT"` with bounded retry (`$GARDEN_LOCK_RETRIES`); a waiter behind a stuck holder gives up loudly instead of blocking forever. This caps the blast radius of any single stuck holder — the amplifier that turned one stuck fetch into a fleet-wide wedge.

**3. Stuck-fetch janitor** (`scripts/jobs/reaper.sh`, runs every 10 min via `garden-reaper.timer`)
- New `reap_stuck_fetches()` kills any `git fetch` process older than `$GARDEN_FETCH_REAP_AGE` (default 120s) and logs a one-line `ANOMALY:` so a stuck fetch self-heals in minutes. Runs **first** in the reaper tick so the reaper's own `sync_clone` can't get wedged behind the hang it's meant to clear.

### Timeout values chosen
| Knob | Default | Meaning |
|---|---|---|
| `GARDEN_FETCH_TIMEOUT` | **45s** | kill + retry a journal fetch |
| `GARDEN_FETCH_RETRIES` | **3** | bounded fetch attempts |
| `GARDEN_LOCK_WAIT` | **60s** | per clone-lock wait before backoff |
| `GARDEN_LOCK_RETRIES` | **3** | bounded lock-acquire attempts |
| `GARDEN_FETCH_REAP_AGE` | **120s** | janitor kills fetches older than this |

All env-overridable.

### Tests & verification
- New `scripts/jobs/test/fetch-timeout-test.sh`: with a fake `git` that sleeps 30s on `fetch`, asserts `journal_fetch` **times out and retries in ~2–3s** (not 30s+) and returns failure; and that a `clone_lock` waiter behind a 20s-held flock **gives up in ~1s** rather than blocking. **4/4 pass.**
- `bash -n` and `shellcheck -x` clean on all four changed scripts and the new test.
- Full `run-test.sh` suite green (concurrency, message bus, scaler, inbox, scheduler, watchman, bulletin, mentor — no regressions from the `clone_lock`/`sync_clone` changes).

### Note / minor follow-up
- During verification I hit a false `run-test.sh` concurrency failure: because this gardener runs as `garden-gardener@62.service`, `GARDEN_GARDENER_CLONE`/`GARDEN_GARDENER_ID=62` are exported into the shell and the test's gardeners inherited my live clone instead of the throwaway. Re-running with those vars unset gave a fully green suite. Possible hardening for a future job: have `run-test.sh` `env -u` the leak-prone `GARDEN_*` vars itself so the suite is robust when invoked from inside a live gardener.
