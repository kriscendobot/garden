Pushed successfully on the first attempt.

## Completion report

**Job:** Self-heal the two-line `new_sha` bug in `scripts/jobs/triager.sh` where `git rev-parse` of a missing `refs/remotes/origin/*` ref echoed the unresolved arg to stdout, corrupting the command-substitution capture.

**State on arrival:** The core fix was already present on `origin/main2` from prior commits — 469cab011 added `--verify -q` to both `git rev-parse` invocations, and 8c25e2597 added test **case E** ("primary ref unresolvable, fallback resolves"), which builds a bare clone with `refs/heads/*` only (no remote-tracking refs) and asserts `new_sha` is a single clean SHA passed to the handler exactly once. That test covers precisely the scenario the job specified.

**What I did:** The only unaddressed item was the spec's optional cleanup — dropping the now-redundant `2>/dev/null` redirects, since `--verify -q` already silences stderr on failure. I removed both redirects, re-ran the suite (26 passed, 0 failed, including case E), committed with explicit pathspec, and pushed to `main2` (CAS succeeded on attempt 1).

**Changed:** `scripts/jobs/triager.sh` — lines 55–56 now read:
```sh
new_sha="$(git --git-dir="$BARE" rev-parse --verify -q "refs/remotes/origin/$ref" \
            || git --git-dir="$BARE" rev-parse --verify -q "$ref")" \
  || die "cannot resolve ref '$ref' in $slug"
```

**Follow-ups:** None. The fix and its regression test are complete and green.
