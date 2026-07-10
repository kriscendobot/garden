In `scripts/jobs/triager.sh` (lines ~55-56), the ref resolution is buggy:

```sh
new_sha="$(git --git-dir="$BARE" rev-parse "refs/remotes/origin/$ref" 2>/dev/null \
            || git --git-dir="$BARE" rev-parse "$ref" 2>/dev/null)" \
  || die "cannot resolve ref '$ref' in $slug"
```

When `refs/remotes/origin/$ref` does not exist in the bare clone (the kriscendobot-endo clone stores its branch at `refs/heads/master`, with no `origin` remote-tracking ref), `git rev-parse refs/remotes/origin/master` echoes its literal argument to **stdout** and exits non-zero. `2>/dev/null` only silences stderr, so the echoed ref name stays on stdout; the `||` fallback then appends the real SHA. The command substitution captures both, yielding a two-line `new_sha` = `refs/remotes/origin/master\nf859ca06796902d693fb4f0a34ded48fdf4461ff`. That value is logged as `<none> → refs/remotes/origin/master\nf859…` and passed downstream to `git log`, which fails with `fatal: ambiguous argument 'refs/remotes/origin/master\nf859…': unknown revision`, exiting 1 (triager FATAL, 1/5 consecutive).

Fix: add `--verify --quiet` to both rev-parse invocations so a non-resolving ref prints nothing (instead of echoing the argument) and exits non-zero cleanly, letting only the successful branch's SHA populate `new_sha`:

```sh
new_sha="$(git --git-dir="$BARE" rev-parse --verify --quiet "refs/remotes/origin/$ref" \
            || git --git-dir="$BARE" rev-parse --verify --quiet "$ref")" \
  || die "cannot resolve ref '$ref' in $slug"
```

(`--quiet` already suppresses stderr, so the `2>/dev/null` redirects can be dropped.) Add/adjust a test covering the case where `refs/remotes/origin/$ref` is absent but `refs/heads/$ref` resolves, asserting `new_sha` is a single 40-hex line.

---
claim:
  host: endolin-garden2-5bcdff64
  gardener: 17
  claimed_at: 2026-07-10T09:37:23Z
