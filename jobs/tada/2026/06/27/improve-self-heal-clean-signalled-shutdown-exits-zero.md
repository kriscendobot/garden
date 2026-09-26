Inbox empty, worktree and temp files cleaned. The fix is landed on `main2` and verified green. Here is my completion report.

---

## Completion report: `improve-self-heal-clean-signalled-shutdown-exits-zero`

**Done — committed `bdae9c559`, pushed to `main2` (`4a2d6748a..bdae9c559`), full test suite green (144 passed, 0 failed).**

### What changed
1. **`scripts/jobs/self-heal-run.sh`** — the core fix. Introduced a `clean_shutdown` flag set when `got_signal=1` OR `rc` is 143/130. In the `if [ "$is_expected" -eq 1 ]` block the wrapper now does `exit 0` when `clean_shutdown=1`, otherwise `exit "$rc"`. A SIGTERM/SIGINT-driven systemd stop now returns 0 instead of 143/130, so systemd no longer records `Failed with result 'exit-code'` on every `stop`/`restart`. Genuine non-signal `--expect` codes and real failures still preserve `rc` for `Restart=`/`OnFailure=`.
2. **Belt-and-suspenders** — added `SuccessExitStatus=143 130 SIGTERM SIGINT` to the `[Service]` section of all long-running unit templates that wrap commands in self-heal: `garden-bulletin`, `garden-foreman`, `garden-watchman`, `garden-proxy`, `garden-mention-watcher`, `garden-repo-watcher`, `garden-comment-watcher@`, plus the two genuinely-continuous templates `garden-watcher@` and `garden-gardener@`. So any future bypass of the wrapper still won't mark a clean SIGTERM stop as failed.

### Verification
- Direct wrapper tests: signalled shutdown → exit 0; real failure (`exit 7`) → preserves 7; `--expect 5` → passes 5 through unchanged.
- Full `scripts/jobs/test/run-test.sh` suite: **144/144 pass**. SUBTEST 21 case (6) — `SIGTERM mid-run → clean shutdown: no diagnosis AND exit 0` — now passes.

### Notable context / follow-ups
- **A sibling/prior effort had already landed the matching test assertion (and the `run-test.sh` fleet-load isolation, commit `4a2d6748a`) on `main2` *without* the wrapper fix** — so SUBTEST 21 case (6) was RED on `main2` until this commit. My change closes that gap; the test now agrees with the code. No separate test commit was needed (the assertion was already present, verbatim).
- **Worktree reaping hazard:** my first isolated worktree (`/home/kris/wt-selfheal-isolate`, registered off `origin/main2`) was deleted out from under me mid-session along with my uncommitted edits, while `main2` simultaneously advanced. I recovered by re-deriving the change as an idempotent `/tmp` script, rebuilding off the fresh `origin/main2`, and committing+pushing immediately before reaping could recur. Worth flagging for the maintainer: registered build worktrees under `/home/kris` are being aggressively reaped, which can silently discard in-progress gardener work — committing/pushing as early as possible is the only safe mitigation today.
