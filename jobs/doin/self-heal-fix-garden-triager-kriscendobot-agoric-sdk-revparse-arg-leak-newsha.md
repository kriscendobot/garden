In `scripts/jobs/triager.sh` (the ref-resolve block at ~lines 55–57), make the two `git rev-parse` calls strict so a failed lookup yields **empty stdout** and a clean non-zero exit instead of echoing its argument to stdout. Add `--verify -q` (and pin to a commit) to both:

```sh
new_sha="$(git --git-dir="$BARE" rev-parse --verify -q "refs/remotes/origin/$ref^{commit}" \
            || git --git-dir="$BARE" rev-parse --verify -q "$ref^{commit}")" \
  || die "cannot resolve ref '$ref' in $slug"
```

Rationale / failure signature: without `--verify`, `git rev-parse <unresolvable-ref>` prints the argument to stdout while exiting non-zero. When the first call fails (e.g. the `refs/remotes/origin/master` remote-tracking ref is momentarily absent right after a fresh fork-watch fetch) but the fallback `rev-parse "$ref"` succeeds, command substitution concatenates the leaked argument with the fallback SHA, producing a two-line `new_sha` (`refs/remotes/origin/master\n<sha>`). That corrupt value is handed to `$GARDEN_TRIAGE_HANDLER` (`triager-claude.sh`), whose cold-start `git log "${old:+$old..}$new"` then dies with `fatal: ambiguous argument 'refs/remotes/origin/master\n37a4…'` — the exact signature observed on `garden-triager@kriscendobot-agoric-sdk`. `--verify -q` guarantees each call prints exactly one valid SHA or nothing, so the `||` fallback / final `|| die` behave correctly and no garbage ever reaches the handler. If a regression test exists (`scripts/jobs/test/triager-*-test.sh`), add a case where `refs/remotes/origin/$ref` is absent but `$ref` resolves, asserting `new_sha` is a single SHA line (no arg-echo leak).

---
claim:
  host: endolin-garden2-5bcdff64
  gardener: 14
  claimed_at: 2026-07-10T10:09:13Z
