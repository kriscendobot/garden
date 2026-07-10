Pushed to main2 on the first attempt. The fix is landed.

## Completion report

**Job:** Fix the stdout leak in `scripts/jobs/triager.sh` where a failed ref-resolution echoed its argument into `new_sha`.

**What I did:**
- Changed the ref-resolution fallback (worktree lines 55-57) to use `git rev-parse --verify -q` in both branches. A failed lookup now prints nothing to stdout and returns non-zero cleanly, instead of echoing the unresolved ref name.
- Reproduced the bug exactly: a bare clone whose only master ref is `refs/heads/master` (no `refs/remotes/origin/master`) made the old code produce the two-line value `refs/remotes/origin/master\n<sha>`. After the fix, `new_sha` resolves to a single 40-hex SHA.
- Verified end-to-end by running the actual `triager.sh` against that bare clone with a stub handler: the "change on" log line and the `$new_sha` handed to the handler are now a clean SHA, and the handler's `git log` on `new_sha` succeeds (no more `fatal: ambiguous argument`), triage completes, cursor advances.
- Audited the other `rev-parse` sites in `scripts/jobs/`. All are safe: they either use flag forms (`--show-toplevel`, `--git-dir`, `--absolute-git-dir`, `--short HEAD`, etc.) that don't echo the argument, or capture a single command guarded directly by `|| return 1` / `|| true` — none share the two-command fallback-capture shape (`X="$(cmd_a || cmd_b)"`) that concatenates two stdout streams. The triager was the only vulnerable site.

**What changed:** one line in `scripts/jobs/triager.sh` (added `--verify -q` to both rev-parse branches). Committed and pushed to `main2` (commit `469cab011`).

**Note / correction I made mid-flight:** my first Read/Edit accidentally targeted the deployed garden root `/home/kris/garden2/scripts/jobs/triager.sh` instead of the job worktree. I reverted that root edit with `git checkout --` (deployed root is now clean) and re-applied the fix in the worktree, where all development belongs.

**Follow-ups:** none required.
