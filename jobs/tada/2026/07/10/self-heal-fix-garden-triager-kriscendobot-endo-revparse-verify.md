Verification is conclusive. Nothing needs to be changed or pushed — the fix is already landed on `origin/main2`.

## Completion report

**Finding: the requested fix is already implemented, committed, and verified on `main2`.**

The `new_sha` resolution bug described in the job was fixed by a series of commits already merged to `origin/main2` (this worktree's HEAD `80acdfce0` == `origin/main2`, clean tree):

- `469cab011` — added `--verify -q` to both `rev-parse` invocations so a failed resolve produces no stdout (the core fix)
- `4ceaff391` — dropped the now-redundant `2>/dev/null`
- `7cc020469` — added the `^[0-9a-f]{40}$` tripwire assert on `new_sha`
- `8c25e2597` — test covering the primary-ref-unresolvable / fallback-resolves path
- `80acdfce0` — peel to `^{commit}` in the resolution

Current `triager.sh:59-61` reads exactly the fix the job prescribes:
```sh
new_sha="$(git --git-dir="$BARE" rev-parse --verify -q "refs/remotes/origin/$ref^{commit}" \
            || git --git-dir="$BARE" rev-parse --verify -q "$ref^{commit}")" \
  || die "cannot resolve ref '$ref' in $slug"
```
plus the `^[0-9a-f]{40}$` guard at `:67-68`.

**Verification performed (both automated and the job's exact manual check):**
- `scripts/jobs/test/triager-test.sh`: **29 passed, 0 failed**, including case **E** (primary ref absent, fallback resolves → single clean SHA, handler invoked exactly once) and case **F** (poisoned multi-line `new_sha` trips the guard, handler never runs).
- Manual repro against a `git clone --bare` of a local path (refs land under `refs/heads/*`, so the `refs/remotes/origin/*` candidate misses): the primary candidate returns empty, the fallback yields a single clean 40-hex SHA matching HEAD with 0 embedded newlines, and the guard passes. The old expression (no `--verify -q`) reproduces the exact two-line `refs/remotes/origin/master\n<sha>` corruption the job describes.

**What changed:** nothing — no code edits or pushes were needed; the fix predates this job's requeue. This job was reaped once (`garden-reaped: 1`) and requeued after the fix had already landed.

**Follow-ups:** none.
