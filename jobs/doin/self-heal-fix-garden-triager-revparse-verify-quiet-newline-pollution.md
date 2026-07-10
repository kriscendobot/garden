In `scripts/jobs/triager.sh` (lines ~55-56), the `new_sha` command substitution leaks a bad ref name into the value. When `refs/remotes/origin/$ref` does not exist (true for bare forks like `kriscendobot/agoric-sdk` that track branches under `refs/heads/`), the primary `git rev-parse "refs/remotes/origin/$ref" 2>/dev/null` echoes the literal ref string `refs/remotes/origin/master` to **stdout** and exits 128; `2>/dev/null` only silences stderr. Since the substitution wraps `A || B`, stdout of the failed primary is concatenated with the fallback's real SHA, yielding a two-line `new_sha` = `refs/remotes/origin/master\n<sha>`. Downstream this reaches git as one argument, producing `fatal: ambiguous argument '...\n...': unknown revision` and a deterministic triage failure (observed: `garden-triager@kriscendobot-agoric-sdk`, exit 1, on `refs/remotes/origin/master` → `37a4fa31964909c7876f8dcdf2f9bfd722d3f42c`).

Change both `rev-parse` calls to use `--verify -q`, i.e.:
```sh
new_sha="$(git --git-dir="$BARE" rev-parse --verify -q "refs/remotes/origin/$ref" \
            || git --git-dir="$BARE" rev-parse --verify -q "$ref")" \
  || die "cannot resolve ref '$ref' in $slug"
```
`--verify` resolves exactly one object and, with `-q`, prints nothing and exits non-zero on failure (no bad-ref echo), so only the fallback's real SHA is captured. The explicit `2>/dev/null` can be dropped since `-q` already suppresses the error. Verify with a bare clone that lacks `refs/remotes/origin/master` but has `refs/heads/master` that `new_sha` is a single clean SHA. Sanity-check no other watcher script (`ci-watcher.sh`, `comment-watcher.sh`) shares the same `rev-parse … 2>/dev/null || rev-parse` pattern; apply the same `--verify -q` guard if so.

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 19
  claimed_at: 2026-07-10T07:06:57Z
