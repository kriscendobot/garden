Inbox empty. The job is complete.

---

## Completion report

**Job:** Shepherd endojs/endo-but-for-bots PR #655 (`feat/mount-grep`, "mount grep, PR C of #127") to CI green.

**Diagnosis.** All four `test` cells (22.x/24.x × ubuntu/macos-15) failed deterministically on exactly one test: `mount-revocation › revocation: an open followNameChanges stream fails after revoke` — "Promise returned by test never resolved". The PR was also `mergeable_state: dirty` (conflict blocking new CI dispatch).

**Root cause.** PR #655 was cut from the *old* base `feat/mount-glob@e2abb76d3`, which predates base commit `39f06ba6b` ("fix(daemon): wake open followNameChanges streams on mount revoke"). That fix gives the revocation record a `whenRevoked` promise and races each `followNameChanges` event pull against it, so an open stream fails promptly on revoke instead of hanging on a `persistent:false` inotify event that CI's serial worker never reliably delivers — the fix commit message names this exact "hung on all CI cells" symptom. The base branch was later force-updated to `6680a60c2` (green) to include the fix; that base advance is what made #655 `dirty`. The grep commit itself only refactored `glob()`→`globFacePaths` and added `grep()`; it never touched `followNameChanges`.

**Fix.** Rebased the single grep commit `--onto origin/feat/mount-glob` (`6680a60c2`) off the old base — clean, no conflicts. This simultaneously (a) pulled in the `whenRevoked` revoke-race fix plus the updated event-free test, and (b) un-dirtied the PR by re-parenting the head on the current base tip. Verified the composed `mount.js` retains both the grep `globFacePaths` refactor and the `followNameChanges` revoke race, syntax-checked the three changed files, then force-pushed with `--force-with-lease` anchored to the old head `96a7a87f5` → new head `673d4b895`.

**Result.** PR #655 is now `mergeable: true`, `mergeable_state: clean`. The full CI workflow re-dispatched and completed **green**: all four `test` cells SUCCESS, zero non-success checks in the rollup.

**Note.** Local reproduction of the daemon suite wasn't possible in this environment (the `better-sqlite3` native build is blocked by the sandbox's exec restrictions); verification was via the diagnosis + CI re-run. No green-run summary comment was posted — the job body carried no external-repo comment authorization.

**Follow-ups.** None. The next step in the M3 stack (review/merge of #655) is unblocked.
