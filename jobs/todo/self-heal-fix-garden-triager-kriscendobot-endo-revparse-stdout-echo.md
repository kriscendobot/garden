In `scripts/jobs/triager.sh` (lines ~55-56), the ref-resolution captures a two-line `new_sha` when the bare clone lacks `refs/remotes/origin/*` refs. `git rev-parse "refs/remotes/origin/$ref" 2>/dev/null` echoes the unresolved arg verbatim to **stdout** (not just stderr) while exiting 128, so the `|| git rev-parse "$ref"` fallback appends the real SHA and the command substitution captures BOTH lines. This produced `new_sha="refs/remotes/origin/master\nf859ca06..."`, which then blew up the handler's `git log` with `fatal: ambiguous argument`.

Fix: add `--verify -q` (i.e. `--verify --quiet`) to BOTH `git rev-parse` invocations so the failed first attempt prints nothing and exits nonzero cleanly, letting the fallback yield a single clean SHA:

```sh
new_sha="$(git --git-dir="$BARE" rev-parse --verify -q "refs/remotes/origin/$ref" \
            || git --git-dir="$BARE" rev-parse --verify -q "$ref")" \
  || die "cannot resolve ref '$ref' in $slug"
```

(`--verify -q` already suppresses stderr on failure, so the `2>/dev/null` redirects become redundant and can be dropped.) Reproduction: `repos/kriscendobot-endo.git` has only `refs/heads/master` (no `refs/remotes/origin/master`); the current code yields a two-line value there, the fixed code yields the single SHA `f859ca06...`. Add/extend a case in `scripts/jobs/test/triager-test.sh` covering a bare clone whose branches live under `refs/heads/*` only (no remote-tracking refs), asserting `new_sha` is a single line / valid SHA.
