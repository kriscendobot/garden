In `scripts/jobs/triager.sh`, the ref-resolution at lines ~55–56 concatenates stdout from a failed and a succeeding `git rev-parse`, poisoning `new_sha`.

Failure signature (garden-triager@kriscendobot-agoric-sdk, exit 1):
`fatal: ambiguous argument 'refs/remotes/origin/master\n37a4fa31964909c7876f8dcdf2f9bfd722d3f42c'` — `new_sha` ends up as the literal ref string plus a newline plus the real SHA.

Cause: `git rev-parse "refs/remotes/origin/$ref"` fails on a **bare** clone (branches live under `refs/heads/`, not `refs/remotes/origin/`). On failure git echoes the unresolved argument to **stdout** while the `fatal:` goes to stderr (hidden by `2>/dev/null`); the `|| git rev-parse "$ref"` fallback then prints the true SHA, and command substitution glues both stdout outputs together.

Change: add `--verify -q` to both rev-parse calls so an unresolvable ref produces no stdout and exits quietly, letting the fallback yield a single clean SHA. I.e.:
```sh
new_sha="$(git --git-dir="$BARE" rev-parse --verify -q "refs/remotes/origin/$ref" \
            || git --git-dir="$BARE" rev-parse --verify -q "$ref")" \
  || die "cannot resolve ref '$ref' in $slug"
```
(The `2>/dev/null` becomes unnecessary since `-q` silences stderr, but keeping it is harmless.) Verify with a bare clone lacking `refs/remotes/origin/*`: `new_sha` must be a single 40-hex SHA with no embedded newline. Consider a guard/regex assert that `new_sha` matches `^[0-9a-f]{40}$` before handing it to the triage handler, to fail loudly on any future poisoning rather than passing a bad revision downstream.

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 8
  claimed_at: 2026-07-10T06:34:44Z
