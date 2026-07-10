In `scripts/jobs/triager.sh` (lines ~55–57), the ref-resolution `git rev-parse "refs/remotes/origin/$ref" 2>/dev/null || git rev-parse "$ref" 2>/dev/null` is buggy: when the first ref is unresolvable, `git rev-parse` echoes the literal argument to stdout (only the diagnostic goes to the suppressed stderr) and exits nonzero, so the `||` fallback's SHA gets *appended* to that echoed string. The command substitution then captures a two-line `new_sha` (e.g. `refs/remotes/origin/master\n<sha>`), which downstream `git log`/handler rejects with `fatal: ambiguous argument`, producing the triager exit-1 seen on `garden-triager@kriscendobot-endo` (bare clone has `refs/heads/master` but no `refs/remotes/origin/master`).

Fix: give both `rev-parse` calls `--verify -q` so a failed resolution prints nothing and the fallback composes cleanly:

```sh
new_sha="$(git --git-dir="$BARE" rev-parse --verify -q "refs/remotes/origin/$ref" \
            || git --git-dir="$BARE" rev-parse --verify -q "$ref")" \
  || die "cannot resolve ref '$ref' in $slug"
```

(`--verify -q` makes `2>/dev/null` redundant but harmless to keep or drop.) After the change, verify by hand against the kriscendobot-endo bare clone that `new_sha` is a single 40-char SHA, and confirm the existing cold-start / SIGPIPE triager tests still pass. This also clears the currently-stuck cursor (left at `<none>`) once a clean single-line SHA is produced.
