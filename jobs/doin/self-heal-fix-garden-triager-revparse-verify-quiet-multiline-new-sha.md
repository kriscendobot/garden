In `scripts/jobs/triager.sh` around lines 55–57, `new_sha` can become a two-line string when the primary ref doesn't exist. In a bare clone, `refs/remotes/origin/$ref` is absent, and `git rev-parse "refs/remotes/origin/$ref"` echoes its argument to **stdout** on failure (only stderr is redirected to /dev/null). The `||` fallback `git rev-parse "$ref"` then appends the real SHA, so the command substitution captures `"refs/remotes/origin/$ref\n<sha>"`. This multiline `new_sha` propagates into the triage handler's git revision arguments, causing `fatal: ambiguous argument 'refs/remotes/origin/master\n<sha>': unknown revision or path not in the working tree` and exit 1 (observed on `kriscendobot-agoric-sdk`, ref `master`, sha `37a4fa31964909c7876f8dcdf2f9bfd722d3f42c`).

Fix: make each `rev-parse` verify quietly so a miss produces no stdout. Change the assignment to use `rev-parse --verify -q` (and pin to a commit) for both the primary and fallback lookups, e.g.:

```
new_sha="$(git --git-dir="$BARE" rev-parse --verify -q "refs/remotes/origin/$ref^{commit}" \
            || git --git-dir="$BARE" rev-parse --verify -q "$ref^{commit}")" \
  || die "cannot resolve ref '$ref' in $slug"
```

With `--verify -q`, the first call prints nothing and returns non-zero when the remote-tracking ref is absent, so only the fallback's single-line SHA is captured. Verify `new_sha` is a single 40-hex line for a bare clone whose branch lives under `refs/heads/` (no `refs/remotes/origin/*`), and add a guard/test covering the bare-clone case (the recent cold-start tests in commits c14da9355 / 35db0c0a7 are the natural place). Note the same echo-on-failure trap would also bite any other `rev-parse` used with `||` fallbacks; audit line 53's `symbolic-ref` path too (it already uses `2>/dev/null || echo master`, which is fine since symbolic-ref does not echo its arg).

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 19
  claimed_at: 2026-07-10T09:38:06Z
