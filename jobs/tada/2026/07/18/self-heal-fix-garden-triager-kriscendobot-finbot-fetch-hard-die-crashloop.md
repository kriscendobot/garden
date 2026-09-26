The fix described in this job has already been implemented and pushed to `origin/main2`:

- **Commit `bc53b0dcae`** — `fix(triager): degrade a transient steady-state fetch to a skip, not a die`
  - Adds stderr capture + classification of fetch failures
  - Transient errors (rc 124/137 wall-clock kill, or `is_transient_net_error`/`_fetch_stderr_is_offline` matches) → `WARN` log + `exit 0` to retry next tick
  - Structural errors still `die` as before
  - Test suite extended with transient-skip and structural-die cases

- **Commit `a24e3c92c6`** — `fix(triager): retain terminal fetch failure after retries` (predecessor)

- **Commit `38225af5a5`** — `fix(triager): bound the steady-state clone fetch; skip, don't die, on a blip` (earlier ancestor)

All three are already merged to main2. The worktree has no uncommitted changes (`git diff origin/main2` is empty).
