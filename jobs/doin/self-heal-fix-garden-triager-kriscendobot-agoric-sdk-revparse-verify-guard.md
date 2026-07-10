In `scripts/jobs/triager.sh`, the `new_sha` resolution (lines ~55-57) uses plain `git rev-parse "refs/remotes/origin/$ref" || git rev-parse "$ref"`. Plain `git rev-parse` echoes its argument to **stdout** (not just stderr) when the revision is unknown and exits non-zero; `2>/dev/null` only suppresses the `fatal:` line, not the echoed arg. For repos whose bare clone lacks `refs/remotes/origin/<branch>` (e.g. `kriscendobot-agoric-sdk`, which has `refs/heads/master`), the first rev-parse prints `refs/remotes/origin/master` to stdout, the `||` fallback prints the real sha, and command substitution concatenates them into a two-line `new_sha` = `refs/remotes/origin/master\n<sha>`. That corrupt value is passed to the triage handler and crashes it with `fatal: ambiguous argument 'refs/remotes/origin/master\n<sha>'`, wedging the `garden-triager@kriscendobot-agoric-sdk` unit until the circuit breaker trips.

Fix: change both rev-parse calls to `git --git-dir="$BARE" rev-parse --verify -q "refs/remotes/origin/$ref"` and `... rev-parse --verify -q "$ref"`. `--verify -q` produces no stdout on an unresolvable ref, so the failed first attempt no longer pollutes the fallback's output and `new_sha` is always a single clean sha. Verify with the reproduction: in `repos/kriscendobot-agoric-sdk.git`, `git rev-parse refs/remotes/origin/master` echoes the arg to stdout on failure while `git rev-parse --verify -q refs/remotes/origin/master` prints nothing. Consider also guarding `new_sha` to reject any value that isn't a single 40-hex-char line (defense-in-depth) and clearing the now-poisoned `failcount/kriscendobot-agoric-sdk` cursor so the breaker reopens after the fix lands.

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 2
  claimed_at: 2026-07-10T11:09:09Z
