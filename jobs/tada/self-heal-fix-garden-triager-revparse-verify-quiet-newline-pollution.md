The job is already fully complete on `origin/main2`. All work described in the spec has been done and committed; the test suite is green. Nothing further to change.

## Completion report

**State:** The fix described in this job is already present and committed at `origin/main2` HEAD. No new changes were needed; my working tree is clean and at the same commit. This was a self-heal job whose substance had already landed across four commits:

- `469cab011` triager: use `rev-parse --verify -q` so a missing ref does not leak its name into `new_sha`
- `8c25e2597` triager-test: cover the primary-ref-unresolvable / fallback-resolves path
- `4ceaff391` triager: drop redundant `2>/dev/null` now that `rev-parse --verify -q` is silent on failure
- `7cc020469` triager: assert `new_sha` is a single 40-hex SHA (tripwire for future poisoning)

**What's in place (`scripts/jobs/triager.sh:55-64`):**
- Both `rev-parse` calls use `--verify -q`, so a failed primary lookup prints nothing to stdout (no `refs/remotes/origin/master` echo) and only the fallback's real SHA is captured — the newline-pollution root cause is fixed.
- The redundant `2>/dev/null` is gone (superseded by `-q`).
- A `[[ "$new_sha" =~ ^[0-9a-f]{40}$ ]]` tripwire dies loudly on any future poisoning regression instead of leaking a bad revision downstream.

**Verification:** `scripts/jobs/test/triager-test.sh` → **29 passed, 0 failed**, including case E (primary ref absent → fallback yields a single clean SHA, handler called exactly once) and case F (poisoned multi-line `new_sha` trips the guard, handler never invoked, cursor not advanced).

**Sibling-script sanity check:** Scanned all of `scripts/jobs/` for the vulnerable `rev-parse … 2>/dev/null || rev-parse` fallback pattern. `ci-watcher.sh` and `comment-watcher.sh` do not contain any `rev-parse` at all, and no other watcher/job script replicates the `A_ref || B_ref` stdout-leaking shape — every other `rev-parse` use is a `--git-dir`/`--show-toplevel`/`HEAD` probe with proper guarding. No further edits required.

**Follow-ups:** None.
