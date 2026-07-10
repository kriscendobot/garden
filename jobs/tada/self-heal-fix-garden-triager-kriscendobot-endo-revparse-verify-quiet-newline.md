The job is already fully resolved in `main2` — no changes needed.

## Completion report

**Finding: the requested fix has already landed.** The `new_sha` corruption in `scripts/jobs/triager.sh` is fixed exactly as this job specifies, across a chain of commits already on `origin/main2`:

- `469cab011` — both rev-parse calls use `--verify -q` so a missing `refs/remotes/origin/<ref>` prints nothing / exits nonzero instead of echoing its literal token to stdout (the fix requested).
- `80acdfce0` — both calls peel with `^{commit}` (the "ideally" part of the ask).
- `4ceaff391` — dropped the now-redundant `2>/dev/null`.
- `7cc020469` — added the `[[ "$new_sha" =~ ^[0-9a-f]{40}$ ]]` tripwire assert (defense-in-depth beyond what the job asked).
- `8c25e2597` — added test case **E** in `scripts/jobs/test/triager-test.sh` covering the primary-ref-absent / fallback-resolves path, asserting `new_sha` is a single 40-hex SHA with no embedded newline (exactly the test the job requested), plus case **F** guarding the poisoned multi-line path.

Current `triager.sh:59-68` matches the job's recommended form verbatim.

**Verification:** ran `scripts/jobs/test/triager-test.sh` → **29 passed, 0 failed**, including case E ("new_sha passed to the handler is the clean resolved SHA", "CALL_LOG is a single line → new_sha carried no newline").

**Changes made:** none — no commit or push. My worktree HEAD (`b793cbb80`) already equals `origin/main2` with the fix present, so there is nothing to add. This was a stale/duplicate self-heal job whose underlying signature was resolved before it was claimed.

**Follow-ups:** none. The `kriscendobot-endo:master` cold-start signature (`… → refs/remotes/origin/master\n<sha>; fatal: ambiguous argument`) can no longer occur with this code.
