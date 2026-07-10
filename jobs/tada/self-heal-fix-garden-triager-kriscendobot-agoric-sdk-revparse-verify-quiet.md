All 29 tests pass on the rebased tree and the guard is live on `origin/main2` at `7cc020469`.

---

## Completion report

**Job:** Fix `scripts/jobs/triager.sh` ref-resolution poisoning that produced `fatal: ambiguous argument 'refs/remotes/origin/master\n<sha>'` (garden-triager@kriscendobot-agoric-sdk, exit 1).

**Finding:** The primary fix — adding `--verify -q` to both `git rev-parse` calls so a failed primary resolution emits nothing on stdout (letting the fallback yield a single clean SHA) — was **already landed** on `origin/main2` before I started (commit `469cab011`, plus test coverage in `8c25e2597`). During my rebase, a further upstream refinement (`4ceaff391`) also dropped the now-redundant `2>/dev/null` since `-q` already silences stderr.

**What I did** (the remaining "consider" item from the spec — the defensive tripwire):
- **`scripts/jobs/triager.sh`**: added a `[[ "$new_sha" =~ ^[0-9a-f]{40}$ ]]` assert immediately after ref resolution. Any future regression that reintroduces a multi-line `new_sha` now dies loudly at the source with a `%q`-quoted diagnostic, instead of surfacing as an `ambiguous argument` fatal deep inside the triage handler.
- **`scripts/jobs/test/triager-test.sh`**: added **section F**, a regression test that reproduces the exact production poisoning via a scoped `git` shim (corrupts only the primary `refs/remotes/origin/<ref>` rev-parse, passes every other git call through) and asserts the tick dies non-zero, the handler is never invoked, and the cursor is not advanced past the bad sha. Also fixed a latent double-`0` from the `calls()` helper on an empty log by asserting on file size directly.

**Verification:** full suite `29 passed, 0 failed`; shellcheck on `triager.sh` shows only pre-existing/benign items (unfollowable `common.sh`, long-standing `GARDEN_TAG`, intentional literal backticks in the maintainer report).

**Pushed:** `7cc020469` → `main2` (rebase CAS, one retry).

**Follow-ups:** none. Note the runtime fix was already deployed; this job's net new contribution is the fail-loud guard and its regression test.
