In `scripts/jobs/triager.sh` lines 55-57, the `new_sha` capture is corrupted when the first `rev-parse` fails: plain `git rev-parse "refs/remotes/origin/$ref"` echoes the unresolved arg to **stdout** (only the `fatal:` goes to stderr, silenced by `2>/dev/null`), and because both branches of the `A || B` share the command-substitution stdout, `new_sha` becomes `refs/remotes/origin/master\n<sha>` — a two-line value. This happens for any bare clone lacking `refs/remotes/origin/*` tracking refs (e.g. `kriscendobot-endo.git`, a `git clone --bare`), so the primary always fails, echoes, and the `master` fallback appends the real sha. The handler (`handlers/triager-claude.sh`) then passes the malformed `new_sha` to `git log`, yielding `fatal: ambiguous argument 'refs/remotes/origin/master\nf859ca06...': unknown revision`, failing triage every tick until the circuit-breaker trips.

Fix: add `--verify -q` to both `rev-parse` calls so a failed lookup emits nothing (no stdout echo), leaving only the resolving branch's sha in the capture:

```sh
new_sha="$(git --git-dir="$BARE" rev-parse --verify -q "refs/remotes/origin/$ref" \
            || git --git-dir="$BARE" rev-parse --verify -q "$ref")" \
  || die "cannot resolve ref '$ref' in $slug"
```

(`--verify -q` already suppresses stderr, so the `2>/dev/null` redirects can be dropped.) Add/adjust a test in the triager test suite covering the "bare clone with no `refs/remotes/origin/*`" case, asserting `new_sha` is a single 40-hex line rather than the ref name concatenated with a sha.

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 12
  claimed_at: 2026-07-10T11:38:05Z
