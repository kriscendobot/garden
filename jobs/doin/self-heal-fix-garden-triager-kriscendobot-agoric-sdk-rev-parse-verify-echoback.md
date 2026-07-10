In `scripts/jobs/triager.sh` lines 55–56, the ref-resolution uses bare `git rev-parse` without `--verify`, so when `refs/remotes/origin/$ref` does not exist (as in the `kriscendobot-agoric-sdk` bare clone, whose refs are not under `refs/remotes/origin/`), the first `rev-parse` echoes the unresolved arg `refs/remotes/origin/master` to stdout before failing, and the `||` fallback appends the real SHA — producing a two-line `new_sha` value `refs/remotes/origin/master\n<sha>`. That garbage value later triggers `fatal: ambiguous argument 'refs/remotes/origin/master\n37a4fa…': unknown revision or path` and the recurring FATAL "triage handler failed" (circuit-breaker 1/5). Fix: add `--verify --quiet` to both rev-parse calls (and prefer a `^{commit}` peel), e.g.

    new_sha="$(git --git-dir="$BARE" rev-parse --verify --quiet "refs/remotes/origin/$ref^{commit}" \
                || git --git-dir="$BARE" rev-parse --verify --quiet "$ref^{commit}")" \
      || die "cannot resolve ref '$ref' in $slug"

With `--verify --quiet`, a failed lookup prints nothing to stdout and exits non-zero, so only the successful fallback's SHA is captured. Verify by running the triager against `kriscendobot-agoric-sdk` (whose bare clone lacks `refs/remotes/origin/master`) and confirming `new_sha` is a single clean 40-hex SHA and no "ambiguous argument" fatal occurs. Consider clearing the stuck `cursors/failcount/kriscendobot-agoric-sdk` failcount after the fix lands.

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 16
  claimed_at: 2026-07-10T07:37:12Z
