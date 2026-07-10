In `scripts/jobs/triager.sh` lines 55-57, the ref-resolution fallback leaks the failed command's stdout into `new_sha`. Plain `git rev-parse "refs/remotes/origin/$ref"` echoes its unresolved argument to stdout on failure (only the `fatal:` goes to stderr), so when that ref is absent (this bare clone has `refs/heads/master`, not `refs/remotes/origin/master`) the `||` fallback appends the real SHA and `new_sha` becomes the two-line string `"refs/remotes/origin/master\n<sha>"`. That mangled value corrupts the "change on" log line and is passed as `$new_sha` to `$GARDEN_TRIAGE_HANDLER`, whose `git log <old>..<new>` dies with `fatal: ambiguous argument 'refs/remotes/origin/master\n<sha>'` (exit 1). Fix: use `git rev-parse --verify -q` in both branches so a failed lookup prints nothing to stdout and returns non-zero cleanly:
```sh
new_sha="$(git --git-dir="$BARE" rev-parse --verify -q "refs/remotes/origin/$ref" 2>/dev/null \
            || git --git-dir="$BARE" rev-parse --verify -q "$ref" 2>/dev/null)" \
  || die "cannot resolve ref '$ref' in $slug"
```
Verify by pointing the triager at a bare clone whose only master ref is `refs/heads/master` and confirming `new_sha` resolves to a single 40-hex SHA with no leading ref-name line. Consider whether other `rev-parse` sites in the jobs scripts share this echo-on-failure pattern.
