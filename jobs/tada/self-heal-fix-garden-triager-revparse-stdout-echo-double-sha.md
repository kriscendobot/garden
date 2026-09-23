Inbox empty. Work complete.

## Completion report

**Job:** Fix the triager's corrupted two-line `new_sha` when the primary ref is unresolvable.

**What I found:** While I was working, a peer already landed the *source* fix (`469cab011`, "triager: use rev-parse --verify -q so a missing ref does not leak its name into new_sha") on `main2`. It applied exactly the fix this job specified — `--verify -q` on both `rev-parse` calls in `scripts/jobs/triager.sh` — so bare `rev-parse <bad-rev>` is now silent-and-empty-on-failure instead of echoing its literal argument to stdout. My independent fix collided at the rebase CAS; I confirmed the landed version is equivalent and correct.

**What was still missing:** the landed fix shipped **without a regression test** for the failure mode. That was the remaining half of this job's spec ("Add/extend a triager test covering the primary-ref-unresolvable / fallback-resolves path").

**What I changed (and pushed, `8c25e2597`):**
- `scripts/jobs/test/triager-test.sh` — added **section E**. A plain `git clone --bare` fixture reproduces the production shape (`refs/heads/<ref>` present, no `refs/remotes/origin/<ref>`), forcing the primary `rev-parse` to fail and the fallback to resolve. It asserts the handler receives `new_sha` as a **single clean SHA** (via CALL_LOG line-count == 1 and value == resolved HEAD sha) and that the activity cursor advances to that clean sha.

**Verification:** I confirmed the test is a genuine guard by reverting to the pre-fix `rev-parse` locally — section E produced 3 failures showing the two-line `refs/remotes/origin/main\n<sha>` corruption — and passes cleanly against the landed fix. Full suite: **26 passed, 0 failed**. `bash -n` clean on both files.

**Follow-ups:** None required. Note the landed source fix retains a now-redundant `2>/dev/null` alongside `--verify -q` (harmless — `-q` already silences the "unknown revision" message); not worth a separate change. The operational instance `garden-triager@kriscendobot-agoric-sdk` should recover on its next tick now that the fix is deployed; its `master` cursor was never advanced, so it will re-triage the pending change correctly.
